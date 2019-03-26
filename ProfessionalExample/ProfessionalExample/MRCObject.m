//
//  MRCObject.m
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/26.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "MRCObject.h"

@implementation MRCObject
- (void)dealloc {
    NSLog(@"%@(%@)销毁了", NSStringFromClass(self.class), self);
    
    [super dealloc];
}
+ (instancetype)object {
    MRCObject *obj = [self allocObject];
    [obj autorelease];
    return obj;
}

+ (instancetype)allocObject {
    MRCObject *obj = [[MRCObject alloc] init];
    NSLog(@"%@(%@)生成了", NSStringFromClass(obj.class), obj);
    
    return obj;
}
+ (void)generateAndHold {
    [self allocObject];
}
+ (void)holdObject {
    MRCObject *obj = [MRCObject object];
    [obj retain];
}
+ (void)releaseNoNeed {
    MRCObject *obj = [self allocObject];
    [obj release];
}
+ (void)releaseNoHold {
    MRCObject *obj = [self allocObject];
    [obj release];
    [obj release];
}

@end
