//
//  DeviceViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-15.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "DeviceViewController.h"
#import "FamilyViewController.h"
#import "MeterViewController.h"
#import "DataVesselObj.h"
#import "MeterDevViewController.h"
#import "WXApi.h"
#import "UIImageView+WebCache.h"
#import "ShareViewController.h"
#import "UMSocialSnsPlatformManager.h"

#define  strName    [DataVesselObj shareInstance]

@interface DeviceViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    __weak IBOutlet UILabel *_labXueya;
    __weak IBOutlet UILabel *_labBluetooth;
    __weak IBOutlet UILabel *_labValue;
    __weak IBOutlet UIButton *_btnGPRS;
    
    
    __weak IBOutlet UILabel *_labUnit;
    
    __weak IBOutlet UIButton *_btnMeter;
    __weak IBOutlet UIButton *_btnPush;
    
    __weak IBOutlet UIButton *_btnShare;
    __weak IBOutlet UIButton *_btnEdit;
    
    
    IBOutlet UIView          *_viewShareBg;
    __weak IBOutlet UIButton *_btnWeiXin;
    __weak IBOutlet UIButton *_btnEmail;
    __weak IBOutlet UIButton *_btnCancel;
    
    
    UIImageView         *_headImage;
    UILabel             *_navUserName;
    
    UIImage             *_sharImage;
    
}
@end

@implementation DeviceViewController

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
    self.backBtn.hidden = YES;
   
    
//    self.view.layer.borderWidth = 2;
//    self.view.layer.borderColor = [UIColor greenColor].CGColor;
    
    [self initView];
}


