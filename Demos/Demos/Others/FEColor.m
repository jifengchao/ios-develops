//
//  FEColor.m
//  FiveEPlay
//
//  Created by hao yin on 2020/3/27.
//  Copyright © 2020 hao yin. All rights reserved.
//

#import "FEColor.h"

@implementation FEColor
- (instancetype)initWithRGBAColor:(uint32_t)color{
    NSUInteger R = (color & 0xff000000) >> 24;
    NSUInteger G = (color & 0x00ff0000) >> 16;
    NSUInteger B = (color & 0x0000ff00) >> 8 ;
    NSUInteger A = (color & 0x000000ff);
    
    return [self initWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A / 255.0];;
}
- (instancetype)initWithRGBColor:(uint32_t)color{
    color = color << 8;
    color = color | 0x000000ff;
    return [self initWithRGBAColor:color];
}
- (instancetype)initWithLightColorHex:(uint32_t)lightColor darkColorHex:(uint32_t)darkColor{
    if (@available(iOS 13.0, *)) {
        return [self initWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
                return [[FEColor alloc] initWithRGBAColor:darkColor];
            }else{
                return [[FEColor alloc] initWithRGBAColor:lightColor];
            }
        }];
    } else {
        return [[FEColor alloc] initWithRGBAColor:lightColor];
    }
}

- (instancetype)initWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor{
    if (@available(iOS 13.0, *)) {
        return [self initWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if(traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
                return darkColor;
            }else{
                return lightColor;
            }
        }];
    } else {
        return (FEColor *)lightColor;
    }
}
@end

@implementation UIColor (hex)

+(UIColor*)colorFromHex:(NSString*)hex{
    NSString * newHex = hex;
    if ([newHex hasPrefix:@"#"]) {
        newHex = [newHex substringFromIndex:1];
    }
    if ([newHex hasPrefix:@"0x"]) {
        newHex = [newHex substringFromIndex:2];
    }
    if (newHex.length != 3 && newHex.length != 6 && newHex.length != 8 && newHex.length < 3) {
        return UIColor.clearColor;
    }
    NSRange range = NSMakeRange(0, 2);
    unsigned int alpha = 255,red = 0,green = 0,blue = 0;
    //Check for short hex strings
    if(newHex.length == 3) {
        //Convert to full length hex string
        newHex = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                  [newHex substringWithRange:NSMakeRange(0, 1)],[newHex substringWithRange:NSMakeRange(0, 1)],
                  [newHex substringWithRange:NSMakeRange(1, 1)],[newHex substringWithRange:NSMakeRange(1, 1)],
                  [newHex substringWithRange:NSMakeRange(2, 1)],[newHex substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if (newHex.length == 8) {
        NSString * alphaStr = [newHex substringWithRange:range];
        range.location = 2;
        NSString * redStr = [newHex substringWithRange:range];
        range.location = 4;
        NSString * greenStr = [newHex substringWithRange:range];
        range.location = 6;
        NSString * blueStr = [newHex substringWithRange:range];
        [[NSScanner scannerWithString:alphaStr] scanHexInt:&alpha];
        [[NSScanner scannerWithString:redStr] scanHexInt:&red];
        [[NSScanner scannerWithString:greenStr] scanHexInt:&green];
        [[NSScanner scannerWithString:blueStr] scanHexInt:&blue];
        return [UIColor colorWithRed:[self transferColorValue:red] green:[self transferColorValue:green] blue:[self transferColorValue:blue] alpha:[self transferColorValue:alpha]];
    }
    
    if (newHex.length == 6) {
        NSString * redStr = [newHex substringWithRange:range];
        range.location = 2;
        NSString * greenStr = [newHex substringWithRange:range];
        range.location = 4;
        NSString * blueStr = [newHex substringWithRange:range];
        [[NSScanner scannerWithString:redStr] scanHexInt:&red];
        [[NSScanner scannerWithString:greenStr] scanHexInt:&green];
        [[NSScanner scannerWithString:blueStr] scanHexInt:&blue];
        return [UIColor colorWithRed:[self transferColorValue:red] green:[self transferColorValue:green] blue:[self transferColorValue:blue] alpha:[self transferColorValue:alpha]];
        
    }
    
    return UIColor.clearColor;
}

/** rgb(235, 75, 75)*/
+ (UIColor *)colorFromRGB:(NSString *)rgb {
    // 移除空白
    if (rgb.length == 0) return nil;
    NSString *replacedRgb = [rgb stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![replacedRgb hasPrefix:@"rgb("] || ![replacedRgb hasSuffix:@")"]) return nil;
    NSRange range = NSMakeRange(4, replacedRgb.length - 5);
    NSString *subRgb = [replacedRgb substringWithRange:range];
    NSArray *rgbArr = [subRgb componentsSeparatedByString:@","];
    if (rgbArr.count != 3) return nil;
    return [UIColor colorWithRed:([rgbArr[0] intValue] / 255.0) green:([rgbArr[1] intValue] / 255.0) blue:([rgbArr[2] intValue] / 255.0) alpha:1];
}

+(CGFloat)transferColorValue:(unsigned int)value{
    
    return value/255.0;
}


+ (UIColor *)titleColor{
    return [[FEColor alloc] initWithRGBColor:0x151617];
}

+ (UIColor *)backgroundColor;{
    return UIColor.whiteColor;
}


@end
