//
//  FamilyViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-15.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "FamilyViewController.h"
#import "YFJLeftSwipeDeleteTableView.h"
#import "FamilyViewCell.h"
#import "DrawLineView.h"
#import "DataVesselObj.h"
#import "AddMemberViewController.h"
#import "NewlyMebViewController.h"
#import "WXApi.h"
#import "ShareViewController.h"
#import "UMSocialSnsPlatformManager.h"

#define TableWIDTH      210
#define USERROLOID    [DataVesselObj shareInstance]

@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView
{

    _btnWeixin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnWeixin.frame = CGRectMake(15, 20, 290, 44);
    [_btnWeixin setTitle:IsEnglish ? @"Share at Wechat": @"微信分享" forState:UIControlStateNormal];
    [_btnWeixin.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btnWeixin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnWeixin setBackgroundImage:[UIImage imageNamed:@"微信分享按钮.png"] forState:UIControlStateNormal];
    [_btnWeixin setBackgroundImage:[UIImage imageNamed:@"微信分享按钮-1.png"] forState:UIControlStateHighlighted];
    [self addSubview:_btnWeixin];
    
    _btnEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEmail.frame = CGRectMake(15, HEIGHTADDY(_btnWeixin)+10, 290, 44);
    [_btnEmail setTitle:IsEnglish ? @"Share at Sina Weibo": @"新浪微博分享" forState:UIControlStateNormal];
    [_btnEmail.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btnEmail setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnEmail setBackgroundImage:[UIImage imageNamed:@"微信分享按钮.png"] forState:UIControlStateNormal];
    [_btnEmail setBackgroundImage:[UIImage imageNamed:@"微信分享按钮-1.png"] forState:UIControlStateHighlighted];
    [self addSubview:_btnEmail];
    
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCancel.frame = CGRectMake(15, HEIGHTADDY(_btnEmail)+10, 290, 44);
    [_btnCancel setTitle:Cancel forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnCancel setBackgroundImage:[UIImage imageNamed:@"长按钮.png"] forState:UIControlStateNormal];
    [_btnCancel setBackgroundImage:[UIImage imageNamed:@"长按钮1.png"] forState:UIControlStateHighlighted];
    [self addSubview:_btnCancel];

}

@end

@interface FamilyViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    
     NSMutableArray     * _dataArray;
    
    DrawLineView        *_drawLineView;
    
    ShareView           *_showViewBg;
    
    
    UIImage             *_shareImage;
}
@property (nonatomic, strong) YFJLeftSwipeDeleteTableView * tableView;
@end

