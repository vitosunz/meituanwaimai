//
//  ZFoodDetailHeaderView.h
//  02-美团外卖
//
//  Created by Zed Link on 15/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseView.h"
@class ZShopFood;

@interface ZFoodDetailHeaderView : ZBaseView

+ (instancetype)foodDetailHeaderView;

/* 菜品模型 */
@property (strong, nonatomic) ZShopFood *food;

@end
