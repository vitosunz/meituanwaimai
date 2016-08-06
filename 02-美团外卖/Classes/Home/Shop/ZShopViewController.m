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

// C语言的常量值通常使用k开头
#define HeaderViewHeight 124    // 顶部视图的高度

@interface ZShopViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

/**
 *  顶部视图
 */
@property (weak, nonatomic) UIView *headerView;

/**
 *  中间分类视图
 */
@property (weak, nonatomic) ZShopCategoryView *categoryView;

/**
 *  底部内容视图
 */
@property (weak, nonatomic) UIScrollView *contentView;

@end

@implementation ZShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"猿糞之家";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 设置导航栏透明度
    self.navigationController.navigationBar.alpha = 0;
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
    
    // 修改子控制器的视图, 适应sizeView的大小
    [zChildController[0].view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(sizeView);
        make.width.equalTo(contentView);
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

@end
