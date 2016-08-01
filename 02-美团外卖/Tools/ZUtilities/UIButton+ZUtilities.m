//
//  UIButton+ZUtilities.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "UIButton+ZUtilities.h"

@implementation UIButton (ZUtilities)

+ (instancetype)zTextButtonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor selectedTextColor:(UIColor *)selectedTextColor
{
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:selectedTextColor forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    [button sizeToFit];
    
    return button;
}

@end
