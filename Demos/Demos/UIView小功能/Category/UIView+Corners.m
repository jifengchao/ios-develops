//
//  UIView+Corners.m
//  demo
//
//  Created by hyl on 2022/8/17.
//

#import "UIView+Corners.h"
#import <objc/runtime.h>

static const void *FEViewCorners = &FEViewCorners;

@implementation UIView (Corners)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method feViewWillAppear = class_getInstanceMethod(self, @selector(fe_layoutSubviews));
        Method viewWillAppear = class_getInstanceMethod(self, @selector(layoutSubviews));
        method_exchangeImplementations(viewWillAppear, feViewWillAppear);
    });
}

- (void)fe_layoutSubviews {
    [self fe_layoutSubviews];
    
    NSValue *value = objc_getAssociatedObject(self, FEViewCorners);
    if (!value) return;
    
    //绘制
    CGRect bounds = self.bounds;
    UICornerRadius cornerRadius = self.cornerRadius;
    CGFloat topLeft = cornerRadius.minXMinYRadius;
    CGFloat topRight = cornerRadius.maxXMinYRadius;
    CGFloat bottemLeft = cornerRadius.minXMaxYRadius;
    CGFloat bottemRight = cornerRadius.maxXMaxYRadius;
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;

    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1.0;
    maskPath.lineCapStyle = kCGLineCapRound;
    maskPath.lineJoinStyle = kCGLineJoinRound;
    [maskPath moveToPoint:CGPointMake(bottemRight, height)]; //左下角
    [maskPath addLineToPoint:CGPointMake(width - bottemRight, height)];

    [maskPath addQuadCurveToPoint:CGPointMake(width, height- bottemRight) controlPoint:CGPointMake(width, height)]; //右下角的圆弧
    [maskPath addLineToPoint:CGPointMake(width, topRight)]; //右边直线

    [maskPath addQuadCurveToPoint:CGPointMake(width - topRight, 0) controlPoint:CGPointMake(width, 0)]; //右上角圆弧
    [maskPath addLineToPoint:CGPointMake(topLeft, 0)]; //顶部直线

    [maskPath addQuadCurveToPoint:CGPointMake(0, topLeft) controlPoint:CGPointMake(0, 0)]; //左上角圆弧
    [maskPath addLineToPoint:CGPointMake(0, height - bottemLeft)]; //左边直线
    [maskPath addQuadCurveToPoint:CGPointMake(bottemLeft, height) controlPoint:CGPointMake(0, height)]; //左下角圆弧

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UICornerRadius)cornerRadius {
    NSValue *value = objc_getAssociatedObject(self, FEViewCorners);
    UIEdgeInsets inset = value.UIEdgeInsetsValue;
    return UICornerRadiusMake(inset.top, inset.left, inset.bottom, inset.right);
}

- (void)setCornerRadius:(UICornerRadius)cornerRadius {
    NSValue *value = [NSValue valueWithUIEdgeInsets:(UIEdgeInsetsMake(cornerRadius.minXMinYRadius, cornerRadius.maxXMinYRadius, cornerRadius.minXMaxYRadius, cornerRadius.maxXMaxYRadius))];
    objc_setAssociatedObject(self, FEViewCorners, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
