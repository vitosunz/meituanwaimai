//
//  ZShopViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopViewController.h"
#import "ZShopCategoryView.h"
#import "ZShopFoodViewController.h"
#import "ZShopSellerViewController.h"
#import "ZShopCommentViewController.h"
#import "ZShoppingCarView.h"
#import "ZShopFoodCategory.h"
#import "ZShopFood.h"
#import "ZShoppingCarViewController.h"
#import "ZFoodDetailPageViewController.h"

// C语言的常量值通常使用k开头
#define HeaderViewHeight 124    // 顶部视图的高度

/**
 *  extern 关键字是C/OC/C++常用的定义字符串的技巧
 *  表示字符串的内容在其它位置实现, 使用extern只需要做声明, 系统会找到对应的实现
 */
extern NSString *const ZShopFoodDidIncreaseNotification;    // 菜品订购增加
extern NSString *const ZShopFoodDidDecreaseNotification;    // 菜品订购减少
extern NSString *const ZShopFoodIncreaseCenterKey;  // 加号按钮中心点

@interface ZShopViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate, ZShoppingCarViewDelegate, ZShopFoodViewControllerDelegate>

/* 顶部视图 */
@property (weak, nonatomic) UIView *headerView;

/* 中间分类视图 */
@property (weak, nonatomic) ZShopCategoryView *categoryView;

/* 底部内容视图 */
@property (weak, nonatomic) UIScrollView *contentView;

/* 点菜控制器 */
@property (weak, nonatomic) ZShopFoodViewController *foodViewController;

/* 购物车视图 */
@property (weak, nonatomic) ZShoppingCarView *shoppingCarView;

@end

@implementation ZShopViewController {
    /**
     *  菜品分类数组
     */
    NSArray <ZShopFoodCategory *> *_foodCategorys;
    
    /**
     *  记录购物车菜品的数组
     */
    NSMutableArray <ZShopFood *> *_shoppingCarFoods;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 实例化购物车数组
    _shoppingCarFoods = [NSMutableArray array];
    
    self.title = @"猿糞之家";
    
    // 加载数据
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 设置导航栏透明度
    self.navigationController.navigationBar.alpha = 0;
    
    // -------- 注册通知 --------
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopFoodDidIncreaseNotification:) name:ZShopFoodDidIncreaseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopFoodDidDecreaseNotification:) name:ZShopFoodDidDecreaseNotification object:nil];
}

#pragma mark - 界面初始化

- (void)zSetupUI
{
    [super zSetupUI];

    // -------- 1. 设置顶部视图(UIView) --------
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:headerView];
    // 记录 headerView
    self.headerView = headerView;
    
//    CGFloat headerHeight = 123;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(HeaderViewHeight);
    }];
    
    // -------- 2. 设置分类视图(自定义) --------
//    UIView *categoryView = [[UIView alloc] init];
    ZShopCategoryView *categoryView = [[ZShopCategoryView alloc] init];
    categoryView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:categoryView];
    self.categoryView = categoryView;
    
    CGFloat categoryHeight = 37;
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(categoryHeight);
    }];
    
    // -------- 3. 设置底部的内容视图(UIScrollView) --------
    UIScrollView *contentView = [self setupContentView];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(categoryView.mas_bottom);
    }];
    
    // -------- 添加平滑手势 --------
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
    // 配置手势代理, 通过代理方法让两个手势共存
    panGesture.delegate = self;
    
    // -------- 添加监听方法, 监听categoyrView的值改变 --------
    [categoryView addTarget:self action:@selector(categoryValueChangeAction:) forControlEvents:UIControlEventValueChanged];
}

// 加载底部的内容视图
- (UIScrollView *)setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
//    contentView.backgroundColor = [UIColor orangeColor];
    // 开启页面支持
    contentView.pagingEnabled = YES;
    // 关闭弹簧效果
    contentView.bounces = NO;
    // 配置代理
    contentView.delegate = self;
    
    // -------- 添加尺寸视图, 将后继视图添加到该视图上, 方便布局 --------
    UIView *sizeView = [[UIView alloc] init];
