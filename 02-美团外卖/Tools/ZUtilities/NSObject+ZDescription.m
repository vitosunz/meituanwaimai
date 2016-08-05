//
//  NSObject+ZDescription.m
//  02-美团外卖
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "NSObject+ZDescription.h"

@implementation NSObject (ZDescription)

@end

@implementation NSArray (ZDescription)

- (NSString *)descriptionWithLocale:(id)locale
{
    // 开始 (
    NSMutableString *tempStringM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 将每个元素换行排列输出, 并缩进
        [tempStringM appendFormat:@"\t%@, \n", obj];
    }];
    // 结束 )
    [tempStringM appendString:@")"];
    
    return tempStringM;
}

@end

@implementation NSDictionary (ZDescription)

- (NSString *)descriptionWithLocale:(id)locale
{
    // 开始 {
    NSMutableString *tempStringM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 将每个元素换行排列并缩进输出,
        [tempStringM appendFormat:@"\t%@ = %@, \n", key, obj];
    }];
    // 结束 }
    [tempStringM appendString:@"}"];
    
    return tempStringM;
}

@end