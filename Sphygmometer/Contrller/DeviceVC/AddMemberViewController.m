//
//  AddMemberViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-17.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "AddMemberViewController.h"
#import "StyledPageControl.h"
#import "DataVesselObj.h"
#import "WXApi.h"
#import "UIImageView+WebCache.h"
#import "ShareViewController.h"
#import "UMSocialSnsPlatformManager.h"

@interface AddMemberViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    
    __weak IBOutlet UIView   *_viewHeadBg;
    __weak IBOutlet UIImageView *_headImage;
    __weak IBOutlet UIButton *_btnValue1;
    __weak IBOutlet UIButton *_btnValue2;
    __weak IBOutlet UIButton *_btnValue3;
    
    
    __weak IBOutlet UIView  *_viewTimes;
    __weak IBOutlet UILabel *_labYear;
    __weak IBOutlet UILabel *_labTime;
    __weak IBOutlet UIButton *_btnAddMember;
    
    
    __weak IBOutlet UIScrollView *_scrollViewBg;
    __weak IBOutlet UIImageView  *_imageColor;
    __weak IBOutlet UIImageView  *_imageHand;
    __weak IBOutlet UILabel      *_labText;
    
    IBOutlet UIView *_pickerViewBg;
    __weak IBOutlet UIPickerView *_pickerViewData;
    __weak IBOutlet UIView *_pickHeadView;
    __weak IBOutlet UILabel *_labTitle;
    
    __weak IBOutlet UIButton *_btnTestSave;//测试保存
    __weak IBOutlet UIButton *_btnTestDel; //重新测
    UILabel                 *_labScrContent;//健康讯息
    
    IBOutlet UIView *_shareViewBg;
    
    __weak IBOutlet UIButton *_btnShare;
    
    
    StyledPageControl  *_pageControl;
    
    UIImage             *_shareImage;
    NSMutableArray      *_arrNumber;
    NSMutableArray      *_arrValueNum;
    NSString            *_number1;
    NSString            *_timeYear;
}


@end

@implementation AddMemberViewController

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
    
    _viewHeadBg.backgroundColor = [Common getColor:@"4cb9c1"];
    
    
    [self initView];
    [self initData];
}
- (void)initView
{
    
    if (isiPhone5 == NO) {
        _imageColor.frame = CGRectMake(75, Y(_imageColor), 170, 160);
        _imageColor.image = [UIImage imageNamed:@"viewdata_pct4"];
        
        _imageHand.frame = CGRectMake(108, Y(_imageHand)-10, 104, 125);
        _imageHand.image = [UIImage imageNamed:@"色圈-指针4"];
        
        CGRect labTextFrame = _labText.frame;
        labTextFrame.origin.y -= 40;
        _labText.frame = labTextFrame;
        _labText.font = [UIFont systemFontOfSize:40];
        
        CGRect btnFrame = _btnTestSave.frame;
        btnFrame.origin.y -= 80;
        _btnTestSave.frame = btnFrame;
        
        _btnTestDel.frame = CGRectMake(X(_btnTestDel), Y(_btnTestSave), WIDTH(_btnTestDel), HEIGHT(_btnTestDel));
        
        if (IsEnglish) {
            _labText.font = [UIFont systemFontOfSize:30];
        }
    }
    
    _btnAddMember.frame = CGRectMake(X(_btnAddMember), SCREEN_HEIGHT - (kIsIOS7 ? 45 : 65), WIDTH(_btnAddMember), HEIGHT(_btnAddMember));
    //活动scrollView
    _scrollViewBg.contentSize = CGSizeMake(WIDTH(self.view)*2, HEIGHT(_scrollViewBg));

    
    //第二屏描述文字
    UILabel *labScrTitle = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self.view)+20, 10, 100, 30)];
    labScrTitle.text = IsEnglish ? @"Analyse result": @"分析结果";
    labScrTitle.backgroundColor = [UIColor clearColor];
    labScrTitle.font = [UIFont systemFontOfSize:24];
    labScrTitle.textColor = [UIColor blackColor];
    [_scrollViewBg addSubview:labScrTitle];
    
    _labScrContent = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self.view)+20, 40, 280, 160)];
    _labScrContent.backgroundColor = [UIColor clearColor];
    _labScrContent.font = [UIFont systemFontOfSize:isiPhone5 ? 18 : 15];
