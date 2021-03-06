//
//  ZShopFoodListCell.m
//  02-美团外卖
//
//  Created by Zed Link on 7/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodListCell.h"
#import "ZShopFood.h"
#import "UIImageView+WebCache.h"
#import "ZShopOrderControl.h"

NSString *const ZShopFoodDidIncreaseNotification = @"ZShopFoodDidIncreaseNotification"; // 菜品订购增加
NSString *const ZShopFoodDidDecreaseNotification = @"ZShopFoodDidDecreaseNotification"; // 菜品订购删除
NSString *const ZShopFoodIncreaseCenterKey = @"ZShopFoodIncreaseCenterKey"; // 加号按钮中心点

@interface ZShopFoodListCell ()

@property (weak, nonatomic) UIImageView *iconView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *saleLabel;
@property (weak, nonatomic) UILabel *likeLabel;
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *descLabel;
/* 订单操作控件 */
@property (weak, nonatomic) ZShopOrderControl *orderControl;

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
    // 取消选中样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // -------- 图像视图 --------
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 设置圆角
    iconView.layer.cornerRadius = 4;
    iconView.layer.masksToBounds = YES;
    // 设置图片拉伸模式
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    
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
    
    // -------- 添加操作控件 --------
    ZShopOrderControl *actionControl = [ZShopOrderControl shopOrderControl];
    [self.contentView addSubview:actionControl];
    self.orderControl = actionControl;
    
    [actionControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconView);
        make.right.equalTo(self.contentView).offset(-margin);
        
        // Xib控件的添加自动布局时, 注意要设置size. 否则自动布局很可能改变其size, 导致显示效果不佳
        // 通过Xib实例化的控件, 其size就是Xib中定义的
        make.size.mas_equalTo(actionControl.bounds.size);
    }];
    
    // 添加操作控件的事件监听
    [actionControl addTarget:self action:@selector(actionControlValueChange:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - 响应事件

- (void)actionControlValueChange:(ZShopOrderControl *)actionControl
{
    ZLog(@"%@ _ %zd", _food.name, actionControl.count);
    
    // -------- 模型数据处理 --------
    // 更新模型中菜品数量
    _food.orderCount = actionControl.count;
    
    // -------- 动画处理 --------
    // 如果是数据增加, 有动画
    if (actionControl.isIncrease) {
        // -------- 获取加号按钮的坐标, 为动画做准备 --------
        // 获取点击的加号按钮
        UIButton *btn = actionControl.increaseBtn;
        
        // 整个动画过程会跨越很多控件, 由控制器来完成.
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        // 转换加号按钮中心点的坐标
        CGPoint pointInWindow = [actionControl convertPoint:btn.center toView:keyWindow];
        
        // -------- 利用通知, 发送坐标点 --------
        NSDictionary *dict = @{
                              ZShopFoodIncreaseCenterKey : [NSValue valueWithCGPoint:pointInWindow],
                              };
        
        // 发出通知, 将 数据模型 和 坐标点信息传递出去
        [[NSNotificationCenter defaultCenter] postNotificationName:ZShopFoodDidIncreaseNotification object:self.food userInfo:dict];
        
        // 测试坐标点位置
//        UIButton *bDemo = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        bDemo.center = pointInWindow;
//
//        [keyWindow addSubview:bDemo];
    } else {
        // 如果是数据减少, 没有动画
        [[NSNotificationCenter defaultCenter] postNotificationName:ZShopFoodDidDecreaseNotification object:_food userInfo:nil];
    }
    
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
    
    // -------- 加载网络图片并显示出来 --------
    ZLog(@"%@", food.picture);
    // 删除文件扩展名
    NSString *urlString = [food.picture stringByDeletingPathExtension];
    // 创建字符串对应的URL
    NSURL *url  = [NSURL URLWithString:urlString];
    // 使用SDWebImage框架设置URL图像
    [self.iconView sd_setImageWithURL:url];
    
    // -------- 判断是否有描述, 根据描述重新标记约束 --------
    CGFloat margin = 10;
    if (food.desc.length > 0) {
        // 有描述, contentView参照描述标签的底部
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(_descLabel.mas_bottom).offset(margin);
        }];
    } else {
        // 无描述, contentView参照价格标签的底部
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(_priceLabel.mas_bottom).offset(margin);
        }];
    }
}

@end





