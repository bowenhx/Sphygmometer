//
//  LifeOfDetailController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-10.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "LifeOfDetailController.h"
#import "WXApi.h"
#import "ShareViewController.h"

@interface LifeOfDetailController ()<UIWebViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    //设置文字
    __weak IBOutlet UIView *_viewText;
    __weak IBOutlet UIButton *_btnSize0;
    __weak IBOutlet UIButton *_btnSize1;
    __weak IBOutlet UIButton *_btnSize2;
    
    __weak IBOutlet UIView *_showShareView;
    
    __weak IBOutlet UIButton *_btnWeixin;
    __weak IBOutlet UIButton *_btnEmail;
    
    
    
    NSMutableArray      *_btnArr;
    CGFloat           _sizeFont;
    NSString            *_webBgColor;
    NSString            *_webTextColor;
}

@end

@implementation LifeOfDetailController

@synthesize titleString = _titleString;
@synthesize lifeWebView = _lifeWebView;
@synthesize newsWebUrl = _newsWebUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView{
    
    [super loadView];
    
    [self initView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _sizeFont = 38.f;
    
    _webBgColor = @"";
    _webTextColor = @"#4b4b4b";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navTitleLable.text = _titleString;
    
    NSURL *webURL = [NSURL URLWithString: _newsWebUrl];
    [_lifeWebView loadRequest: [NSURLRequest requestWithURL: webURL]];
    
    if (_btnArr.count >0) {
        NSArray *collectArr = [SavaData parseArrFromFile:CollectFile];
        [collectArr enumerateObjectsUsingBlock:^(NSDictionary *dicInfo , NSUInteger index, BOOL *stop)
        {
            if ([dicInfo[@"id"] intValue] == _typeID) {
                UIButton *button = _btnArr[0];
                button.selected = YES;
            }
        }];
    }
   
}
#pragma mark --

- (void) initView{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-108 , WIDTH(self.view), 44)];
    footView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"养生下背景"]];
    
    _btnArr = [NSMutableArray array];
    NSArray *arrImage = @[
                          @[@"收藏",@"收藏-1"],
                          @[@"养生分享",@"养生分享-1"],
                          @[@"lifeOf_moon_image",@"lifeOf_moon_image-1",@"太阳"],
                          @[@"a" , @"a-1"]
                          ];
    for (int i =0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*80, 1, 80, 41);
        button.selected = NO;
        if (i == 2) {
            [button setImage:[UIImage imageNamed:arrImage[i][0]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:arrImage[i][1]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:arrImage[i][2]] forState:UIControlStateSelected];
        }else{
            [button setImage:[UIImage imageNamed:arrImage[i][0]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:arrImage[i][1]] forState:UIControlStateSelected];
        }
        
        button.tag = i;
        [footView addSubview:button];
        [_btnArr addObject:button];
        
        [button addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    [self.view addSubview:footView];
    
    
    _lifeWebView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view),SCREEN_HEIGHT-108)];
    _lifeWebView.delegate = self;
    [_lifeWebView sizeToFit];
    _lifeWebView.scalesPageToFit = YES;
    _lifeWebView.autoresizesSubviews = YES;
//    _lifeWebView.layer.borderWidth = 1;
//    _lifeWebView.layer.borderColor = [UIColor redColor].CGColor;
//    _lifeWebView.backgroundColor = [UIColor redColor];
    [self.view addSubview: _lifeWebView];
    
    //设置文字
    CGRect viewSizeFrame = _viewText.frame;
    viewSizeFrame.origin.y = Y(footView) - 69;
    _viewText.frame = viewSizeFrame;
    
//    _viewText.hidden = YES;
    
    [self.view bringSubviewToFront:_viewText];
//    [self.view sendSubviewToBack:_lifeWebView];
   
    [_btnWeixin setTitleColor:[Common getColor:@"4cb9c1"] forState:UIControlStateNormal];
    [_btnEmail setTitleColor:[Common getColor:@"4cb9c1"] forState:UIControlStateNormal];

    if (isiPhone5 == YES) {
        CGRect shareFrame = _showShareView.frame;
        shareFrame.origin.y += 50;
        _showShareView.frame = shareFrame;
    }
