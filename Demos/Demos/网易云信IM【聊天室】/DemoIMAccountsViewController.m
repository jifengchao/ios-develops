//
//  DemoIMAccountsViewController.m
//  Demos
//
//  Created by hyl on 2022/8/2.
//

#import "DemoIMAccountsViewController.h"

#define kNIM_ID @"3437b724c32feee71f3da24d8fff8f7c"

#import <NIMSDK/NIMSDK.h>
#import "FEIMRoomViewController.h"

@interface DemoIMAccountsViewController ()

@property (nonatomic, strong) NSArray<NSDictionary *> *accounts;
@property (nonatomic, strong) NSArray<NSString *> *roomIds;

@property (nonatomic, assign) NSInteger accountIndex;
@property (nonatomic, assign) NSInteger roomIdIndex;

@property (nonatomic, weak) UIStackView *stackAccountV;
@property (nonatomic, weak) UIStackView *stackIdV;

@end

@implementation DemoIMAccountsViewController

- (NSArray<NSDictionary *> *)accounts {
    if (!_accounts) {
        _accounts = @[
            @{
                @"account": @"42de4c840e45e0bef538b27ba95ce9a6",
                @"token": @"c3d3cda1a7e996e9960582c24bbd04d1",
            },
            @{
                @"account": @"f51cd793dd67df64541526e54680f962",
                @"token": @"84e069c513243c3f0b27ddb8b1a1ff33",
            },
        ];
    }
    return _accounts;
}
- (NSArray<NSString *> *)roomIds {
    if (!_roomIds) {
        _roomIds = @[
            @"1762756233",
            @"1762821561",
        ];
    }
    return _roomIds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"网易云信IM【聊天室】";
    
    self.accountIndex = self.roomIdIndex = -1;
    
    [self configIM];
    [self setupUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //先退出
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
    }];
}

- (void)configIM {
    NSString *NIM_ID = kNIM_ID;
    NIMSDKOption *option = [NIMSDKOption optionWithAppKey:NIM_ID];
    
    [[NIMSDK sharedSDK] registerWithOption:option];
}

- (void)setupUI {
    UIStackView *stackAccountV = [self stackAccountView];
    [self.view addSubview:stackAccountV];
    self.stackAccountV = stackAccountV;
    [stackAccountV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(88 + 50);
    }];
    
    UIStackView *stackIdV = [self stackIdView];
    [self.view addSubview:stackIdV];
    self.stackIdV = stackIdV;
    [stackIdV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stackAccountV);
        make.top.equalTo(stackAccountV.mas_bottom).offset(20);
    }];
    
    UIButton *doneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:doneBtn];
    [doneBtn setTitle:@"去聊天" forState:(UIControlStateNormal)];
    [doneBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
    doneBtn.backgroundColor = UIColor.orangeColor;
    [doneBtn addTarget:self action:@selector(clickDoneBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(stackIdV.mas_bottom).offset(20);
        make.height.mas_equalTo(35);
    }];
}

- (UIStackView *)stackAccountView {
    UIStackView *stackV = [[UIStackView alloc] init];
    stackV.axis = UILayoutConstraintAxisVertical;
    stackV.distribution = UIStackViewDistributionFillEqually;
    stackV.spacing = 10;
    
    for (NSDictionary *dic in self.accounts) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [stackV addArrangedSubview:btn];
        btn.tag = [self.accounts indexOfObject:dic];
        [btn setImage:[UIImage imageNamed:@"check_unselect"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"check_select"] forState:(UIControlStateSelected)];
        [btn setTitle:[NSString stringWithFormat:@"账号：%@", dic[@"account"]] forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(clickAccountBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
        }];
    }
    
    return stackV;
}

- (UIStackView *)stackIdView {
    UIStackView *stackV = [[UIStackView alloc] init];
    stackV.axis = UILayoutConstraintAxisVertical;
    stackV.distribution = UIStackViewDistributionFillEqually;
    stackV.spacing = 10;
    
    for (NSString *roomId in self.roomIds) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [stackV addArrangedSubview:btn];
        btn.tag = [self.roomIds indexOfObject:roomId];
        [btn setImage:[UIImage imageNamed:@"check_unselect"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"check_select"] forState:(UIControlStateSelected)];
        [btn setTitle:[NSString stringWithFormat:@"房间号：%@", roomId] forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(clickIdBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
        }];
    }
    
    return stackV;
}

- (void)clickAccountBtn:(UIButton *)sender {
    for (UIView *subV in self.stackAccountV.arrangedSubviews) {
        if ([subV isKindOfClass:UIButton.class]) {
            ((UIButton *)subV).selected = false;
        }
    }
    sender.selected = true;
    self.accountIndex = sender.tag;
}
- (void)clickIdBtn:(UIButton *)sender {
    for (UIView *subV in self.stackIdV.arrangedSubviews) {
        if ([subV isKindOfClass:UIButton.class]) {
            ((UIButton *)subV).selected = false;
        }
    }
    sender.selected = true;
    self.roomIdIndex = sender.tag;
}
- (void)clickDoneBtn:(UIButton *)sender {
    if (self.accountIndex == -1) {
        [MBProgressHUD hyl_showErrorDetailsTitle:@"请先选择登录账号" toView:self.view];
        return;
    }
    if (self.roomIdIndex == -1) {
        [MBProgressHUD hyl_showErrorDetailsTitle:@"请先选择房间号" toView:self.view];
        return;
    }
    
    NSString *account = self.accounts[self.accountIndex][@"account"];
    NSString *token = self.accounts[self.accountIndex][@"token"];
    NSString *roomId = self.roomIds[self.roomIdIndex];
    
    FEIMRoomViewController *vc = [[FEIMRoomViewController alloc] init];
    vc.account = account;
    vc.token = token;
    vc.roomId = roomId;
    [self.navigationController pushViewController:vc animated:true];
}

@end
