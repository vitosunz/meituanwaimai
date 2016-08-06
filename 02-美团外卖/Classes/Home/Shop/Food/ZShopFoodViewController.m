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
#import "ZShopFoodCategoryCell.h"

/**
 *  可重用标识
 */
static NSString *CategoryCellReuseID = @"CategoryCellReuseID";
static NSString *ListCellReuseID = @"ListCellReuseID";
static NSString *ListHeaderReuseID = @"ListHeaderReuseID";

@interface ZShopFoodViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *foodCategoryView;
@property (weak, nonatomic) UITableView *foodListView;

@end

@implementation ZShopFoodViewController {
    /**
     *  菜品分类数组
     */
    NSArray <ZShopFoodCategory *> *_foodCategorys;
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
    if (tableView == self.foodCategoryView) {
        // 菜品分类只需要一组
        return 1;
    } else if (tableView == self.foodListView) {
        // 返回菜品的分组行数
        return _foodCategorys.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.foodCategoryView) {
        return _foodCategorys.count;
    } else if (tableView == self.foodListView) {
        // 返回每个菜品分类对应的菜品数量
        return _foodCategorys[section].spus.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView == self.foodCategoryView)
    {
        // 获取注册的原型Cell
        cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellReuseID];
        cell.textLabel.text = _foodCategorys[indexPath.row].name;
    }
    else if (tableView == self.foodListView)
    {
        // 获取注册的原型Cell
        cell = [tableView dequeueReusableCellWithIdentifier:ListCellReuseID];
        
        // 获取菜品分类的模型
        ZShopFoodCategory *foodCategory = _foodCategorys[indexPath.section];
        // 获取菜品分类模型中spus属性中indexPath所对应菜品模型
        ZShopFood *food = foodCategory.spus[indexPath.row];
        
        cell.textLabel.text = food.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果选中 菜品类别, 刷新 商品列表
    if (tableView == self.foodCategoryView) {
        // 当前的IndexPath为选中 菜品分类的索引
        // 选中第n个菜品分类, 则应该将该菜品分类的第一个滚动到TableView顶部
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        
        // 让右侧的 foodListView 滚动
        [self.foodListView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.foodCategoryView) {
        return nil;
    }
    
    // -------- foodListView, 菜品列表 --------
    // 获取headerView
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ListHeaderReuseID];
    
    // 配置
    // backgroundColor属性已经废弃, 使用下面的方式替代
//    headerView.backgroundColor = [UIColor redColor];
    headerView.contentView.backgroundColor = [UIColor redColor];
    
    return headerView;
}

#pragma mark - 界面初始化

- (void)zSetupUI
{
    // -------- 添加两个TableView --------
    // 菜品分类视图, 默认样式
    UITableView *foodCategoryView = [[UITableView alloc] init];
    [self.view addSubview:foodCategoryView];
    self.foodCategoryView = foodCategoryView;
    
    // 配置行高
    foodCategoryView.rowHeight = 55;
    
    // 菜品列表视图, 分组样式
    UITableView *foodListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:foodListView];
    self.foodListView = foodListView;
    
    // -------- 添加约束 --------
    [foodCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(86);
    }];
    
    [foodListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.left.equalTo(foodCategoryView.mas_right).offset(9);
    }];
    
    // -------- 配置TableView --------
    // 注册 原型Cell
    [foodCategoryView registerClass:[ZShopFoodCategoryCell class] forCellReuseIdentifier:CategoryCellReuseID];
    [foodListView registerClass:[UITableViewCell class] forCellReuseIdentifier:ListCellReuseID];
    // 注册 菜品列表的HeaderView
    [foodListView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:ListHeaderReuseID];
    
    // 配置 数据源
    foodCategoryView.dataSource = self;
    foodListView.dataSource = self;
    // 配置 代理
    foodCategoryView.delegate = self;
    foodListView.delegate = self;
    
    // -------- 配置HeaderView的高度 --------
    // 设置Header高度, 如果要自定义Header视图, 一定要设置行高, 否则不走代理方法
    foodListView.sectionHeaderHeight = 23;
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
    
    _foodCategorys = [tempArrM copy];
//    NSLog(@"%@", tempArrM);
}

@end
