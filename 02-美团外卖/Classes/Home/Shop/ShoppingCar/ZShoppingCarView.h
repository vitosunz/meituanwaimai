//
//  ZShoppingCarView.h
//  02-美团外卖
//
//  Created by Zed Link on 8/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseView.h"
@class ZShopFood, ZShoppingCarView;

/**
 *  定义协议, 告诉代理方需要实现的方法
 */
@protocol ZShoppingCarViewDelegate <NSObject>

@optional

/**
 *  将要显示
 */
- (void)shoppingCarView:(ZShoppingCarView *)shoppintCarView willDisplayShoppingCar:(UIButton *)shopCar;

/**
 *  将要结账
 */
- (void)shoppingCarViewDidCheckAccount:(ZShoppingCarView *)shoppintCarView;

@end

@interface ZShoppingCarView : ZBaseView

+ (instancetype)shoppingCarView;

/* 代理对象 */
@property (weak, nonatomic) id<ZShoppingCarViewDelegate> delegate;

/* 购物车数组 */
@property (strong, nonatomic) NSMutableArray <ZShopFood *> *shoppingCarFoods;

@end