//    _labScrContent.layer.borderWidth = 1;
    _labScrContent.numberOfLines = 0;
    _labScrContent.textColor = [UIColor darkGrayColor];
    [_scrollViewBg addSubview:_labScrContent];
    
    
    //分页标签
    _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(110.0f, SCREEN_HEIGHT - 65, 100, 22)];
    _pageControl.pageControlStyle = PageControlStyleDefault;
    _pageControl.numberOfPages = 2;
    [_pageControl setCoreNormalColor:[UIColor whiteColor]];
    [_pageControl setCoreSelectedColor:RGBCOLOR(65.0, 171.0, 179.0)];
    [self.view addSubview: _pageControl];
    
    UIImage *headImage = [UIImage imageNamed:@"头像.png"];
     [_headImage sd_setImageWithURL:[NSURL URLWithString:[DataVesselObj shareInstance].headImageUrl] placeholderImage:headImage];
    
}
//- (UIImage *)showHeadImage
//{
//    NSArray *arrImage = [SavaData parseArrFromFile:USER_HEAD_IMAGE];
//    
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_memberType == 1) {
        //进入详情页面
        _btnAddMember.hidden = YES;
        
        _btnValue1.userInteractionEnabled = NO;
        _btnValue2.userInteractionEnabled = NO;
        _btnValue3.userInteractionEnabled = NO;
        
        if (_dicInfor.allKeys.count) {
             [_btnValue1 setTitle:_dicInfor[@"sys"] forState:UIControlStateNormal];
             [_btnValue2 setTitle:_dicInfor[@"dia"] forState:UIControlStateNormal];
             [_btnValue3 setTitle:_dicInfor[@"pul"] forState:UIControlStateNormal];
            
            [self showDataOrDraw:@[_dicInfor]];
        }
        if ([DataVesselObj shareInstance].scanDevShow ==1) {
            _btnTestSave.hidden =  NO;
            _btnTestDel.hidden = NO;
            _btnAddMember.hidden = YES;
        }else
        {
            _btnTestSave.hidden =  YES;
            _btnTestDel.hidden = YES;
            
            //添加分享按钮
            _btnShare.hidden = NO;
//            UIImage *rightImage = [UIImage imageNamed: @""];
//            self.rightbtn.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
//            [self.rightbtn setBackgroundImage:rightImage forState:UIControlStateNormal];

        }
    }else{
        //添加页面
        _btnAddMember.hidden = NO;
        _btnTestSave.hidden = YES;
        _btnTestDel.hidden = YES;
    }
}
- (void)initData
{
    _arrValueNum = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [self userDateFormatter];
    _timeYear = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    LOG(@"datestr = %@",_timeYear);
    _labYear.text = [_timeYear substringToIndex:11];
    _labTime.text = [_timeYear substringFromIndex:10];
    
    _arrNumber = [[NSMutableArray alloc] init];
    for (int i=1; i<301; i++) {
        [_arrNumber addObject:@(i)];
    }
    
}
#pragma mark 分享按钮
- (IBAction)shareAction
{
    _shareImage = [[DataVesselObj getImageUIScreenFromViewBg] copy];
    [self showShareViewBg];
}

