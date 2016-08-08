//
//  ZShopFoodViewController.h
//  02-美团外卖
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseViewController.h"
@class ZShopFoodCategory;

@interface ZShopFoodViewController : ZBaseViewController

/* 菜品数据源 */
@property (strong, nonatomic) NSArray <ZShopFoodCategory *> *foodCategorys;

@end
