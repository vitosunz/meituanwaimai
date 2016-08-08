//
//  ZShoppingCarView.m
//  02-美团外卖
//
//  Created by Zed Link on 8/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShoppingCarView.h"
#import "ZShopFood.h"

@interface ZShoppingCarView ()

/* 账单按钮 */
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
/* 提示标签 */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
/* 购物车按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shopCarBtn;

@end

@implementation ZShoppingCarView

+ (instancetype)shoppingCarView
{
    return [[UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil] instantiateWithOwner:nil options:nil][0];
}

#pragma mark - Getter & Setter

- (void)setShoppingCarFoods:(NSMutableArray<ZShopFood *> *)shoppingCarFoods
{
    _shoppingCarFoods = shoppingCarFoods;
    
    // 如果有菜品, 按钮显示黄色
    _shopCarBtn.selected = (shoppingCarFoods.count > 0);
    
    // -------- 计算总金额 --------
    CGFloat amount = 0;
    for (ZShopFood *food in _shoppingCarFoods) {
        // 单价 * 数量
        amount += food.min_price * food.orderCount;
    }
    
    // 购物车是空白时提示处理
    if (amount > 0) {
        _tipLabel.text = [NSString stringWithFormat:@"¥ %.02f", amount];
    } else {
        _tipLabel.text = @"购物车空空如也~";
    }
    
    // -------- 结账按钮 --------
    // 最小起送金额
    CGFloat minAmount = 20;
    
    if (amount < minAmount) {
        // 还没有达到最小起送金额
        NSString *content = [NSString stringWithFormat:@"还差 ¥ %.02f", minAmount - amount];
        [_accountBtn setTitle:content forState:UIControlStateNormal];
        
        _accountBtn.enabled = NO;
        [_accountBtn setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [_accountBtn setTitle:@"去结账" forState:UIControlStateNormal];
        [_accountBtn setBackgroundColor:[UIColor orangeColor]];
    }
}

@end




