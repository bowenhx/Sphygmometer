//
//  AppDelegate.h
//  Sphygmometer
//
//  Created by gugu on 14-5-12.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "BMapKit.h"
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,BMKGeneralDelegate,WXApiDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)getAppDelegate;
- (void)showLoginVC;
@end
