//
//  ShareViewController.m
//  SouthernFund
//
//  Created by jianle chen on 13-12-5.
//  Copyright (c) 2013年 深圳市呱呱网络科技有限公司. All rights reserved.
//

#import "ShareViewController.h"
#import "Common.h"
#import "JSONKit.h"
#import "UIViewExtend.h"

@interface ShareViewController ()
@property (nonatomic,retain) SinaWeiBoSDK *sinaWeiBoSDK;
@end

@implementation ShareViewController
@synthesize isTencent = _isTencent;
@synthesize sinaWeiBoSDK = _sinaWeiBoSDK;
@synthesize shareContent = _shareContent;
@synthesize shareImage = _shareImage;


- (void)loadView {
    [super loadView];
    
    self.navTitleLable.text = IsEnglish ? @"Share at Sina Weibo": @"分享到新浪微博";
    
    if (_isTencent ) {
       
    } else if (!_isTencent) {
        _sinaWeiBoSDK = [[SinaWeiBoSDK alloc] init];
        _sinaWeiBoSDK.delegate = self;
        
        if (![Common isLoginSinaWeibo]) {
            UIView *weiBoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
            weiBoView.backgroundColor = [UIColor whiteColor];
            weiBoView.tag = 300;
            [self.view addSubview:weiBoView];
            
            [_sinaWeiBoSDK authorizeWithView:weiBoView];
        } else {
            [self initView];

        }
        
    }

    
    
    self.view.backgroundColor = [UIColor whiteColor];
    

}

- (void)initView {
    
    self.rightbtn.hidden = NO;
    [self.rightbtn setTitleColor:[Common getColor:@"4cb9c1"] forState:UIControlStateNormal];
    [self.rightbtn setTitle:IsEnglish ? @"Send": @"发送" forState:UIControlStateNormal];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH(self.view) - 301.0f) / 2.0f, 20.0f, 301.0f, 200.0f)];
    if (kIsIOS5) {
        [bgView setImage:[[UIImage imageNamed:@"shurukuangbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f)]];
    } else {
        [bgView setImage:[[UIImage imageNamed:@"shurukuangbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f) resizingMode:UIImageResizingModeStretch]];
    }
    
    bgView.userInteractionEnabled = YES;
    
    
    //分享内容
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 15.0f, 160.0f, 170.0f)];
    textView.text = _shareContent;
    textView.tag = 400;
    textView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:textView];

    
    //分享图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X(textView) + WIDTH(textView), Y(textView), 100.0f, 170.0f)];
    imageView.image = _shareImage;
    imageView.tag = 401;
    [bgView addSubview:imageView];

    
    [self.view addSubview:bgView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark 点击左按钮
- (void) tapBackBtn{
    [self dismissViewControllerAnimated: YES completion: nil];
    
}

#pragma mark 发送微博
- (void)tapRightBtn {
    
    

        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addHUDActivityView:IsEnglish ?@"Send...": @"发送中..."];
            
            
        });
        
        UITextView *textView = (UITextView *)[self.view viewWithTag:400];
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:401];
        if (imageView.image != nil) {
            [self shareWeiBo:textView.text withPicData:imageView.image];
        }else{
            [self shareWeiBo:textView.text];
        }
        
        //    [self shareWeiBo:textView.text];
        
    });

    

}

- (void)shareWeiBo:(NSString *)content {
    
    NSString *result = nil;
    
    if (_isTencent) {

    } else if (!_isTencent) {
        result = [_sinaWeiBoSDK add:content];
    }
    [self resolveShareWeiBoFinishInfo:result];
    
}
- (void)shareWeiBo:(NSString *)content withPicUrl:(NSString *)pic_url {
    NSString *result = nil;
    if (_isTencent) {

    } else if (!_isTencent) {
        result = [_sinaWeiBoSDK add:content withPicUrl:pic_url];
    }
    [self resolveShareWeiBoFinishInfo:result];
    
}
- (void)shareWeiBo:(NSString *)content withPicData:(UIImage *)image {
    NSString *result = nil;
    if (_isTencent) {

    } else if (!_isTencent) {
        result = [_sinaWeiBoSDK add:content withPicData:UIImageJPEGRepresentation(image, 0.1f)];

    }
    [self resolveShareWeiBoFinishInfo:result];
}
- (void)addFriend:(NSString *)name {
    NSString *result = nil;
    if (_isTencent) {

    } else if (!_isTencent) {
        result = [_sinaWeiBoSDK addfriend:name];
    }
    [self resolveShareWeiBoFinishInfo:result];
}

#pragma mark 解析微博分享返回信息
- (void)resolveShareWeiBoFinishInfo:(NSString *)result {
    
    NSDictionary *dic =  [result objectFromJSONString];
    


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view removeHUDActivityView];
            
            if (_isTencent) {
                
                if ([[dic valueForKey:@"msg"] isEqualToString:@"ok"]) {
                    [self showMessage:IsEnglish ? @"Share successfully": @"分享成功"];
                } else {
                    [self showMessage:IsEnglish ? @"Share unsuccessfully": @"分享失败"];
                };
            } else if (!_isTencent) {
                
                if ([[dic valueForKey:@"created_at"] isEqualToString:@""] || ![dic valueForKey:@"created_at"]) {
                    [self showMessage:IsEnglish ? @"Share unsuccessfully": @"分享失败"];
                }else {
                    [self showMessage:IsEnglish ? @"Share successfully": @"分享成功"];
                }
            }
            
            [self tapBackBtn];
        });
        

        
    });
    
    

}

#pragma mark QWeiBoDelegate
- (void)QWeiboDidLogin {
    UIWebView *webView = (UIWebView *)[self.view viewWithTag:300];
    [webView removeFromSuperview];
    
    [self initView];

}

#pragma mark SWeiBoDelegate
- (void)SWeiboDidLogin {
    UIWebView *webView = (UIWebView *)[self.view viewWithTag:300];
    [webView removeFromSuperview];
    
    [self initView];
}

#pragma mark 提示
- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:IsEnglish ? @"Prompt": @"提示信息" message:message delegate:nil cancelButtonTitle:IsEnglish ? @"I know": @"我知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
