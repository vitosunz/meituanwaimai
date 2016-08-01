//
//  ZShopViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopViewController.h"

@interface ZShopViewController ()

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
    
    CGFloat headerHeight = 123;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(headerHeight);
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
}

@end
