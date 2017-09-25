//
//  LeakViewController.m
//  TimerLeakOC
//
//  Created by JF on 2017/9/25.
//  Copyright © 2017年 HYL. All rights reserved.
//

#import "LeakViewController.h"

@interface LeakViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(log) userInfo:nil repeats:YES];
}

- (void)log {
    
    NSLog(@"存在泄漏---");
}

- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
}

@end
