//
//  ZShopFoodCategoryCell.m
//  02-美团外卖
//
//  Created by Zed Link on 6/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodCategoryCell.h"

@implementation ZShopFoodCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 修改字体大小
        self.textLabel.font = [UIFont systemFontOfSize:13];
        
        // 设置多行文本为0, 只要空间足够就会继续显示
        // 设置为2, 如果文本超过2行, 则显示 ....
        self.textLabel.numberOfLines = 2;

        // -------- 设置选中样式 --------
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        // -------- 添加黄色视图 --------
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor zColorWithHex:0xFFD900];
        [bgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(4, 33));
        }];
        // 设置选中状态背景色
        self.selectedBackgroundView = bgView;
        
        // 设置默认状态背景色
        self.contentView.backgroundColor = [UIColor zColorWithHex:0xF8F8F8];
        
        // -------- 添加分割线 --------
        UIView *separatorLine = [[UIView alloc] init];
        separatorLine.backgroundColor = [UIColor zColorWithHex:0xf3f3f3];
        [self.contentView addSubview:separatorLine];
        
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            // 分割线占据1个点像素大小
            make.height.mas_equalTo(1 / [UIScreen zScreenScale]);
        }];
    }
    return self;
}

@end
