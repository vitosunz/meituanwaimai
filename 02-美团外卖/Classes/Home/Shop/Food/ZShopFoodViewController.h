//
//  ZShopFoodViewController.h
//  02-美团外卖
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//
//  点菜控制器

#import "ZBaseViewController.h"
@class ZShopFoodCategory, ZShopFood, ZShopFoodViewController;

@protocol ZShopFoodViewControllerDelegate <NSObject>

@optional

/**
 *  点菜控制器选择了菜品
 */
- (void)shopFoodViewController:(ZShopFoodViewController *)controller didSelectedFood:(ZShopFood *)food;

@end

@interface ZShopFoodViewController : ZBaseViewController

/* 代理 */
@property (weak, nonatomic) id<ZShopFoodViewControllerDelegate> delegate;

/* 菜品数据源 */
@property (strong, nonatomic) NSArray <ZShopFoodCategory *> *foodCategorys;

@end
