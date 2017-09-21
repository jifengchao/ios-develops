//
//  ViewController.swift
//  CoreTelephonyDemo
//
//  Created by JF on 2017/9/19.
//  Copyright © 2017年 HYL. All rights reserved.
//

import UIKit

import CoreTelephony

class ViewController: UIViewController {

    var callCenter: CTCallCenter
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        callCenter = CTCallCenter()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        callCenter = CTCallCenter()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallEventHandler()
        getCarrierInfo()
    }
    
    /**
     注意:
     不要使用模拟器调试
     使用SIM卡的真机调试
     */
    func getCarrierInfo() {
        
        let info: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        print(info)
        
        let carrier: CTCarrier = info.subscriberCellularProvider!
        print(carrier)
        
        print(info.currentRadioAccessTechnology!)
        print(carrier.carrierName!)
        print(carrier.mobileCountryCode!)
        print(carrier.mobileNetworkCode!)
    }
    
    /**
     注意:
     使用SIM卡的真机调试
     另一台手机呼叫此设备时，能看到打印的信息
     */
    func setupCallEventHandler() {
        
        callCenter.callEventHandler = { call in
            
            if call.callState == CTCallStateDialing {
                
                print("正在播出电话")
            } else if call.callState == CTCallStateIncoming {
                
                print("来电话了")
            } else if call.callState == CTCallStateConnected {
                
                print("电话通了")
            } else if call.callState == CTCallStateDisconnected {
                
                print("电话挂断了")
            } else {
                
                print("什么也没做")
            }
        }
    }

}

