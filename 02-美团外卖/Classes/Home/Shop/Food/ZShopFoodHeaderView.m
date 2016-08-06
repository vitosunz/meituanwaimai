//
//  ZShopFoodHeaderView.m
//  02-美团外卖
//
//  Created by Zed Link on 6/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodHeaderView.h"

@implementation ZShopFoodHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor zColorWithHex:0xf8f8f8];
    }
    return self;
}

#pragma mark - Getter & Setter

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        // 添加Label控件
        UILabel *titleLabel = [UILabel zLabelWithText:@"" textColor:[UIColor redColor] fontSize:12];
        
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

@end
