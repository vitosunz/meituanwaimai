//
//  UIColor+ZUtilities.h
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZUtilities)

/**
 *  创建16进制数字对应的颜色, 如0xFF0000
 *
 *  @param hex 表示颜色的16进制数值
 *
 *  @return 数值对应颜色的UIColor实例
 */
+ (instancetype)zColorWithHex:(uint32_t)hex;

/**
 *  生成随机颜色
 *
 *  @return 随机颜色的UIColor实例
 */
+ (instancetype)zRandomColor;

/**
 *  使用RGB值数值创建对应的颜色
 *
 *  @param red   R值, 范围为0.0~255.0
 *  @param green G值, 范围为0.0~255.0
 *  @param blue  B值, 范围为0.0~255.0
 *
 *  @return RGB值对应颜色的UIColor实例
 */
+ (instancetype)zColorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

@end
