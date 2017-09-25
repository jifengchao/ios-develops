//
//  LeakViewController.swift
//  TimerLeakSwift
//
//  Created by JF on 2017/9/25.
//  Copyright © 2017年 HYL. All rights reserved.
//

import UIKit

class LeakViewController: UIViewController {

    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.white
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(log), userInfo: nil, repeats: true)
//            Timer(timeInterval: 1, target: self, selector: #selector(log), userInfo: nil, repeats: true)
    }

    deinit {
        
        timer.invalidate()
    }
    
    func log() {
        
        print("存在泄漏---")
    }
    
}
