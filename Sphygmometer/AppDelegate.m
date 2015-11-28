//
//  AppDelegate.m
//  Sphygmometer
//
//  Created by gugu on 14-5-12.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "AppDelegate.h"
#import "objc/runtime.h"
#import "HomeTabBarController.h"
#import "LoginViewController.h"
#import "DataVesselObj.h"
#import "BPush.h"
#import "PushNewsView.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
// 方法名, 用BPushRequestMethodKey取出的值

static AppDelegate *_appDelegate;
static char pushDataKey;

@implementation AppDelegate
{
    UIScrollView    *_scrollView ;
    UIPageControl   *_pageControl;
    
    BMKMapManager* _mapManager;
    
    BOOL            _firstOp;
}
+ (AppDelegate *)getAppDelegate
{
    return _appDelegate;
}
//
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    _appDelegate = self;
     application.applicationIconBadgeNumber = 0;

    //向微信注册
    if ([WXApi registerApp:@"wx497ff18db212c1bc"]) {
        LOG(@"微信注册成功");
    }else{
        LOG(@"微信注册失败");
    }
    
    //注册友盟
    [UMSocialData setAppKey:@"54acd652fd98c5f406000c9e"];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:kBaiduMapKey generalDelegate:self];
    if (!ret) {
        NSLog(@"map start failed!");
    }
    
    _firstOp = YES;
    
    LOG(@"userID = %@,userFile = %@",USERID,[SavaData parseDicFromFile:User_File]);
    LOG(@"userid = %@",[SavaData getUserId]);
    LOG(@"userInterget = %d",[[SavaData shareInstance] printDataInteger:USER_ID_SAVA]);
     NSLog(@"userINforid = %@",[SavaData getOutUserFile]);
    NSString *userName = [SavaData getOutUserFile];
    
    if (USERID == nil && userName.length == 0) {
        [self welcomePage];
    }else{
        [[SavaData shareInstance] savadataStr:userName KeyString:USER_ID_SAVA];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
         [HomeTabBarController showRootView];
    }
   
    //设置闹钟提醒
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        NSLog(@"Recieved Notification %@",localNotif);
//        NSDictionary* infoDic = localNotif.userInfo;
//        NSLog(@"userInfo description=%@",[infoDic description]);
//        NSString* codeStr = [infoDic objectForKey:@"Awok"];
    }
   
    //取消提醒
    NSArray *arrAwork = [SavaData parseArrFromFile:Awoke];
    if (arrAwork.count == 0) {
         [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    NSArray *arrCount = [[UIApplication sharedApplication] scheduledLocalNotifications];
    LOG(@"arrcount = %@",arrCount);
    //设置单位转化信息
    NSMutableDictionary *dicUnits = [NSMutableDictionary dictionaryWithDictionary:UNITS_TYPE_DATA];
    if (dicUnits.allKeys.count ==0) {
        [dicUnits setObject:@"0" forKey:@"weight"];
        [dicUnits setObject:@"0" forKey:@"height"];
        [dicUnits setObject:@"0" forKey:@"blood"];
        
        [SavaData writeDicToFile:dicUnits FileName:UnitsType];
    }
    

    
    [self.window makeKeyAndVisible];
    
    // 必须
    [BPush setupChannel:launchOptions];
    // 必须。参数对象必须实现(void)onMethod:(NSString*)method response:(NSDictionary*)data 方法,本示例中为 self
    [BPush setDelegate:self];
    
    [self registerPushNotice];
    
    
    NSDictionary *aDict = [launchOptions objectForKey:
                           UIApplicationLaunchOptionsRemoteNotificationKey];
    if (aDict != nil) {
        //判断从推送消息来启动应用程序
        objc_setAssociatedObject(self, &pushDataKey, aDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self performSelector:@selector(showPushView) withObject:nil afterDelay:.8f];
    }

    
    return YES;
}
- (void)showLoginVC{
    
    if (self.window.rootViewController.view != nil) {
        [self.window.rootViewController.view removeFromSuperview];
    }
    
    [self beginShowLoginView];
}
- (void)beginShowLoginView
{

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
//    loginVC.navigationController.navigationBar.hidden = YES;
}
- (void)registerPushNotice{
    
    //注册推送
    if(kIsISO8) {
      
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             
                                                                             categories:nil]];
         [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
    
    if ([self pushNotificationOpen]) {
         NSLog(@"推送已打开");
    }else{
        NSLog(@"推送未打卡");
    }
   
}

//判断推送是否打开

- (BOOL)pushNotificationOpen
{
    if (kIsISO8)
    {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        return (types & UIRemoteNotificationTypeAlert);
    }
    else{
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return (types & UIRemoteNotificationTypeAlert);
    }
}
- (void)welcomePage
{
    _scrollView= [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _scrollView.layer.borderWidth = 1;
    _scrollView.contentSize = CGSizeMake(320*3, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
//    _pageControl = [[UIPageControl alloc] init];
//    _pageControl.frame = CGRectMake(145, SCREEN_HEIGHT - 50, 30, 20);
//    _pageControl.numberOfPages = 3;
//    _pageControl.currentPage = 0;
//    
//    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
//    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    
    if (isiPhone5 == YES) {
        for (int i =0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
            imageView.userInteractionEnabled = YES;
            NSString *strImage = @"";
            if (IsEnglish) {
                strImage = [NSString stringWithFormat:@"en_icon_welcome_%d.png",i];
            }else{
                strImage = [NSString stringWithFormat:@"icon_welcome_%d.png",i];
            }
            imageView.image = [UIImage imageNamed:strImage];
            if (i==2) {
                [imageView addSubview:[self buttonAccessRootViewPage]];
            }

            [_scrollView addSubview:imageView];
        }
    }else{
        for (int i =0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
            imageView.userInteractionEnabled = YES;
            NSString *strImage = @"";
            if (IsEnglish) {
                strImage = [NSString stringWithFormat:@"en_icon_welcome_4s_%d.png",i];
            }else{
                strImage = [NSString stringWithFormat:@"icon_welcome_4s_%d.png",i];
            }
            imageView.image = [UIImage imageNamed:strImage];
            
            if (i==2) {
                [imageView addSubview:[self buttonAccessRootViewPage]];
            }
            
            [_scrollView addSubview:imageView];
            
        }
    }
    
//    self.window.layer.borderWidth = 1;
//    self.window.layer.borderColor = [UIColor greenColor].CGColor;
    [self.window addSubview:_scrollView];
//    [self.window addSubview:_pageControl];
}
- (UIButton *)buttonAccessRootViewPage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, SCREEN_HEIGHT-80, 220, 40);
    [button setImage:[UIImage imageNamed:IsEnglish ? @"en_unpressed": @"icon_unpressed"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:IsEnglish ? @"en_pressed": @"icon_pressed"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(accessRootViewAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)changePage:(id)sender
{
    int page = _pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(320 * page, 0)];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / 320;
    _pageControl.currentPage = page;

}
- (void)accessRootViewAction
{
    [self beginShowLoginView];
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface
   
}
- (void)showPushView
{
    NSDictionary *dicData = objc_getAssociatedObject(self, &pushDataKey);
    if (dicData) {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PushNewsView *pushView = [[PushNewsView alloc] initWithFrame:CGRectMake(0, 20, WIDTH(self.window), HEIGHT(self.window)-20)];
        [pushView loadData:dicData[@"aps"][@"alert"] webUrl:dicData[@"link"]];
        [self.window addSubview:pushView];
        //        });
        
        objc_setAssociatedObject(self, &pushDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    LOG(@"getUser = %@,userId = %@, channelID = %@",[BPush getAppId],[BPush getUserId],[BPush getChannelId]);

}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 
    // 必须
    [BPush registerDeviceToken:deviceToken];
//    [BPush setAccessToken:token];
    // 必须。可以在其它时机调用,只有在该方法返回(通过 onMethod:response:回调)绑定成功时,app 才能接收到 Push 消息。一个 app 绑定成功至少一次即可(如 果 access token 变更请重新绑定)。
    [BPush bindChannel];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    LOG(@"error = %@",error);
}
// 必须,如果正确调用了 setDelegate,在 bindChannel 之后,结果在这个回调中返回。 若绑定失败,请进行重新绑定,确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    objc_setAssociatedObject(self, &pushDataKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:IsEnglish ?@"Cigii Health Care": @"实捷健康"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:IsEnglish ? @"Hide" : @"隐藏"
                                                  otherButtonTitles:IsEnglish ? @"Show": @"显示",nil];
        [alertView show];
    }else {
        [self performSelector:@selector(showPushView) withObject:nil afterDelay:1.f];
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
    
   
    
    
//     = [self.viewController.textView.text stringByAppendingFormat:@"Receive notification:\n%@", [userInfo JSONString]];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"fication = %@",[notification alertAction]);
    NSLog(@"userINforo = %@",[notification userInfo]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IsEnglish ? @"Title": @"标题" message:notification.alertBody delegate:nil cancelButtonTitle:Verify otherButtonTitles:nil];
    [alert show];
    
    application.applicationIconBadgeNumber = 0;

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self showPushView];
    }
}
//- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//{
////    return UIInterfaceOrientationMaskPortrait;
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
@end
