//
//  ViewController.m
//  RecordAndPlayOC
//
//  Created by JF on 2017/9/21.
//  Copyright © 2017年 HYL. All rights reserved.
//

#import "ViewController.h"

#import "HYLRecordKit.h"

@interface ViewController ()<HYLRecordKitDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *levelImgView;

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
    
@property (nonatomic, strong) HYLRecordKit *recordKit;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDatas];
}
    
- (void)dealloc {
    
    if ([self.recordKit.recorder isRecording]) [self.recordKit stopPlaying];
    if ([self.recordKit.player isPlaying]) [self.recordKit stopRecording];
}

- (void)setupDatas {
    
    self.recordKit = [HYLRecordKit sharedRecordKit];
    
    self.recordKit.delegate = self;
    // 录音按钮
    [self.recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.recordBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    // 播放按钮
    [self.playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
}
    
/** 按下 */ 
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
    
    [self.recordKit startRecording];
}
    
/** 点击 */
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
    
    double currentTime = self.recordKit.recorder.currentTime;
    NSLog(@"%lf", currentTime);
    if (currentTime < 2) {
        
        NSLog(@"说话时间太短");
        
        self.levelImgView.image = [UIImage imageNamed:@"mic_0"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordKit stopRecording];
            [self.recordKit destructionRecordingFile];
        });
    } else {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordKit stopRecording];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.levelImgView.image = [UIImage imageNamed:@"mic_0"];
            });
        });
        
        NSLog(@"已成功录音");
    }
}
    
/** 手指从按钮上移除 */
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
    
    self.levelImgView.image = [UIImage imageNamed:@"mic_0.png"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.recordKit stopRecording];
        [self.recordKit destructionRecordingFile];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"已取消录音");
        });
    });
}
    
/** 播放 */
- (void)play {
    
    [self.recordKit playRecordingFile];
}
    
#pragma mark - HYLRecordKitDelegate
- (void)recordKit:(HYLRecordKit *)recordKit didstartRecording:(int)level {
    
    NSString *imageName = [NSString stringWithFormat:@"mic_%d.png", level];
    self.levelImgView.image = [UIImage imageNamed:imageName];
}

@end
