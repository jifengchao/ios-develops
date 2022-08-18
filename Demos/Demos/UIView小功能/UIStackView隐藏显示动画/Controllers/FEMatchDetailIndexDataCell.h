//
//  FEMatchDetailIndexDataCell.h
//  FiveEPlay
//
//  Created by hyl on 2022/8/10.
//  Copyright © 2022 hao yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FEMatchDetailIndexDataModel;
@interface FEMatchDetailIndexDataCell : UITableViewCell

+ (NSString *)cellIdentifier;

@property (nonatomic, weak) UITableView *tabV;

@property (nonatomic, strong) FEMatchDetailIndexDataModel *dataModel;

/** 第几局【回合】*/
@property (nonatomic, weak) UILabel *roundIndexLabel;
@property (nonatomic, weak) UILabel *name1Label;
@property (nonatomic, weak) UILabel *name2Label;

@end


@interface FEMatchDetailIndexDataModel : NSObject

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) int count;

@property (nonatomic, strong) NSArray *array;

@end

NS_ASSUME_NONNULL_END
