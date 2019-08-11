//
//  UIButton+ReTouchAvoid.h
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ReTouchAvoid)
// 两次点击事件之间的间隔
@property (nonatomic, assign) NSTimeInterval eventInverval;
@end

NS_ASSUME_NONNULL_END
