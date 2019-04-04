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
#import "BlockObject.h"

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
        [blocks addRowModelWithTitle:@"Block使用__strong修饰符的自动变量和__block变量" detail:@"堆上的Block持有这些变量，栈上的Block并不持有这些变量。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            typedef void (^Block) (id);
            __unsafe_unretained Block block;
            Block block1;
            {
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
                NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
                block = ^(id obj) {
                    [array addObject:obj];
                    NSLog(@"array: %@, array count: %li", array, array.count);
                };
                block1 = ^(id obj) {
                    [array1 addObject:obj];
                    NSLog(@"array1: %@, array1 count: %li", array1, array1.count);
                };
            }
            block([[NSObject alloc] init]);
            block1([[NSObject alloc] init]);
        }];
        [blocks addRowModelWithTitle:@"__block变量为__weak修饰符的对象" detail:@"__block变量不持有该对象。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            typedef void (^Block) (id);
            Block block;
            {
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
                __block NSMutableArray __weak *array1 = array;
                block = ^(id obj) {
                    [array1 addObject:obj];
                    NSLog(@"array1: %@, array1 count: %li", array1, array1.count);
                };
            }
            block([[NSObject alloc] init]);
        }];
        [blocks addRowModelWithTitle:@"__block变量也可以避免循环引用" detail:@"使用__block变量避免循环引用，必须执行Block并手动释放__block变量对对象的引用（如置空或其它值）。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            __block BlockObject *obj = [[BlockObject alloc] init];
            obj.block = ^{
                NSLog(@"%@", obj);
                obj = nil;
            };
            obj.block();
        }];
        [_mainModel addSectionModel:blocks];
        
        SectionModel *gcd = [SectionModel modelWithTitle:@"Grand Central Dispatch"];
        [gcd addRowModelWithTitle:@"Serial Dispath Queue" detail:@"Serial Dispath Queue等待正在执行的任务结束后才开始执行下一个任务。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            dispatch_queue_t serialQueue = dispatch_queue_create("SerialQueue", DISPATCH_QUEUE_SERIAL);
            for (int index = 0; index < 100; index++) {
                dispatch_async(serialQueue, ^{
                    printf("Serial Queue: %i\n", index);
                });
            }
        }];
        [gcd addRowModelWithTitle:@"Concurrent Dispath Queue" detail:@"Concurrent Dispath Queue不管正在执行的任务是否结束都开始执行下一个任务。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            dispatch_queue_t concurrentQueue = dispatch_queue_create("ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
            for (int index = 0; index < 100; index++) {
                dispatch_async(concurrentQueue, ^{
                    printf("Concurrent Queue: %i\n", index);
                });
            }
        }];
        [gcd addRowModelWithTitle:@"dispatch_set_target_queue" detail:@"将多个Serial Dispatch Queue使用dispatch_set_target_queue函数指定目标为某一个Serial Dispatch Queue这种方式可以防止多个Serial Dispatch Queue之间的并行执行。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            dispatch_queue_t serialQueue = dispatch_queue_create("SerialQueue", DISPATCH_QUEUE_SERIAL);
            for (int index = 0; index < 10; index++) {
                dispatch_queue_t serialQueue1 = dispatch_queue_create("SerialQueue1", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(serialQueue1, serialQueue);
                dispatch_async(serialQueue1, ^{
                    printf("Serial Queue1: %i\n", index);
                });
            }
        }];
        [gcd addRowModelWithTitle:@"Dispatch Group" detail:@"Dispatch Group用于监视一批处理的结束，一旦检测到所有处理结束，就会将结果处理追加到Dispatch Queue中。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            dispatch_queue_t serialQueue = dispatch_queue_create("SerialQueue", DISPATCH_QUEUE_SERIAL);
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, serialQueue, ^{
                printf("Serial Queue\n");
            });
            dispatch_group_async(group, globalQueue, ^{
                printf("Global Queue\n");
            });
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                printf("Main Queue\n");
            });
            if (dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC))) == 0) {
                printf("Dispatch Group结束\n");
            } else {
                printf("Dispatch Group在1秒后没有结束\n");
            }
        }];
        [gcd addRowModelWithTitle:@"dispatch_barrier_async" detail:@"dispatch_barrier_async函数会等待前面追加到Concurrent Dispatch Queue中的所有处理全部结束之后再将指定处理追加到该Concurrent Dispatch Queue中。然后dispatch_barrier_async函数追加的处理结束后，才恢复Concurrent Dispatch Queue处理后面追加的处理。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            dispatch_queue_t concurrentQueue = dispatch_queue_create("com.xxxx.xxxx.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(concurrentQueue, ^{
                printf("Concurrent Queue: 1\n");
            });
            dispatch_async(concurrentQueue, ^{
                printf("Concurrent Queue: 2\n");
            });
            dispatch_barrier_async(concurrentQueue, ^{
                printf("Concurrent Queue: 3\n");
            });
            dispatch_async(concurrentQueue, ^{
                printf("Concurrent Queue: 4\n");
            });
            dispatch_async(concurrentQueue, ^{
                printf("Concurrent Queue: 5\n");
            });
        }];
        [gcd addRowModelWithTitle:@"dispatch_apply" detail:@"dispatch_apply函数按指定的次数将Block追加到指定的Dispatch Queue中，并等待全部处理结束。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            dispatch_queue_t concurrentQueue = dispatch_queue_create("com.xxxx.xxxx.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_apply(5, concurrentQueue, ^(size_t index) {
                printf("Concurrent Queue: %li\n", index);
            });
            
            printf("Concurrent Queue End.\n");
        }];
        [gcd addRowModelWithTitle:@"Dispatch Semaphore" detail:@"Dispatch Semaphore是持有计数的信号，该计数是多线程编程中的计数类型信号。是用更细粒度的对象实现排他控制。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
            for (int index = 0; index < 10000; index++) {
                dispatch_async(globalQueue, ^{
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                    [mArray addObject:@(index)];
                    dispatch_semaphore_signal(semaphore);
                });
            }
        }];
        [gcd addRowModelWithTitle:@"死锁" detail:@"GCD中的一些函数在指定的Block处理没有结束之前，不会返回。如dispatch_sync、dispatch_apply等。在使用这些同步等待处理执行的函数时，稍有不慎就会导致死锁。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSLog(@"1");
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"2");
            });
            NSLog(@"3");
        }];
        [_mainModel addSectionModel:gcd];
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
