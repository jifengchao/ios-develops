//
//  FEChatRoomManager.m
//  FiveEPlay
//
//  Created by hyl on 2022/7/6.
//  Copyright © 2022 hao yin. All rights reserved.
//

#import "FEChatRoomManager.h"

@interface FEChatRoomManager()

/** 是否为独立模式，即无需登录即可进入聊天室*/
@property (nonatomic, assign) BOOL needLogin;

@property (nonatomic, copy) NSString *roomId;
/** 登录信息 account和token*/
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *token;

@end

@implementation FEChatRoomManager

/** 进入聊天室，需提供聊天室的信息*/
- (void)enterWith:(NSString *)roomId {
    self.needLogin = false;
    self.roomId = roomId;
    [self enterNotWithLogin];
}
/** 进入聊天室，需提供聊天室的信息 需登录*/
- (void)enterWith:(NSString *)roomId account:(NSString *)account token:(NSString *)token {
    self.needLogin = true;
    self.roomId = roomId;
    self.account = account;
    self.token = token;
    [self enterWithLogin];
}


- (void)enterWithLogin {
    id<NIMChatroomManager> chatroomManager = [[NIMSDK sharedSDK] chatroomManager];
    [self loginWithAccount:self.account token:self.token back:^(NSError *error) {
        NSLog(@"login error %@", error);
        [chatroomManager enterChatroom:[self enterRequest] completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
            NSLog(@"enterChatroom error %@", error);
        }];
    }];
}
- (void)enterNotWithLogin {
    id<NIMChatroomManager> chatroomManager = [[NIMSDK sharedSDK] chatroomManager];
    [chatroomManager enterChatroom:[self enterRequest] completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
        NSLog(@"");
    }];
}

- (NIMChatroomEnterRequest *)enterRequest {
    NIMChatroomEnterRequest *request = [NIMChatroomEnterRequest new];
    request.roomId = self.roomId;
    if (self.roomExt.length) {
        request.roomExt = self.roomExt;
    }
    if (self.needLogin) {
        request.mode = nil;
    } else {
        NIMChatroomIndependentMode *model = [NIMChatroomIndependentMode new];
        model.username = @"";
//        model.chatroomAppKey = @"";
        
//        [NIMChatroomIndependentMode registerRequestChatroomAddressesHandler:^(NSString * _Nonnull roomId, NIMRequestChatroomAddressesCallback  _Nonnull callback) {
//            //App服务器获取addresses
//            [YourHTTPService request:roomId completion:^(NSError *error,NSArray *addresses)
//            {
//                //无论请求是否成功，都需要进行回调
//                if(callback)
//                {
//                    callback(error,addresses);
//                }
//            }];
//        }];
        
        request.mode = model;
    }
    
    return request;
}

- (void)loginWithAccount:(NSString *)account token:(NSString *)token back:(void(^)(NSError *error))back {
    if ([[[NIMSDK sharedSDK] loginManager] isLogined]) {
        if (back) back(nil);
        return;
    }
    
    [[[NIMSDK sharedSDK] loginManager] login:account
                                       token:token
                                  completion:^(NSError *error) {
        if (back) back(error);
    }];

}

#pragma mark 聊天室数据

/**
 *  查询服务器保存的聊天室消息记录
 *
 *  @param limit  查询数量
 *  @param result   完成回调
 */
- (void)fetchMessageHistoryWithLimit:(NSUInteger)limit
                              result:(nullable void(^)(NSError * __nullable error, NSArray<NIMMessage *> * __nullable messages))result {
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.startTime = 0;
    option.limit = limit;
    option.order = NIMMessageSearchOrderDesc;
    [[[NIMSDK sharedSDK] chatroomManager] fetchMessageHistory:self.roomId option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        //倒叙
        NSArray *array = messages.count ?[[messages reverseObjectEnumerator] allObjects] :messages;
        if (result) result(error, array);
    }];
}

#pragma mark 行为

/** 离开聊天室*/
- (void)leave {
    id<NIMChatroomManager> chatroomManager = [[NIMSDK sharedSDK] chatroomManager];
    [chatroomManager exitChatroom:self.roomId completion:^(NSError * _Nullable error) {
        NSLog(@"");
    }];
}

/** 发生文本信息*/
- (void)sendTextMessage:(NSString *)text {
    if (text.length == 0) return;
    NIMMessage *textMessage = [[NIMMessage alloc] init];
    textMessage.text = text;
    
    NSMutableDictionary *remoteExt = @{}.mutableCopy;
    remoteExt[@"avatar_url"] = @"https://oss.5ewin.com/avatar/20210616/990c373e72bfc9cafe5dd1c00fb5938e.jpg";
    remoteExt[@"username"] = @"ios_模拟器";
    textMessage.remoteExt = remoteExt;
    
    NIMSession *session = [NIMSession session:self.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:textMessage toSession:session error:nil];
}

@end
