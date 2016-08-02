//
//  ZShopFoodCategory.h
//  03-JSON体验
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//
//  菜品分类模型

#import <Foundation/Foundation.h>
@class ZShopFood;

@interface ZShopFoodCategory : NSObject

/**
 * 分类名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * 该分类包含的商家菜品
 */
@property (nonatomic, strong) NSArray <ZShopFood *> *spus;

@end