//    sizeView.backgroundColor = [UIColor blueColor];
    [contentView addSubview:sizeView];
    
    // 添加约束
    [sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 约束 edges 等价于设置了 contentInset 和 frame
        make.edges.equalTo(contentView);
        // 约束 宽和高 等于于设置了 contentSize
        make.height.equalTo(contentView.mas_height);
        make.width.equalTo(contentView).multipliedBy(3);
    }];
    
    // -------- 三个子控制器 --------
    NSArray *controllerNames = @[
                                 @"ZShopFoodViewController",
                                 @"ZShopSellerViewController",
                                 @"ZShopCommentViewController"
                                 ];
 
    NSMutableArray <UIViewController *> *zChildController = [NSMutableArray arrayWithCapacity:controllerNames.count];
    for (NSString *name in controllerNames) {
        // 实例化控制器
        Class class = NSClassFromString(name);
        UIViewController *vc = [[class alloc] init];
        
        // 断言, 使用名字转换容易出错
        NSAssert([vc isKindOfClass:UIViewController.class], @"不能被转换成控制器的名字");
        
        // 添加控制器视图到sizeView中
        [self zAddChildConrollerView:vc intoView:sizeView];
        [zChildController addObject:vc];
    }
    
    // 记录点菜控制器
    self.foodViewController = (ZShopFoodViewController *)zChildController[0];
    
    // 配置点菜控制器代理
    self.foodViewController.delegate = self;
    
    // -------- 添加购物车视图 --------
    ZShoppingCarView *carView = [ZShoppingCarView shoppingCarView];
    [sizeView addSubview:carView];
    self.shoppingCarView = carView;
    
    // 配置代理
    self.shoppingCarView.delegate = self;
    
    // 购物车约束
    [carView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(sizeView);
        make.width.equalTo(contentView);
        make.height.mas_equalTo(46);
    }];
    
    // 修改子控制器的视图, 适应sizeView的大小
    // 添加购物车后, 子控制器的视图约束要调整
    [zChildController[0].view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(sizeView);
        make.width.equalTo(contentView);
        make.bottom.equalTo(carView);
    }];
    
    [zChildController[1].view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.equalTo(zChildController[0].view);
        make.left.equalTo(zChildController[0].view.mas_right);
    }];
    
    [zChildController[2].view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.equalTo(zChildController[1].view);
        make.left.equalTo(zChildController[1].view.mas_right);
    }];
    
    return contentView;
}

/**
 *  重构添加子控制器视图的方法
    1. 新建方法, 复制要重构的代码
    2. 根据代码调整参数和返回值
    3. 修改调用位置的代码
    4. 测试
    5. 修改注释
 */
- (void)zAddChildConrollerView:(UIViewController *)viewController intoView:(UIView *)view
{
    // 添加子控制器  注意: 如果不添加会导致响应者链条被打断, 事件无法正常传递
    [self addChildViewController:viewController];
    
    // 将子控制器视图添加到内容视图上
    [view addSubview:viewController.view];
    
    // 完成子控制器的添加 (控制器内部可能做了相关操作)
    [viewController didMoveToParentViewController:self];
}

#pragma mark - 手势响应处理

- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer
{
    // 1. 获取手势移动的距离
    CGPoint translation = [recognizer translationInView:self.headerView];
    
    // 注意: 手势复位归零 (旋转/缩放/平移 都需要复位)
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    // 2. 计算顶度视图修改后的新高度
    CGFloat newHeight = self.headerView.bounds.size.height + translation.y;
    
    // -------- 高度最大值处理 --------
    // 自定义最大值范围 | 最小高度范围 (status bar + navigation bar)
    CGFloat minHeight = 64;
    if (newHeight > HeaderViewHeight || newHeight < minHeight) {
        return;
    }
    
    // -------- 判断水平方向与竖起方向的移动距离 --------
    // 在手势处理中, 非常常见的判断
    if (ABS(translation.x) > ABS(translation.y)) {
        // 水平方向的拖拽, 竖直方向的事件不要响应
        return;
    }
    
    // -------- 根据高度, 修改导航栏的透明度 --------
    // 1 - (headerView当前呈现的高度 / headerView能呈现的最大高度)
    CGFloat alpha = 1- (newHeight - minHeight) / (HeaderViewHeight - minHeight);
    // 修正一下浅色的aplha值
    alpha = (alpha < 0.1) ? 0 : alpha;
    
    // 3. 根据手势状态处理顶部视图高度
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            // 更新约束
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(newHeight);
            }];
            
            // 修改导航条的透明度
            self.navigationController.navigationBar.alpha = alpha;
            break;
        }
        default:
            break;
    }
}

