//
//  ZShopFoodViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodViewController.h"
#import "ZShopFoodCategory.h"
#import "ZShopFood.h"

/**
 *  可重用标识
 */
static NSString *CategoryCellReuseID = @"CategoryCellReuseID";
static NSString *ListCellReuseID = @"ListCellReuseID";

@interface ZShopFoodViewController () <UITableViewDataSource>

@property (weak, nonatomic) UITableView *categoryView;
@property (weak, nonatomic) UITableView *listTableView;

@end

@implementation ZShopFoodViewController {
    /**
     *  菜品分类数组
     */
    NSArray <ZShopFoodCategory *> *_foodList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加载数据
    [self loadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

/**
 *  多个TableView使用同一个DataSource和Delegate时, 需要在代理方法中处理判断
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.categoryView) {
        // 菜品分类只需要一组
        return 1;
    } else if (tableView == self.listTableView) {
        // 返回菜品的分组行数
        return _foodList.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryView) {
        return _foodList.count;
    } else if (tableView == self.listTableView) {
        // 返回每个菜品分类对应的菜品数量
        return _foodList[section].spus.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView == self.categoryView)
    {
        // 获取注册的原型Cell
        cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellReuseID];
        cell.textLabel.text = _foodList[indexPath.row].name;
    }
    else if (tableView == self.listTableView)
    {
        // 获取注册的原型Cell
        cell = [tableView dequeueReusableCellWithIdentifier:ListCellReuseID];
        
        // 获取菜品分类的模型
        ZShopFoodCategory *foodCategory = _foodList[indexPath.section];
        // 获取菜品分类模型中spus属性中indexPath所对应菜品模型
        ZShopFood *food = foodCategory.spus[indexPath.row];
        
        cell.textLabel.text = food.name;
    }
    
    return cell;
}

#pragma mark - 界面初始化

- (void)setupUI
{
    // -------- 添加两个TableView --------
    // 菜品分类视图
    UITableView *categoryView = [[UITableView alloc] init];
    [self.view addSubview:categoryView];
    self.categoryView = categoryView;
    
    // 菜品列表视图
    UITableView *listTableView = [[UITableView alloc] init];
    [self.view addSubview:listTableView];
    self.listTableView = listTableView;
    
    // -------- 添加约束 --------
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(86);
    }];
    
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.left.equalTo(categoryView.mas_right).offset(9);
    }];
    
    // -------- 配置TableView --------
    // 注册 原型Cell, 此处演示比较简单, 并没有自定义Cell
    [categoryView registerClass:[UITableViewCell class] forCellReuseIdentifier:CategoryCellReuseID];
    [listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ListCellReuseID];
    // 配置 数据源
    categoryView.dataSource = self;
    listTableView.dataSource = self;
}

#pragma mark - 数据加载

- (void)loadData
{
    // -------- 加载JSON数据 --------
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"food.json" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // 反序列化
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    // -------- 获取菜品类型对应的数据 --------
    NSArray *foodcategorys = resultDict[@"data"][@"food_spu_tags"];
    
    // 保存数据到磁盘, 实现工作中做数据测试的重要手段
//    [resultDict writeToFile:@"/Users/ZED/Desktop/food.plist" atomically:YES];
    
    // 将字典数据转换成模型
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (NSDictionary *dict in foodcategorys) {
        // 建立模型
        ZShopFoodCategory *foodcategory = [[ZShopFoodCategory alloc] init];
        // 字典转模型
        [foodcategory setValuesForKeysWithDictionary:dict];
        
        [tempArrM addObject:foodcategory];
    }
    
    _foodList = [tempArrM copy];
//    NSLog(@"%@", tempArrM);
}

@end
