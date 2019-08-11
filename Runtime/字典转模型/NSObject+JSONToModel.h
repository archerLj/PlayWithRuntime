//
//  NSObject+JSONToModel.h
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol JSONToModelProtocol <NSObject>
+(NSDictionary<NSString *, id> *)specialPropertyInfo;
@end

@interface NSObject (JSONToModel)
+(instancetype)modelWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
