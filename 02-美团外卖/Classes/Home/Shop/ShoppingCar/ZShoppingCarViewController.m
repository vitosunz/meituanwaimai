//
//  ZShoppingCarViewController.m
//  02-美团外卖
//
//  Created by Zed Link on 12/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShoppingCarViewController.h"
#import "ZShoppingCarPresentationControl.h"

@interface ZShoppingCarViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation ZShoppingCarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // 设置呈现方式为自定义
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        // 设置过渡动画代理
        self.transitioningDelegate = self;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate

/**
 *  返回过渡动画执行对象
 */
 - (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    ZShoppingCarPresentationControl *presentationController = [[ZShoppingCarPresentationControl alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
    return presentationController;
}

@end
