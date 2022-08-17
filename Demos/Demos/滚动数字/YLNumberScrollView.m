//
//  YLNumberScrollView.m
//  demo
//
//  Created by hyl on 2021/8/27.
//

/*
 数字跳动
 */

#import "YLNumberScrollView.h"

#import <Masonry/Masonry.h>

@interface YLNumberScrollView ()

@property (nonatomic, strong) NSArray *dicArray;

@property (nonatomic, weak) UILabel *integerLab;

@property (nonatomic, weak) UIView *scrollBgView;

@end

@implementation YLNumberScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 默认值
        self.labColor = UIColor.blackColor;
        self.labFont = [UIFont systemFontOfSize:16];
        self.singleLabWidth = 12;
        self.singleLabHeight = 50;
        self.duartion = 1;
        self.targetInteger = 0;
    }
    return self;
}

- (void)loadScrollBgView {
    [self.scrollBgView removeFromSuperview];
    self.scrollBgView = nil;
    [self.integerLab removeFromSuperview];
    self.integerLab = nil;
    
    if (self.targetInteger == 0) {
        UILabel *integerLab = [self scrollLab];
        [self addSubview:integerLab];
        self.integerLab = integerLab;
        integerLab.text = @(self.targetInteger).stringValue;
        [integerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    } else {
        NSArray *targetIntegerArray = [self arrayWithInteger:self.targetInteger];
        
        UIView *scrollBgView = [UIView new];
        [self addSubview:scrollBgView];
        self.scrollBgView = scrollBgView;
        [scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
        // 布局子控件scrollViews
        [self loadScrollViewsWith:targetIntegerArray];
    }
}

- (NSArray *)arrayWithInteger:(NSUInteger)integer {
    if (integer < 10) {
        return @[@(integer).stringValue];
    }
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger handleInteger = integer;
    while (handleInteger > 9) {
        int mod = handleInteger % 10;
        handleInteger = (handleInteger - mod) / 10;
        [array insertObject:@(mod).stringValue atIndex:0];
    }
    [array insertObject:@(handleInteger).stringValue atIndex:0];
    return array;
}

- (void)loadScrollViewsWith:(NSArray *)integerArray {
    if (integerArray.count == 0) return;
    NSTimeInterval singleInterval = self.duartion / integerArray.count;
    NSMutableArray *array = [NSMutableArray array];
    for (int index = 0; index < integerArray.count; index++) {
        NSString *integerString = integerArray[index];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        // 处理数据
        dic[@"random"] = [self randomWith:integerString];
        dic[@"target"] = integerString;
        dic[@"type"] = @(index % 2);
        dic[@"duartion"] = @(singleInterval * (integerArray.count - index));
        // 生成控件
        UIScrollView *scrollV = [[UIScrollView alloc] init];
        dic[@"scroll"] = scrollV;
        // 存储
        [array addObject:dic];
    }
    
    // 布局scrollView的子控件
    for (int index = 0; index < array.count; index++) {
        NSMutableDictionary *dic = array[index];
        // 取数据
        NSNumber *typeNum = dic[@"type"];
        UIScrollView *scrollV = dic[@"scroll"];
        // 布局
        [self.scrollBgView addSubview:scrollV];
        [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.singleLabWidth * index);
            if (index == array.count - 1) {
                make.right.mas_equalTo(0);
            }
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(self.singleLabWidth);
            make.height.mas_equalTo(self.singleLabHeight);
        }];
        [scrollV layoutIfNeeded];
        // 布局子控件
        UILabel *randomLab = [self scrollLab];
        randomLab.frame = CGRectMake(0, 0, self.singleLabWidth, self.singleLabHeight);
        [scrollV addSubview:randomLab];
        randomLab.text = dic[@"random"];
        UILabel *targetLab = [self scrollLab];
        targetLab.frame = CGRectMake(0, ([typeNum intValue] == 1 ?(-self.singleLabHeight) :(self.singleLabHeight)), self.singleLabWidth, self.singleLabHeight);
        [scrollV addSubview:targetLab];
        targetLab.text = dic[@"target"];
    }
    
    self.dicArray = array;
}

- (UILabel *)scrollLab {
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = self.labColor;
    lab.font = self.labFont;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (NSString *)randomWith:(NSString *)integerString {
    int integer =  [integerString intValue];
    int x = integer;
    while (x == integer) {
        // 从0到9从随机取数
        x = arc4random() % 10;
    }
    return @(x).stringValue;
}

/** 开始布局*/
- (void)startUI {
    // 布局
    [self loadScrollBgView];
    // 开始动效
    [self startAnimation];
}

/** 注意：
 scrollV的值得存在
 */
- (void)startAnimation {
    if (self.dicArray.count == 0) return;
    for (NSMutableDictionary *dic in self.dicArray) {
        // 取数据
        NSNumber *typeNum = dic[@"type"];
        UIScrollView *scrollV = dic[@"scroll"];
        NSNumber *duartionNum = dic[@"duartion"];
        
        CGFloat offsetY = [typeNum intValue] == 1 ?-self.singleLabHeight :self.singleLabHeight;
        __weak typeof(scrollV) weakScrollV = scrollV;
        // 动画
        [UIView animateWithDuration:[duartionNum floatValue] animations:^{
            [weakScrollV setContentOffset:(CGPointMake(0, offsetY))];
        }];
    }
}

@end


/*
 
 设计思路：
 存在多个滚动scrollV

 目标数值，必须大于0；暂时为整数，后面可扩展【即传入字符串】
 持续时间，可先设置默认

 居中展示

 //UI设置
 文字高度；singleLabHeight
 文字宽度；singleLabWidth

 将数字拆分成一维数组；
     再根据随机数，生成一维字典数组「random，target，type，duartion」
         type=0；从下往上滚
         type=1，从上往下滚
     duartion持续时长，依次倍数递减

 scroll布局
 先生成控件
 根据字典的type类型，设置子控件布局
     type=0，
             randomLab{0，0，singleLabWidth, singleLabHeight}
             targetLab{0，singleLabHeight，singleLabWidth, singleLabHeight}
     type=1，
             randomLab{0，0，singleLabWidth, singleLabHeight}
             targetLab{0，-singleLabHeight，singleLabWidth, singleLabHeight}

 设置字典的{scrollView = 控件}

 滚动动效
     遍历一维字典数组，为控件添加动效
 
 */
