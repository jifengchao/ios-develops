//
//  FEIMRoomViewController.m
//  demo
//
//  Created by hyl on 2022/7/7.
//

#import "FEIMRoomViewController.h"

#import "FEKeyboardToolbarView.h"
#import <Masonry/Masonry.h>
#import "FEChatroomNotificationHandler.h"
#import "FEChatRoomManager.h"
#import "NetworkInterface.h"

@interface FEIMRoomViewController () <UITableViewDelegate, UITableViewDataSource, FEChatroomNotificationHandlerDelegate, FEKeyboardToolbarDelegate>

@property (nonatomic, strong) FEChatroomNotificationHandler *handler;

@property (nonatomic, strong) FEChatRoomManager *roomManager;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FEKeyboardToolbarView *keyboardView;


@property (nonatomic, strong) NSMutableArray *displayContent;

@property (nonatomic, assign) BOOL isEnter;

@property (nonatomic,strong) NSMutableArray *pendingMessages;   //缓存的插入消息,聊天室需要在另外个线程计算高度,减少UI刷新

@end

@implementation FEIMRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"点击消息，可撤回";
    
    [self setupUI];
    [self setupDatas];
    [self bindNotis];
}

- (void)dealloc {
    [self.roomManager leave];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    
    UIView *bottomV = [self bottomView];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(tableView.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    [self.view addSubview:self.keyboardView];
}

- (void)setupDatas {
    _pendingMessages = [[NSMutableArray alloc] init];
    self.displayContent = [NSMutableArray array];
    [self.displayContent addObject:@"连接中。。。。。。"];
    
    FEChatRoomManager *roomManager = [[FEChatRoomManager alloc] init];
    self.roomManager = roomManager;
    [roomManager enterWith:self.roomId account:self.account token:self.token];
    
    FEChatroomNotificationHandler *handler = [[FEChatroomNotificationHandler alloc] initWithDelegate:self];
    self.handler = handler;
    handler.roomId = self.roomId;
}

- (void)bindNotis {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
        name:UIKeyboardWillHideNotification object:nil];
}

- (UIView *)bottomView {
    UIView *bottomV = [UIView new];
    bottomV.backgroundColor = UIColor.redColor;
    return bottomV;
}

// 根据键盘状态，调整_mainView的位置
- (void)keyboardWillShow:(NSNotification *)notification{

    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyBoardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.keyboardView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-keyBoardHeight-50, UIScreen.mainScreen.bounds.size.width, 50);
    }];

}

- (void)keyboardWillHide:(NSNotification *)aNotification {
     //键盘消失时 隐藏工具栏
     [UIView animateWithDuration:0.1 animations:^{
         self.keyboardView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height+50, UIScreen.mainScreen.bounds.size.width, 50);
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.keyboardView becomeFirstResponse];
    });
}

- (void)addMessages:(NSArray<NIMMessage *> *)messages {
    if (messages.count) {
        [self caculateHeight:messages];
    }
}

static const void * const FEDispatchMessageDataPrepareSpecificKey = &FEDispatchMessageDataPrepareSpecificKey;
dispatch_queue_t FEMessageDataPrepareQueue(void) {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("nim.live.demo.message.queue", 0);
        dispatch_queue_set_specific(queue, FEDispatchMessageDataPrepareSpecificKey, (void *)FEDispatchMessageDataPrepareSpecificKey, NULL);
    });
    return queue;
}

void fe_main_sync_safe(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)caculateHeight:(NSArray<NIMMessage *> *)messages
{
    dispatch_async(FEMessageDataPrepareQueue(), ^{
        //后台线程处理宽度计算，处理完之后同步抛到主线程插入
        BOOL noPendingMessage = self.pendingMessages.count == 0;
        [self.pendingMessages addObjectsFromArray:messages];
        if (noPendingMessage)
        {
            [self processPendingMessages];
        }
    });
}

- (void)processPendingMessages
{
    __weak typeof(self) weakSelf = self;
    NSUInteger pendingMessageCount = self.pendingMessages.count;
    if (!weakSelf || pendingMessageCount== 0) {
        return;
    }
    
    fe_main_sync_safe(^{
        if (weakSelf.tableView.isDecelerating || weakSelf.tableView.isDragging)
        {
            //滑动的时候为保证流畅，暂停插入
            NSTimeInterval delay = 1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), FEMessageDataPrepareQueue(), ^{
                [weakSelf processPendingMessages];
            });
            return;
        }
    });

    //获取一定量的消息计算高度，并扔回到主线程
    static NSInteger FEMaxInsert = 2;
    NSArray *insert = nil;
    NSRange range;
    if (pendingMessageCount > FEMaxInsert)
    {
        range = NSMakeRange(0, FEMaxInsert);
    }
    else
    {
        range = NSMakeRange(0, pendingMessageCount);
    }
    insert = [self.pendingMessages subarrayWithRange:range];
    [self.pendingMessages removeObjectsInRange:range];
    
    NSUInteger leftPendingMessageCount = self.pendingMessages.count;
    dispatch_sync(dispatch_get_main_queue(), ^{
        [weakSelf addModels:insert];
    });
    
    if (leftPendingMessageCount)
    {
        NSTimeInterval delay = 0.1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), FEMessageDataPrepareQueue(), ^{
            [weakSelf processPendingMessages];
        });
    }
}

