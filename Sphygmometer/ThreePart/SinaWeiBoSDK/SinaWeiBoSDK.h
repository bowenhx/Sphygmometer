//
//  SinaWeiBoSDK.h
//  
//
//  Created by 陈 建乐 on 12-4-27.
//  Copyright (c) 2012年 jlteams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define SWEIBO_VERSION @"2.a"
#define SWEIBO_FORMAT @"json"

//血压计key
#define SWEIBO_APP_KEY @"528515613"
#define SWEIBO_APP_SECRET @"9e8856291243e73360a31b7d5c3a5750"

//南方基金key
//#define SWEIBO_APP_KEY @"2243611312"
//#define SWEIBO_APP_SECRET @"e816d70670acfc6cd27009cf83363cec"

#define SWEIBO_URL_AUTHORIZE @"https://api.weibo.com/oauth2/authorize"
#define SWEIBO_URL_ACCESS_TOKEN @"https://api.weibo.com/oauth2/access_token"
#define SWEIBO_URL_REDIRECT @"http://www.sina.com"

#define SWEIBO_URL_ADD @"https://api.weibo.com/2/statuses/update"
#define SWEIBO_URL_ADD_PIC_URL @"https://api.weibo.com/2/statuses/upload_url_text"
#define SWEIBO_URL_ADD_FRIEND @"https://api.weibo.com/2/friendships/create"
#define SWEIBO_URL_ADD_PIC @"https://upload.api.weibo.com/2/statuses/upload"

@protocol SWeiBoSDKDelegate;

@interface SinaWeiBoSDK : NSObject<UIWebViewDelegate,MBProgressHUDDelegate> {
    UIView *parentView;
    UIWebView *webView;
    
    time_t expires_in;
    NSString *uid;
    NSString *access_token;
    
    MBProgressHUD *HUDAuthrize;
//    id<SWeiBoSDKDelegate> _delegate;
}

@property (nonatomic, retain) UIView *parentView;
@property (nonatomic, assign) id<SWeiBoSDKDelegate> delegate;

- (BOOL)authorize;
- (BOOL)authorizeWithView:(UIView *)view;

- (NSString *)add:(NSString *)content;
- (NSString *)add:(NSString *)content withPicUrl:(NSString *)pic_url;
- (NSString *)add:(NSString *)content withPicData:(NSData *)data;
- (NSString *)addfriend:(NSString *)name;

- (void)clearWeiboInfo;

@end

@protocol SWeiBoSDKDelegate <NSObject>

@optional
- (void)SWeiboDidLogin;

@end
