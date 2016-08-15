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

#define HeaderHeight 200

static NSString *FoodDetailReuseID = @"FoodDetailReuseID";

@interface ZShopFoodDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"CellReuseID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }

    // -------- 配置Cell --------
    cell.textLabel.text = @(indexPath.row).description;
    
    return cell;
}


@end
