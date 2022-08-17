//
//  DemoNumberScrollViewController.m
//  Demos
//
//  Created by hyl on 2022/8/17.
//

#import "DemoNumberScrollViewController.h"
#import "YLNumberScrollView.h"

@interface DemoNumberScrollViewController ()

@property (nonatomic, strong) YLNumberScrollView *shakeV;

@end

@implementation DemoNumberScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self ui];
}

- (void)ui {
    YLNumberScrollView *shakeV = [[YLNumberScrollView alloc] init];
    [self.view addSubview:shakeV];
    self.shakeV = shakeV;
    [shakeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    shakeV.labColor = UIColor.greenColor;
    shakeV.labFont = [UIFont systemFontOfSize:18];
    shakeV.singleLabWidth = 15;
    shakeV.singleLabHeight = 20;
    shakeV.duartion = 1.5;
    shakeV.targetInteger = 7012;
    
    
    UILabel *nameLabel = [UILabel new];
    [self.view addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
    nameLabel.text = @"点击屏幕开始吧";
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.shakeV startUI];
}

@end
