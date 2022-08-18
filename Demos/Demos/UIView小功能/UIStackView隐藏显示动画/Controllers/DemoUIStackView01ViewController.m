//
//  DemoUIStackView01ViewController.m
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import "DemoUIStackView01ViewController.h"

@interface DemoUIStackView01ViewController ()

@property (nonatomic, assign) BOOL expand;

@property (nonatomic, weak) UIStackView *stackV;

@end

@implementation DemoUIStackView01ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"点击屏幕显示效果";
    
    [self ui];
}

- (void)ui {
    UIStackView *stackV = [[UIStackView alloc] init];
    [self.view addSubview:stackV];
    self.stackV = stackV;
    stackV.axis = UILayoutConstraintAxisVertical;
    [stackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(300);
    }];
    stackV.clipsToBounds = true; //注意点
    
    UIView *v01 = [self colorView:UIColor.redColor];
    [stackV addArrangedSubview:v01];
    
    UIView *v02 = [self colorView:UIColor.blueColor];
    [stackV addArrangedSubview:v02];
    
    UIView *v03 = [self colorView:UIColor.greenColor];
    [stackV addArrangedSubview:v03];
    
    UIView *v04 = [self colorView:UIColor.grayColor];
    [stackV addArrangedSubview:v04];
    
    UIView *v05 = [self colorView:UIColor.orangeColor];
    [stackV addArrangedSubview:v05];
    
    [@[v01, v02, v03, v04, v05] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
    
    [stackV bringSubviewToFront:v01]; //注意点
    
    UILabel *nameLabel = [UILabel new];
    [self.view addSubview:nameLabel];
    nameLabel.textColor = UIColor.blackColor;
    nameLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
    nameLabel.text = @"测试文字";
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(stackV.mas_bottom).offset(20);
    }];
}

- (UIView *)colorView:(UIColor *)color {
    UIView *partV = [UIView new];
    partV.backgroundColor = color;
    return partV;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.expand) { //展开
        [UIView animateWithDuration:0.3 animations:^{
            self.stackV.arrangedSubviews[1].hidden = false;
            self.stackV.arrangedSubviews[2].hidden = false;
            self.stackV.arrangedSubviews[3].hidden = false;
        }];
    } else { //收起
        [UIView animateWithDuration:0.3 animations:^{
            self.stackV.arrangedSubviews[1].hidden = true;
            self.stackV.arrangedSubviews[2].hidden = true;
            self.stackV.arrangedSubviews[3].hidden = true;
        }];
    }
    
    self.expand = !self.expand;
}

@end
