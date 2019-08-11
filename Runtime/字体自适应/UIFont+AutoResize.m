//
//  UIFont+AutoResize.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "UIFont+AutoResize.h"
#import "objc/runtime.h"

typedef IMP *IMPPointer;

// swizzle函数声明
static UIFont* MethodSwizzle(id self, SEL _cmd, CGFloat fontSize);
// 声明一个函数指针用来保存原方法的函数地址
static UIFont* (*MethodOriginal)(id self, SEL _cmd, CGFloat fontSize);

static UIFont* MethodSwizzle(id self, SEL _cmd, CGFloat fontSize) {
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat scale = screenWidth / 375.0;
    return MethodOriginal(self, _cmd, scale * fontSize);
}

BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store) {
    // imp用来保存原方法的函数指针，方便在替换方法中调用原方法
    IMP imp = NULL;
    Method method = class_getClassMethod(class, original);
    
    // 这里因为是类方法，所以我们要获取UIFont的元类，元类的实例方法就是类方法了
    Class metaClass = object_getClass((id)class);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(metaClass, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}

@implementation UIFont (AutoResize)
+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer)store {
    return class_swizzleMethodAndStore(self, original, replacement, store);
}

+ (void)load {
    // 我们用MethodOriginal来保存原方法的函数指针
    [self swizzle:@selector(systemFontOfSize:) with:(IMP)MethodSwizzle store:(IMP *)&MethodOriginal];
}
@end
