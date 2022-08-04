//
//  FEKeyboardToolbar.h
//  NLiteAVDemo
//
//  Created by Think on 2021/1/20.
//  Copyright © 2021 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FEKeyboardToolbarDelegate <NSObject>

/**
 点击工具条发送文字
 @param text    - 文本
 */
- (void)didToolBarSendText:(NSString *)text;

@end

@interface FEKeyboardToolbarView : UIView


@property (nonatomic, weak) id<FEKeyboardToolbarDelegate> cusDelegate;

////相应成为第一响应者
- (void)becomeFirstResponse;

- (void)setUpInputContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
