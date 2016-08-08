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

- (void)setValue:(id)value forKey:(NSString *)key
{
    // 如果属性名与JSON文件中的名字不匹配, 设置会失败
    if ([key isEqualToString:@"description"]) {
        // 通过判断处理, 让JSON数据与属性对应起来
        [super setValue:value forKey:@"desc"];
    } else {
        [super setValue:value forKey:key];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {name = %@, month_saled_content = %@, min_price = %@, praise_num = %@, picture = %@, desc = %@, orderCount = %zd}", NSStringFromClass(self.class), self, _name, _month_saled_content, @(_min_price), @(_praise_num), _picture, _desc, _orderCount];
}

@end
