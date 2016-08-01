//
//  ZShopCategoryView.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopCategoryView.h"

@implementation ZShopCategoryView

#pragma mark - 界面初始化

- (void)zSetupUI
{
    [super zSetupUI];
    
    // -------- 添加按钮 --------
    UIColor *normalColor = [UIColor zColorWithHex:0x555555];
    UIColor *selectedColor = [UIColor zColorWithHex:0x000000];
    NSArray *buttonNames = @[@"点菜", @"评价", @"商家"];
    
    NSMutableArray <UIButton *> *buttons = [NSMutableArray array];
    for (NSString *name in buttonNames) {
        UIButton *btn = [UIButton zTextButtonWithTitle:name fontSize:14 textColor:normalColor selectedTextColor:selectedColor];
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        
        [buttons addObject:btn];
    }
    
    // 添加按钮约束, 三个按钮大小相等, 左右互相约束
    [buttons[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
    }];
    [buttons[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttons[0].mas_right);
        make.size.top.equalTo(buttons[0]);
    }];
    [buttons[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttons[1].mas_right);
        make.size.top.equalTo(buttons[1]);
        make.right.equalTo(self);
    }];
}

@end
