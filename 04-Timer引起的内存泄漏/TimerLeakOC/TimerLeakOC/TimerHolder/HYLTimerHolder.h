//
//  HYLTimerHolder.h
//  TimerLeakOC
//
//  Created by JF on 2017/9/25.
//  Copyright © 2017年 HYL. All rights reserved.
//

/**
 功能为
 对于非repeats的Timer, 执行一次后自动释放Timer
 对于repeats的Timer, 需要持有HYLTimerHolder的对象在析构时调用[HYLTimerHolder stopTimer]
 */

#import <Foundation/Foundation.h>

@class HYLTimerHolder;
@protocol HYLTimerHolderDelegate <NSObject>

- (void)onHYLTimerFired:(HYLTimerHolder *)timerHolder;

@end

@interface HYLTimerHolder : NSObject

/** timerHolder 标签*/
@property (nonatomic, assign) NSInteger timerHolderTag;

@property (nonatomic, weak) id<HYLTimerHolderDelegate> timerDelegate;

- (void)startTimer:(NSTimeInterval)seconds
          delegate:(id<HYLTimerHolderDelegate>)delegate
           repeats:(BOOL)repeats;

- (void)stopTimer;

@end
