//
//  MainTableViewCell.m
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/27.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)setModel:(RowModel *)model {
    _model = model;
    
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.detail;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(RowModel *)model {
    return [[self alloc] initWithTableView:tableView indexPath:indexPath model:model];
}
- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(RowModel *)model {
    static NSString *identifier = @"MainTableViewCell";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    cell.model = model;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
