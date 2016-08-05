//
//  ZShopFood.m
//  03-JSON体验
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFood.h"

@implementation ZShopFood

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // 如果未定义的key, 则忽略
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {name = %@, month_saled_content = %@, min_price = %@, praise_num = %@, picture = %@, desc = %@}", NSStringFromClass(self.class), self, _name, _month_saled_content, @(_min_price), @(_praise_num), _picture, _desc];
}

@end
