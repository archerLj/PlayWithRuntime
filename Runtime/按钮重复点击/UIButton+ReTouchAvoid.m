//
//  UIButton+ReTouchAvoid.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "UIButton+ReTouchAvoid.h"
#import "objc/runtime.h"

static void *EventIntervalKey = &EventIntervalKey;
static void *LastEventDateKey = &LastEventDateKey;

@interface UIButton()
@property (nonatomic, assign) NSTimeInterval lastEvetDate;
@end

@implementation UIButton (ReTouchAvoid)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clazz = [self class];
        
        SEL originalSEL = @selector(sendAction:to:forEvent:);
        SEL fakeSEL = @selector(fake_sendAction:to:forEvent:);
        
        Method originalMethod = class_getInstanceMethod(clazz, originalSEL);
        Method fakeMethod = class_getInstanceMethod(clazz, fakeSEL);
        
        BOOL didAdded = class_addMethod(clazz,
                                        originalSEL,
                                        method_getImplementation(fakeMethod),
                                        method_getTypeEncoding(fakeMethod));
        if (didAdded) {
            class_replaceMethod(clazz,
                                fakeSEL,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, fakeMethod);
        }
    });
}

-(void)fake_sendAction:(SEL)selector to:(id)target forEvent:(UIEvent *)event {
    if ([self eventInverval] <= 0) {
        [self setEventInverval:0.5];
    }
    
    NSTimeInterval eventGap = [NSDate timeIntervalSinceReferenceDate] - [self lastEvetDate];
    
    if (eventGap >= [self eventInverval]) {
        [self setLastEvetDate:[NSDate timeIntervalSinceReferenceDate]];
        [self fake_sendAction:selector to:target forEvent:event];
    }
}

-(void)setEventInverval:(NSTimeInterval)eventInverval {
    objc_setAssociatedObject(self, EventIntervalKey, @(eventInverval), OBJC_ASSOCIATION_RETAIN);
}

-(NSTimeInterval)eventInverval {
    return [objc_getAssociatedObject(self, EventIntervalKey) doubleValue];
}

-(void)setLastEvetDate:(NSTimeInterval)lastEvetDate {
    objc_setAssociatedObject(self, LastEventDateKey, @(lastEvetDate), OBJC_ASSOCIATION_RETAIN);
}

-(NSTimeInterval)lastEvetDate {
    return [objc_getAssociatedObject(self, LastEventDateKey) doubleValue];
}
@end