#pragma 分享微信
- (IBAction)didShareWeixin
{
    //是否安装微信
    if ([WXApi isWXAppInstalled] == NO || [WXApi isWXAppSupportApi] == NO) {
        [[[UIAlertView alloc]initWithTitle:IsEnglish ? @"error": @"错误" message:IsEnglish ? @"wechat is not installed or the version doesn't support sharing": @"您还没有安装微信或者您的版本不支持分享功能!" delegate:self cancelButtonTitle:Verify otherButtonTitles:nil, nil]show];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage: [UIImage imageNamed: @"pic@2x.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData = UIImagePNGRepresentation(_shareImage);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    BOOL secceed = [WXApi sendReq:req];
    LOG(@"secceed = %d",secceed);
}
#pragma mark 显示分享view

- (void)showShareViewBg
{
    CGRect rect = _shareViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _shareViewBg.frame = rect;
    if (!_shareViewBg.superview) {
        [self.view addSubview:_shareViewBg];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _shareViewBg.frame;
        frame.origin.x = 0;
        frame.origin.y = HEIGHT(self.view) - _shareViewBg.frame.size.height;
        _shareViewBg.frame = frame;
    }];
    
}
- (void)didHiddenShareViewBg
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _shareViewBg.frame;
        rect.origin.x = 0;
        rect.origin.y = SCREEN_HEIGHT;
        _shareViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_shareViewBg removeFromSuperview];
    }];
    
    
}


- (IBAction)didShareEmail {
    NSString *shareText = IsEnglish ? @"Cigii Health Care Share" : @"实捷健康分享";        //分享内嵌文字
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:_shareImage socialUIDelegate:nil];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    
//    ShareViewController *shareViewController = [[ShareViewController alloc] init];
//    shareViewController.isTencent = NO;
//    //    UIImage *shareImage = [UIImage imageNamed: @"胎动心不透明.png"];
//    shareViewController.shareImage = _shareImage;
//    shareViewController.shareContent = IsEnglish ? @"Cigii Health Care Share": @"实捷健康分享";
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
            NSData *imageData = UIImagePNGRepresentation(_shareImage);
            
            [mailPicker addAttachmentData: imageData mimeType:@"" fileName: @"pic@2x.png"];
            [self presentViewController: mailPicker animated: YES completion: nil];
            
            
        }else{
            [self openEmailView];
        }
        
    }else{
        [self openEmailView];
        
    }*/

}
- (void) openEmailView
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
    
}
- (IBAction)didCancelShare
{
    [self didHiddenShareViewBg];
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

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [_pageControl setCurrentPage:currentPage];
}

- (NSDateFormatter *)userDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return formatter;
}
//测量舒张压
- (IBAction)sphygmometerPuffAction {
    [self showDatePickerView:SYS];
    
}
//测量收缩压
- (IBAction)sphygmometerStrictionAction {
    [self showDatePickerView:DIA];
}
//测量心率
- (IBAction)sphygmometerValueActon:(id)sender {
    [self showDatePickerView:HR];
}



- (IBAction)disMisVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isValueData
{
    if (_arrValueNum.count ==0) {
        return NO;
    }
    if ([self isTitleBlank:_arrValueNum[0][@"sys"]]) {
         [self.view addHUDLabelView:IsEnglish ? @"Please select systolic pressure": @"请选择收缩压" Image:nil afterDelay:2.0f];
        return NO;
    }else if ([self isTitleBlank:_arrValueNum[0][@"dia"]])
    {
        [self.view addHUDLabelView:IsEnglish ? @"Please select diastolic pressure" : @"请选择舒张压" Image:nil afterDelay:2.0f];
        return NO;
    }else if ([self isTitleBlank:_arrValueNum[0][@"pul"]])
    {
        [self.view addHUDLabelView:IsEnglish ? @"Please select the heart rate" : @"请选择心率" Image:nil afterDelay:2.0f];
        return NO;
    }else{
        return YES;
    }
    
}
#pragma mark 保存添加成员信息
 //保存操作
