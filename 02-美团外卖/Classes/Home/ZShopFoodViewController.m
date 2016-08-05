//
//  ZShopFoodViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodViewController.h"
#import "ZShopFoodCategory.h"

/**
 *  可重用标识
 */
static NSString *CategoryCellReuseID = @"CategoryCellReuseID";

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 多个TableView使用同一个DataSource和Delegate时, 需要在代理方法中处理判断
    if (tableView == _categoryView) {
        return _foodList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取注册的原型Cell
    UITableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:CategoryCellReuseID];

    if (tableView == self.categoryView) {
        categoryCell.textLabel.text = _foodList[indexPath.row].name;
    }
    
    return categoryCell;
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
    // 注册 原型Cell
    [categoryView registerClass:[UITableViewCell class] forCellReuseIdentifier:CategoryCellReuseID];
    // 配置 数据源
    categoryView.dataSource = self;
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
    
    NSLog(@"%@", tempArrM);
}

@end
