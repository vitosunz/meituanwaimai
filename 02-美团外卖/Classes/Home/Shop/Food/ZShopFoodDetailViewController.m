//
//  ZShopFoodDetailViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 13/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShopFoodDetailViewController.h"
#import "ZShopFood.h"
#import "UIImageView+WebCache.h"
#import "ZFoodDetailHeaderView.h"

#define HeaderHeight 200

static NSString *FoodDetailReuseID = @"FoodDetailReuseID";

@interface ZShopFoodDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/* 图像视图高度的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstant;

@end

@implementation ZShopFoodDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // -------- TableView初始化 --------
    _tableView.backgroundColor = [UIColor clearColor];
    
    // 设置内容的偏移
    _tableView.contentInset = UIEdgeInsetsMake(HeaderHeight, 0, 0, 0);
    // 设置滚动指示器的偏移
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(HeaderHeight, 0, 0, 0);
    
    // 注册重用Cell
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FoodDetailReuseID];
    
    // -------- 加载菜品图片 --------
    NSString *urlString = [_food.picture stringByDeletingPathExtension];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 加载URL图片到imageView上
    [_imageView sd_setImageWithURL:url];
    
    // -------- 设置TableView的表头视图 --------
    ZFoodDetailHeaderView *headerView = [ZFoodDetailHeaderView foodDetailHeaderView];
    _tableView.tableHeaderView =headerView;
    
    // 配置数据模型
    headerView.food = self.food;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FoodDetailReuseID];

    // -------- 配置Cell --------
    cell.textLabel.text = @(indexPath.row).description;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 实际拖拽产生的偏移量计算
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    
    // offset > 0 向上移动, 反之向下
    ZLog(@"offset %f", offset);
    
    // 根据拖拽偏移, 来修改图片的高度
    CGFloat height = HeaderHeight - offset;
    if (height <= 0) {
        // 向上拖拽时, 不修改
        return;
    }
    
    // 向下拖拽, 修改高度约束
    _imageHeightConstant.constant = height;
    
    // 注意:  Masonry的约束不能和IB中的约束混用!
//    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
}

@end
