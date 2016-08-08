//
//  ZShoppingCarView.h
//  02-美团外卖
//
//  Created by Zed Link on 8/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseView.h"
@class ZShopFood;

@interface ZShoppingCarView : ZBaseView

+ (instancetype)shoppingCarView;

/* 购物车数组 */
@property (strong, nonatomic) NSMutableArray <ZShopFood *> *shoppingCarFoods;

@end
