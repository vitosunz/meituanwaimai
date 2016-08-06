//
//  ZShopCategoryView.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopCategoryView.h"

@interface ZShopCategoryView ()

/**
 *  线条视图
 */
@property (weak, nonatomic) UIView *lineView;

/**
 *  点菜按钮
 */
@property (weak, nonatomic) UIButton *foodButton;

@property (strong, nonatomic) NSArray <UIButton *> *buttons;

@end

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
    
    // -------- 添加按钮约束 --------
    // 三个按钮大小相等, 左右互相约束
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
    
    // ------- 添加线条视图 --------
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor zColorWithHex:0xffd900];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    // 约束在第一个按钮位置下
    UIButton *firstBtn = buttons.firstObject;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(firstBtn);
        make.height.mas_equalTo(4);
    }];
    
    // -------- 添加按钮点击事件 --------
    NSUInteger index = 0;
    for (UIButton *btn in buttons) {
        // 添加响应事件
        [btn addTarget:self action:@selector(categoryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        // 先赋值, 再自增
        btn.tag = index++;
    }
    
    self.foodButton = buttons[0];
    self.buttons = [buttons copy];
    
    // 默认第一个按钮选中
    self.foodButton.selected = YES;
    _selectedIndex = 0;
}

#pragma mark - 按钮响应事件

- (void)categoryButtonAction:(UIButton *)sender
{
    // -------- 按钮选中状态修改 --------
    if (sender.tag == self.selectedIndex) {
        return;
    }
    // 选中按钮后, 按钮的状态更新, 非常常见
    self.buttons[self.selectedIndex].selected = NO;
    self.selectedIndex = sender.tag;
    self.buttons[self.selectedIndex].selected = YES;
    
    // -------- 根据选中按钮的tag值来修改线条视图 --------
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        // 根据按钮的位置调整线条视图的x值
        make.centerX.equalTo(self.foodButton).offset(sender.tag * sender.bounds.size.width);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        // 重新布局子视图
        [self layoutIfNeeded];
    }];
    
    // -------- 选中标签按钮后, 触发对应的事件 --------
    
    // 记录选中索引
    _selectedIndex = sender.tag;
    
    // 触发事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Getter & Setter

- (void)setLineOffsetX:(CGFloat)lineOffsetX
{
    _lineOffsetX = lineOffsetX;
    
    // 根据偏移量调整线的位置
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.foodButton).offset(_lineOffsetX);
    }];
    
    // -------- 更新按钮的选中状态 --------
    // 线的偏移量 / 按钮宽度
    CGFloat temp = (lineOffsetX / self.foodButton.bounds.size.width);
    NSUInteger index = temp;
    NSLog(@"%f, %zd", temp, index);
    
    if (self.selectedIndex != index) {
        // -------- 更新按钮状态 --------
        self.buttons[self.selectedIndex].selected = NO;
        self.selectedIndex = index;
        self.buttons[self.selectedIndex].selected = YES;
    }
}

@end
