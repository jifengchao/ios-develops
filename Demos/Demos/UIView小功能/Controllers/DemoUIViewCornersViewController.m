//
//  DemoUIViewCornersViewController.m
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import "DemoUIViewCornersViewController.h"
#import "UIView+Corners.h"

@interface DemoUIViewCornersViewController ()

@property (nonatomic, weak) UIView *testView;

@end

@implementation DemoUIViewCornersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"点击屏幕更改大小";
    
    [self setupUI];
}

- (void)setupUI {
    UIView *testView = [UIView new];
    [self.view addSubview:testView];
    self.testView = testView;
    testView.backgroundColor = UIColor.redColor;
    //设置切角
    testView.cornerRadius = UICornerRadiusMake(0, 15, 10, 5);
    
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat right = (arc4random() % 50);
    [self.testView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo((arc4random() % 50) + 60);
    }];
}

@end
