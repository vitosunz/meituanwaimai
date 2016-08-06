//
//  UILabel+ZUtilities.m
//  02-美团外卖
//
//  Created by Zed Link on 6/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "UILabel+ZUtilities.h"

@implementation UILabel (ZUtilities)

+ (instancetype)zLabelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] init];
    
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.text = text;
    
    return label;
}

@end
