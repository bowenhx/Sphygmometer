//
//  SinaWeiBoSDK.h
//
//
//  Created by 陈 建乐 on 12-4-27.
//  Copyright (c) 2012年 jlteams. All rights reserved.
//

#import "SinaWeiBoSDK.h"
#import "AppDelegate.h"
#import "WBUtil.h"
#import "JSONKit.h"
#import "UIViewExtend.h"

@interface SinaWeiBoSDK ()
@property (nonatomic,assign) BOOL hasFile;
@end

@implementation SinaWeiBoSDK

@synthesize parentView;
@synthesize delegate = _delegate;
@synthesize hasFile = _hasFile;

#pragma mark - get方法
- (NSString *)access_token {
    if (expires_in < time(nil)) {
        access_token = nil;
    }
    return access_token;
}

- (NSString *)uid {
    if (expires_in < time(nil)) {
        uid = nil;
    }
    return uid;
}

#pragma mark - 储存到文件
- (void)readWeiboInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    time_t deadline = [userDefaults integerForKey:@"sweibo_expires_in"];
    if (deadline > time(nil)) {
        expires_in = deadline;
        access_token = [userDefaults stringForKey:@"sweibo_access_token"];
        uid = [userDefaults stringForKey:@"sweibo_uid"];
    }
}

- (void)writeWeiboInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:expires_in forKey:@"sweibo_expires_in"];
    [userDefaults setValue:[self access_token] forKey:@"sweibo_access_token"];
    [userDefaults setValue:[self uid] forKey:@"sweibo_uid"];
    [userDefaults synchronize];
}

- (void)clearWeiboInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:@"sweibo_expires_in"];
    [userDefaults setValue:nil forKey:@"sweibo_access_token"];
    [userDefaults setValue:nil forKey:@"sweibo_uid"];
}

#pragma mark - 初始化函数

- (id)init {
    if (self = [super init]) {
        webView = [[UIWebView alloc] init];
        [webView setDelegate:self];
        
        [self readWeiboInfo];
    }
    return self;
}