- (void)initView
{

    [self navigationLeftTextNmae];
    
    self.navTitleLable.text = @"";
    self.navTitleLable.textAlignment = NSTextAlignmentLeft;
    self.rightbtn.hidden = YES;
    
//    UIImage *rightImage = [UIImage imageNamed: @"设备连接"];
//    UIImage *rightImage2 = [UIImage imageNamed:@"设备连接点击"];
//    self.rightbtn.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
//    [self.rightbtn setBackgroundImage:rightImage forState:UIControlStateNormal];
//    [self.rightbtn setBackgroundImage:rightImage2 forState:UIControlStateSelected];
    
    _labBluetooth.textColor = [Common getColor:@"4cb9c1"];
    _labXueya.textColor = [Common getColor:@"4cb9c1"];
    [_btnGPRS setTitleColor:[Common getColor:@"4cb9c1"] forState:UIControlStateNormal];
    [_btnWeiXin setTitleColor:[Common getColor:@"4cb9c1"] forState:UIControlStateNormal];
    [_btnEmail setTitleColor:[Common getColor:@"4cb9c1"] forState:UIControlStateNormal];
   
   
    
    if (!isiPhone5) {
        CGRect btnShare = _btnShare.frame;
        btnShare.origin.y = SCREEN_HEIGHT- 108 - HEIGHT(_btnShare)-10;
        _btnShare.frame = btnShare;
        
        _btnEdit.frame = CGRectMake(X(_btnEdit), Y(_btnShare), WIDTH(_btnEdit), HEIGHT(_btnEdit));
    }
    
    CGRect shareFrmae = _viewShareBg.frame;
    shareFrmae.origin.y = SCREEN_HEIGHT - HEIGHT(_viewShareBg);
    _viewShareBg.frame = shareFrmae;
    
    
     [[UIApplication sharedApplication].windows[0] addSubview:_viewShareBg];
//    _btnCancel.layer.borderWidth = 2;
//    _viewShareBg.layer.borderWidth = 1;
//    _viewShareBg.layer.borderColor = [UIColor redColor].CGColor;
    
}
- (IBAction)didSelectGPRSDeviceVC
{
    MeterDevViewController *meterDevVC  = [[MeterDevViewController alloc] initWithNibName:@"MeterDevViewController" bundle:nil];
    meterDevVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:meterDevVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self isTitleBlank:strName.titleName]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeTabBarNotificationCenter object:@(0)];
    }
    
    [self reloaShowData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableArray *arrUser = [SavaData parseArrFromFile:UserMemberList];
    if (arrUser.count) {
        UIImage *headImage = [UIImage imageNamed:@"默认头像.png"];
        _navUserName.text = strName.titleName;
        [_headImage sd_setImageWithURL:[NSURL URLWithString:strName.headImageUrl] placeholderImage:headImage];
    }
    
//    if (strName.arrData.count) {
//        NSDictionary *dicEnd = strName.arrData[0];
    
     
//    }
  
   
    
    //设置单位
    if ([UNITS_TYPE_DATA[@"blood"] boolValue] == NO) {
        _labUnit.text = @"mmhg";
    }else{
        _labUnit.text = @"kpa";
    }
}
- (void)reloaShowData
{

    LOG(@"roleid = %d",strName.roleid);
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"uid":USERID,@"roleid":@(strName.roleid),@"size":@(1000)} withURL:Api_RoleHistory withType:POST completed:^(id content, ResponseType responseType) {

        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            NSArray *arr = content[@"data"];
             _labValue.text = [NSString stringWithFormat:@"%@/%@",arr[0][@"sys"],arr[0][@"dia"]];
          
        } else if (responseType == FAIL) {
            _labValue.text = [NSString stringWithFormat:@"0/0"];
        }
    }];
}
- (void)didSelectHome
{
     [[NSNotificationCenter defaultCenter] postNotificationName:ChangeTabBarNotificationCenter object:@(0)];
}
//- (UIImage *)showHeadImage
//{
//    NSArray *arrImage = [SavaData parseArrFromFile:USER_HEAD_IMAGE];
//    UIImage *headImage = [UIImage imageNamed:@"默认头像.png"];
//    __block UIImage *headImage = [UIImage imageNamed:@"默认头像.png"];
//    [arrImage enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger index, BOOL *stop){
//        if ([dic[@"name"] isEqualToString:strName.titleName]) {
//            UIImage *image = [UIImage imageWithData:dic[@"headImage"]];
//            CGSize size = CGSizeMake(38.f, 38.f);
//            UIGraphicsBeginImageContext(size);
//            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//            image = UIGraphicsGetImageFromCurrentImageContext();
//            NSData *data = UIImageJPEGRepresentation(image, 0.4);
//            
//            headImage = [UIImage imageWithData:data];
//        }
//    }];
//    
//    return headImage;
//}
- (void)navigationLeftTextNmae
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
//    headView.layer.borderWidth = 1;
//    headView.layer.borderColor= [UIColor redColor].CGColor;
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 40, 40)];
    _headImage.layer.masksToBounds = YES;
    [headView addSubview:_headImage];
    
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:_headImage.frame];
    img.image = [UIImage imageNamed:@"head_default_bg"];
    
    [headView addSubview:img];
    
    _navUserName = [[UILabel alloc] initWithFrame:CGRectMake(WIDTHADDX(_headImage)+4, 5, 70, 35)];
    
    _navUserName.text = @"";
    _navUserName.font = [UIFont systemFontOfSize:14];
    _navUserName.textColor = [UIColor darkGrayColor];
    [headView addSubview:_navUserName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = headView.frame;
    [headView addSubview:button];
    [button addTarget:self action:@selector(didSelectHome) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem.customView = headView;
}
//血压测量
- (IBAction)didSelectPushMeterAction:(UIButton *)sender {
    MeterViewController *meterVC = [[MeterViewController alloc] initWithNibName:@"MeterViewController" bundle:nil];
    if (![_headImage.image isEqual:[UIImage imageNamed:@"默认头像.png"]]) {
        meterVC.headImage = _headImage.image;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:meterVC];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}
//血压详细
- (IBAction)didSelectPushVCPageAction:(UIButton *)sender {
    FamilyViewController *familyVC = [[FamilyViewController alloc] init]; 
    familyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:familyVC animated:YES];
}

