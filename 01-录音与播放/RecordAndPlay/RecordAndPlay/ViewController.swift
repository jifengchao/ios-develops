//
//  ViewController.swift
//  RecordAndPlay
//
//  Created by JF on 2017/9/21.
//  Copyright © 2017年 HYL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HYLRecordKitDelegate {

    @IBOutlet weak var levelImgView: UIImageView!
    
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var playBtn: UIButton!
    
    var recordKit: HYLRecordKit
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        recordKit = HYLRecordKit()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
    
        recordKit = HYLRecordKit()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatas()
    }

    deinit {
        recordKit.stopRecording()
        recordKit.stopPlaying()
    }
    
    func setupDatas() {
        
        recordKit.delegate = self
        
        // 录音按钮
        recordBtn.setTitle("按住 说话", for: .normal)
        recordBtn.setTitle("松开 结束", for: .highlighted)
        
        recordBtn.addTarget(self, action: #selector(recordBtnDidTouchDown), for: .touchDown)
        recordBtn.addTarget(self, action: #selector(recordBtnDidTouchUpInside), for: .touchUpInside)
        recordBtn.addTarget(self, action: #selector(recordBtnDidTouchDragExit), for: .touchDragExit)
        
        // 播放按钮
        playBtn.addTarget(self, action: #selector(play), for: .touchUpInside)
    }
    
    /** 按下 */
    func recordBtnDidTouchDown() {
        
        recordKit.startRecording()
    }
    
    /** 点击 */
    func recordBtnDidTouchUpInside() {
        
        let currentTime = recordKit.recorder.currentTime
        
        if currentTime < 2 {
            
            levelImgView.image = UIImage(named: "mic_0.png")
            print("说话时间太短")
            DispatchQueue.global().async {
                
                self.recordKit.stopRecording()
                self.recordKit.destructionRecordingFile()
            }
        } else {
            
            DispatchQueue.global().async {
                
                self.recordKit.stopRecording()
                DispatchQueue.main.async {
                    
                    self.levelImgView.image = UIImage(named: "mic_0.png")
                }
            }
            print("已成功录音")
        }
    }
    
    /** 手指从按钮上移除 */
    func recordBtnDidTouchDragExit() {
        
        levelImgView.image = UIImage(named: "mic_0.png")
        
        DispatchQueue.global().async {
        
            self.recordKit.stopRecording()
            self.recordKit.destructionRecordingFile()
            DispatchQueue.global().async {
            
                print("已取消录音")
            }
        }
    }
    
    /** 播放录音 */
    func play() {
        
        recordKit.playRecordingFile()
    }
    
    // MARK: - HYLRecordKitDelegate
    func recordKit(_ recordKit: HYLRecordKit, didstartRecording level: Int) {
        
        levelImgView.image = UIImage(named: "mic_\(level).png")
    }
}

