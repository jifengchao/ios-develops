//
//  NormalViewController.swift
//  TimerLeakSwift
//
//  Created by JF on 2017/9/25.
//  Copyright © 2017年 HYL. All rights reserved.
//

import UIKit

class NormalViewController: UIViewController, HYLTimerHolderDelegate {

    var timerHolder: HYLTimerHolder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.white
        
        timerHolder = HYLTimerHolder()
        timerHolder.startTimer(1, delegate: self, repeats: true)
    }
    
    deinit {
        
        timerHolder.stopTimer()
    }
    
    // MARK: - HYLTimerHolderDelegate
    func onHYLTimerFired(_ timerHolder: HYLTimerHolder) {
        
        print("不存在泄漏---")
    }

}
