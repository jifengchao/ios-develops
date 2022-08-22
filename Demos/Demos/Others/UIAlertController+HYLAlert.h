//
//  UIAlertController+HYLAlert.h
//  QiQueQiao
//
//  Created by dc on 2017/12/7.
//  Copyright © 2017年 dc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (HYLAlert)

+ (void)hyl_alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)cancelButtonName sureButtonName:(NSString *)sureButtonName cancelBlock:(void(^)(void))cancelBlock sureBlock:(void(^)(void))sureBlock fromVc:(UIViewController *)fromVc;

+ (void)hyl_alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)cancelButtonName cancelBlock:(void(^)(void))cancelBlock fromVc:(UIViewController *)fromVc;

@end
