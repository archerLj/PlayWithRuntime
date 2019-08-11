//
//  UITableView+PlaceHolder.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "UITableView+PlaceHolder.h"
#import "objc/runtime.h"

static void *IsFirstLoadKey = &IsFirstLoadKey;
static void *PlaceHolderViewKey = &PlaceHolderViewKey;

@interface UITableView()
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) UIView *placeHolderView;
@end

@implementation UITableView (PlaceHolder)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clazz = [self class];
        
        SEL originalSEL = @selector(reloadData);
        SEL fakeSEL = @selector(fake_reloadData);
        
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

-(void)fake_reloadData {
    if (!self.isFirstLoad) {
        [self checkEmpty];
    }
    self.isFirstLoad = NO;
    [self fake_reloadData];
}

-(void)checkEmpty {
    BOOL isEmpty = YES;
    
    id<UITableViewDataSource> dataSource = self.dataSource;
    
    // 获取section数量
    NSInteger sectionNumber = 1;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sectionNumber = [dataSource numberOfSectionsInTableView:self];
    }
    
    // 检查每个section下面的row行数，有一个section下面行数>0就不为空
    for (NSInteger i=0; i<sectionNumber; i++) {
        if ([dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            NSInteger rowNumber = [dataSource tableView:self numberOfRowsInSection:i];
            if (rowNumber > 0) {
                isEmpty = NO;
                break;
            }
        }
    }
    
    if (isEmpty) {
        if (!self.placeHolderView) {
            [self makePlaceHodlerView];
        }
        [self addSubview:self.placeHolderView];
    } else {
        [self.placeHolderView removeFromSuperview];
    }
}

-(void)makePlaceHodlerView {
    self.placeHolderView = [[UIView alloc] initWithFrame:self.bounds];
    [self.placeHolderView setBackgroundColor:[UIColor redColor]];
}

-(void)setIsFirstLoad:(BOOL)isFirstLoad {
    objc_setAssociatedObject(self, IsFirstLoadKey, @(isFirstLoad), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isFirstLoad {
    return [objc_getAssociatedObject(self, IsFirstLoadKey) boolValue];
}

-(void)setPlaceHolderView:(UIView *)placeHolderView {
    objc_setAssociatedObject(self, PlaceHolderViewKey, placeHolderView, OBJC_ASSOCIATION_RETAIN);
}

-(UIView *)placeHolderView {
    return objc_getAssociatedObject(self, PlaceHolderViewKey);
}
@end
