//
//  ZFoodDetailPageViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 16/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZFoodDetailPageViewController.h"
#import "ZShopFoodDetailViewController.h"
#import "ZShopFoodCategory.h"

@interface ZFoodDetailPageViewController () <UIPageViewControllerDataSource>

@end

@implementation ZFoodDetailPageViewController

#pragma mark - 界面初始化

- (void)zSetupUI
{
    [super zSetupUI];
    
    // -------- 添加分页控制器 --------
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    // 配置代理
    pageController.dataSource = self;
    
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
    
    // -------- 为分页添加内容 --------
    // 创建分页明细控制器
    ZShopFoodDetailViewController *detailVC = [[ZShopFoodDetailViewController alloc] init];
    detailVC.food = self.currentFood;
    
    [pageController setViewControllers:@[detailVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - UIPageViewControllerDataSource

/**
 * 返回前一个控制器
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    // -------- 获取当前菜品模型的上一个数据 --------
    NSInteger categoryIndex = 0;
    for (ZShopFoodCategory *foodCategory in self.foodList) {
        NSArray *foods = foodCategory.spus;
        
        // 找到当前菜品数据所在的分类
        if ([foods containsObject:self.currentFood]) {
            // 如果当前菜品是第一个, 则获取上一个菜品分类的最后一个 | 注意数组越界
            if (foods.firstObject == self.currentFood) {
                // 注意数组越界
                if (categoryIndex > 0) {
                    ZShopFoodCategory *previousCategory = self.foodList[--categoryIndex];
                    
                    ZShopFoodDetailViewController *detailVC = [[ZShopFoodDetailViewController alloc] init];
                    detailVC.food = previousCategory.spus.lastObject;
                    self.currentFood = detailVC.food;
                    return detailVC;
                }
            } else {
                // 获取该分类中, 上一个菜品数据
                NSInteger index = [foods indexOfObject:self.currentFood];
                // 注意数组越界
                if (index > 0) {
                    ZShopFoodDetailViewController *detailVC = [[ZShopFoodDetailViewController alloc] init];
                    detailVC.food = [foods objectAtIndex:--index];
                    self.currentFood = detailVC.food;
                    return detailVC;
                }
            }
        }
        
        categoryIndex--;
    }
    
    // 返回nil, 表示没有前一个
    return nil;
}

/**
 *  返回下一个控制器
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    // -------- 获取当前菜品模型的下一个数据 --------
    NSInteger categoryIndex = 0;
    for (ZShopFoodCategory *foodcategory in self.foodList) {
        NSArray *foods = foodcategory.spus;
        
        // 找到当前菜品数据所在的分类
        if ([foods containsObject:self.currentFood]) {
            // 如果当前菜品是最后一个, 则获取下一个菜品分类的第一个
            if (foods.lastObject == self.currentFood) {
                // 注意数组越界
                if (categoryIndex < self.foodList.count - 1) {
                    ZShopFoodCategory *previousCategory = self.foodList[++categoryIndex];
                    
                    ZShopFoodDetailViewController *detailVC = [[ZShopFoodDetailViewController alloc] init];
                    detailVC.food = previousCategory.spus.firstObject;
                    self.currentFood = detailVC.food;
                    return detailVC;
                }
            } else {
                // 获取该分类中, 下一个菜品数据
                NSUInteger index = [foods indexOfObject:self.currentFood];
                // 注意数组越界
                if (index < foods.count - 1) {
                    ZShopFoodDetailViewController *detailVC = [[ZShopFoodDetailViewController alloc] init];
                    detailVC.food = [foods objectAtIndex:++index];
                    self.currentFood = detailVC.food;
                    return detailVC;
                }
            }
        }
        
        categoryIndex++;
    }
    
    // 返回nil 表示没有下一个
    return nil;
}

@end
