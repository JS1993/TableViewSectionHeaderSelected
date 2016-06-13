//
//  AppDelegate.m
//  TableViewSectionHeaderSelected
//
//  Created by  江苏 on 16/6/13.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dic;//字典
    NSArray *allKeys;//所有key值数组
    
    BOOL isShow[10];//定义一个布尔类型,来记录每个数组的收起和展开状态 默认全为NO
    UITableView *_tableView;
}

//选中按钮的索引，初始化的时候要为-1
@property(nonatomic)NSInteger selIndex;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window =  [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController *vc = [[UIViewController alloc] init];
    self.window.rootViewController = vc;
    
    [self _initUITableView];
    
    self.selIndex=-1;
    
    return YES;
}

-(void)_initUITableView
{
    //创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 667-20)];
    //实现数据源协议
    _tableView.dataSource = self;
    
    //实现代理
    _tableView.delegate = self;
    
    //添加到窗口上
    [self.window addSubview:_tableView];
    
    //获取数据源
    //文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ListData" ofType:@"plist"];
    
    dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //获取所有key值 并且排序 为升序排序
    allKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark---------UITabelView
//返回数组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return allKeys.count;
}
//返回每个数组元素个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //拿到内层数组
    NSArray *arr = [dic objectForKey:allKeys[section]];
    
    //判断是否为收起状态  如果是收起状态则返回0个元素
    if (isShow[section] == NO) {
        return 0;
    }
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //定义标示符
    static NSString *identifier = @"cell";
    
    //创建单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSArray *arr = [dic objectForKey:allKeys[indexPath.section]];
    
    cell.textLabel.text = arr[indexPath.row];
    
    return cell;
}
//返回每组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //创建button 可以不用设置frame  和数组头视图一样大小
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.tag = section;//通过btn的tag值来存储section下标
    
    [btn setTitle:allKeys[section] forState:UIControlStateNormal];
    
    btn.backgroundColor = [UIColor redColor];
    
    [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    
    return btn;
}



//每组头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


-(void)btnAct:(UIButton *)btn
{
    
    //点击按钮切换展开或收起状态
    isShow[btn.tag] = !isShow[btn.tag];
    
    if (isShow[btn.tag]) {
        self.selIndex=btn.tag;
    }else{
        self.selIndex=-1;
    }
    //刷新表视图
    NSIndexSet* indexSet=[NSIndexSet indexSetWithIndex:btn.tag];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    UIButton* btn=(UIButton*)view;
    
    if (self.selIndex==section) {
        btn.selected=YES;
    }else{
        btn.selected=NO;
    }
    
}
@end
