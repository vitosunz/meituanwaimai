//
//  UIScreen+ZUtilities.m
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "UIScreen+ZUtilities.h"

@implementation UIScreen (ZUtilities)

+ (CGFloat)zScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)zScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)zScreenScale
{
    return [UIScreen mainScreen].scale;
}

@end
