//
//  ZFoodDetailPageViewController.h
//  02-美团外卖
//
//  Created by Zed Link on 16/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseViewController.h"
@class ZShopFoodCategory, ZShopFood;

@interface ZFoodDetailPageViewController : ZBaseViewController

/* 菜品分类数组, 包含所有的菜品数据 */
@property (strong, nonatomic) NSArray <ZShopFoodCategory *> *foodList;

/* 当前选择的菜品数据 */
@property (strong, nonatomic) ZShopFood*currentFood;

@end
