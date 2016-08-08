//
//  ZShoppingCarView.m
//  02-美团外卖
//
//  Created by Zed Link on 8/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShoppingCarView.h"

@implementation ZShoppingCarView

+ (instancetype)shoppingCarView
{
    return [[UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil] instantiateWithOwner:nil options:nil][0];
}

@end