//主页面分享按钮
- (IBAction)didSelectShareAction:(UIButton *)sender {
    _sharImage = [[DataVesselObj getImageUIScreenFromViewBg] copy];
    
    self.tabBarController.tabBar.hidden = YES;
   
    _viewShareBg.hidden = NO;
    
    self.view.backgroundColor = [UIColor grayColor];
    self.view.alpha = 0.8;
    _btnMeter.userInteractionEnabled = NO;
    _btnPush.userInteractionEnabled = NO;
    _btnGPRS.userInteractionEnabled = NO;
    
//    [UIView animateWithDuration:0.37 animations:^{
//        CGRect shareFrmae = _viewShareBg.frame;
//        shareFrmae.origin.y = SCREEN_HEIGHT -(kIsIOS7 ? 88 : 108)- HEIGHT(_viewShareBg);
//        _viewShareBg.frame = shareFrmae;
//
//    }];
}
//主页面编辑按钮
- (IBAction)didSelcetEditAction:(UIButton *)sender {
    [self.view addHUDLabelView:IsEnglish ? @"Coming soon" : @"敬请期待" Image:nil afterDelay:2.0f];
}

//分享-- 微信
- (IBAction)didSelectShareWeiXinAction:(UIButton *)sender {
    
    //是否安装微信
    if ([WXApi isWXAppInstalled] == NO || [WXApi isWXAppSupportApi] == NO) {
        [[[UIAlertView alloc]initWithTitle:IsEnglish ? @"Error" : @"错误" message:IsEnglish ? @"wechat is not installed or the version doesn't support sharing": @"您还没有安装微信或者您的版本不支持分享功能!" delegate:self cancelButtonTitle:Verify otherButtonTitles:nil, nil]show];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage: [UIImage imageNamed: @"pic@2x.png"]];
    
    WXImageObject *ext = [WXImageObject object];

    ext.imageData = UIImagePNGRepresentation(_sharImage);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;

    BOOL secceed = [WXApi sendReq:req];
    LOG(@"secceed = %d",secceed);

}
//分享-- 邮件
- (IBAction)didSelectShareEmailAction:(UIButton *)sender {
    
    NSString *shareText = IsEnglish ? @"Cigii Health Care Share" : @"实捷健康分享";        //分享内嵌文字
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:_sharImage socialUIDelegate:nil];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
//    ShareViewController *shareViewController = [[ShareViewController alloc] init];
//    shareViewController.isTencent = NO;
//    //    UIImage *shareImage = [UIImage imageNamed: @"胎动心不透明.png"];
//    shareViewController.shareImage = _sharImage;
//    shareViewController.shareContent = IsEnglish ? @"Cigii Health Care Share" : @"实捷健康分享";
//    UINavigationController *shareNav = [[UINavigationController alloc] initWithRootViewController: shareViewController];
//    [self.navigationController presentViewController: shareNav animated: YES completion: nil];
    
   /*
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
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
            
//            [mailPicker setMessageBody:_newsWebUrl isHTML:YES];
            // 添加图片
            NSData *imageData = UIImagePNGRepresentation(_sharImage);
            
            [mailPicker addAttachmentData: imageData mimeType:@"" fileName: @"pic@2x.png"];
            [self.navigationController presentViewController: mailPicker animated: YES completion: nil];
            
            
        }else{
            [self openEmailView];
        }
        
    }else{
        [self openEmailView];
        
    }
    */
}
//分享-- 取消
- (IBAction)cancelAction:(UIButton *)sender {
    self.tabBarController.tabBar.hidden = NO;
    self.view.backgroundColor = RGBCOLOR(237.0, 237.0, 237.0);
    self.view.alpha = 1.f;
    _viewShareBg.hidden = YES;
    _btnMeter.userInteractionEnabled = YES;
    _btnPush.userInteractionEnabled = YES;
    _btnGPRS.userInteractionEnabled = YES;
//    [UIView animateWithDuration:0.37 animations:^{
//        CGRect shareFrmae = _viewShareBg.frame;
//        shareFrmae.origin.y = SCREEN_HEIGHT;
//        _viewShareBg.frame = shareFrmae;
//
//    }];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
