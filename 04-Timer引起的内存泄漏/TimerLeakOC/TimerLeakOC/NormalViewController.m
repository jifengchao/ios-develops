//
//  NormalViewController.m
//  TimerLeakOC
//
//  Created by JF on 2017/9/25.
//  Copyright © 2017年 HYL. All rights reserved.
//

#import "NormalViewController.h"

#import "HYLTimerHolder.h"

@interface NormalViewController ()<HYLTimerHolderDelegate>

@property (nonatomic, strong) HYLTimerHolder *timerHolder;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.timerHolder = [[HYLTimerHolder alloc] init];
    [self.timerHolder startTimer:1 delegate:self repeats:YES];
}

- (void)dealloc {
    
    [self.timerHolder stopTimer];
}

#pragma mark - HYLTimerHolderDelegate

- (void)onHYLTimerFired:(HYLTimerHolder *)timerHolder {
    
    NSLog(@"不存在泄漏---");
}

@end
