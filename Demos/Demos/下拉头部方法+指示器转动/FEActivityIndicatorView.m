//
//  FEActivityIndicatorView.m
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import "FEActivityIndicatorView.h"

#define FEActivityIndicatorViewAngle2R(value)  (value / 180.0 * M_PI)

@interface FEActivityIndicatorView () {
    CGFloat _angle;
}

@property(nonatomic, readwrite) BOOL animating;

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation FEActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.frame, CGRectZero)) return;
    
    self.imageView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}

- (void)setup {
    self.hidesWhenStopped = YES;
    self.indicatorWH = 17;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    imageView.frame = CGRectMake(0, 0, self.indicatorWH, self.indicatorWH);
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setIndicatorWH:(CGFloat)indicatorWH {
    _indicatorWH = indicatorWH;
    self.imageView.frame = CGRectMake(0, 0, self.indicatorWH, self.indicatorWH);
}

- (void)startAnimating {
    self.hidden = NO;
    self.animating = YES;
    //旋转
    [self rotateView:self.imageView duration:1.5];
}

- (void)stopAnimating {
    [self.imageView.layer removeAllAnimations];
    self.imageView.transform = CGAffineTransformIdentity;
    _angle = 0;
    self.hidden = self.hidesWhenStopped;
    self.animating = NO;
}

- (void)rotateView:(UIView *)view duration:(CFTimeInterval)duration {
    [view.layer removeAllAnimations];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0+_angle];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)rotateWith:(CGFloat)value {
    if (self.isAnimating) return;
    _angle = FEActivityIndicatorViewAngle2R(value);
    self.imageView.transform = CGAffineTransformMakeRotation(_angle);
}

@end
