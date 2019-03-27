//
//  MainTableViewCell.h
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/27.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

@interface MainTableViewCell : UITableViewCell

@property (strong, nonatomic) RowModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(RowModel *)model;
- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(RowModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END
