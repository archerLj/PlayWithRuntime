//
//  EncodeAndDecode.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "EncodeAndDecode.h"
#import "NSObject+AutoEncodeDecode.h"

@implementation EncodeAndDecode

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self lj_decoderWithCoder:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [self lj_encodeWithCoder:aCoder];
}

@end
