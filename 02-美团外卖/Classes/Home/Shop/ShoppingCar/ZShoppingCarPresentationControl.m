//
//  ZShoppingCarPresentationControl.m
//  02-美团外卖
//
//  Created by Zed Link on 12/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZShoppingCarPresentationControl.h"

@interface ZShoppingCarPresentationControl ()

/* 遮罩视图 */
@property (weak, nonatomic) UIView *maskView;

@end

@implementation ZShoppingCarPresentationControl


/**
 *  容器视图将要布局子视图, 等价于UIViewController中的viewDidLayoutSubviews
 *  自定义转场动画, 在此方法中布局子视图
 */
- (void)containerViewWillLayoutSubviews
{
    ZLog(@"%@, %@, %@", self.containerView, self.presentedViewController, self.presentedView);
    
    
    // -------- 布局目标视图 --------
    // 取出容器视图的大小
    CGRect rect = self.containerView.bounds;
    
    CGFloat height = 320;
    rect.origin.y = rect.size.height - height;
    rect.size.height = height;
    
    // 设置目标视图的位置
    self.presentedView.frame = rect;
    
    // -------- 布局遮罩视图 --------
    self.maskView.frame = self.containerView.bounds;
}

#pragma mark - 呈现阶段处理

/**
 *  即将开始呈现动画, 在该方法中添加自定义视图
 */
- (void)presentationTransitionWillBegin
{
    // 默认 do nothing, 可不Super
    
    // -------- 添加遮罩视图 --------
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.maskView = maskView;
    
    [self.containerView insertSubview:maskView atIndex:0];
    
    // -------- 添加点击手势 --------
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.maskView addGestureRecognizer:tapGesture];
}

/**
 *  呈现动画结束
 */
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    // 默认 do nothing, 可不Super
    
    // -------- 如果呈现过程失败, 则移除 --------
    if (completed == NO) {
        [self.containerView removeFromSuperview];
    }
}

#pragma mark - 消失阶段处理

/**
 *  即将开始消失动画, 在该方法中添加消失的动画相关视图
 */
- (void)dismissalTransitionWillBegin
{
    // 默认 do nothing, 可不Super
}

/**
 *  消失动画结束
 */
- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    // 默认 do nothing, 可不Super
    
    [self.containerView removeFromSuperview];
}

#pragma mark - 手势事件处理

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    // -------- 点击后让目标控制器消失 --------
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
