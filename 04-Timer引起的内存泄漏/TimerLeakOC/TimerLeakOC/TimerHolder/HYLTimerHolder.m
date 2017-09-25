//
//  HYLTimerHolder.m
//  TimerLeakOC
//
//  Created by JF on 2017/9/25.
//  Copyright © 2017年 HYL. All rights reserved.
//

#import "HYLTimerHolder.h"

@interface HYLTimerHolder () {
    
    NSTimer *_timer;
    BOOL _repeats;
}

- (void)onTimer:(NSTimer *)timer;

@end

@implementation HYLTimerHolder

- (void)dealloc {
    
    [self stopTimer];
}

- (void)startTimer:(NSTimeInterval)seconds
          delegate:(id<HYLTimerHolderDelegate>)delegate
           repeats:(BOOL)repeats {
    
    _timerDelegate = delegate;
    _repeats = repeats;
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:repeats];
}

- (void)stopTimer {
    
    [_timer invalidate];
    _timer = nil;
    _timerDelegate = nil;
}

- (void)onTimer: (NSTimer *)timer {
    
    if (!_repeats) {
        
        _timer = nil;
    }
    if (_timerDelegate && [_timerDelegate respondsToSelector:@selector(onHYLTimerFired:)]) {
        
        [_timerDelegate onHYLTimerFired:self];
    }
}

@end
