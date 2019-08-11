//
//  ViewController.m
//  Runtime
//
//  Created by archerLj on 2019/8/11.
//  Copyright © 2019 com.tech.zhonghua. All rights reserved.
//

#import "ViewController.h"
#import "LFViewControllerManager.h"
#import "objc/runtime.h"
#import "Student.h"
#import "EncodeAndDecode.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITextField *demoField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主控制器";
    [self uitableViewPlaceHolder];
    [self makeDataSource];
}

/******************************************************************/
//             UITableView为空时的占位图
/******************************************************************/
-(void)uitableViewPlaceHolder {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *subArr = self.dataSource[section];
    return subArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *subArr = self.dataSource[indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.textLabel.text = subArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self clearDataSource];
}

-(void)makeDataSource {
    for (int i=0; i<10; i++) {
        NSMutableArray *subSource = [[NSMutableArray alloc] init];
        for (int j=0; j<20; j++) {
            
            [subSource addObject:[NSString stringWithFormat:@"%d", j]];
        }
        
        [self.dataSource addObject:subSource];
    }
    [self.tableView reloadData];
}

-(void)clearDataSource {
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


/******************************************************************/
//             按钮重复点击
/******************************************************************/
-(void)buttonReTouchAvoid {
    UIButton *demoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 120, 40)];
    [demoBtn setTitle:@"点我" forState:UIControlStateNormal];
    [demoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [demoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:demoBtn];
}

-(void)btnAction:(UIButton *)sender {
    NSLog(@"btn action.");
}


/******************************************************************/
//             字体自适应
/******************************************************************/
-(void)fontAutoResize {
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, 150, 40)];
    text.text = @"测试文字";
    text.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:text];
}


/******************************************************************/
//             自动归解档
/******************************************************************/
-(void)autoEncodeAndDecoder {
    EncodeAndDecode *demo = [[EncodeAndDecode alloc] init];
    demo.name = @"demo";
    demo.age = 20;
    NSMutableArray *address = [[NSMutableArray alloc] init];
    [address addObject:@"address 1"];
    [address addObject:@"address 2"];
    [address addObject:@"address 3"];
    demo.address = address;
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"encodeDemo.archiver"];
    BOOL result = [NSKeyedArchiver archiveRootObject:demo toFile:filePath];
    if (result) {
        NSLog(@"归档成功");
    }
    
    EncodeAndDecode *demoUnarchered = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"%@", demoUnarchered);
}


/******************************************************************/
//             字典转模型
/******************************************************************/
-(void)JSONtoModel {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"student" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if(!error) {
        Student *student = [Student modelWithDictionary:json];
        NSLog(@"%@", student);
    }
}


/******************************************************************/
//             打印UITextField的所有属性和成员变量
/******************************************************************/
-(void)getPropertyAndIVarsOfUITextField {
    unsigned int count;
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    for (int i=0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *cName = ivar_getName(ivar);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSLog(@"%@", name);
    }
    
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *cPropertyName = property_getName(property);
        NSString *name = [NSString stringWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        NSLog(@"%@", name);
    }
}


/******************************************************************/
//             万能控制器跳转
/******************************************************************/
-(void)controllerManagerTest {
    NSDictionary *params = @{
                             @"controller": @"NextViewController",
                             @"params": @{
                                     @"name": @"john",
                                     @"age": @"10"
                                     }
                             };
    [LFViewControllerManager showViewControllerWithParams:params];
}
@end
