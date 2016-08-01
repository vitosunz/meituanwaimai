//
//  ZBaseViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseViewController.h"

@interface ZBaseViewController ()

@end

@implementation ZBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self zSetupUI];
}

#pragma mark - 设置界面
- (void)zSetupUI
{
    // 0. 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
