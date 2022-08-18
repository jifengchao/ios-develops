//
//  FEMatchDetailIndexDataCell.m
//  FiveEPlay
//
//  Created by hyl on 2022/8/10.
//  Copyright © 2022 hao yin. All rights reserved.
//

#import "FEMatchDetailIndexDataCell.h"
#import "Util.h"

@interface FEMatchDetailIndexDataCell ()

@property (nonatomic, weak) UIStackView *indexDataV;
@property (nonatomic, weak) UIView *moreV;
@property (nonatomic, weak) UIButton *moreButton;

@end

@implementation FEMatchDetailIndexDataCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildSubviews];
    }
    return self;
}

// 构建子视图
- (void)buildSubviews {
    self.contentView.backgroundColor = [FEColor colorFromHex:@"f4f4f4"];
    
    UIView *roundV = [UIView new];
    [self.contentView addSubview:roundV];
    roundV.clipsToBounds = true;
    roundV.backgroundColor = UIColor.whiteColor;

    [roundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    
    UIView *introV = [self introView];
    [roundV addSubview:introV];
    
    UIStackView *indexDataV = [self indexDataView];
    [roundV addSubview:indexDataV];
    self.indexDataV = indexDataV;
    indexDataV.clipsToBounds = true; //注意点
    
    [introV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(37);
    }];
    [indexDataV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(introV.mas_bottom);
    }];
    
    UIView *moreV = [self moreView];
    [roundV addSubview:moreV];
    self.moreV = moreV;
    [moreV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(indexDataV.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];
}

- (UIView *)introView {
    UIView *partV = [UIView new];
    
    UILabel *roundIndexLabel = [UILabel new];
    [partV addSubview:roundIndexLabel];
    self.roundIndexLabel = roundIndexLabel;
    roundIndexLabel.textColor = [FEColor colorFromHex:@"8390ff"];
    roundIndexLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    UILabel *name1Label = [UILabel new];
    [partV addSubview:name1Label];
    self.name1Label = name1Label;
    name1Label.textColor = [FEColor colorFromHex:@"333333"];
    name1Label.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    UILabel *name2Label = [UILabel new];
    [partV addSubview:name2Label];
    self.name2Label = name2Label;
    name2Label.textColor = [FEColor colorFromHex:@"333333"];
    name2Label.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    [roundIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(0);
    }];
    [name1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    [name2Label mas_makeConstraints:^(MASConstraintMaker *make) { //临时的 - 布局存在疑问
        make.right.mas_equalTo(-14);
        make.centerY.mas_equalTo(0);
    }];
    
    return partV;
}

- (UIStackView *)indexDataView {
    UIStackView *partV = [[UIStackView alloc] init];
    partV.axis = UILayoutConstraintAxisVertical;
    return partV;
}

- (UIView *)indexItemView:(UIColor *)color data:(id)data {
    UIView *partV = [UIView new];
    partV.backgroundColor = color;
    
    UILabel *label01 = [UILabel new];
    [partV addSubview:label01];
    label01.textColor = [FEColor colorFromHex:@"999999"];
    label01.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    UILabel *label02 = [UILabel new];
    [partV addSubview:label02];
    label02.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    UILabel *label03 = [UILabel new];
    [partV addSubview:label03];
    label03.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    [label01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.centerY.mas_equalTo(0);
    }];
    [label02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    [label03 mas_makeConstraints:^(MASConstraintMaker *make) { //临时的 - 布局存在疑问
        make.centerX.equalTo(partV.mas_right).offset(-25);
        make.centerY.mas_equalTo(0);
    }];
    
    //临时的 - 赋值
    label01.text = @"2022-08-19";
    label02.text = @"1.52";
    label03.text = @"0.26";
    
    return partV;
}

- (UIView *)moreView {
    UIView *partV = [UIView new];
    
    UIButton *moreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [partV addSubview:moreButton];
    self.moreButton = moreButton;
    //临时的 - 缺切图
    [moreButton setImage:[UIImage imageNamed:@"select_expand_indicate_close"] forState:(UIControlStateNormal)];
    moreButton.backgroundColor = [[FEColor colorFromHex:@"8390ff"] colorWithAlphaComponent:0.05];
    [moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(-1);
        make.height.mas_equalTo(20);
    }];
    
    return partV;
}

- (void)setDataModel:(FEMatchDetailIndexDataModel *)dataModel {
    _dataModel = dataModel;
    
    //临时的
    self.roundIndexLabel.text = @"全局胜负";
    self.name1Label.text = @"NAVI";
    self.name2Label.text = @"TYLOO";
    
    [self loadList];
    self.moreButton.selected = dataModel.selected;
    if (dataModel.selected) {
        [self hideIndex:false];
        self.moreButton.transform = CGAffineTransformMakeScale(1, -1);
    } else {
        [self hideIndex:true];
        self.moreButton.transform = CGAffineTransformIdentity;
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    self.moreV.hidden = _dataModel.array.count <= 2;
    [self.moreV mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.moreV.hidden) {
            make.height.mas_equalTo(0);
        } else {
            make.height.mas_equalTo(42);
        }
    }];
    [super updateConstraints];
}

- (void)loadList {
    [self.indexDataV.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray<UIView *> *items = [NSMutableArray array];
    for (int index = 0; index < _dataModel.array.count; index ++) {
        UIColor *colorBg = (index % 2 == 0) ?[[FEColor colorFromHex:@"8390ff"] colorWithAlphaComponent:0.05] :UIColor.whiteColor;
        UIView *itemV = [self indexItemView:colorBg data:_dataModel.array[index]];
        [self.indexDataV addArrangedSubview:itemV];
        if (index > 1) {
            itemV.tag = 20220810;
        }
        [items addObject:itemV];
    }
    [items mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
    }];
    if (items.count > 2) { //注意点
        [self.indexDataV bringSubviewToFront:items[0]];
        [self.indexDataV bringSubviewToFront:items[1]];
    }
}

- (void)hideIndex:(BOOL)hidden {
    for (UIView *subV in self.indexDataV.arrangedSubviews) {
        if (subV.tag == 20220810) {
            subV.hidden = hidden;
        }
    }
}

- (void)clickMoreButton:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    
    sender.selected = !sender.selected;
    [self.tabV beginUpdates];   //注意点
    if (sender.selected) { //展开
        [UIView animateWithDuration:0.3 animations:^{
            [self hideIndex:false];
            self.moreButton.transform = CGAffineTransformMakeScale(1, -1);
        } completion:^(BOOL finished) {
            sender.userInteractionEnabled = true;
        }];
    } else { //隐藏
        [UIView animateWithDuration:0.3 animations:^{
            [self hideIndex:true];
            self.moreButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            sender.userInteractionEnabled = true;
        }];
    }
    [self.tabV endUpdates]; //注意点
    
    _dataModel.selected = sender.selected;
}

@end


@implementation FEMatchDetailIndexDataModel

- (NSArray *)array { //临时的
    NSMutableArray *mu = [NSMutableArray array];
    for (int index = 0; index < _count; index++) {
        [mu addObject:@""];
    }
    return mu;
}

@end
