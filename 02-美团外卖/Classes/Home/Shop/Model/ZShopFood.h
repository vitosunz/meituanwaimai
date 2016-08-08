//
//  ZShopFood.h
//  03-JSON体验
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//
//  商家菜品

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZShopFood : NSObject

/**
 *  菜品名称
 */
@property (copy, nonatomic) NSString *name;

/**
 *  月售
 */
@property (copy, nonatomic) NSString *month_saled_content;

/**
 *  点赞数
 */
@property (assign, nonatomic) NSInteger praise_num;

/**
 *  售价
 */
@property (assign, nonatomic) CGFloat min_price;

/**
 *  描述
 */
@property (copy, nonatomic) NSString *desc;

/**
 *  配图的链接地址
 */
@property (copy, nonatomic) NSString *picture;

/*
 *  订单数量
 */
@property (assign, nonatomic) NSInteger orderCount;

@end
