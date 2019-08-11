//
//  Student.h
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JSONToModel.h"
#import "Address.h"
#import "Course.h"

@interface Student : NSObject <JSONToModelProtocol>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSArray *courses;
@end
