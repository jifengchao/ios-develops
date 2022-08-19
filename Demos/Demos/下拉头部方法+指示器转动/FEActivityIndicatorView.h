//
//  FEActivityIndicatorView.h
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEActivityIndicatorView : UIView

@property(nonatomic) BOOL hidesWhenStopped;           // default is YES. calls -setHidden when animating gets set to NO

@property (nonatomic, assign) CGFloat indicatorWH;

@property(nonatomic, readonly, getter=isAnimating) BOOL animating;

@property (nonatomic, strong) UIImage *image;

/** pt换算旋转角度*/
- (void)rotateWith:(CGFloat)value;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
