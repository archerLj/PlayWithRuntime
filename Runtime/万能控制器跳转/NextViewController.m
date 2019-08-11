//
//  NextViewController.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    self.title = @"目标控制器";
    
    NSLog(@"得到的参数: name:%@, age:%d", self.name, self.age);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
