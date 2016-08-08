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
#import "ZShopFoodHeaderView.h"
#import "ZShopFoodListCell.h"

/**
 *  extern 关键字是C/OC/C++常用的定义字符串的技巧
 *  表示字符串的内容在其它位置实现, 使用extern只需要做声明, 系统会找到对应的实现
 */
extern NSString *const ZShopFoodDidIncreaseNotification; // 菜品订购按钮点击
extern NSString *const ZShopFoodIncreaseCenterKey; // 加号按钮中心点

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
    
    /**
     *  处于顶部的SectionHeader的索引
     */
    NSUInteger _topSectionIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加载数据
    [self loadData];
    
    // 默认选中菜品类别第一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.foodCategoryView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    // -------- 注册通知 --------
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopFoodDidIncreaseNotification:) name:ZShopFoodDidIncreaseNotification object:nil];
}

- (void)dealloc
{
    // 移除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - 通知响应事件

- (void)shopFoodDidIncreaseNotification:(UILocalNotification *)notification
{
    ZLog(@"%@", notification);
    
    // 获取订购按钮的中心点
//    CGPoint originalPoint = [notification.userInfo[ZShopFoodIncreaseCenterKey] CGPointValue];
    CGPoint point = [notification.userInfo[ZShopFoodIncreaseCenterKey] CGPointValue];
    CGPoint originalPoint = [[UIApplication sharedApplication].keyWindow convertPoint:point toView:self.view];
    
    // 添加动画的图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_common_point"]];
    // 显示在订购按钮的位置上
    imageView.center = originalPoint;
    [self.view addSubview:imageView];
    
    // 使用贝塞尔曲线绘制二次参数曲线路径
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:originalPoint];
    
#warning 临时目标点
    CGPoint destinationPoint = CGPointMake(50, 400);
    CGPoint controlPoint = CGPointMake(originalPoint.x - 100, originalPoint.y - 150);
    
    [bezier addQuadCurveToPoint:destinationPoint controlPoint:controlPoint];
    
    // -------- 使用关键帧动画 --------
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 隐式代理, 不需要遵守协议, 相关方法定义在NSObject中
    animation.delegate = self;
    
    // 使用 KVC 为动画绑定图像对象
    [animation setValue:imageView forKey:@"IncreaseAnimationImageView"];
    
    animation.path = bezier.CGPath;
    animation.duration = 1.0;
    
    [imageView.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIImageView *imageView = [anim valueForKey:@"IncreaseAnimationImageView"];
    
    // 动画完成后移除图片
    [imageView removeFromSuperview];
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
    if (tableView == self.foodCategoryView)
    {
        // 获取注册的原型Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellReuseID];
        cell.textLabel.text = _foodCategorys[indexPath.row].name;
        
        return cell;
    }
    else if (tableView == self.foodListView)
    {
        // 获取注册的原型Cell
        ZShopFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellReuseID];
        
        // 获取菜品分类的模型
        ZShopFoodCategory *foodCategory = _foodCategorys[indexPath.section];
        // 获取菜品分类模型中spus属性中indexPath所对应菜品模型
        ZShopFood *food = foodCategory.spus[indexPath.row];
        
        // 赋值数据模型
        cell.food = food;
        
        return cell;
    }
    
    return nil;
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
    ZShopFoodHeaderView *headerView = (ZShopFoodHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ListHeaderReuseID];
    
    // 配置
//    // 控制台输出:  Setting the background color on UITableViewHeaderFooterView has been deprecated. Please use contentView.backgroundColor instead. | backgroundColor属性已经废弃, 使用contentView.backgroundColor替代
////    headerView.backgroundColor = [UIColor redColor];
//    headerView.contentView.backgroundColor = [UIColor redColor];
//    
//    // 设置headerView的标题为菜品分类名
//    headerView.textLabel.text = _foodCategorys[section].name;
//    // 配置字体
//    headerView.textLabel.font = [UIFont systemFontOfSize:12];
    
    headerView.titleLabel.text = _foodCategorys[section].name;
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (tableView == self.foodListView) {
        
        //  如果要显示的是上一组的Header, 则上级header在顶部
        if (section < _foodCategorys.count - 1 && _topSectionIndex == section + 1) {
            
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:section inSection:0];
            
            // 会选中执行Cell, 但不会触发 didSelect 的代理方法
            [self.foodCategoryView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            _topSectionIndex = section;
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (tableView == self.foodListView) {

        // 如果顶部的header要消失, 则下一组header显示在顶部
        if (section < _foodCategorys.count - 1 && _topSectionIndex == section) {
            
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:section + 1 inSection:0];
            
            // 会选中执行Cell, 但不会触发 didSelect 的代理方法
            [self.foodCategoryView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            _topSectionIndex = section + 1;
        }
    }
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
    // 取消分隔线
    foodCategoryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 背景色
    foodCategoryView.backgroundColor = [UIColor zColorWithHex:0xF8F8F8];
    
    // 菜品列表视图
    UITableView *foodListView = [[UITableView alloc] init];
    [self.view addSubview:foodListView];
    self.foodListView = foodListView;
    
    // -------- 行高配置 --------
//#warning 临时设置行高
//    // 配置行高
//    foodListView.rowHeight = 120;

    // 设置预估行高
    foodListView.estimatedRowHeight = 120;
    // 自动规划计算行高  (使用AutoLayout布局Cell才有效)
    foodListView.rowHeight = UITableViewAutomaticDimension;
    
    // -------- 添加约束 --------
    [foodCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(86);
    }];
    
    [foodListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.left.equalTo(foodCategoryView.mas_right);
    }];
    
    // -------- 配置TableView --------
    // 注册 原型Cell
    [foodCategoryView registerClass:[ZShopFoodCategoryCell class] forCellReuseIdentifier:CategoryCellReuseID];
    [foodListView registerClass:[ZShopFoodListCell class] forCellReuseIdentifier:ListCellReuseID];
    // 注册 菜品列表的HeaderView
    [foodListView registerClass:[ZShopFoodHeaderView class] forHeaderFooterViewReuseIdentifier:ListHeaderReuseID];
    
    // 配置 数据源
    foodCategoryView.dataSource = self;
    foodListView.dataSource = self;
    // 配置 代理
    foodCategoryView.delegate = self;
    foodListView.delegate = self;
    
    // -------- 配置HeaderView的高度 --------
    // 设置Header高度, 如果要自定义Header视图, 一定要设置行高, 否则不走代理方法
    foodListView.sectionHeaderHeight = 23;
    
    // -------- 默认第一行header处于顶部 --------
    _topSectionIndex = 0;
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
