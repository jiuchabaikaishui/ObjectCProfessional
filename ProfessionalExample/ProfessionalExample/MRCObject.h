//
//  MRCObject.h
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/26.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCObject : NSObject

+ (void)generateAndHold;
+ (void)holdObject;
+ (void)releaseNoNeed;
+ (void)releaseNoHold;

@end

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END
