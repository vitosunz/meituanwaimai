//
//  ZShopFoodViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodViewController.h"
#import "ZShopFoodCategory.h"

@implementation ZShopFoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加载数据
    [self loadData];
}

#pragma mark - 数据加载

- (void)loadData
{
    // -------- 加载JSON数据 --------
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"food.json" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // 反序列化
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    // -------- 获取菜品类型对应的数据 --------
    NSArray *foodcategorys = resultDict[@"data"][@"food_spu_tags"];
    
    // 保存数据到磁盘, 实现工作中做数据测试的重要手段
//    [resultDict writeToFile:@"/Users/ZED/Desktop/food.plist" atomically:YES];
    
    // 将字典数据转换成模型
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (NSDictionary *dict in foodcategorys) {
        // 建立模型
        ZShopFoodCategory *foodcategory = [[ZShopFoodCategory alloc] init];
        // 字典转模型
        [foodcategory setValuesForKeysWithDictionary:dict];
        
        [tempArrM addObject:foodcategory];
    }
    
    NSLog(@"%@", tempArrM);
}

@end