@implementation FamilyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navTitleLable.text = [DataVesselObj shareInstance].titleName;
    
    [self initLoadView];
    [self initLoadData];
    
    /**
     *  添加成员信息通知处理
     *
     */
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshTabList) name:refreshListNotificationCenter object:nil];
    
    /**
     *  点击详情查看通知
     *
     */
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(pushDetail:) name:SelectDetailNotificationCenter object:nil];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
   

}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)initLoadView
{
    
    self.rightbtn.hidden = NO;
    UIImage *rightImage = [UIImage imageNamed: @"family_share_image"];
//    UIImage *rightImage2 = [UIImage imageNamed:@"设备连接点击"];
    self.rightbtn.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    [self.rightbtn setBackgroundImage:rightImage forState:UIControlStateNormal];
//    [self.rightbtn setBackgroundImage:rightImage2 forState:UIControlStateSelected];
    
    
    UIButton *btnGraph = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGraph.frame = CGRectMake(5, HEIGHT(self.view)- 44-(kIsIOS7?64:44), 152, 44);
    [btnGraph setBackgroundImage:[UIImage imageNamed:@"分享按钮.png"] forState:UIControlStateNormal];
    [btnGraph setBackgroundImage:[UIImage imageNamed:@"分享按钮-1.png"] forState:UIControlStateHighlighted];
    [btnGraph setTitle:IsEnglish ? @"Chart": @"图表" forState:UIControlStateNormal];
    [self.view addSubview:btnGraph];
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectOffset(btnGraph.frame, WIDTHADDX(btnGraph), 0);
    [btnAdd setBackgroundImage:[UIImage imageNamed:@"编辑按钮.png"] forState:UIControlStateNormal];
    [btnAdd setBackgroundImage:[UIImage imageNamed:@"编辑按钮-1.png"] forState:UIControlStateHighlighted];
    [btnAdd setTitle:IsEnglish ? @"Add" : @"添加" forState:UIControlStateNormal];
    [self.view addSubview:btnAdd];
    
    _drawLineView = [[DrawLineView alloc] initWithFrame:CGRectMake(5, 0, WIDTH(self.view)-5, 200)];
//    _drawLineView.layer.borderWidth = 1;
//    _drawLineView.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:_drawLineView];
    
    
    _tableView = [[YFJLeftSwipeDeleteTableView alloc] initWithFrame:CGRectMake(0, HEIGHTADDY(_drawLineView), WIDTH(self.view),HEIGHT(self.view)-HEIGHTADDY(_drawLineView)-44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.layer.borderWidth = 1;
    [self.view addSubview:_tableView];
    

   
    [btnGraph addTarget:self action:@selector(didSelectGraphAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd addTarget:self action:@selector(didSelectAddAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _showViewBg = [[ShareView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220, WIDTH(self.view), 220)];

    _showViewBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_image_scrobg"]];
    _showViewBg.alpha = 1;
}
#pragma mark 分享按钮
- (void)tapRightBtn
{
    _shareImage = [DataVesselObj getImageUIScreenFromViewBg];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.view.alpha = 0.7;
    _drawLineView.userInteractionEnabled = NO;
    [self showShareViewBg];
}

- (void)showShareViewBg
{
    
    CGRect rect = _showViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _showViewBg.frame = rect;
    if (!_showViewBg.superview) {
        [self.view addSubview:_showViewBg];
    }
    
    [_showViewBg.btnWeixin addTarget:self action:@selector(didShareWeixin) forControlEvents:UIControlEventTouchUpInside];
    [_showViewBg.btnEmail addTarget:self action:@selector(didShareWiebo) forControlEvents:UIControlEventTouchUpInside];
    [_showViewBg.btnCancel addTarget:self action:@selector(didCancelShare) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _showViewBg.frame;
        frame.origin.x = 0;
        frame.origin.y = HEIGHT(self.view) - _showViewBg.frame.size.height;
        _showViewBg.frame = frame;
    }];
    
}
- (void)didHiddenShareViewBg
{
    self.view.backgroundColor = RGBCOLOR(237.0, 237.0, 237.0);
    self.view.alpha = 1.f;
    _drawLineView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _showViewBg.frame;
        rect.origin.x = 0;
        rect.origin.y = SCREEN_HEIGHT;
        _showViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_showViewBg removeFromSuperview];
    }];
    
    
}
#pragma 分享微信
- (void)didShareWeixin
{
    //是否安装微信
    if ([WXApi isWXAppInstalled] == NO || [WXApi isWXAppSupportApi] == NO) {
        [[[UIAlertView alloc]initWithTitle:IsEnglish ? @"Error": @"错误" message:IsEnglish ? @"wechat is not installed or the version doesn't support sharing": @"您还没有安装微信或者您的版本不支持分享功能!" delegate:self cancelButtonTitle:Verify otherButtonTitles:nil, nil]show];
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
    
    if (![WXApi sendReq:req]) {
        LOG(@"分享失败");
    }
    
}


- (void)didShareWiebo {
    
    NSString *shareText = IsEnglish ? @"Cigii Health Care Share" : @"实捷健康分享";        //分享内嵌文字
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:_shareImage socialUIDelegate:nil];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//    ShareViewController *shareViewController = [[ShareViewController alloc] init];
//    shareViewController.isTencent = NO;
//    //    UIImage *shareImage = [UIImage imageNamed: @"胎动心不透明.png"];
//    shareViewController.shareImage = _shareImage;
//    shareViewController.shareContent = IsEnglish ? @"Cigii Health Care Share" : @"实捷健康分享";
//    UINavigationController *shareNav = [[UINavigationController alloc] initWithRootViewController: shareViewController];
//    [self.navigationController presentViewController: shareNav animated: YES completion: nil];
    
    
    
    /*Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
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
- (void)openEmailView
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
    
}
- (void)didCancelShare
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


- (void)initLoadData
{
     _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [self showListData];
}
- (void)refreshTabList
{
    [self showListData];
//      [_drawLineView reloadDataViewLine];
}
- (void)showListData
{
    [_drawLineView reloadDataViewLine];
    [self.view addHUDActivityView:Loading];
    LOG(@"roleid = %d",USERROLOID.roleid);
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"uid":USERID,@"roleid":@(USERROLOID.roleid),@"size":@(1000)} withURL:Api_RoleHistory withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            if (_dataArray.count) {
                [_dataArray removeAllObjects];
            }
            [USERROLOID.arrData setArray:content[@"data"]];
            if (USERROLOID.arrData.count >7) {
                for (int i=0; i<7; i++) {
                    [_dataArray addObject:USERROLOID.arrData[i]];
                }
            }else{
                for (int i=0; i<USERROLOID.arrData.count; i++) {
                    [_dataArray addObject:USERROLOID.arrData[i]];
                }
            }
            
            
            //按时间取出最近七次进行排序由小到大排序，默认是由大到小
            [_dataArray setArray:[[_dataArray reverseObjectEnumerator] allObjects]];
            
            [_tableView setContentSize:CGSizeMake(WIDTH(self.view), _tableView.contentSize.height+70)];
            [_tableView reloadData];
            [_drawLineView showDataOrDraw:_dataArray];
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
    }];
}
//选择图表操作
- (void)didSelectGraphAction:(UIButton *)sender {
    NewlyMebViewController *newlyMebVC = [[NewlyMebViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newlyMebVC];
    

    [self.navigationController pushViewController:newlyMebVC animated:NO];
    
}
//选择添加操作
- (void)didSelectAddAction:(UIButton *)sender {
    
    [self pushAddMemberVC:0 detail:nil];
}
- (void)pushDetail:(NSNotification *)infor
{
    NSInteger index = [[infor object] integerValue];
    
    [self pushAddMemberVC:1 detail:_dataArray[index]];

}
- (void)pushAddMemberVC:(NSInteger)index detail:(NSDictionary *)dic
{
    [DataVesselObj shareInstance].scanDevShow = 0;
    AddMemberViewController *addMemberVC = [[AddMemberViewController alloc] initWithNibName:@"AddMemberViewController" bundle:nil];
    addMemberVC.memberType = index;
    addMemberVC.dicInfor = dic;
    [self presentViewController:addMemberVC animated:YES completion:nil];
    

}
#pragma  mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineString = @"defineString";
    FamilyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FamilyViewCell" owner:self options:nil]objectAtIndex:0];
    }
    [self showLoadDataFamilyViewCell:cell cellForRowInSection:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushAddMemberVC:1 detail:_dataArray[indexPath.row]];
}
- (void)showLoadDataFamilyViewCell:(FamilyViewCell *)cell cellForRowInSection:(NSIndexPath *)indexPath
{
    cell.labText.text = _dataArray[indexPath.row][@"val"];
    cell.labValuePercent.text = [NSString stringWithFormat:@"%@/%@",_dataArray[indexPath.row][@"sys"],_dataArray[indexPath.row][@"dia"]];
    cell.labValueNum.text = _dataArray[indexPath.row][@"pul"];
    cell.labValueTime.text = _dataArray[indexPath.row][@"time"];
    
    cell.imageStatus.image = [self showImageStatu:_dataArray[indexPath.row][@"val"]];
    
    
}
- (UIImage *)showImageStatu:(NSString *)text
{
//    LOG(@">>>>>>   text = %@",text);
    if ([text isEqualToString:Severe]) {
        return [UIImage imageNamed:@"重度"];
    }else if ([text isEqualToString:Moderate])
    {
        return [UIImage imageNamed:@"中度"];
    }else if ([text isEqualToString:Mild])
    {
        return [UIImage imageNamed:@"轻度"];
    }else if ([text isEqualToString:Normal])
    {
        return [UIImage imageNamed:@"正常"];
    }else if ([text isEqualToString:Optimal])
    {
        return [UIImage imageNamed:@"理想"];
    }else if ([text isEqualToString:Low])
    {
        return [UIImage imageNamed:@"偏低"];
    }
    return nil;
}
- (void)remoFamilyDataListUserInfo:(NSInteger)row
{
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"uid":USERID,@"roleid":@(USERROLOID.roleid),@"bid":_dataArray[row][@"bid"]} withURL:Api_RoleDeldata withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            
            [_dataArray removeObjectAtIndex:row];
 
            [_drawLineView showDataOrDraw:nil];

            [_tableView reloadData];
            [_drawLineView showDataOrDraw:_dataArray];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self remoFamilyDataListUserInfo:indexPath.row];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