- (void)addModels:(NSArray<NIMMessage *> *)models
{
    NSInteger count = self.displayContent.count;
    [self.displayContent addObjectsFromArray:models];
    
    NSMutableArray *insert = [[NSMutableArray alloc] init];
    for (NSInteger index = count; index < count+models.count; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [insert addObject:indexPath];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView layoutIfNeeded];
    [self scrollToBottom:models];
}

- (void)scrollToBottom:(NSArray<NSString *> *)newModels {
    UIEdgeInsets insets = self.tableView.contentInset;
    if (insets.top != 0 ) {
        CGFloat height = 0;
        for (NSString *model in newModels) {
            height += 44;
        }
        CGFloat top = insets.top - height;
        insets.top = MAX(top, 0);
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.contentInset = insets;
        }];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.displayContent.count - 1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark 懒加载

- (FEKeyboardToolbarView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[FEKeyboardToolbarView alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, 50)];
        _keyboardView.backgroundColor = UIColor.whiteColor;
        _keyboardView.cusDelegate = self;
    }
    return _keyboardView;
}

#pragma mark FEKeyboardToolbarDelegate

- (void)didToolBarSendText:(NSString *)text {
    if (text.length) {
        [self.roomManager sendTextMessage:text];
    }
}

#pragma mark table datagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayContent.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell new];
    
    if ([self.displayContent[indexPath.row] isKindOfClass:NIMMessage.class]) {
        NIMMessage *nimMsg = self.displayContent[indexPath.row];
        cell.textLabel.text = nimMsg.text;
    } else if ([self.displayContent[indexPath.row] isKindOfClass:NSString.class]) {
        cell.textLabel.text = self.displayContent[indexPath.row];
    } else {
        cell.textLabel.text = @"占位~~~~";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if ([self.displayContent[indexPath.row] isKindOfClass:NIMMessage.class]) {
        NIMMessage *nimMsg = self.displayContent[indexPath.row];
        [UIAlertController hyl_alertWithTitle:@"确定取消此消息？" message:[NSString stringWithFormat:@"消息内容【%@】", nimMsg.text] cancelButtonName:@"取消" sureButtonName:@"确定" cancelBlock:nil sureBlock:^{
            //调用接口
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"roomid"] = weakSelf.roomId;
            dic[@"msgTimetag"] = @(nimMsg.timestamp * 1000);
            dic[@"fromAcc"] = nimMsg.from;
            dic[@"msgId"] = nimMsg.messageId;
            dic[@"operatorAcc"] = nimMsg.from;
            [NetworkInterface startPostRequestWithParams:dic method:@"https://app3-testing.5eplay.com/api/im/chatroom_recall" block:^(NSDictionary *response, NSError *error) {
                if (!error) {
                    [MBProgressHUD hyl_showInfoDetailsTitle:@"撤回成功" toView:weakSelf.view];
                    nimMsg.text = @"~~此消息已被撤回~~";
                    [weakSelf.tableView reloadData];
                } else {
                    [MBProgressHUD hyl_showInfoDetailsTitle:error.domain toView:weakSelf.view];
                }
            }];
            
        } fromVc:self];
    } else {
        [MBProgressHUD hyl_showInfoDetailsTitle:@"请选择IM消息" toView:self.view];
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark FEChatroomNotificationHandlerDelegate

/** 聊天室成员是否进入*/
- (void)didChatroomMember:(NIMChatroomNotificationMember *)member enter:(BOOL)enter {}
/** 聊天室成员是否禁言*/
- (void)didChatroomMember:(NIMChatroomNotificationMember *)member mute:(BOOL)mute {}
/** 聊天室是否禁言*/
- (void)didChatroomMute:(BOOL)mute {}
/** 聊天室是否被关闭*/
- (void)didChatroomClosed {
    
}
/** 聊天室是否已进入*/
- (void)didChatroomEnter {
    self.isEnter = true;
    [self.displayContent addObject:@"连接成功"];
    [self.tableView reloadData];
    /*
     状态展示
     拉取历史消息
     */
    __weak typeof(self) weakSelf = self;
    [self.roomManager fetchMessageHistoryWithLimit:60 result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        if (messages.count) {
            [weakSelf addMessages:messages];
        }
    }];
}

/** 接收聊天室信息*/
- (void)didShowMessages:(NSArray<NIMMessage *> *)messages {
    [self addMessages:messages];
}
//接收发送的自定义消息
- (void)didReceiveCustomMessage:(NIMMessage *)customMessage {}

@end
