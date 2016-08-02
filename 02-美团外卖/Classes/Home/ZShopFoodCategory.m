//
//  ZShopFoodCategory.m
//  03-JSON体验
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodCategory.h"
#import "ZShopFood.h"

@implementation ZShopFoodCategory

/**
 * setValuesForKeysWithDictionary方法会根据字典中的 key顺序调用 setValue:forKey:方法
 */
- (void)setValue:(id)value forKey:(NSString *)key
{
//    NSLog(@"forKey: %@" , key);
    
    //  如果 key对应的属性，在模型中不存在，在字典转模型的时候，会自动调用 setValue:forUndefinedKey:方法
//    [super setValue:value forKey:key];
    
    /**
     如果value是数组或字典类型, 并不会动态的创建数组或字典对应的模型数据再赋值 而是直接将字典或数组赋值给属性
     如果要处理JSON数据模型的嵌套赋值, 需要在该方法中做处理
     */
    
    // 如果key是 "spus", 说明value是保存了商家菜品数据的数组
    if ([key isEqualToString:@"spus"]) {
        NSArray *dataArray = value;
        
        NSMutableArray *tempArrayM = [NSMutableArray array];
        for (NSDictionary *dict in dataArray) {
            // 创建对应的数据模型
            ZShopFood *food = [[ZShopFood alloc] init];
            
            // 将数据赋值给模型
            [food setValuesForKeysWithDictionary:dict];
            
            [tempArrayM addObject:food];
        }
        // 将处理后的模型数组赋值给属性
        _spus = [tempArrayM copy];
        
        // 不需要再执行super了
        return;
    }
    
    [super setValue:value forKey:key];
}

/**
 *  如果出现未定义的key, 默认会抛出异常, 程序崩溃!
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // UndefinedKey 未定义的 Key
//    NSLog(@"forUndefinedKey :  %@", key);
    
    // 不super，不执行父类的默认方法
    // 在遇到未定义的key时什么都不做
//    [super setValue:value forUndefinedKey:key];
}

- (NSString *)description
{
    // 在模型的开发中, 使用调试, 经常会重写该方法来输出需要的信息
    return [NSString stringWithFormat:@"<%@: %p> {name = %@, spus = %@}", NSStringFromClass(self.class), self, _name, _spus];
}

@end
