//
//  ZBaseView.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "ZBaseView.h"

@implementation ZBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zSetupUI];
    }
    return self;
}

#pragma mark - 设置界面
- (void)zSetupUI {
    
}

@end
