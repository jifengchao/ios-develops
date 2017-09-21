//
//  HYLRecordKit.swift
//  RecordAndPlay
//
//  Created by JF on 2017/9/21.
//  Copyright © 2017年 HYL. All rights reserved.
//

import UIKit

import AVFoundation

@objc protocol HYLRecordKitDelegate {
    
    @objc optional func recordKit(_ recordKit: HYLRecordKit, didstartRecording level: Int)
}

let HYLRecordFilelName = "HYLRecord.caf"

class HYLRecordKit: NSObject, AVAudioRecorderDelegate {

    var delegate: HYLRecordKitDelegate?
    
    /** 录音对象 */
    var recorder: AVAudioRecorder!
    
    /** 播放器对象 */
    var player: AVAudioPlayer?
    
    var recordFileUrl: URL
    
    var session: AVAudioSession
    
    var timer: Timer!
    
    override init() {
        
        // 获取沙盒地址
        let path: NSString? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last as NSString?
        let filePath = path?.appendingPathComponent(HYLRecordFilelName) ?? ""
        recordFileUrl = URL(fileURLWithPath: filePath)
        print("filePath = \(filePath)")
        
        session = AVAudioSession.sharedInstance()
        
        super.init()
        
        // 设置录音的一些参数
        let setting = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleIMA4), // 编码格式
            AVSampleRateKey: NSNumber(value: 44100.0), // 声音采样率
            AVNumberOfChannelsKey: NSNumber(value: 1), // 采集音轨
            AVLinearPCMBitDepthKey: NSNumber(value: 8),
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.high.rawValue)
        ]
        
        do {
            try recorder = AVAudioRecorder(url: recordFileUrl, settings: setting)
        } catch {
        }
        
        recorder.delegate = self
        recorder.isMeteringEnabled = true
        recorder.prepareToRecord()
    }
    
    /** 开始录音 */
    func startRecording() {
        
        // 录音时停止播放 删除曾经生成的文件
        stopPlaying()
        destructionRecordingFile()
        
        // 真机环境下需要的代码
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            recorder.record()
        } catch {
            
        }
        
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    func updateImage() {
        
        recorder.updateMeters()
        
        let lowPassResults = pow(10, 0.05 * Double(recorder.peakPower(forChannel: 0)))
        
        let result = 10 * lowPassResults
        
        var level = 0
        if result > 0 && result <= 1.3 {
            level = 1
        } else if result > 1.3 && result <= 2 {
            level = 2
        } else if (result > 2 && result <= 3.0) {
            level = 3
        } else if (result > 3.0 && result <= 3.0) {
            level = 4
        } else if (result > 5.0 && result <= 10) {
            level = 5
        } else if (result > 10 && result <= 40) {
            level = 6
        } else if (result > 40) {
            level = 7
        }
        
        delegate?.recordKit?(self, didstartRecording: level)
    }
    
    /** 停止录音 */
    func stopRecording() {
        
        if recorder.isRecording {
            recorder.stop()
            timer.invalidate()
            
            do {
                try session.setActive(false)
            } catch {
            }
        }
    }
    
    /** 播放录音文件 */
    func playRecordingFile() {
        
        recorder.stop()
        
        if let player = player {
            
            if player.isPlaying {
                return
            }
        }
        
        do {
            try player = AVAudioPlayer(contentsOf: recordFileUrl)
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            
        }
        
        player?.play()
    }
    
    /** 停止播放录音文件 */
    func stopPlaying() {
        
        if let player = player {
            
            player.stop()
        }
    }
    
    /** 销毁录音文件 */
    func destructionRecordingFile() {
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: recordFileUrl)
        } catch {
            
        }
    }
    
    // MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            
            do {
                try session.setActive(false)
            } catch {
                
            }
        }
    }
}


