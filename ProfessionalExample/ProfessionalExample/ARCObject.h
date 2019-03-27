//
//  ARCObject.h
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/27.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARCObject : NSObject

+ (instancetype)allocObject;
- (void)setStrongObject:(id)obj;
- (void)setWeakObject:(id)obj;

@end

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END
