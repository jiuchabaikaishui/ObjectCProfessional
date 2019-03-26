//
//  ViewController.m
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/26.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "ViewController.h"
#import "MainModel.h"
#import "MRCObject.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MainModel *mainModel;

@end

@implementation ViewController

- (MainModel *)mainModel {
    if (_mainModel == nil) {
        _mainModel = [MainModel modelWithTitle:@"内存管理和多线程"];
        SectionModel *section = [SectionModel modelWithTitle:@"引用计数"];
        [section addRowModelWithTitle:@"自己生成并持有对象" detail:@"因为持有，不会打印销毁信息" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject generateAndHold];
        }];
        [section addRowModelWithTitle:@"不是自己生成的对象也能持有" detail:@"因为持有，不会打印销毁信息" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject holdObject];
        }];
        [section addRowModelWithTitle:@"不在需要自己持有的对象时释放" detail:@"因为释放了，会打印销毁信息" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject releaseNoNeed];
        }];
        [section addRowModelWithTitle:@"无法释放自己没有持有的对象" detail:@"因为没有持有，会奔溃" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject releaseNoHold];
        }];
        [_mainModel addSectionModel:section];
    }
    
    return _mainModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = self.mainModel.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mainModel sectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mainModel rowCountOfSetion:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    RowModel *model = [self.mainModel rowModelOfIndexPath:indexPath];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.detail;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SectionModel *model = [self.mainModel sectionModelOfSection:section];
    return model.title;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RowModel *model = [self.mainModel rowModelOfIndexPath:indexPath];
    if (model.selectedAction) {
        model.selectedAction(self, tableView, indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
