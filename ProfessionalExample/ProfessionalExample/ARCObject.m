//
//  ARCObject.m
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/27.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "ARCObject.h"

@interface ARCObject ()
{
    __strong id _strongObj;
    __weak id _weakObj;
}

@end

@implementation ARCObject

- (void)dealloc {
    NSLog(@"%@(%@)销毁了", NSStringFromClass(self.class), self);
}
+ (instancetype)allocObject {
    ARCObject *obj = [[ARCObject alloc] init];
    NSLog(@"%@(%@)生成了", NSStringFromClass(obj.class), obj);
    return obj;
}
+ (instancetype)object {
    ARCObject __autoreleasing *obj = [self allocObject];
    return obj;
}
- (void)setStrongObject:(id)obj {
    _strongObj = obj;
}
- (void)setWeakObject:(id)obj {
    _weakObj = obj;
}

@end
