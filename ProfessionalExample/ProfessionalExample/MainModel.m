
//
//  MainModel.m
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/26.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "MainModel.h"

@implementation RowModel

+ (instancetype)modelWithTitle:(NSString *)title detail:(NSString *)detail selectedAction:(SelectedBlock)selectedAction {
    return [[self alloc] initWithRowTitle:title detail:detail selectedAction:selectedAction];
}
- (instancetype)initWithRowTitle:(NSString *)title detail:(NSString *)detail selectedAction:(SelectedBlock)selectedAction {
    if (self = [super init]) {
        _title = title;
        _detail = detail;
        _selectedAction = selectedAction;
    }
    
    return self;
}

@end

@interface SectionModel ()

@property (strong, nonatomic) NSMutableArray *rows;

@end

@implementation SectionModel

- (NSMutableArray *)rows {
    if (_rows == nil) {
        _rows = [NSMutableArray array];
    }
    
    return _rows;
}

+ (instancetype)modelWithTitle:(NSString *)title {
    return [[self alloc] initWithSectionTitle:title];
}
- (instancetype)initWithSectionTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
    }
    
    return self;
}
- (void)addRowModelWithTitle:(NSString *)title detail:(NSString *)detail selectedAction:(SelectedBlock)selectedAction {
    [self.rows addObject:[RowModel modelWithTitle:title detail:detail selectedAction:selectedAction]];
}
- (NSInteger)rowCount {
    return self.rows.count;
}
- (RowModel *)rowModelOfRow:(NSInteger)row {
    return [self.rows objectAtIndex:row];
}

@end

@interface MainModel ()

@property (strong, nonatomic) NSMutableArray *sections;

@end

@implementation MainModel

- (NSArray *)sections {
    if (_sections == nil) {
        _sections = [NSMutableArray array];
    }
    
    return _sections;
}
+ (instancetype)modelWithTitle:(NSString *)title {
    return [[self alloc] initWithModelTitle:title];
}
- (instancetype)initWithModelTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
    }
    
    return self;
}
- (void)addSectionModel:(SectionModel *)model {
    [self.sections addObject:model];
}
- (NSInteger)sectionCount {
    return self.sections.count;
}
- (NSInteger)rowCountOfSetion:(NSInteger)section {
    SectionModel *model = [self.sections objectAtIndex:section];
    return [model rowCount];
}
- (SectionModel *)sectionModelOfSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}
- (RowModel *)rowModelOfIndexPath:(NSIndexPath *)indexPath {
    SectionModel *model = [self.sections objectAtIndex:indexPath.section];
    return [model rowModelOfRow:indexPath.row];
}

@end