//    _showShareView.layer.borderWidth = 1;
    
    [self.view bringSubviewToFront:_showShareView];
    
}
- (void)selectState:(UIButton *)btn
{

    _viewText.hidden = YES;
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *button , NSUInteger index, BOOL *stop)
     {
         if (button.tag == btn.tag) {
             btn.selected = !btn.selected;
         }else{
             if (button.tag ==0) {
                 //当为收藏时，不做状态改变
             }else{
                button.selected = NO;
             }
             
         }
         
     }];
    
    switch (btn.tag) {
        case 0:
        {//收藏
            NSDictionary *dicTemp = [SavaData parseDicFromFile:CollectTempDic];
            
            NSMutableArray *collectArr = [NSMutableArray arrayWithArray:[SavaData parseArrFromFile:CollectFile]];
            
            if (btn.selected == YES) {

                [collectArr addObject:dicTemp];
                [SavaData writeArrToFile:collectArr FileName:CollectFile];
                
                 [self.view addHUDLabelView:IsEnglish ? @"Added to favorite": @"收藏成功" Image:nil afterDelay:2.0f];
            }else{
                NSInteger collectID = [dicTemp[@"id"] integerValue];

                for (int i =0 ; i < collectArr.count ; i++) {
                    NSDictionary *dic = collectArr[i];
                    if (collectID == [dic[@"id"] integerValue]) {
                        [collectArr removeObjectAtIndex:i];
                    }
                }
                
                 [SavaData writeArrToFile:collectArr FileName:CollectFile];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:CollectDataNotificationCenter object:nil];
                
                [self.view addHUDLabelView:IsEnglish ? @"Remove from the favorite": @"取消收藏成功" Image:nil afterDelay:2.0f];
            }
           
        }
            break;
        case 1:
        {//分享
            _showShareView.hidden = NO;
        }
            break;
        case 2:
        {//设置阅读模式
            if (btn.selected == YES) {
                [btn setImage:[UIImage imageNamed:@"太阳"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"太阳-1"] forState:UIControlStateHighlighted];
                _webBgColor = @"#4b4b4b";
                _webTextColor = @"#ffffff";
            }else{
                [btn setImage:[UIImage imageNamed:@"月亮"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"月亮-1"] forState:UIControlStateHighlighted];
                _webBgColor = @"";
                _webTextColor = @"#4b4b4b";
            }
            [_lifeWebView reload];
        }
            break;
        case 3:
        {//设置字体大小
            _viewText.hidden = NO;
        }
            break;
            
        default:
            break;
    }

}

#pragma mark 设置文字大小
- (IBAction)setTextSizeSmallAction:(UIButton *)sender {
    sender.selected = YES;
    _btnSize1.selected = NO;
    _btnSize2.selected = NO;
    _viewText.hidden = YES;
    _sizeFont = 30.f;
    [_lifeWebView reload];
}
- (IBAction)setTextSizeMiddleAction:(UIButton *)sender {
    sender.selected = YES;
    _btnSize2.selected = NO;
    _btnSize0.selected = NO;
    _viewText.hidden = YES;
    _sizeFont = 38.f;
    [_lifeWebView reload];
}
- (IBAction)setTextSizebigAction:(UIButton *)sender {
    sender.selected = YES;
    _btnSize0.selected = NO;
    _btnSize1.selected = NO;
    _viewText.hidden = YES;
    _sizeFont = 43.f;
    [_lifeWebView reload];
}

