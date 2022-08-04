//
//  FELabelsFlowLayout.m
//  demo
//
//  Created by hyl on 2022/7/25.
//

#import "FEDirectionLabelsFlowLayout.h"

@interface FEDirectionLabelsFlowLayout  ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributeArray;

@property (nonatomic, assign) CGFloat maxHeight;

@end

@implementation FEDirectionLabelsFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.layoutAttributeArray removeAllObjects];
    self.layoutAttributeArray = [NSMutableArray array];
    
    if (self.direction == FEDirectionLabelsFlowLayoutDirectionLeft) {
        [self prepareLeft];
    }
    if (self.direction == FEDirectionLabelsFlowLayoutDirectionRight) {
        [self prepareRight];
    }
}

- (void)prepareLeft {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat itemX = self.sectionInset.left;
    CGFloat itemY = self.sectionInset.top;
    CGFloat itemMaxX = self.collectionViewContentSize.width;
    for (int index = 0; index < itemCount; index ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        // 获取动态宽度
        CGFloat itemHeight = self.itemHeight;
        CGFloat itemWidth = itemHeight;
        if ([self.delegate respondsToSelector:@selector(labelsFlowLayout:itemWidthWithIndexPath:)]) {
            itemWidth = [self.delegate labelsFlowLayout:self itemWidthWithIndexPath:indexPath];
        }
        CGFloat currentMaxX = itemX + itemWidth + self.minimumInteritemSpacing;
        if (currentMaxX > itemMaxX) { //换行
            itemX = self.sectionInset.left;
            itemY = itemY + itemHeight + self.minimumLineSpacing;
        }
        
        // 赋值新的位置信息
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        [self.layoutAttributeArray addObject:attr];
        
        itemX = itemX + itemWidth + self.minimumInteritemSpacing;
    }
    
    self.maxHeight = itemY + self.itemHeight + self.minimumLineSpacing;
}
- (void)prepareRight {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat itemX = 0;
    CGFloat itemY = self.sectionInset.top;
    CGFloat itemMaxX = self.collectionViewContentSize.width;
    for (int index = 0; index < itemCount; index ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        // 获取动态宽度
        CGFloat itemHeight = self.itemHeight;
        CGFloat itemWidth = itemHeight;
        if ([self.delegate respondsToSelector:@selector(labelsFlowLayout:itemWidthWithIndexPath:)]) {
            itemWidth = [self.delegate labelsFlowLayout:self itemWidthWithIndexPath:indexPath];
        }
        
        if (index == 0) {
            itemX = itemMaxX - self.sectionInset.right - itemWidth;
        } else {
            CGFloat currentMinX = itemX - itemWidth - self.minimumInteritemSpacing;
            if (currentMinX < 0) { //换行
                itemX = itemMaxX - self.sectionInset.right - itemWidth;
                itemY = itemY + itemHeight + self.minimumLineSpacing;
            } else {
                itemX = currentMinX;
            }
        }
        
        // 赋值新的位置信息
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        [self.layoutAttributeArray addObject:attr];
    }
    
    self.maxHeight = itemY + self.itemHeight + self.minimumLineSpacing;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 返回相交的区域
    NSMutableArray *arr = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in self.layoutAttributeArray) {
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [arr addObject:attr];
        }
    }
    return arr;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxHeight);
}

@end
