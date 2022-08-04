//
//  FEColor.h
//  FiveEPlay
//
//  Created by hao yin on 2020/3/27.
//  Copyright © 2020 hao yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEColor : UIColor
/// 通过色值创建颜色
/// @param color 颜色值 eg. 0xFF0000 为红色
- (instancetype)initWithRGBAColor:(uint32_t)color;

/// 通过色值创建颜色 包含alppa
/// @param color 颜色值 eg. 0xFF000077 为红色并且有透明度的
- (instancetype)initWithRGBColor:(uint32_t)color;

- (instancetype)initWithLightColorHex:(uint32_t)lightColor darkColorHex:(uint32_t)darkColor;

- (instancetype)initWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

@end


@interface UIColor (hex)

+ (UIColor*)colorFromHex:(NSString*)hex;
+ (UIColor *)colorFromRGB:(NSString *)rgb;

+ (UIColor *)titleColor;

+ (UIColor *)backgroundColor;

@end



NS_ASSUME_NONNULL_END
