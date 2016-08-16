//
//  ZFoodDetailPageViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 16/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZFoodDetailPageViewController.h"
#import "ZShopFoodDetailViewController.h"

@interface ZFoodDetailPageViewController ()

@end

@implementation ZFoodDetailPageViewController

#pragma mark - 界面初始化

- (void)zSetupUI
{
    [super zSetupUI];
    
    // -------- 添加分页控制器 --------
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    // 添加子控制器 与 子视图
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    
    // 完成控制器添加 (添加到容器视图或从中移除后要执行)
    [pageController didMoveToParentViewController:self];
    
    // 随机背景色, 临时检测
    pageController.view.backgroundColor = [UIColor zRandomColor];
    
    // 约束
    [pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
