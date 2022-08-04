//
//  FEChatroomHandler.m
//  NERtcAudioChatroom
//
//  Created by Simon Blue on 2019/1/25.
//  Copyright © 2019年 netease. All rights reserved.
//

#import "FEChatroomNotificationHandler.h"

@interface FEChatroomNotificationHandler ()

@property (nonatomic, weak) id<FEChatroomNotificationHandlerDelegate> delegate;

@end


@implementation FEChatroomNotificationHandler

- (instancetype)initWithDelegate:(id<FEChatroomNotificationHandlerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }
    return self;
}

- (void)dealWithCustomNotification:(NIMCustomSystemNotification *)notification {
}

- (void)dealWithNotificationMessage:(NIMMessage *)message {
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    switch (object.notificationType) {
        case NIMNotificationTypeChatroom:{
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
            if (content.eventType == NIMChatroomEventTypeEnter) { //进入聊天室
                NIMChatroomNotificationMember *member = content.source;
                if (_delegate && [_delegate respondsToSelector:@selector(didChatroomMember:enter:)]) {
                    [_delegate didChatroomMember:member enter:YES];
                }
            }
            else if (content.eventType == NIMChatroomEventTypeExit) { //离开聊天室
                NIMChatroomNotificationMember *member = content.source;
                if (_delegate && [_delegate respondsToSelector:@selector(didChatroomMember:enter:)]) {
                    [_delegate didChatroomMember:member enter:NO];
                }
            }
            else if (content.eventType == NIMChatroomEventTypeAddMuteTemporarily) { //禁言
                NIMChatroomNotificationMember *member = [content.targets lastObject];
                if (_delegate && [_delegate respondsToSelector:@selector(didChatroomMember:mute:)]) {
                    [_delegate didChatroomMember:member mute:YES];
                }
            }
            else if (content.eventType == NIMChatroomEventTypeRemoveMuteTemporarily) { //取消禁言
                NIMChatroomNotificationMember *member = [content.targets lastObject];
                if (_delegate && [_delegate respondsToSelector:@selector(didChatroomMember:mute:)]) {
                    [_delegate didChatroomMember:member mute:NO];
                }
            }
            else if (content.eventType == NIMChatroomEventTypeRoomMuted) { //聊天室被禁言
                if (_delegate && [_delegate respondsToSelector:@selector(didChatroomMute:)]) {
                    [_delegate didChatroomMute:YES];
                }
            }
            else if (content.eventType == NIMChatroomEventTypeRoomUnMuted) { //聊天室不在禁言状态
                if (_delegate && [_delegate respondsToSelector:@selector(didChatroomMute:)]) {
                    [_delegate didChatroomMute:NO];
                }
            }
            else if (content.eventType == NIMChatroomEventTypeClosed) { //聊天室被关闭
                if (_delegate && [_delegate respondsToSelector:@selector(didChatroomClosed)]) {
                    [_delegate didChatroomClosed];
                }
            } else if (content.eventType == NIMChatroomEventTypeInfoUpdated) {
//                NSString *ext = content.notifyExt;
//                NSDictionary *dict = [ext jsonObject];
//                NSInteger anchorMicMuteInt = dict ? [dict[@"anchorMute"] boolValue] : 0;
//                BOOL anchorMicMute = (anchorMicMuteInt ==  1 ? YES : NO);
//                if (_delegate && [_delegate respondsToSelector:@selector(didChatroomAnchorMicMute:)]) {
//                    [_delegate didChatroomAnchorMicMute:anchorMicMute];
//                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification {
    [self dealWithCustomNotification:notification];
}

#pragma mark - NIMChatManagerDelegate
- (void)willSendMessage:(NIMMessage *)message {
    switch (message.messageType) {
        case NIMMessageTypeText:
            if (_delegate && [_delegate respondsToSelector:@selector(didShowMessages:)]) {
                [_delegate didShowMessages:@[message]];
            }
            break;
        default:
            break;
    }
}

- (void)onRecvMessages:(NSArray *)messages {
    for (NIMMessage *message in messages) {
        if (![message.session.sessionId isEqualToString:_roomId]
            && message.session.sessionType == NIMSessionTypeChatroom) {
            //不属于这个聊天室的消息
            return;
        }
        switch (message.messageType) {
            case NIMMessageTypeText:
                if (_delegate && [_delegate respondsToSelector:@selector(didShowMessages:)]) {
                    [_delegate didShowMessages:@[message]];
                }
                break;
            case NIMMessageTypeCustom: {
                if (_delegate && [_delegate respondsToSelector:@selector(didReceiveCustomMessage:)]) {
                    [_delegate didReceiveCustomMessage:message];
                }
            }
                 
                break;
            case NIMMessageTypeNotification:{
                [self dealWithNotificationMessage:message];
            }
                break;
            default:
                break;
        }
    }
}

- (void)chatroomBeKicked:(NIMChatroomBeKickedResult *)result {
    if (![result.roomId isEqualToString:_roomId]) {
        return;
    }
    if (result.reason == NIMChatroomKickReasonInvalidRoom) {
        if (_delegate && [_delegate respondsToSelector:@selector(didChatroomClosed)]) {
            [_delegate didChatroomClosed];
        }
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state {
    if (state == NIMChatroomConnectionStateEnterOK && [roomId isEqualToString:self.roomId]) {
        if (_delegate && [_delegate respondsToSelector:@selector(didChatroomEnter)]) {
            [_delegate didChatroomEnter];
        }
    }
}


@end
