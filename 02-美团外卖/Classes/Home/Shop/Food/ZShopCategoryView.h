//
//  ZShopCategoryView.h
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseControl.h"

@interface ZShopCategoryView : ZBaseControl

/**
 *  线条的水平位移偏移量
 */
@property (assign, nonatomic)  CGFloat lineOffsetX;

/**
 *  当前选中标签按钮的索引
 */
@property (assign, nonatomic) NSUInteger selectedIndex;

@end
