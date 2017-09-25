//
//  HYLTimerHolder.swift
//  TimerLeakSwift
//
//  Created by JF on 2017/9/25.
//  Copyright © 2017年 HYL. All rights reserved.
//

/**
 功能为
 对于非repeats的Timer, 执行一次后自动释放Timer
 对于repeats的Timer, 需要持有HYLTimerHolder的对象在析构时调用[HYLTimerHolder stopTimer]
 */

import UIKit

protocol HYLTimerHolderDelegate: NSObjectProtocol {
    
    func onHYLTimerFired(_ timerHolder: HYLTimerHolder);
}

class HYLTimerHolder: NSObject {

    var timerHolderTag: Int
    
    weak var timerDelegate: HYLTimerHolderDelegate?
    
    private var _timer: Timer?
    
    private var _repeats: Bool
    
    override init() {
        
        timerHolderTag = 0
        _repeats = false
        
        super.init()
    }
    
    deinit {
        
        stopTimer()
    }
    
    func startTimer(_ seconds: TimeInterval, delegate: HYLTimerHolderDelegate, repeats: Bool) {
        
        timerDelegate = delegate
        _repeats = repeats
        if let _ = _timer {
            
            self._timer!.invalidate()
            self._timer = nil
        }
        _timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(onTimer(_:)), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        
        _timer?.invalidate()
        _timer = nil
        timerDelegate = nil
    }
    
    func onTimer(_ timer: Timer) {
        
        if (!_repeats) {
            
            _timer = nil;
        }
        
        timerDelegate?.onHYLTimerFired(self)
    }
}
