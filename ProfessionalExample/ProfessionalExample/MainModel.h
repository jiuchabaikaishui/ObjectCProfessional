//
//  MainModel.h
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/26.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MainCellTitleFont               [UIFont systemFontOfSize:17.0]
#define MainCellDetailFont              [UIFont systemFontOfSize:12.0]

typedef void(^SelectedBlock)(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath);

@interface RowModel : NSObject

@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *detail;
@property (copy, nonatomic, readonly) SelectedBlock selectedAction;

+ (instancetype)modelWithTitle:(NSString *)title detail:(NSString *)detail selectedAction:(SelectedBlock)selectedAction;

@end

@interface SectionModel : NSObject

@property (copy, nonatomic) NSString *title;

+ (instancetype)modelWithTitle:(NSString *)title;
- (void)addRowModelWithTitle:(NSString *)title detail:(NSString *)detail selectedAction:(SelectedBlock)selectedAction;
- (NSInteger)rowCount;
- (RowModel *)rowModelOfRow:(NSInteger)row;

@end

@interface MainModel : NSObject

@property (copy, nonatomic) NSString *title;

+ (instancetype)modelWithTitle:(NSString *)title;
- (void)addSectionModel:(SectionModel *)model;
- (NSInteger)sectionCount;
- (NSInteger)rowCountOfSetion:(NSInteger)section;
- (SectionModel *)sectionModelOfSection:(NSInteger)section;
- (RowModel *)rowModelOfIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END
