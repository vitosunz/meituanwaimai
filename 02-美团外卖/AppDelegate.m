//
//  AppDelegate.m
//  02-美团外卖
//
//  Created by Zed Link on 1/8/2016.
//  Copyright © 2016 itHeima. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // -------- 通过代码加载启动界面 --------
    self.window = [[UIWindow alloc] init];
    
    Class shopClass = NSClassFromString(@"ZShopViewController");
    UIViewController *shopVC = [[shopClass alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopVC];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
