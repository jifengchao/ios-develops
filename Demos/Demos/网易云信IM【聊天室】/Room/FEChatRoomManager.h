//
//  FEChatRoomManager.h
//  FiveEPlay
//
//  Created by hyl on 2022/7/6.
//  Copyright © 2022 hao yin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEChatRoomManager : NSObject

/** 拓展字段，可携带在消息中*/
@property (nonatomic, copy) NSString *roomExt;

/** 进入聊天室，需提供聊天室的信息*/
- (void)enterWith:(NSString *)roomId;
/** 进入聊天室，需提供聊天室的信息 需登录*/
- (void)enterWith:(NSString *)roomId account:(NSString *)account token:(NSString *)token;
/** 离开聊天室*/
- (void)leave;

/**
 *  查询服务器保存的聊天室消息记录
 *
 *  @param limit  查询数量
 *  @param result   完成回调
 */
- (void)fetchMessageHistoryWithLimit:(NSUInteger)limit
                              result:(nullable void(^)(NSError * __nullable error, NSArray<NIMMessage *> * __nullable messages))result;

/** 发生文本信息*/
- (void)sendTextMessage:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
