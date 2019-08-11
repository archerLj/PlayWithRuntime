//
//  NSObject+JSONToModel.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "NSObject+JSONToModel.h"
#import "objc/runtime.h"

@implementation NSObject (JSONToModel)
+(instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    id object = [[self alloc] init];
    
    // 获取对象的属性列表
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        // 获取属性名称
        objc_property_t property = properties[i];
        const char *cPropertyName = property_getName(property);
        NSString *propertyNameStr = [NSString stringWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        
        // 获取JSON中的属性值
        id value = [dictionary valueForKey:propertyNameStr];
        
        // 获取属性所属类名
        NSString *propertyType;
        unsigned int attrCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
        for (int i=0; i<attrCount; i++) {
            objc_property_attribute_t attr = attrs[i];
            
            // attr中不会包含父类的属性，一般value都是空的，只有属性的类型type ‘T’才有值
            switch (attr.name[0]) {
                case 'T':{
                    if (attrs[i].value) {
                        propertyType = [NSString stringWithUTF8String:attrs[i].value];
                        // 去除转义字符: @\"NSString\" -> @NSString
                        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        // 去掉@符号: @NSString -> NSString
                        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"@" withString:@""];
                                        
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
        // 对特殊属性进行处理
        NSDictionary *specialPropertiesInfo;
        if ([self respondsToSelector:@selector(specialPropertyInfo)]) {
            specialPropertiesInfo = [self performSelector:@selector(specialPropertyInfo) withObject:nil];
            
            if (specialPropertiesInfo) {
                // 1. 处理字典中的特殊键，比如"id"
                id antherName = specialPropertiesInfo[propertyNameStr];
                if (antherName && [antherName isKindOfClass:[NSString class]]) {
                    value = dictionary[antherName];
                }
                
                // 2. 模型嵌套模型
                // value是字典类型，并且当前属性的类型不是系统自带类型
                if ([value isKindOfClass:[NSDictionary class]] && ![propertyType hasPrefix:@"NS"]) {
                    Class realClass = NSClassFromString(propertyType);
                    if (realClass) {
                        value = [realClass modelWithDictionary:value];
                    }
                }
                
                // 3. 模型嵌套数组
                if ([value isKindOfClass:[NSArray class]] &&
                    ([propertyType isEqualToString:@"NSArray"] ||
                     [propertyType isEqualToString:@"NSMutableArray"])) {
                        
                        Class realClass = specialPropertiesInfo[propertyNameStr];
                        
                        NSMutableArray *valueArr = [[NSMutableArray alloc] init];
                        for (NSDictionary *subValue in value) {
                            [valueArr addObject:[realClass modelWithDictionary:subValue]];
                        }
                        
                        value = valueArr;
                    }
            }
        }
        
        if (value) {
            [object setValue:value forKey:propertyNameStr];
        }
    }
    
    free(properties);
    return object;
}
@end
