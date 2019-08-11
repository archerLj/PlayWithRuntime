//
//  NSObject+AutoEncodeDecode.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "NSObject+AutoEncodeDecode.h"
#import "objc/runtime.h"

@implementation NSObject (AutoEncodeDecode)
-(void)lj_decoderWithCoder:(NSCoder *)aDecoder {
    if (!aDecoder) {
        return;
    }
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *cname = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:cname encoding:NSUTF8StringEncoding];
        
        id value = [aDecoder decodeObjectForKey:propertyName];
        [self setValue:value forKey:propertyName];
    }
    free(properties);
}

-(void)lj_encodeWithCoder:(NSCoder *)aEncoder {
    if (!aEncoder) {
        return;
    }
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *cname = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:cname encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:propertyName];
        [aEncoder encodeObject:value forKey:propertyName];
    }
    free(properties);
}
@end