#pragma mark 分享
- (IBAction)selectShareWeixinAction:(UIButton *)sender {
    
    //是否安装微信
    if ([WXApi isWXAppInstalled] == NO || [WXApi isWXAppSupportApi] == NO) {
        [[[UIAlertView alloc]initWithTitle:IsEnglish ? @"Error": @"错误" message:IsEnglish ? @"wechat is not installed or the version doesn't support sharing": @"您还没有安装微信或者您的版本不支持分享功能!" delegate:self cancelButtonTitle:Verify otherButtonTitles:nil, nil]show];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage: [UIImage imageNamed: @"120.png"]];
    
    
    if (_newsWebUrl) {
        WXWebpageObject *webObject = WXWebpageObject.object;
        webObject.webpageUrl = _newsWebUrl;
        message.mediaObject = webObject;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    req.message.title = _titleString;
    BOOL secceed = [WXApi sendReq:req];
    LOG(@"secceed = %d",secceed);
    
    
    
    
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.scene = WXSceneTimeline;
//    req.message = WXMediaMessage.message;
//    req.message.title = _titleString;
//    req.text = @"分享测试";
//    req.bText = NO;
//    [req.message setThumbImage:[UIImage imageNamed:@"理想"]];
//    if (_newsWebUrl) {
//        WXWebpageObject *webObject = WXWebpageObject.object;
//        webObject.webpageUrl = _newsWebUrl;
//        req.message.mediaObject = webObject;
//    }
//    else if (image) {
//        WXImageObject *imageObject = WXImageObject.object;
//        imageObject.imageData = UIImageJPEGRepresentation(image, 1);
//        req.message.mediaObject = imageObject;
//    }
   
//    BOOL secceed = [WXApi sendReq:req];
//    LOG(@"secceed = %d",secceed);
}

- (IBAction)selectShareEmailAction:(UIButton *)sender {
    
    ShareViewController *shareViewController = [[ShareViewController alloc] init];
    shareViewController.isTencent = NO;
    //    UIImage *shareImage = [UIImage imageNamed: @"胎动心不透明.png"];
    shareViewController.shareImage = nil;
    shareViewController.shareContent = [NSString stringWithFormat:@"%@%@",IsEnglish ? @"Cigii Health Care:" :@"实捷健康：",_newsWebUrl];
    UINavigationController *shareNav = [[UINavigationController alloc] initWithRootViewController: shareViewController];
    [self.navigationController presentViewController: shareNav animated: YES completion: nil];
    
   /* Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            NSArray *tempArray = [NSArray arrayWithObjects: @"123456@163.com", nil];
            MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
            mailPicker.mailComposeDelegate = self;
            //设置主题
            [mailPicker setSubject: @"邮件分享"];
            // 添加发送者
            [mailPicker setToRecipients: tempArray];
            
            [mailPicker setMessageBody:_newsWebUrl isHTML:YES];
            
            [self.navigationController presentViewController: mailPicker animated: YES completion: nil];
            
            
        }else{
            [self openEmailView];
        }
        
    }else{
        [self openEmailView];
        
    }
    */
}
- (void)openEmailView
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            
            break;
        default:
            break;
    }
    
    [self.view addHUDLabelView:msg Image: nil afterDelay: 2.0];
    
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)selectShareCancelAction:(UIButton *)sender {
    _showShareView.hidden = YES;
}


#pragma mark vebViewDelegate
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//   
//}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    window.onload = function(){
    if (![_webBgColor isEqualToString:@""]) {
        
        NSString *color = [NSString stringWithFormat:@"document.body.style.backgroundColor = '%@'",_webBgColor];
        [webView stringByEvaluatingJavaScriptFromString:color];
        
//        NSString *textColor = @"document.getElementsByTagName('body')[0].style.webkitTextColorAdjust='#ffffff'";
//        [webView stringByEvaluatingJavaScriptFromString:textColor];
    }
    
        
//    }
//    LOG(@"_sizeFont = %f",_sizeFont);
//    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%@'",_sizeFont];
    
     NSString *str = [NSString stringWithFormat:@"document.body.style.fontSize='%f';document.body.style.color='%@'",_sizeFont,_webTextColor];
    [webView stringByEvaluatingJavaScriptFromString:str];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
