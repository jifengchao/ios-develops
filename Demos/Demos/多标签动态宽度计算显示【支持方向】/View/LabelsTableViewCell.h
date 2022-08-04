//
//  LabelsTableViewCell.h
//  demo
//
//  Created by hyl on 2022/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelsTableViewCell : UITableViewCell

@property (nonatomic, weak) UIStackView *stackView;

@property (nonatomic, assign) BOOL expand;

@end

NS_ASSUME_NONNULL_END
