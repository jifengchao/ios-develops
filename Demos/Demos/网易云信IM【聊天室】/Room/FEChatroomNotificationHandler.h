//
//  FEChatroomHandler.h
//  NERtcAudioChatroom
//
//  Created by Simon Blue on 2019/1/25.
//  Copyright © 2019年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FEChatroomNotificationHandlerDelegate <NSObject>

/** 聊天室成员是否进入*/
- (void)didChatroomMember:(NIMChatroomNotificationMember *)member enter:(BOOL)enter;
/** 聊天室成员是否禁言*/
- (void)didChatroomMember:(NIMChatroomNotificationMember *)member mute:(BOOL)mute;
/** 聊天室是否禁言*/
- (void)didChatroomMute:(BOOL)mute;
/** 聊天室是否被关闭*/
- (void)didChatroomClosed;
/** 聊天室是否已进入*/
- (void)didChatroomEnter;

/** 接收聊天室信息*/
- (void)didShowMessages:(NSArray<NIMMessage *> *)messages;
//接收发送的自定义消息
- (void)didReceiveCustomMessage:(NIMMessage *)customMessage;

@end

@interface FEChatroomNotificationHandler : NSObject <NIMSystemNotificationManagerDelegate, NIMChatManagerDelegate, NIMChatroomManagerDelegate>

@property (nonatomic, copy) NSString *roomId;

- (instancetype)initWithDelegate:(id<FEChatroomNotificationHandlerDelegate>)delegate;

- (void)dealWithCustomNotification:(NIMCustomSystemNotification *)notification;
/** 处理聊天室消息*/
- (void)dealWithNotificationMessage:(NIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
