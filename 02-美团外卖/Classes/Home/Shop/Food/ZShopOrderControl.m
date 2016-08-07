//
//  ZShopOrderControl.m
//  02-美团外卖
//
//  Created by Zed Link on 8/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopOrderControl.h"

/**
 *  UIControl继承自UIView, 与Xib的绑定和UIView类似
    * 不需要操作File's owner
    * 将Xib中的视图类绑定类型
 */

@implementation ZShopOrderControl

+ (instancetype)shopOrderControl
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
    
    return [nib instantiateWithOwner:nil options:nil].lastObject;
}

@end
