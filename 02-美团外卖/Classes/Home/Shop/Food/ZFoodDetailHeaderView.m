//
//  ZFoodDetailHeaderView.m
//  02-美团外卖
//
//  Created by Zed Link on 15/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZFoodDetailHeaderView.h"
#import "ZShopFood.h"

@interface ZFoodDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation ZFoodDetailHeaderView

+ (instancetype)foodDetailHeaderView
{
    return  [[UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
}

#pragma mark - Getter & Setter

- (void)setFood:(ZShopFood *)food
{
    _food = food;
    
    _nameLabel.text = food.name;
    _scaleLabel.text = food.month_saled_content;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.02f", _food.min_price];
    _commentLabel.text = [NSString stringWithFormat:@"[%@] 真好吃, 价格才 %@!!!", _food.name, _priceLabel.text];
}

@end
