//
//  IdeaViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-7-2.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "IdeaViewController.h"

@interface IdeaViewController ()<UITextViewDelegate>
{
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UILabel *_labText;
    
}
@end

@implementation IdeaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navTitleLable.text = IsEnglish ? @"Feedback" : @"意见反馈";
    
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = RGBCOLOR(237.0, 237.0, 237.0).CGColor;
    
    self.rightbtn.hidden = NO;
    [self.rightbtn setTitle:IsEnglish ? @"Refer" :@"提交" forState:UIControlStateNormal];
    [self.rightbtn setTitleColor:[SavaData getColor:@"4cb9c1" alpha:1.f] forState:UIControlStateNormal];
    
    _labText.text = IsEnglish ? @"Please enter your suggestions" :@"请输入反馈内容";
}
- (void)tapRightBtn
{
    [self ideaFinishActon];
}
- (IBAction)ideaFinishActon {
    [_textView resignFirstResponder];
    
    if ([self isTitleBlank:_textView.text]) {
        [self.view addHUDLabelView:IsEnglish ? @"Please provide feedbacks" :@"请输入您的宝贵意见" Image:nil afterDelay:.2f];
        return;
    }
    [self.view addHUDActivityView:Loading];
    NSString *device = [self checkIphone];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSDictionary *dicUser = [SavaData parseDicFromFile:User_File];
    
    NSDictionary *dic = @{langType:language,
                          @"uid":USERID,
                          @"type":device,
                          @"version":version,
                          @"contact":@"",
                          @"username":dicUser[@"user_name"],
                          @"account":dicUser[@"user_account"],
                          @"content":_textView.text,
                          };
    
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)dic withURL:Api_FeedBack withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            [self.view addHUDLabelView:IsEnglish ? @"Send successfully" :@"发送成功" Image:nil afterDelay:2.0f];
            [self performSelector:@selector(tapBackBtn) withObject:nil afterDelay:2.f];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
    }];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _labText.hidden = YES;
}
//检测手机设备类型
- (NSString*)checkIphone{
    
    NSString*
    machineName();
    {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];

        if ([platform isEqualToString:@"iPhone1,1"]){
            return @"iPhone 2G";
        }else if ([platform isEqualToString:@"iPhone1,2"]){
            return @"iPhone 3G";
        }else if ([platform isEqualToString:@"iPhone2,1"]){
            return @"iPhone 3GS";
        }else if ([platform isEqualToString:@"iPhone3,1"]){
            return @"iPhone 4";
        }else if ([platform isEqualToString:@"iPhone3,2"]){
            return @"iPhone 4";
        }else if ([platform isEqualToString:@"iPhone3,3"]){
            return @"iPhone 4 (CDMA)";
        }else if ([platform isEqualToString:@"iPhone4,1"]){
            return @"iPhone 4S";
        }else if ([platform isEqualToString:@"iPhone5,1"]){
            return @"iPhone 5";
        }else if ([platform isEqualToString:@"iPhone5,2"]){
            return @"iPhone 5 (GSM+CDMA)";
        }else if ([platform isEqualToString:@"iPhone6,2"]){
            return @"iPhone 5S";
        }else if ([platform isEqualToString:@"iPod1,1"]) {
            return @"iPod Touch (1 Gen)";
        }else if ([platform isEqualToString:@"iPod2,1"]) {
            return @"iPod Touch (2 Gen)";
        }else if ([platform isEqualToString:@"iPod3,1"]) {
            return @"iPod Touch (3 Gen)";
        }else if ([platform isEqualToString:@"iPod4,1"]) {
            return @"iPod Touch (4 Gen)";
        }else if ([platform isEqualToString:@"iPod5,1"]) {
            return @"iPod Touch (5 Gen)";
        }else if ([platform isEqualToString:@"iPad1,1"]) {
            return @"iPad";
        }else if ([platform isEqualToString:@"iPad1,2"]) {
            return @"iPad 3G";
        }else if ([platform isEqualToString:@"iPad2,1"]) {
            return @"iPad 2 (WiFi)";
        }else if ([platform isEqualToString:@"iPad2,2"]) {
            return @"iPad 2";
        }else if ([platform isEqualToString:@"iPad2,3"]) {
            return @"iPad 2 (CDMA)";
        }else if ([platform isEqualToString:@"iPad2,4"]) {
            return @"iPad 2";
        }else if ([platform isEqualToString:@"iPad2,5"]) {
            return @"iPad Mini (WiFi)";
        }else if ([platform isEqualToString:@"iPad2,6"]) {
            return @"iPad Mini";
        }else if ([platform isEqualToString:@"iPad2,7"]) {
            return @"iPad Mini (GSM+CDMA)";
        }else if ([platform isEqualToString:@"iPad3,1"]) {
            return @"iPad 3 (WiFi)";
        }else if ([platform isEqualToString:@"iPad3,2"]) {
            return @"iPad 3 (GSM+CDMA)";
        }else if ([platform isEqualToString:@"iPad3,3"]) {
            return @"iPad 3";
        }else if ([platform isEqualToString:@"iPad3,4"]) {
            return @"iPad 4 (WiFi)";
        }else if ([platform isEqualToString:@"iPad3,5"]) {
            return @"iPad 4";
        }else if ([platform isEqualToString:@"iPad3,6"]) {
            return @"iPad 4 (GSM+CDMA)";
        }else if ([platform isEqualToString:@"i386"])    {
            return @"Simulator";
        }else if ([platform isEqualToString:@"x86_64"])  {
            return @"Simulator";
        }else{
            return platform;
        }
        return platform;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
