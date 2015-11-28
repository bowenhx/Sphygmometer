//
//  BaiduLoginViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14/10/24.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "BaiduLoginViewController.h"
#import "HomeTabBarController.h"

@interface BaiduLoginViewController ()<UIWebViewDelegate>
{
    
    __weak IBOutlet UIWebView *_webView;
}
@end

@implementation BaiduLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://121.40.146.159/api/baidu/login"]]];
}
#pragma mark webViewDelegate
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    LOG(@"url = %@", url);
    
    if ([url hasSuffix:@"#otherlogin"]) {
        
        [self performSelector:@selector(selectDriftData) withObject:nil afterDelay:3.5];
        return NO;
    }
    
    return YES;
}
- (void)selectDriftData
{
    
    NSString *getJS = @"getUserByIOS()";
    NSString *backJS = [_webView stringByEvaluatingJavaScriptFromString:getJS];
    LOG(@"backJS  = %@",backJS);
    
    if (backJS.length >1) {
        NSDictionary *dicData = [backJS objectFromJSONString];
        
        //保存用户ID
        NSString *userid = [NSString stringWithFormat:@"%@",dicData[@"data"][@"user_id"]];
        [[SavaData shareInstance] savadataStr:userid KeyString:USER_ID_SAVA];
        [[SavaData shareInstance] savaDataInteger:userid.integerValue KeyString:USER_ID_SAVA];;
        
        [SavaData setUserId:userid];
        //存入用户信息
        [SavaData writeDicToFile:dicData[@"data"] FileName:User_File];
        
        LOG(@"userid = %@--- userFile = %@",[SavaData getUserId],[SavaData parseDicFromFile:User_File]);
        
        [SavaData setUserInfoData:userid];
        
        NSLog(@"userINforid = %@",[SavaData getOutUserFile]);
        
        //进入主界面
        [HomeTabBarController showRootView];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