// 把URL字符串转换成字典
- (NSDictionary *)translate_url_to_dictionary:(NSString *)query_string {
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    NSArray *params = [query_string componentsSeparatedByString:@"&"];
    
    for (NSString *param in params) {
        NSArray *pair = [param componentsSeparatedByString:@"="];
        if ([pair count] == 2) {
            [info setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:info];
}

// 序列化参数
- (NSString *)serial_params:(NSDictionary *)params {
    NSMutableString *serial = [NSMutableString string];
    
    for (NSString *key in params) {
        [serial appendFormat:@"%@=%@&", [key URLEncodedString], [[params objectForKey:key] URLEncodedString]];
    }
    return [NSString stringWithString:[serial substringToIndex:[serial length] - 1]];
}

#pragma mark - 授权页面

- (BOOL)authorizeWithView:(UIView *)view {
//    if ([self access_token]) {
//        return YES;
//    }
    
//    if (view == nil || ![view isKindOfClass:[UIView class]]) {
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        
//        view = [[appDelegate viewController] view];
//        if (view == nil || ![view isKindOfClass:[UIView class]]) {
//            return NO;
//        }
//    }
    
    //清除cookies
    for (NSHTTPCookie *cache in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cache];
    }
    
    NSString *request_url = [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&redirect_uri=%@&display=default", SWEIBO_URL_AUTHORIZE, SWEIBO_APP_KEY, SWEIBO_URL_REDIRECT];
    
    [webView setFrame:[view bounds]];
    [view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request_url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
    
    return NO;
}

- (BOOL)authorize {
    return [self authorizeWithView:parentView];
}

#pragma mark - 方法调用

- (NSString *)requestWithMethod:(NSString *)method url:(NSString *)url params:(NSDictionary *)params {
//    if (![self authorize]) {
//        return nil;
//    }
    
    url = [NSString stringWithFormat:@"%@.%@?access_token=%@", url, SWEIBO_FORMAT, access_token];
    
    NSLog(@"%@",access_token);
    
    NSMutableDictionary *reusltParams = [NSMutableDictionary dictionary];
    
    for (NSString *key in params) {
        if ([key isEqualToString:@"pic"]) {
            _hasFile = YES;
            continue;
        } else {
            [reusltParams setValue:[params objectForKey:key] forKey:key];
        }
    }
    
    NSMutableDictionary *request_params = [NSMutableDictionary dictionaryWithDictionary:reusltParams];
    
    NSString *serial = [self serial_params:request_params];
    NSLog(@"%@", serial);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nil cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    method = [method uppercaseString];
    // 处理GET方法
    if ([method isEqualToString:@"GET"]) {
        NSURL *request_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&%@", url, serial]];
        [request setURL:request_url];
    } else if ([method isEqualToString:@"POST"]) {
        
        NSMutableData *httpBody = [NSMutableData data];
        [request setURL:[NSURL URLWithString:url]];
        
        if (_hasFile) {
            CFUUIDRef uuid = CFUUIDCreate(nil);
            NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
            CFRelease(uuid);
            NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
            NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary] forHTTPHeaderField: @"Content-Type"];
            
            for (NSString *key in request_params) {
                
                NSString *value = [request_params objectForKey:key];
                if ([value isKindOfClass:[NSString class]]) {
                    [httpBody appendData:boundaryBytes];
                    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
            }
            
            [httpBody appendData:boundaryBytes];
            
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"image.jpg\"\r\nContent-Type: \"image/jpeg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[params objectForKey:@"pic"]];
            
            
            [httpBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

        } else {            
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [httpBody appendData:[serial dataUsingEncoding:NSUTF8StringEncoding]];

        }
        [request setValue:[NSString stringWithFormat:@"%d", [httpBody length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:httpBody];
    }
        
    [request setHTTPMethod:method];
    NSData *respone = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *request_result = [[NSString alloc] initWithData:respone encoding:NSUTF8StringEncoding];
    NSLog(@"SWeibo : %@", request_result);
    
    return request_result;
}

#pragma mark - 微博API
// 发微博
- (NSString *)add:(NSString *)content {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            content, @"status", nil];
    
    return [self requestWithMethod:@"POST" url:SWEIBO_URL_ADD params:params];
}

// 带图片连接发微博
- (NSString *)add:(NSString *)content withPicUrl:(NSString *)pic_url {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            content, @"status",
                            pic_url, @"pic_url", nil];
    
    return [self requestWithMethod:@"POST" url:SWEIBO_URL_ADD_PIC_URL params:params];
}

//带图片微博
- (NSString *)add:(NSString *)content withPicData:(NSData *)data {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            content, @"status",
                            data, @"pic", nil];
    
    return [self requestWithMethod:@"POST" url:SWEIBO_URL_ADD_PIC params:params];
}

// 收听某(些)人
- (NSString *)addfriend:(NSString *)name {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"uid", nil];
    
    return [self requestWithMethod:@"POST" url:SWEIBO_URL_ADD_FRIEND params:params];
}

#pragma mark - UIWebViewDelegate 托管方法
- (BOOL)webView:(UIWebView *)_webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSString *fragment = [[request URL] fragment];
//
//    NSLog(@"%@",[[request URL] query]);
//
//    if (fragment) {
        NSString *host = [[request URL] host];
        if ([host isEqualToString:[[NSURL URLWithString:SWEIBO_URL_REDIRECT] host]]) {

            NSString *code = [[[request URL] query] substringFromIndex:5];

            NSString *access_token_url = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",SWEIBO_URL_ACCESS_TOKEN,SWEIBO_APP_KEY,SWEIBO_APP_SECRET,SWEIBO_URL_REDIRECT,code];


            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:access_token_url]];
            [request setHTTPMethod:@"POST"];

            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

            NSString *request_result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"SWeibo : %@", [request_result objectFromJSONString]);

            NSMutableDictionary *params = [request_result objectFromJSONString];

//            [self d];

//
//            [_webView loadRequest:request];

//            NSDictionary *params = [self translate_url_to_dictionary:fragment];
//
//            NSLog(@"%@", params);
//            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            
            expires_in = time(nil) + [[params objectForKey:@"remind_in"] intValue];
            uid = [params objectForKey:@"uid"];
            access_token = [params objectForKey:@"access_token"];

            [self writeWeiboInfo];
            [self readWeiboInfo];
            
            if ([_delegate respondsToSelector:@selector(SWeiboDidLogin)]) {
                [_delegate SWeiboDidLogin];
            }

            return NO;
        }
//    }



    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)_webView {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    if (HUDAuthrize) {
//        [HUDAuthrize hide:YES];
//        [HUDAuthrize release];
//    }
//    
//    HUDAuthrize = [[MBProgressHUD alloc] initWithView:_webView];
//    HUDAuthrize.delegate = self;
//    HUDAuthrize.labelText = @"请稍候...";
//    [_webView addSubview:HUDAuthrize];
//    
//    [HUDAuthrize show:YES];
    
    [_webView addHUDActivityView: @"请稍候..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [HUDAuthrize hide:YES];
    [_webView removeHUDActivityView];

    NSLog(@"%@",[_webView.request URL]);
}


@end
