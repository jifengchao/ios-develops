//
//  HYLRecordKit.h
//  RecordAndPlayOC
//
//  Created by JF on 2017/9/21.
//  Copyright © 2017年 HYL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@class HYLRecordKit;
@protocol HYLRecordKitDelegate <NSObject>

@optional
- (void)recordKit:(HYLRecordKit *)recordKit didstartRecording:(int)level;

@end

@interface HYLRecordKit : NSObject

/** 更新图片的代理 */
@property (nonatomic, assign) id<HYLRecordKitDelegate> delegate;
    
/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;
    
/** 录音工具的单例 */
+ (instancetype)sharedRecordKit;

/** 开始录音 */
- (void)startRecording;

/** 停止录音 */
- (void)stopRecording;

/** 播放录音文件 */
- (void)playRecordingFile;

/** 停止播放录音文件 */
- (void)stopPlaying;

/** 销毁录音文件 */
- (void)destructionRecordingFile;
    
@end
