//
//  ZShopFoodListCell.m
//  02-美团外卖
//
//  Created by Zed Link on 7/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodListCell.h"
#import "ZShopFood.h"

@interface ZShopFoodListCell ()

@property (weak, nonatomic) UIImageView *iconView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *saleLabel;
@property (weak, nonatomic) UILabel *likeLabel;
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *descLabel;

@end

@implementation ZShopFoodListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zSetupUI];
    }
    return self;
}

#pragma mark - 界面初始化

- (void)zSetupUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // -------- 图像视图 --------
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 设置圆角
    iconView.layer.cornerRadius = 4;
    iconView.layer.masksToBounds = YES;
    
    // 约束
    CGFloat margin = 10;
    CGSize iconSize = CGSizeMake(50, 50);
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(margin);
        make.size.mas_equalTo(iconSize);
    }];
    
    // -------- 标题标签 --------
    UILabel *titleLabel = [UILabel zLabelWithText:@"班主任做的饭" textColor:[UIColor zColorWithHex:0x7e7e7e] fontSize:13];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 约束
    CGFloat lineMargin = 3;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(lineMargin);
    }];
    
    // -------- 销售数量 --------
    UILabel *saleLabel = [UILabel zLabelWithText:@"月售666" textColor:[UIColor zColorWithHex:0x7e7e7e] fontSize:11];
    [self.contentView addSubview:saleLabel];
    self.saleLabel = saleLabel;
    
    [saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(lineMargin);
    }];
    
    // -------- 点赞图像 --------
    UIImage *image = [UIImage imageNamed:@"icon_food_review_praise"];
    // imageView的会根据图片内容得到对应的size
    UIImageView *likeView = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:likeView];
    
    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(saleLabel.mas_right).offset(margin);
        make.centerY.equalTo(saleLabel);
    }];
    
    // -------- 价格 --------
    UILabel *priceLabel = [UILabel zLabelWithText:@"2" textColor:[UIColor zColorWithHex:0xfa2a09] fontSize:15];
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(saleLabel);
        make.top.equalTo(saleLabel.mas_bottom).offset(lineMargin);
    }];
    
    // -------- 描述 --------
    UILabel *descLabel = [UILabel zLabelWithText:@"吃了就会爱上班主任" textColor:[UIColor zColorWithHex:0x7e7e7e] fontSize:11];
    descLabel.numberOfLines = 0;
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView);
        make.top.equalTo(iconView.mas_bottom).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-margin);
    }];
}

#pragma mark - Getter & Setter

- (void)setFood:(ZShopFood *)food
{
    _food = food;
    
    // 将模型数据更新到UI界面上
    _titleLabel.text = food.name;
    _saleLabel.text = food.month_saled_content;
    _likeLabel.text = @(food.praise_num).description;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.02f", food.min_price];
    _descLabel.text = food.desc;
    ZLog(@"%@", food.desc);
}

@end