- (IBAction)saveUserMemberDataAction {
    
    if (_memberType == 0) {
        if ([self isValueData]) {
            
            NSInteger roleid = [DataVesselObj shareInstance].roleid;
            NSDictionary *dic = @{
                                  langType:language,
                                  @"uid":USERID,
                                  @"roleid":@(roleid),
                                  @"sys":_arrValueNum[0][@"sys"],
                                  @"dia":_arrValueNum[0][@"dia"],
                                  @"pul":_arrValueNum[0][@"pul"],
                                  @"time":_timeYear};
            LOG(@"dic = %@",dic);
            [self testDataFinishSaveAction:dic];
        }
    }else{
        if ([DataVesselObj shareInstance].scanDevShow == 1) {
            NSInteger roleid = [DataVesselObj shareInstance].roleid;
            NSDictionary *dic = @{
                                  langType:language,
                                  @"uid":USERID,
                                  @"roleid":@(roleid),
                                  @"sys":_dicInfor[@"sys"],
                                  @"dia":_dicInfor[@"dia"],
                                  @"pul":_dicInfor[@"pul"],
                                  @"time":_timeYear};
             [self testDataFinishSaveAction:dic];
        }
    }
    
    
}

//重测
- (IBAction)backAgainAction {
    [self disMisVC];
     [[NSNotificationCenter defaultCenter] postNotificationName:refreshListNotificationCenter object:nil];
}

- (void)testDataFinishSaveAction:(NSDictionary *)dic
{
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)dic withURL:Api_RoleBluePost withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:refreshListNotificationCenter object:nil];
            [self.view addHUDLabelView:SaveSuccessd Image:nil afterDelay:2.0f];
            [self performSelector:@selector(disMisVC) withObject:nil afterDelay:1.f];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
    }];
}
#pragma mark pickerHeadButton

- (IBAction)cancelPickerViewAction {
    
    [self didHiddenPickerView];
}

- (IBAction)selectFinishPickerViewAction {
    
    if (_number1.length ==0) {
        _number1 = @"1";
    }
    NSMutableDictionary *dicNum = [NSMutableDictionary dictionary];
    if (_arrValueNum.count >0) {
        dicNum = _arrValueNum[0];
    }else{
        [_arrValueNum addObject:@{@"aaaaa":@(110)}];
    }
    
    //判断类型
    if ([_labTitle.text isEqualToString:SYS]) {
        [_btnValue1 setTitle:_number1 forState:UIControlStateNormal];
        
        [dicNum setObject:_number1 forKey:@"sys"];
        [_arrValueNum replaceObjectAtIndex:0 withObject:dicNum];
        
    }else if ([_labTitle.text isEqualToString:DIA])
    {
        [_btnValue2 setTitle:_number1 forState:UIControlStateNormal];
        [dicNum setObject:_number1 forKey:@"dia"];
        [_arrValueNum replaceObjectAtIndex:0 withObject:dicNum];
    }else{
        [_btnValue3 setTitle:_number1 forState:UIControlStateNormal];
        [dicNum setObject:_number1 forKey:@"pul"];
        [_arrValueNum replaceObjectAtIndex:0 withObject:dicNum];
    }
    
    [self showDataOrDraw:_arrValueNum];
    [self didHiddenPickerView];
}


#pragma mark 显示pickerView

- (void)showDatePickerView:(NSString *)title
{
    
    CGRect rect = _pickerViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _pickerViewBg.frame = rect;
    if (!_pickerViewBg.superview) {
        [self.view addSubview:_pickerViewBg];
    }
    
    _labTitle.text = title;
    _pickHeadView.backgroundColor = [Common getColor:@"4cb9c1"];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _pickerViewBg.frame;
        frame.origin.x = 0;
        frame.origin.y = HEIGHT(self.view) - _pickerViewBg.frame.size.height;
        _pickerViewBg.frame = frame;
    }];
    
    [_pickerViewData reloadAllComponents];
    
