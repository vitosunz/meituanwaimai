//
//  ViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLaunchImage];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [SVProgressHUD showSuccessWithStatus:@"Hello world"];
}

/**
 *  LaunchScreen中配置启动图片的布局设置时, 约束为 left | right | bottom | height (与父视图相等) 
 *  否则会有布局错误的提示!
 */
- (void)showLaunchImage
{
    // --------  将 LaunchScreen.storyboard中的视图获取出来, 并且放大显示 --------
    // 获取Storyboard文件
    UIStoryboard *launchScreen = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    // 加载LaunchScreen的初始化视图控制器
    UIViewController *initVC = [launchScreen instantiateInitialViewController];
    // 获取根视图 (LaunchImage所在的视图)
    UIView *launchImageView = initVC.view;
    
    [self.view addSubview:launchImageView];
    
    // 放大的动画效果
    [UIView animateWithDuration:1.0 animations:^{
        launchImageView.transform = CGAffineTransformMakeScale(3.0, 3.0);
        launchImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [launchImageView removeFromSuperview];
    }];
}

@end
