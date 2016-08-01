//
//  UIButton+ZUtilities.h
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZUtilities)

/**
 *  快速创建只有文本的按钮
 *
 *  @param title         按钮标题
 *  @param size          字体大小
 *  @param textColor   普通状态字体颜色
 *  @param selectedTextColor 选中状态字体颜色
 *
 *  @return 按钮实例
 */
+ (instancetype)zTextButtonWithTitle:(NSString *)title fontSize:(CGFloat)size textColor:(UIColor *)textColor selectedTextColor:(UIColor *)selectedColor;

@end