//    _imageHand.transform = CGAffineTransformMakeRotation(M_PI / 180.0f);
}
- (void)didHiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _pickerViewBg.frame;
        rect.origin.x = 0;
        rect.origin.y = SCREEN_HEIGHT;
        _pickerViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_pickerViewBg removeFromSuperview];
    }];
    
   
}

#pragma  mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arrNumber.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",_arrNumber[row]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _number1 = [NSString stringWithFormat:@"%@",_arrNumber[row]];

}


#pragma  mark 计算旋转角度
- (float)hypertensionRatioShowData:(NSInteger)value range:(NSInteger)i type:(BOOL)isHeight
{
    LOG(@"转到点数  = %d",value);

    //每格占得的单位
    float rangeH = 360 / 7;
    //高压值判断取值
    if (isHeight) {
        switch (i) {
            case 0:
            {
                if (value > 210) {
                    
                    return 6*rangeH;
                }else{
                    NSInteger v = value - 180;      //求取重度所占比例
                    return rangeH/30 * v + rangeH *5;
                }
            }
                break;
            case 1:
            {
                NSInteger v = value - 160;      //求取中度所占比例
                return rangeH/20 * v + rangeH *4;
            }
                break;
            case 2:
            {
                NSInteger v = value - 140;      //求取轻度所占比例
                return rangeH/20 * v + rangeH *3;
            }
                break;
            case 3:
            {
                NSInteger v = value - 120;      //求取正常所占比例
                return rangeH/20 * v + rangeH *2;
            }
                break;
            case 4:
            {
                NSInteger v = value - 90;      //求取理想所占比例
                return rangeH/30 * v + rangeH;
            }
                break;
            case 5:
            {
                //求取偏低所占比例
                return rangeH/90 * value;
            }
                break;
            default:
                break;
        }
    }else{
        switch (i) {
            case 0:
            {
                if (value >140) {
                    return 5*rangeH;
                }else{
                    NSInteger v = value - 110;      //求取重度所占比例
                    return rangeH/30 * v + rangeH *5;
                }
            }
                break;
            case 1:
            {
                NSInteger v = value - 100;      //求取中度所占比例
                return rangeH/10 * v + rangeH *4;
            }
                break;
            case 2:
            {
                NSInteger v = value - 90;      //求取轻度所占比例
                return rangeH/10 * v + rangeH *3;
            }
                break;
            case 3:
            {
                NSInteger v = value - 80;      //求取正常所占比例
                return rangeH/10 * v + rangeH *2;
            }
                break;
            case 4:
            {
                NSInteger v = value - 60;      //求取理想所占比例
                return rangeH/20 * v + rangeH *1;
            }
                break;
            case 5:
            {
                //求取偏低所占比例
                return rangeH/60 * value;
            }
                break;
                
            default:
                break;
        }
    }
    return 0.f;
}

- (void)showDataOrDraw:(NSArray *)arr
{
    NSDictionary *dicUser = arr[0];
    
    NSInteger X = [dicUser[@"dia"] integerValue];
    NSInteger Y = [dicUser[@"sys"] integerValue];
    LOG(@"X = %d Y = %d",X,Y);
    NSInteger        ratioX = 0;
    NSInteger        ratioY = 0;
    
    //低压
    if (X >= 60 && X < 80) {            //理想
        ratioX = 4;
    } else if (X >= 80 && X < 90) {     //正常
        ratioX = 3;
    } else if (X >= 90 && X < 100) {    //轻度
        ratioX = 2;
    } else if (X >= 100 && X < 110) {   //中度
        ratioX = 1;
    } else if (X >= 110) {              //重度
        ratioX = 0;
    } else if (X < 60) {               //偏低
        ratioX = 5;
    }
    
    //高压
    if (Y >= 90 && Y < 120) {
        ratioY = 4;
    } else if (Y >= 120 && Y < 140) {
        ratioY = 3;
    } else if (Y >= 140 && Y < 160) {
        ratioY = 2;
    } else if (Y >= 160 && Y < 180) {
        ratioY = 1;
    } else if (Y >= 180) {
        ratioY = 0;
    } else if (Y < 90) {
        ratioY = 5;
    }
    
    CGFloat endValue = ratioX <= ratioY ? ratioX : ratioY;
    if (ratioY == endValue) {//以高压值判断
        float value = 0;
        if (Y ==0) {
            value = X;
        }else{
            value = Y;
        }
        float valueV =  [self hypertensionRatioShowData:value range:endValue type:YES];
        [self beginRotateAngle:valueV];
        
    }else{
        float value = [self hypertensionRatioShowData:X range:endValue type:NO];
        [self beginRotateAngle:value];
    }
    
    [self showSphyValueText:endValue];
}
/**
 *  显示血压状态值
 *
 */
