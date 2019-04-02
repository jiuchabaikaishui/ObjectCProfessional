//
//  BlockObject.h
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/4/2.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockObject : NSObject

@property (strong, nonatomic) void (^block)(void);

@end

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END
