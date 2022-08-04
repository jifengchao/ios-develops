//
//  FELabelsFlowLayout.h
//  demo
//
//  Created by hyl on 2022/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FEDirectionLabelsFlowLayoutDirection) {
    FEDirectionLabelsFlowLayoutDirectionLeft      = 0,   //从左往右
    FEDirectionLabelsFlowLayoutDirectionRight     = 1,   //从右往做
};

@class FEDirectionLabelsFlowLayout;
@protocol FEDirectionLabelsFlowLayoutDelegate <NSObject>

- (CGFloat)labelsFlowLayout:(FEDirectionLabelsFlowLayout *)flowLayout itemWidthWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface FEDirectionLabelsFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<FEDirectionLabelsFlowLayoutDelegate> delegate;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) FEDirectionLabelsFlowLayoutDirection direction;

@end

NS_ASSUME_NONNULL_END
