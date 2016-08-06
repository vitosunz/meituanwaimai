//
//  ZBaseControl.m
//
//  Created by Zed Link on 2/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseControl.h"

@implementation ZBaseControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self zSetupUI];
    }
    return self;
}

#pragma mark - 设置界面

- (void)zSetupUI
{
    self.backgroundColor = [UIColor whiteColor];
}

@end
