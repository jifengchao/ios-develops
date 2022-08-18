//
//  DemoYYLabelViewController.m
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import "DemoYYLabelViewController.h"
#import <YYText.h>

@interface DemoYYLabelViewController ()

@property (nonatomic, weak) YYLabel *yyLabel;

@end

@implementation DemoYYLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"YYLabel简单使用";
    
    [self setupYYLabel];
}

- (void)setupYYLabel {
    YYLabel *yyLabel = [[YYLabel alloc] init];
    [self.view addSubview:yyLabel];
    self.yyLabel = yyLabel;
    self.yyLabel.numberOfLines = 0;
    self.yyLabel.preferredMaxLayoutWidth = 100; // 预留区域宽度，便于多行展示【可自行动态计算】
    [yyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    
    //设置属性
    NSString *string;
    NSString *highString01 = @"高亮区域1";
    NSString *highString02 = @"高亮区域2";
    string = [NSString stringWithFormat:@"自定义文字%@自定义文字%@", highString01, highString02];
    // YYText 富文本
    UIColor *colorNormal = [FEColor colorFromHex:@"#333333"];
    UIColor *colorHighlight = [FEColor colorFromHex:@"#7C8AFF"];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    //属性
    attributedText.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    attributedText.yy_color = colorNormal;
    attributedText.yy_minimumLineHeight = 15; // 最小行高
    attributedText.yy_lineSpacing = 3;
    attributedText.yy_alignment = NSTextAlignmentJustified;
    
    __weak typeof(self) weakSelf = self;
    [attributedText yy_setTextHighlightRange:[string rangeOfString:highString01]
                             color:colorHighlight
                   backgroundColor:nil
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        [MBProgressHUD hyl_showInfoDetailsTitle:@"高亮区域1" toView:weakSelf.view];
    }];
    [attributedText yy_setTextHighlightRange:[string rangeOfString:highString02]
                             color:colorHighlight
                   backgroundColor:nil
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        [MBProgressHUD hyl_showInfoDetailsTitle:@"高亮区域2" toView:weakSelf.view];
    }];
    
    self.yyLabel.attributedText = attributedText;
}

@end
