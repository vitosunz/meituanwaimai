//
//  ZShopOrderControl.m
//  02-美团外卖
//
//  Created by Zed Link on 8/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopOrderControl.h"

/**
 *  UIControl继承自UIView, 与Xib的绑定和UIView类似
    * 不需要操作File's owner
    * 将Xib中的视图类绑定类型
 */

@interface ZShopOrderControl ()

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *decreaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *increaseBtn;

@end

@implementation ZShopOrderControl

+ (instancetype)shopOrderControl
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
    
    return [nib instantiateWithOwner:nil options:nil].lastObject;
}

/**
 *  Xib解档后, 视图加载完成了之后触发, 使用Xib开发时的代码入口
 */
- (void)awakeFromNib
{
    self.count = 0;
}

#pragma mark - Getter & Setter

- (void)setCount:(NSInteger)count
{
    _count = count;
    
    // 判断数量
    if (_count > 0) {
        _countLabel.text = @(count).description;
    }
    
    // 订购数量小于1时隐藏控件
    _countLabel.hidden = (_count <= 0);
    _decreaseBtn.hidden = (_count <= 0);
}

#pragma mark - 按钮响应事件

- (IBAction)increaseBtnAction:(id)sender
{
    self.count++;
    self.isIncrease = YES;
    
    // 发送 valuechange 事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (IBAction)decreaseBtnAction:(id)sender
{
    self.count--;
    self.isIncrease = NO;
    
    // 发送 valuechange 事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
