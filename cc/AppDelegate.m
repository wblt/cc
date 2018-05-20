//
//  AppDelegate.m
//  cc
//
//  Created by yanghuan on 2018/4/11.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "BaseNavViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Bugly/Bugly.h>
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "LoginVC.h"
#import "WelcomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
	self.window.backgroundColor = [UIColor clearColor];
	[self.window makeKeyAndVisible];
	[self test];
	// 初始化本地话文件目录
	IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
	keyboardManager.enable = YES; // 控制整个功能是否启用
	keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
	keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
	[SVProgressHUD setMaximumDismissTimeInterval:2.0];
	[Bugly startWithAppId:@"10dcef5d13"];
	
	//还未去 蒲公英注册appid
	//启动基本SDK
	//[[PgyManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"];
	//启动更新检查SDK
	//[[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"];
    
    WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    self.window.rootViewController = vc;
	// 进入主控制器，需要判断是否登录
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)test {
	NSString *str = @"13917114404";
	DLog(@"原始------%@",str);
	DLog(@"MD5------%@",str.MD5Hash.lowercaseString);
	
	DLog(@"加密------%@",str.convertMD5);
	DLog(@"解密------%@",str.convertMD5.decodeMD5);
}

@end
