//
//  ZShopFoodListCell.h
//  02-美团外卖
//
//  Created by Zed Link on 7/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZShopFood;

@interface ZShopFoodListCell : UITableViewCell

/* 菜品模型 */
@property (strong, nonatomic) ZShopFood *food;

@end
