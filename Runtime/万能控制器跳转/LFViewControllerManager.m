//
//  LFViewControllerManager.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "LFViewControllerManager.h"
#import "objc/runtime.h"

@implementation LFViewControllerManager
+(void)showViewControllerWithParams:(NSDictionary *)params {
    
    // 获取控制器名称
    NSString *controllerStr = params[@"controller"];
    const char *controllerClassName = [controllerStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    
    // 获取控制器类
    Class controllerClass = objc_getClass(controllerClassName);
    if (!controllerClass) { // 如果控制器没有在runtime中注册，则注册一个新的控制器，或者直接抛出异常
        NSString *msg = [NSString stringWithFormat:@"类 %@ 没有注册", controllerStr];
        NSAssert(false, msg);
        return;
//        Class superClass = [NSObject class];
//        controllerClass = objc_allocateClassPair(superClass, controllerClassName, 0); // 新建一个类
//        objc_registerClassPair(controllerClass); // 注册类
    }
    
    // 创建控制器对象
    id object = [[controllerClass alloc] init];
    if (![object isKindOfClass:[UIViewController class]]) {
        NSString *msg = [NSString stringWithFormat:@"%@ 不是控制器类型", controllerStr];
        NSAssert(false, msg);
        return;
    }
    
    
    // 检查参数是否是对应的属性
    NSDictionary *inParams = params[@"params"];
    [inParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  obj, BOOL * stop) {
        if ([LFViewControllerManager isProperty:key existsInObject:object]) {
            [object setValue:obj forKey:key];
        }
    }];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *presentingViewController = [LFViewControllerManager getPresentingViewControllerInViewController:rootVC];
    if ([presentingViewController navigationController]) {
        [presentingViewController.navigationController pushViewController:object animated:YES];
    } else {
        [presentingViewController presentViewController:object animated:YES completion:nil];
    }
}

// 检测实例对象中是否存在某个属性
+(BOOL)isProperty:(NSString *)propertyName existsInObject:(id)object {
    
    unsigned int count;
    objc_property_t *propetyList = class_copyPropertyList([object class], &count);
    
    for (int i=0; i<count; i++) {
        objc_property_t property = propetyList[i];
        const char *_propertyName = property_getName(property);
        NSString *propertyNameStr = [NSString stringWithCString:_propertyName encoding:NSUTF8StringEncoding];
        if ([propertyName isEqualToString:propertyNameStr]) {
            free(propetyList);
            return YES;
        }
    }
    
    free(propetyList);
    return NO;
}

// 获取当前处于顶端的控制器
+(UIViewController *)getPresentingViewControllerInViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [LFViewControllerManager getPresentingViewControllerInViewController:[nav topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        return [LFViewControllerManager getPresentingViewControllerInViewController:[tab selectedViewController]];
    } else if ([vc presentedViewController]) {
        return [LFViewControllerManager getPresentingViewControllerInViewController:[vc presentedViewController]];
    } else {
        return vc;
    }
}
@end
