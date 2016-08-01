//
//  UIColor+ZUtilities.m
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "UIColor+ZUtilities.h"

@implementation UIColor (ZUtilities)

+ (instancetype)zColorWithHex:(uint32_t)hex
{
    uint8_t red = (hex & 0xff0000) >> 16;
    uint8_t green = (hex & 0x00ff00) >> 8;
    uint8_t blue = (hex & 0x0000ff);
    
    return [self zColorWithRed:red green:green blue:blue];
}

+ (instancetype)zRandomColor
{
    return [UIColor zColorWithRed:arc4random_uniform(256) green:arc4random_uniform(256) blue:arc4random_uniform(256)];
}

+ (instancetype)zColorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

@end
