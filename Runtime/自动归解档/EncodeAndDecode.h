//
//  EncodeAndDecode.h
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EncodeAndDecode : NSObject<NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSMutableArray *address;
@end
