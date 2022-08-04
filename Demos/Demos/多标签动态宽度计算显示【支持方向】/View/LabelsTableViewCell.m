//
//  LabelsTableViewCell.m
//  demo
//
//  Created by hyl on 2022/7/25.
//

#import "LabelsTableViewCell.h"
#import <Masonry.h>

#import "FEDirectionLabelsFlowLayout.h"
#import "LabelsCell.h"

@interface LabelsTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, FEDirectionLabelsFlowLayoutDelegate>

@property (nonatomic, strong) UIView *itemsView;
@property (nonatomic, strong) UICollectionView *collectionV;

@end

@implementation LabelsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildSubviews];
    }
    return self;
}

- (void)buildSubviews {
    UIStackView *stackV = [[UIStackView alloc] init];
    [self.contentView addSubview:stackV];
    self.stackView = stackV;
    stackV.axis = UILayoutConstraintAxisVertical;
    [stackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView *view0 = [UIView new];
    [stackV addArrangedSubview:view0];
    view0.backgroundColor = UIColor.redColor;
    [view0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
    }];
    UILabel *nameLabel = [UILabel new];
    [view0 addSubview:nameLabel];
    nameLabel.textColor = UIColor.whiteColor;
    nameLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
    nameLabel.text = @"可点击";
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    UIView *itemsV = [self itemsView];
    [stackV addArrangedSubview:itemsV];
    self.itemsView = itemsV;
    itemsV.backgroundColor = UIColor.greenColor;
}

- (UIView *)itemsView {
    UIView *partV = [UIView new];
    
    FEDirectionLabelsFlowLayout *layout = [[FEDirectionLabelsFlowLayout alloc] init];
    layout.delegate = self;
    layout.direction = FEDirectionLabelsFlowLayoutDirectionLeft;
    layout.itemHeight = 30;
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 10, 10, 8);
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [partV addSubview:collectionV];
    self.collectionV = collectionV;
    collectionV.delegate = self;
    collectionV.dataSource = self;
    
    [collectionV registerClass:LabelsCell.class forCellWithReuseIdentifier:@"LabelsCell"];
        
    [collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(100);
    }];
    
    return partV;
}

- (void)setExpand:(BOOL)expand {
    _expand = expand;
    self.stackView.arrangedSubviews[1].hidden = !expand;
    
    // 设置
//    if (expand) [self loadLabels];
    [self.collectionV reloadData];
    
    [self setNeedsUpdateConstraints];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelsCell" forIndexPath:indexPath];
    
    cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.redColor : UIColor.grayColor;
    
    return cell;
}

- (CGFloat)labelsFlowLayout:(FEDirectionLabelsFlowLayout *)flowLayout itemWidthWithIndexPath:(NSIndexPath *)indexPath {
    //随机数
    int ran = arc4random() % 10;
    
    return ran + 50;
}

- (void)updateConstraints {
    
    [self.collectionV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.collectionV.contentSize.height);
    }];
    
    [super updateConstraints];
}

@end
