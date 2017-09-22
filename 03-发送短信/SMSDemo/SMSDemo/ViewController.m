//
//  ViewController.m
//  SMSDemo
//
//  Created by JF on 2017/9/22.
//  Copyright © 2017年 HYL. All rights reserved.
//

#import "ViewController.h"

#import <MessageUI/MessageUI.h>

@interface ViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)sendSMSOutside {
    
    NSURL *url = [NSURL URLWithString:@"sms://10086"];
    [[UIApplication sharedApplication] openURL:url];
}

/**
 注意：
 1.使用真机调试
 2.若测试机未安装SIM卡，代理返回的依然是 MessageComposeResultSent(已发送)
 */
- (IBAction)sendSMSInside {
    
    // 实例化MFMessageComposeViewController,并设置委托
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    
    // 拼接并设置短信内容
    NSString *messageContent = [NSString stringWithFormat:@"发送短信测试内容"];
    
    messageController.body = messageContent;
    
    // 设置发送给谁
    messageController.recipients = @[@"10086", @"10010"];
    
    // 推到发送试图控制器
    [self presentViewController:messageController animated:YES completion:nil];
}

- (IBAction)sendSMSDirectly {
    
    NSString *tipContent = @"官方SDK不存在这样的直接发送短信的方式\n\n间接的解决办法是：利用自己的网关服务器或者第三方短信网关服务器，即把要发送的号码和信息传送到服务器，由服务器去发送。";
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:tipContent delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alterView show];
}


#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    NSString *tipContent;
    switch (result) {
        case MessageComposeResultCancelled:
            
            tipContent = @"发送短信取消";
            break;
        case MessageComposeResultFailed:
            
            tipContent = @"发送短信失败";
            break;
        case MessageComposeResultSent:
            
            tipContent = @"发送成功";
            break;
        default:
            break;
    }
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:tipContent delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alterView show];
}

@end
