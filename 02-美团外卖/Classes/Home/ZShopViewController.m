//
//  ZShopViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopViewController.h"

// C语言的常量值通常使用k开头
#define HeaderViewHeight 124    // 顶部视图的高度

@interface ZShopViewController ()

@property (weak, nonatomic) UIView *headerView;

@end

@implementation ZShopViewController

- (void)zSetupUI
{
    // 0. 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];

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
    
    // -------- 2. 设置分类视图(UIView) --------
    UIView *categoryView = [[UIView alloc] init];
    categoryView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:categoryView];
    
    CGFloat categoryHeight = 37;
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(categoryHeight);
    }];
    
    // -------- 3. 设置底部的内容视图(UIScrollView) --------
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(categoryView.mas_bottom);
    }];
    
    // -------- 添加平滑手势 --------
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
}

#pragma mark - 手势响应处理

- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer
{
    // 1. 获取手势移动的距离
    CGPoint translation = [recognizer translationInView:self.headerView];
    
    // 注意: 手势复位归零 (旋转/缩放/平移 都需要复位)
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    // 2. 计算顶度视图高度的修改值
    CGFloat height = self.headerView.bounds.size.height + translation.y;
    
    // -------- 高度最大值处理 --------
    // 自定义最大值范围 | 最小高度范围 (status bar + navigation bar)
    if (height > HeaderViewHeight || height < 64) {
        return;
    }
    
    // 3. 根据手势状态处理顶部视图高度
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            // 更新约束
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            break;
        }
        default:
            break;
    }
}

@end
