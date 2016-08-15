//
//  ZShopFoodDetailViewController.h
//  02-美团外卖
//
//  Created by Zed Link on 13/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//
//  菜品详情控制器

#import "ZBaseViewController.h"
@class ZShopFood;

@interface ZShopFoodDetailViewController : ZBaseViewController

/* 菜品模型 */
@property (strong, nonatomic) ZShopFood *food;

@end
