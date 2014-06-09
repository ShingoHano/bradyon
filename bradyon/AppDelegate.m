//
//  AppDelegate.m
//  bradyon
//
//  Created by 羽野 真悟 on 12/10/17.
//  Copyright (c) 2012年 羽野 真悟. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"

@implementation AppDelegate

UIViewController *viewController1;
UIViewController *viewController2;
UIViewController *viewController3;
UIViewController *viewController4;
UIViewController *viewController5;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"609400727"]; // Apple ID（アプリ毎の識別番号：iTunes Connectで参照可）
    [Appirater setDebug: NO]; // デバッグモードの設定。YESにするとアプリを起動するたびに表示される。(デフォルト:NO)
    [Appirater appLaunched:YES]; // Appiraterの起動
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    viewController3 = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];
    viewController4 = [[FourthViewController alloc] initWithNibName:@"FourthViewController" bundle:nil];
    viewController5 = [[FifthViewController alloc] initWithNibName:@"FifthViewController" bundle:nil];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2,viewController3,viewController4,viewController5];
    self.tabBarController.tabBar.backgroundImage=[UIImage imageNamed:@"blue_wall3"];

    //タブバーのフレームサイズの調整
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    tabFrame.size.height -= 10;
    tabFrame.origin.y+=10;
    self.tabBarController.tabBar.frame = tabFrame;
    
    //メイン画面のフレームサイズの調整
    UIView * contentView = [[[self.tabBarController.tabBar superview] subviews] objectAtIndex:0];
    contentView.frame = CGRectMake(0, 0, frame.size.width, self.window.frame.size.height-tabFrame.size.height);
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