#pragma mark - 控件的事件处理

- (void)categoryValueChangeAction:(ZShopCategoryView *)categoryView
{
    // -------- 获取categoryView的选中索引, 更新contentView显示的内容 --------
    CGFloat offsetX = categoryView.selectedIndex * self.contentView.bounds.size.width;
    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.contentView.contentOffset = CGPointMake(offsetX, 0);
//    }];
    
    // 带有动画效果的偏移量调整
    [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - 通知响应事件

- (void)shopFoodDidIncreaseNotification:(NSNotification *)notification
{
    ZLog(@"%@", notification);
    
    // -------- 更新购物车数组的数据 --------
    ZShopFood *food = notification.object;
    // 同一个数据不用添加两次
    if ([_shoppingCarFoods containsObject:food] == NO) {
        [_shoppingCarFoods addObject:food];
    }
    ZLog(@"购物车数据;  %@", _shoppingCarFoods);
    
    // 获取订购按钮的中心点
    //    CGPoint originalPoint = [notification.userInfo[ZShopFoodIncreaseCenterKey] CGPointValue];
    CGPoint point = [notification.userInfo[ZShopFoodIncreaseCenterKey] CGPointValue];
    CGPoint originalPoint = [[UIApplication sharedApplication].keyWindow convertPoint:point toView:self.view];
    
    // -------- 添加动画的图片 --------
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_food_count_bg"]];
    // 显示在订购按钮的位置上
    imageView.center = originalPoint;
    [self.view addSubview:imageView];
    
    // -------- 使用贝塞尔曲线绘制二次参数曲线路径 --------
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:originalPoint];
    
    CGPoint destinationPoint = CGPointMake(50, self.view.bounds.size.height - 40);
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

- (void)shopFoodDidDecreaseNotification:(NSNotification *)notification
{
    ZShopFood *food = notification.object;
    
    // 菜品数量为0时, 从购物车中删除
    if (food.orderCount == 0) {
        [_shoppingCarFoods removeObject:food];
    }
    
    // 更新购物车模型 (更新UI)
    _shoppingCarView.shoppingCarFoods = _shoppingCarFoods;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIImageView *imageView = [anim valueForKey:@"IncreaseAnimationImageView"];
    
    // 动画完成后移除图片
    [imageView removeFromSuperview];
    
    // -------- 更新购物车的数据 --------
    self.shoppingCarView.shoppingCarFoods = _shoppingCarFoods;
}

#pragma mark - UIGestureRecognizerDelegate

/**
 * 是否允许多个手势同时识别, YES表示允许.
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 判断是否使用手指拖动 scrollView, 在开发中非常常见的技巧
    if (scrollView.isDragging || scrollView.decelerating || scrollView.isTracking) {
        // 将内容视图的偏移量传递给分类视图
        // 对应的比例关系是 1 : 3, contentView的contentSize是三倍大小
        self.categoryView.lineOffsetX = scrollView.contentOffset.x / 3;
    }
}

#pragma mark - ZShoppingCarViewDelegate

- (void)shoppingCarView:(ZShoppingCarView *)shoppintCarView willDisplayShoppingCar:(UIButton *)shopCar
{
    // 弹出购物车控制器
    ZShoppingCarViewController *vc = [[ZShoppingCarViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - ZShopFoodViewControllerDelegate

- (void)shopFoodViewController:(ZShopFoodViewController *)controller didSelectedFood:(ZShopFood *)food
{
    ZLog(@"food : %@", food);
    
    // -------- 跳转到菜品详情分页控制器 --------
    ZFoodDetailPageViewController *pageVC = [[ZFoodDetailPageViewController alloc] init];
    
    pageVC.foodList = _foodCategorys;
    pageVC.currentFood = food;
    
    [self.navigationController pushViewController:pageVC animated:YES];
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
    
    // -------- 加载后的数据传递给ShopFoodViewController实例 --------
    self.foodViewController.foodCategorys = _foodCategorys;
}

@end