- (void)showSphyValueText:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            _labText.text = Severe;
            _labScrContent.text = STATUS_5;
            CGFloat labH = [self labelTextHeitht:STATUS_5];
            _labScrContent.frame = CGRectMake(X(_labScrContent), Y(_labScrContent), WIDTH(_labScrContent), labH);
            [self hypertensionAwoke];
        }
           break;
        case 1:
        {
            _labText.text = Moderate;
            _labScrContent.text = STATUS_4;
            CGFloat labH = [self labelTextHeitht:STATUS_4];
            _labScrContent.frame = CGRectMake(X(_labScrContent), Y(_labScrContent), WIDTH(_labScrContent), labH);
        }
            break;
        case 2:
        {
            _labText.text = Mild;
            _labScrContent.text = STATUS_3;
            CGFloat labH = [self labelTextHeitht:STATUS_3];
            _labScrContent.frame = CGRectMake(X(_labScrContent), Y(_labScrContent), WIDTH(_labScrContent), labH);
        }
            break;
        case 3: {
            _labText.text = Normal;
            _labScrContent.text = STATUS_2;
            CGFloat labH = [self labelTextHeitht:STATUS_2];
            _labScrContent.frame = CGRectMake(X(_labScrContent), Y(_labScrContent), WIDTH(_labScrContent), labH);
        }
            break;
        case 4: {
            _labText.text = Optimal;
            _labScrContent.text = STATUS_1;
            CGFloat labH = [self labelTextHeitht:STATUS_1];
            _labScrContent.frame = CGRectMake(X(_labScrContent), Y(_labScrContent), WIDTH(_labScrContent), labH);
        }
            break;
        case 5:
        {
            _labText.text = Low;
            _labScrContent.text = STATUS_0;
            CGFloat labH = [self labelTextHeitht:STATUS_0];
            _labScrContent.frame = CGRectMake(X(_labScrContent), Y(_labScrContent), WIDTH(_labScrContent), labH);
            [self hypertensionAwoke];
        }
            break;
        default:
            break;
    }
}
//高血压提醒
- (void)hypertensionAwoke
{
    NSInteger isON = [[SavaData shareInstance] printDataInteger:@"ISON"];
    if (isON == 1 || _dicInfor.allKeys.count == 0) {
        return;
    }
    [[[UIAlertView alloc] initWithTitle:nil message:IsEnglish ? @"Blood pressure is abnormal, please turn to your doctor" : @"您的血压已超标,请及时就医" delegate:nil cancelButtonTitle:Verify otherButtonTitles:nil, nil] show];
}

- (void)beginRotateAngle:(float)value
{
    _imageHand.transform = CGAffineTransformMakeRotation(value* (M_PI / 180.0f));
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)labelTextHeitht:(NSString *)str
{
    CGSize size =[str sizeWithFont:[UIFont systemFontOfSize:isiPhone5 ? 18.0f : 15.f] constrainedToSize:CGSizeMake(280, 200) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height<40 ? 50 : size.height+20;
}
@end
