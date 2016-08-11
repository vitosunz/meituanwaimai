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
/* 计数按钮 */
@property (weak, nonatomic) IBOutlet UIButton *countBtn;

@end

@implementation ZShoppingCarView

+ (instancetype)shoppingCarView
{
    return [[UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil] instantiateWithOwner:nil options:nil][0];
}

- (void)awakeFromNib
{
    // 给购物车数据设置初始值
    self.shoppingCarFoods = nil;
}

#pragma mark - 按钮响应事件

/**
 *  结账按钮 (跳转到结账页面)
 *  所有控制器之间的跳转都是由控制器负责的, 视图只负责显示和事件处理
 */
- (IBAction)accountAction:(UIButton *)sender
{
    /**
     *  如果协议方法是可选的, 需要判断代理是否实现了协议方法, 否则直接调用会崩溃
     */
    if ([self.delegate respondsToSelector:@selector(shoppingCarViewDidCheckAccount:)]) {
        [self.delegate shoppingCarViewDidCheckAccount:self];
    }
}

- (IBAction)shoppingCarAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(shoppingCarView:willDisplayShoppingCar:)]) {
        [self.delegate shoppingCarView:self willDisplayShoppingCar:self.shopCarBtn];
    }
}

#pragma mark - Getter & Setter

- (void)setShoppingCarFoods:(NSMutableArray<ZShopFood *> *)shoppingCarFoods
{
    _shoppingCarFoods = shoppingCarFoods;
    
    // 如果有菜品, 按钮显示黄色
    _shopCarBtn.selected = (shoppingCarFoods.count > 0);
    
    // -------- 计算总金额 --------
    CGFloat amount = 0;
    NSInteger count = 0;
    
    for (ZShopFood *food in _shoppingCarFoods) {
        // 单价 * 数量
        amount += food.min_price * food.orderCount;
        // 计算购买的菜品总数量
        count += food.orderCount;
    }
    
    // 购物车是空白时提示处理
    if (amount > 0) {
        _tipLabel.text = [NSString stringWithFormat:@"¥ %.02f", amount];
    } else {
        _tipLabel.text = @"购物车空空如也~";
    }
    
    // 根据商品数量决定是否显示计数按钮
    _countBtn.hidden = (count == 0);
    [_countBtn setTitle:@(count).description forState:UIControlStateNormal];
    
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
        
        _accountBtn.enabled = YES;
        [_accountBtn setBackgroundColor:[UIColor orangeColor]];
    }
    
    // -------- 购物车按钮动画--------
    // 初始状态, 缩小
    _shopCarBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    // 弹簧动画
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:0 animations:^{
        // 从缩小变回标准大小
        _shopCarBtn.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end




