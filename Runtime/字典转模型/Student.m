//
//  Student.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "Student.h"

@implementation Student
+(NSDictionary<NSString *,id> *)specialPropertyInfo {
    return @{
             @"uid": @"id",
             @"courses": [Course class]
             };
}
@end
