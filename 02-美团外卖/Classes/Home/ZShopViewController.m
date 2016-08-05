//
//  ZShopViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopViewController.h"
#import "ZShopCategoryView.h"

// C语言的常量值通常使用k开头
#define HeaderViewHeight 124    // 顶部视图的高度

@interface ZShopViewController ()

@property (weak, nonatomic) UIView *headerView;

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
    
    CGFloat categoryHeight = 37;
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(categoryHeight);
    }];
    
    // -------- 3. 设置底部的内容视图(UIScrollView) --------
    UIScrollView *contentView = [self setupContentView];
    [self.view addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(categoryView.mas_bottom);
    }];
    
    // -------- 添加平滑手势 --------
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
}

// 加载底部的内容视图
- (UIScrollView *)setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor orangeColor];
    
    // -------- 添加尺寸视图, 将后继视图添加到该视图上, 方便布局 --------
    UIView *sizeView = [[UIView alloc] init];
    sizeView.backgroundColor = [UIColor blueColor];
    [contentView addSubview:sizeView];
    
    // 添加约束
    [sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 约束 edges 等价于设置了 contentInset 和 frame
        make.edges.equalTo(contentView);
        // 约束 宽和高 等于于设置了 contentSize
        make.height.equalTo(contentView.mas_height);
        make.width.equalTo(contentView).multipliedBy(3);
    }];
    
    return contentView;
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

@end
