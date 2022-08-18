//
//  UIView+Corners.h
//  demo
//
//  Created by hyl on 2022/8/17.
//

#import <UIKit/UIKit.h>

typedef struct __attribute__((objc_boxable)) UICornerRadius {
    CGFloat minXMinYRadius, maxXMinYRadius, minXMaxYRadius, maxXMaxYRadius;
} UICornerRadius;

static inline UICornerRadius UICornerRadiusMake(CGFloat minXMinYRadius, CGFloat maxXMinYRadius, CGFloat minXMaxYRadius, CGFloat maxXMaxYRadius) {
    UICornerRadius radius = {minXMinYRadius, maxXMinYRadius, minXMaxYRadius, maxXMaxYRadius};
    return radius;
}

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Corners)

@property (nonatomic, assign) UICornerRadius cornerRadius;

@end

NS_ASSUME_NONNULL_END
