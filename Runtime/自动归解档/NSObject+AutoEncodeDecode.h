//
//  NSObject+AutoEncodeDecode.h
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (AutoEncodeDecode)

-(void)lj_decoderWithCoder:(NSCoder *)aDecoder;
-(void)lj_encodeWithCoder:(NSCoder *)aEncoder;

@end
