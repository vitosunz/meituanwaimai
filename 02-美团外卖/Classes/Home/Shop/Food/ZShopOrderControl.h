//
//  ZShopOrderControl.h
//  02-美团外卖
//
//  Created by Zed Link on 8/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseControl.h"

@interface ZShopOrderControl : ZBaseControl

/**
 *  从Xib加载并返回自定义控件
 */
+ (instancetype)shopOrderControl;

/* 订购数量 */
@property (assign, nonatomic) NSInteger count;

@end
