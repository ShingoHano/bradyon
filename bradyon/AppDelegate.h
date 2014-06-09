//
//  AppDelegate.h
//  bradyon
//
//  Created by 羽野 真悟 on 12/10/17.
//  Copyright (c) 2012年 羽野 真悟. All rights reserved.
//

#import <UIKit/UIKit.h>
//NSInteger lock;                 // lockフラグ
//NSString *passString;           // パスワード文字列

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
