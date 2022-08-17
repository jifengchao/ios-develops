//
//  YLNumberScrollView.h
//  demo
//
//  Created by hyl on 2021/8/27.
//

/*
 使用示例：
 
 YLNumberScrollView *shakeV = [[YLNumberScrollView alloc] init];
 [self.view addSubview:shakeV];
 [shakeV mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.mas_equalTo(0);
     make.right.mas_equalTo(0);
     make.top.mas_equalTo(60);
     make.height.mas_equalTo(100);
 }];
 
 shakeV.labColor = UIColor.greenColor;
 shakeV.labFont = [UIFont systemFontOfSize:18];
 shakeV.singleLabWidth = 15;
 shakeV.singleLabHeight = 20;
 shakeV.duartion = 1.5;
 shakeV.targetInteger = 712;
 
 [shakeV startUI];
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLNumberScrollView : UIView

// 布局参数

/** 最终展示的数字*/
@property (nonatomic, assign) NSUInteger targetInteger;
/** 动画持续时长*/
@property (nonatomic, assign) NSTimeInterval duartion;

/** 单个数字的宽高*/
@property (nonatomic, assign) CGFloat singleLabWidth;
@property (nonatomic, assign) CGFloat singleLabHeight;
/** 数字的颜色、字号*/
@property (nonatomic, strong) UIColor *labColor;
@property (nonatomic, strong) UIFont *labFont;

/** 开始布局*/
- (void)startUI;

@end

NS_ASSUME_NONNULL_END
