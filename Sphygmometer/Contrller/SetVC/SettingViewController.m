//
//  SettingViewController.m
//  Sphygmometer
//
//  Created by gugu on 14-5-13.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "SettingViewController.h"
#import "SetCell.h"
#import "AwokeViewController.h"
#import "LoginViewController.h"
#import "UnitsViewController.h"
#import "AppDelegate.h"
#import "WEBViewController.h"
#import "IdeaViewController.h"
#import "PushNewsViewController.h"

@interface SettingViewController ()<UIAlertViewDelegate>
{
    UISwitch       *_switchV;
    
    NSString        *urlApp;
}
@end

@implementation SettingViewController

@synthesize setTable = _setTable;
@synthesize dataDic = _dataDic;

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
    
    self.backBtn.hidden = YES;
	
    self.navTitleLable.text = IsEnglish ? @"Setting" : @"设置";
    
    [self initTableData];
    
}

#pragma mark --

- (void) initView{
    _setTable = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), CommonViewHeight(self.view)) style: UITableViewStyleGrouped];
    _setTable.backgroundColor = [UIColor clearColor];
    _setTable.backgroundView = nil;
    _setTable.delegate = self;
    _setTable.dataSource = self;
    [self.view addSubview: _setTable];

}

#pragma mark 初使化数据
- (void) initTableData{
    _dataDic = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dic = [SavaData parseDicFromFile:User_File];
    
    NSArray *firstArray = @[
                            dic[@"user_account"],
                            dic[@"user_name"],
                            Remind];
    
    NSArray *secondArray = IsEnglish ? @[@"SYS Warn",
                                         @"News update",
                                         @"Unit",
                                         @"Product information",
                                         @"Clean up cache",
                                         @"Instructions & help",
                                         @"About us",
                                         @"Feedback",
                                         @"Check and Update"
                                         ] : @[
                             @"高血压提醒",
                             @"要闻推送",
                             @"单位",
                             @"产品信息",
                             @"清除缓存",
                             @"使用帮助",
                             @"关于我们",
                             @"意见反馈",
                             @"检查更新"];
    
    [_dataDic setObject: firstArray forKey: @"0"];
    
    [_dataDic setObject: secondArray forKey: @"1"];
    
    [_setTable reloadData];

}
- (void)touchClickSwich:(UISwitch *)S
{
    NSLog(@"S.isOn = %d",S.isOn);
    
    [[SavaData shareInstance] savaDataInteger:!S.isOn KeyString:@"ISON"];
}
- (UISwitch *)firstCellSwitch
{
    if (_switchV == nil) {
        _switchV = [[UISwitch alloc] initWithFrame:CGRectMake(kIsIOS7 ? 260 : 210, 8, 60, 35)];
        _switchV.on = YES;
        [_switchV addTarget:self action:@selector(touchClickSwich:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchV;
    
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *tempArray = [_dataDic objectForKey: [NSString stringWithFormat: @"%ld",(long)section]];
    
    return tempArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *memberIndentified = @"memberindentified";
    
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier: memberIndentified];
    
    if (cell == nil) {
        cell = [[SetCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: memberIndentified];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSMutableArray *tempArray = [_dataDic objectForKey: [NSString stringWithFormat: @"%ld",(long)indexPath.section]];
    
    cell.nameLable.text = [tempArray objectAtIndex: indexPath.row];
     cell.detailImg.hidden = YES;
    if (indexPath.section ==0 ) {
        if (indexPath.row ==1) {
        }else{
            cell.detailImg.image = [UIImage imageNamed: @"设置箭头.png"];
            cell.detailImg.hidden = NO;
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[self firstCellSwitch]];
    }else if (indexPath.section ==1 && indexPath.row == 4){
        cell.detailImg.hidden = NO;
        //删除图标
        cell.detailImg.image = [UIImage imageNamed: @"设置删除.png"];
    }else{
        cell.detailImg.hidden = NO;
        cell.detailImg.image = [UIImage imageNamed: @"设置箭头.png"];
    }
    
    return cell;
    
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{            //退出登录
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:IsEnglish ? @"Are you sure to log out?": @"请问您确定退出登录吗？" delegate:self cancelButtonTitle:Cancel otherButtonTitles:Verify, nil];
                    alert.tag = 50;
                    [alert show];
                     break;
                }
                    
                case 1:break;
                case 2:
                {//提醒
                    AwokeViewController *awokeVC = [[AwokeViewController alloc] initWithNibName:@"AwokeViewController" bundle:nil];
                    awokeVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:awokeVC animated: YES];
                }
                    break;
                   
                    
                default:
                    break;
            }
        
            break;
        }
            
        case 1:{
            switch (indexPath.row) {
                case 0:
                {//高血压提醒
                    
                }
                    break;
                case 1:
                {//推送要闻
                    [self pushNews];
                }
                    break;
                case 2:
                {   //单位
                    UnitsViewController *unitsVC  = [[UnitsViewController alloc] initWithNibName:@"UnitsViewController" bundle:nil];
                    unitsVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:unitsVC animated: YES];
                }
                    break;
                case 3:
                {//产品信息
                    NSString *strUrl = [NSString stringWithFormat:@"%@datum/datum_product.php",PHP_URL];
                    [self webViewPageVC:strUrl title:IsEnglish ? @"Product information" : @"产品信息"];
                }
                    break;
                case 4:
                {//清除缓存
                     [self.view addHUDLabelView:IsEnglish ? @"Clear the cache successfully" : @"清除缓存成功" Image:nil afterDelay:2.0f];
                }
                    break;
                case 5:
                {//使用帮助
                    NSString *strUrl = [NSString stringWithFormat:@"%@datum/datum_help.php",PHP_URL];
                    [self webViewPageVC:strUrl title:IsEnglish ? @"Instructions & help" : @"使用帮助"];
                }
                    break;
                case 6:
                {//关于我们
                    NSString *strUrl = [NSString stringWithFormat:@"%@datum/datum_about.php",PHP_URL];
                    [self webViewPageVC:strUrl title:IsEnglish ? @"About us" : @"关于我们"];
                }
                    break;
                case 7:
                {//意见反馈
                    IdeaViewController *ideaVC = [[IdeaViewController alloc] initWithNibName:@"IdeaViewController" bundle:nil];
                    ideaVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:ideaVC animated:YES];
                    
                }
                    break;
                case 8:
                {
                    [self.view addHUDActivityView:Loading];
                    
                    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    LOG(@"version = %@",version);
                    
                    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"system":@(2),@"number":version} withURL:Api_Version withType:POST completed:^(id content, ResponseType responseType) {
                        [self.view removeHUDActivityView];
                        
                        if (responseType == SUCCESS)
                        {
                            LOG(@"data = %@",content[@"data"]);
                            urlApp = [[NSString stringWithFormat:@"%@",content[@"data"][@"url"]] copy];
                            NSString *strNum = [NSString stringWithFormat:@"%@%@",IsEnglish ? @"A new version ... is available" : @"发现新版本为：",content[@"data"][@"number"]];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IsEnglish ? @"Version update notice:": @"版本更新提示：" message:strNum delegate:self cancelButtonTitle:Cancel otherButtonTitles:Verify, nil];
                            alert.tag = 100;
                            [alert show];
                        } else if (responseType == FAIL) {
                            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
                        }
                        
                    }];
                }
                    break;
                default:
                    break;
            }
            break;
        }
            
            
        default:
            break;
    }
    
}
- (void)pushNews
{
    PushNewsViewController *pushNewsVC = [[PushNewsViewController alloc] initWithNibName:@"PushNewsViewController" bundle:nil];
    pushNewsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushNewsVC animated:YES];
}
- (void)webViewPageVC:(NSString *)html title:(NSString *)title
{
    WEBViewController *webViewVC = [[WEBViewController alloc] init];
    webViewVC.webUrl = html;
    webViewVC.titleName = title;
    webViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewVC animated:YES];
    
}
#pragma mark --AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlApp]];
        }
    }else{
        if (buttonIndex == 1) {
            
            [DataVesselObj clearUserInfo];
            
            //切换回登陆界面
            [[AppDelegate getAppDelegate] showLoginVC];
            
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
