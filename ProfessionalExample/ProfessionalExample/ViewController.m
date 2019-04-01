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
#import "MainTableViewCell.h"
#import "ARCObject.h"
#import <objc/runtime.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MainModel *mainModel;

@end


@implementation ViewController

- (MainModel *)mainModel {
    if (_mainModel == nil) {
        _mainModel = [MainModel modelWithTitle:@"内存管理和多线程"];
        
        SectionModel *mrc = [SectionModel modelWithTitle:@"手动引用计数"];
        [mrc addRowModelWithTitle:@"自己生成并持有对象" detail:@"因为持有，不会打印销毁信息" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject generateAndHold];
        }];
        [mrc addRowModelWithTitle:@"不是自己生成的对象也能持有" detail:@"因为持有，不会打印销毁信息" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject holdObject];
        }];
        [mrc addRowModelWithTitle:@"不在需要自己持有的对象时释放" detail:@"因为释放了，会打印销毁信息" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject releaseNoNeed];
        }];
        [mrc addRowModelWithTitle:@"无法释放自己没有持有的对象" detail:@"因为没有持有，会奔溃" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject releaseNoHold];
        }];
        [_mainModel addSectionModel:mrc];
        
        SectionModel *autorelease = [SectionModel modelWithTitle:@"autorelease"];
        [autorelease addRowModelWithTitle:@"NSAutoreleasePool的使用" detail:@"autorelease像c语言的自动变量来对待对象实例，当超出其作用域（相当于变量作用域），对象实例的release方法被调用。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject autoreleaseUse];
        }];
        [autorelease addRowModelWithTitle:@"大量产生autorelease对象" detail:@"如果不及时废弃NSAutoreleasePool对象，会发现内存剧增。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject lotOfAutoreleaseObjects];
        }];
        [autorelease addRowModelWithTitle:@"废弃NSAutoreleasePool对象" detail:@"大量产生autorelease对象时，如果及时废弃NSAutoreleasePool对象，则不会发现内存剧增。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject lotOfAutoreleaseObjectsRelease];
        }];
        [_mainModel addSectionModel:autorelease];
        
        SectionModel *arc = [SectionModel modelWithTitle:@"自动引用计数"];
        [arc addRowModelWithTitle:@"__strong修饰符在超出其作用域" detail:@"超出作用域时会废弃__strong变量。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            {
                ARCObject *obj = [ARCObject allocObject];
                NSLog(@"作用域最后一行%@", obj);
            }
            NSLog(@"作用域已经结束");
        }];
        [arc addRowModelWithTitle:@"__strong修饰符被重新赋值" detail:@"重新赋值__strong变量，将废弃旧值。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject *obj = [ARCObject allocObject];
            NSLog(@"重新赋值前%@", obj);
            obj = [ARCObject allocObject];
            NSLog(@"重新赋值前后%@", obj);
        }];
        [arc addRowModelWithTitle:@"循环引用之两个对象相互强引用" detail:@"两个对象相互强引用，会导致两个对象不会被释放。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject *aObj = [ARCObject allocObject];
            ARCObject *bObj = [ARCObject allocObject];
            [aObj setStrongObject:bObj];
            [bObj setStrongObject:aObj];
        }];
        [arc addRowModelWithTitle:@"循环引用之自身强引用" detail:@"对象强引用自身，会导致对象不会被释放。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject *obj = [ARCObject allocObject];
            [obj setStrongObject:obj];
        }];
        [arc addRowModelWithTitle:@"__weak修饰符可以解决循环引用问题" detail:@"__weak修饰符不持有对象，因此可以打破对象之间的循环引用和自身循环引用。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject *aObj = [ARCObject allocObject];
            ARCObject *bObj = [ARCObject allocObject];
            ARCObject *cObj = [ARCObject allocObject];
            [aObj setWeakObject:bObj];
            [bObj setWeakObject:aObj];
            [cObj setWeakObject:cObj];
        }];
        [arc addRowModelWithTitle:@"__unsafe_unretained修饰符不是安全的" detail:@"__unsafe_unretained修饰符的变量，在销毁时并不会对其置为nil，因此会产生垂悬指正，如果该内存地址不覆盖就会造成奔溃。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject __unsafe_unretained *obj = nil;
            {
                ARCObject *obj1 = [ARCObject allocObject];
                obj = obj1;
            }
            NSLog(@"%@(%@)", NSStringFromClass(obj.class), obj);
        }];
        [arc addRowModelWithTitle:@"ARC有效时不能使用outorelease方法和NSAutoreleasePool类" detail:@"使用@outoreleasepool{}块代码来代替NSAutoreleasePool类对象的生成持有以及废弃。通过赋值给__outoreleasing修饰符的变量来代替调用outorelease方法，也就是说对象被注册到autoreleasepool中。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            @autoreleasepool {
                ARCObject __autoreleasing *obj1 = [ARCObject allocObject];
                NSLog(@"autoreleasepool块最后一行%@", obj1);
            }
            NSLog(@"autoreleasepool块已经结束");
        }];
        [arc addRowModelWithTitle:@"非显示的使用__outoreleasing修饰符" detail:@"cocoa中由于编译器会检查方法名是否以alloc/new/copy/mutableCopy开始，如果不是则自动将返回值的对象注册到outoreleasepool中。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSMutableArray __weak *array = nil;
            NSLog(@"作用域块开始前%@", array);
            {
                NSMutableArray *arr = [NSMutableArray arrayWithObject:@(1)];
                array = arr;
                NSLog(@"作用域块最后一行%@", array);
            }
            NSLog(@"作用域块已经结束%@", array);
        }];
        [arc addRowModelWithTitle:@"循环中生成大量对象" detail:@"单次次循环结束，则作用域也结束，就会销毁单次创建的对象，并不会累计到循环全部结束时才去销毁。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            for (int index = 0; index < 2; index++) {
                if (index == 0) {
                    NSLog(@"-------------begin");
                    ARCObject *obj = [[ARCObject alloc] init];
                    NSLog(@"%@(%@)生成了", NSStringFromClass(obj.class), obj);
                }
                if (index == 1) {
                    NSLog(@"-------------end");
                }
            }
        }];
        [arc addRowModelWithTitle:@"c静态数组" detail:@"各修饰符与修饰OC对象一样没有区别。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            {
                ARCObject *array[2];
                array[0] = [ARCObject allocObject];
                NSLog(@"array第一个元素：%@", array[0]);
                NSLog(@"array第二个元素：%@", array[1]);
                array[1] = nil;
                NSLog(@"array第二个元素：%@", array[1]);
            }
            NSLog(@"作用域块已经结束");
        }];
        [arc addRowModelWithTitle:@"c动态数组" detail:@"各修饰符与修饰OC对象一样没有区别。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            {
                ARCObject *__strong *array;
                array = (ARCObject *__strong *)calloc(2, sizeof(ARCObject *));
                NSLog(@"array第一个元素：%@", array[0]);
                NSLog(@"array第二个元素：%@", array[1]);
                array[0] = [ARCObject allocObject];
                array[1] = [ARCObject allocObject];
                array[0] = nil;
                NSLog(@"array第一个元素：%@", array[0]);
                NSLog(@"array第二个元素：%@", array[1]);
                free(array);
            }
            NSLog(@"作用域块已经结束");
        }];
        [_mainModel addSectionModel:arc];
        
        SectionModel *blocks = [SectionModel modelWithTitle:@"Blocks"];
        [blocks addRowModelWithTitle:@"Block截获自动变量" detail:@"Block表达式截获所使用的自动变量的值，即保存该自动变量的瞬间值，所以在执行Block语法后，即使改写了Block中使用的自动变量的值也不会影响Block执行时的值。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            int a = 1;
            void (^block) (void) = ^{
                NSLog(@"%i", a);
            };
            a = 2;
            block();
        }];
        [blocks addRowModelWithTitle:@"Block不支持c语言数组的自动变量截获" detail:@"如果Block中需要截获c语言数组，那么需要使用指针代替。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            int nums[4] = {1, 2, 3, 4};
            int *p = nums;
            void (^block) (void) = ^{
                NSLog(@"%i", *(p + 1));
            };
            block();
        }];
        [blocks addRowModelWithTitle:@"数组存Block" detail:@"栈上的Block存进数组不会复制到堆上，需要手动复制，否则会产生垂悬指针造成奔溃。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSArray *array;
            {
                int a = 2;
                array = [NSArray arrayWithObjects:[^{ NSLog(@"a + a = %i", a + a); } copy], ^{ NSLog(@"a * a = %i", a * a); }, nil];
            }
            typedef void (^Block) (void);
            Block first = [array firstObject];
            first();
        }];
        [_mainModel addSectionModel:blocks];
    }
    
    return _mainModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = self.mainModel.title;
}
- (BOOL)performOperationWithError:(ARCObject **)obj {
    *obj = [ARCObject object];
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mainModel sectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mainModel rowCountOfSetion:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MainTableViewCell cellWithTableView:tableView indexPath:indexPath model:[self.mainModel rowModelOfIndexPath:indexPath]];
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
