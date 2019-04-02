//
//  BlockObject.m
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/4/2.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "BlockObject.h"

@implementation BlockObject

- (void)dealloc {
    NSLog(@"%@销毁了", self);
}

@end
