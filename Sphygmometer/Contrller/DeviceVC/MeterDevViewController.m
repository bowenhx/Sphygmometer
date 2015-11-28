//
//  MeterDevViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-19.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "MeterDevViewController.h"
#import "MeterDevViewCell.h"
#import "FindDeviceViewController.h"
#import "InputDeviceNumViewController.h"
#import "UIImageView+WebCache.h"


@interface MeterDevViewController ()<ZBarReaderDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
     ZBarReaderViewController *_reader;
    
    IBOutlet UIView *_viewPickerBg;
    
    __weak IBOutlet UIPickerView *_pickerView;
    
    __weak IBOutlet UIView *_viewHead;
    __weak IBOutlet UILabel *_labTitle;
    
    NSMutableArray     *_arrUserInfo;
    
    NSString   *_userStr;
    NSInteger   _userIndex;  //标记成员
    NSInteger   _userType; //区分AB
    NSInteger   _roleid;    //角色id
    
    BOOL _isShow;
}
@end

@implementation MeterDevViewController

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
    self.navTitleLable.text = IsEnglish ? @"Detecting device": @"测量设备";
    self.rightbtn.hidden = NO;
    [self.rightbtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    
    _arrUserInfo = [[NSMutableArray alloc] initWithArray:[SavaData parseArrFromFile:UserMemberList]];
    
    _userIndex= 0;
    _isShow = YES;
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.arrData setArray:[[SavaData shareInstance] printDataAry:DeviceSN_Code]];
    
    if (_isShow) {
        [self relodSNCodeRequest];
        _isShow = NO;
    }
    [self.baseTableView reloadData];
}
- (void)relodSNCodeRequest
{
    //把SN码提交服务器
    
    if (self.arrData.count) {
        [self.view addHUDActivityView:Loading];
        
        [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"uid":USERID,@"sn":self.arrData[self.arrData.count-1][@"SNcode"],@"mode":@(1)} withURL:Api_Scanning withType:POST completed:^(id content, ResponseType responseType) {
            [self.view removeHUDActivityView];
            
            if (responseType == SUCCESS)
            {
                LOG(@"data = %@",content[@"data"]);
                
                [self saveSNCodeFinle:content[@"data"]];
                
            } else if (responseType == FAIL) {
                [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
            }
        }];
    }
    
}
- (void)saveSNCodeFinle:(NSDictionary *)dicName
{
    //存入本地
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[SavaData shareInstance] printDataAry:DeviceSN_Code]];
    NSMutableDictionary *dicSN = [NSMutableDictionary dictionaryWithDictionary:arr[arr.count-1]];
    
    [dicSN setObject:dicName[@"A_rolename"] forKey:@"A_rolename"];
    [dicSN setObject:dicName[@"B_rolename"] forKey:@"B_rolename"];
    [dicSN setObject:dicName[@"type"] forKey:@"type"];
    [dicSN setObject:dicName[@"thumb"] forKey:@"thumb"];
    
    [arr replaceObjectAtIndex:arr.count-1 withObject:dicSN];
    [[SavaData shareInstance] savaArray:arr KeyString:DeviceSN_Code];
    
    [self.baseTableView reloadData];
}


- (void)tapRightBtn
{
    _reader = [ZBarReaderViewController new];
    _reader.readerDelegate = self;
    _reader.sourceType = UIImagePickerControllerSourceTypeCamera;
    _reader.supportedOrientationsMask = UIInterfaceOrientationPortrait;
    _reader.showsZBarControls = NO;
    _reader.readerView.torchMode = 0;//关闭闪光灯
    _reader.wantsFullScreenLayout = NO;
    _reader.showsZBarControls = NO;
//    _reader.enableCache = YES;
    
    
    for (UIView *temp in [_reader.view subviews]) {
        
        for (UIButton *button in [temp subviews]) {
            
            if ([button isKindOfClass:[UIButton class]]) {
                
                [button removeFromSuperview];
                
            }
            
        }
        
        for (UIToolbar *toolbar in [temp subviews]) {
            
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                
                [toolbar setHidden:YES];
                
                [toolbar removeFromSuperview];
                
            }
            
        }
        
    }

    
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];

//    aView.layer.borderWidth = 1;
//    aView.layer.borderColor = [UIColor redColor].CGColor;
    if (isiPhone5) {
        aView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_scan_codeBg"]];
    }else{
        aView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_scan_codeBg4"]];
    }
    

    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 5, 40, 37);
    [backBtn setImage:[UIImage imageNamed:@"返回箭头绿色.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(disMisAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView: backBtn];
    left.style = UIBarButtonItemStylePlain;
    _reader.navigationItem.leftBarButtonItem = left;
    
    //标题
    UILabel *bartitlelable = [[UILabel alloc] initWithFrame: CGRectMake(80, 20, 160, 24)];
    bartitlelable.backgroundColor = [UIColor clearColor];
    bartitlelable.font = GETBOLDFONT(22.0);
    bartitlelable.textColor = [UIColor blackColor];
    bartitlelable.textAlignment = NSTextAlignmentCenter;
    bartitlelable.text = IsEnglish ? @"Searching Devices": @"设备扫描";
    _reader.navigationItem.titleView = bartitlelable;
    
    
    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 290, 50)];
    labText.font = [UIFont systemFontOfSize:14];
    labText.textColor = [UIColor darkGrayColor];
    labText.numberOfLines = 0;
    labText.text = IsEnglish ? @"Scan the QR code by smart phone and the software will identify it automatically": @"      将产品标贴上的二维码至于矩形框内，离手机镜头10cm左右，软件会自动识别";
    [aView addSubview:labText];
    
    UIButton *btnAddSNCode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddSNCode.frame = CGRectMake(20, HEIGHT(self.view)-80, 280, 50);
    [btnAddSNCode setTitle:IsEnglish ? @"If the QR code can not be identified, please enter the SN code manually" : @"扫描不到？手动输入SN码" forState:UIControlStateNormal];
    btnAddSNCode.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnAddSNCode setBackgroundImage:[UIImage imageNamed:@"扫描-按钮.png"] forState:UIControlStateNormal];
    [btnAddSNCode setBackgroundImage:[UIImage imageNamed:@"扫描-按钮-1.png"] forState:UIControlStateHighlighted];
    
    [btnAddSNCode addTarget:self action:@selector(didSelectInputDeviceCode) forControlEvents:UIControlEventTouchUpInside];
    
    [aView addSubview:btnAddSNCode];
 
    if (isiPhone5 == NO) {
        CGRect btnFrame = btnAddSNCode.frame;
        btnFrame.origin.y += 20;
        btnAddSNCode.frame = btnFrame;
    }
    
//    _line=[[UIImageView alloc] initWithFrame:CGRectMake(49, 100, 221, 10)];
//    [_line setImage:[UIImage imageNamed:@"ic_sweep_line"]];
//    [aView addSubview:_line];
//
//    if (version >= 7.0) {
//        _line.frame = CGRectMake(49,100,221,10);
//    }
    
    _reader.cameraOverlayView = aView;

    ZBarImageScanner *scanner = _reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self.navigationController pushViewController: _reader animated: YES];
    
    
//    FindDeviceViewController *findDeviceVC = [[FindDeviceViewController alloc] initWithNibName:@"FindDeviceViewController" bundle:nil];
//    UINavigationController *navFind = [[UINavigationController alloc] initWithRootViewController:findDeviceVC];
//    [self presentViewController:navFind animated:NO completion:nil];
}

-(void)handletheToolBar:(ZBarReaderViewController *)reader{
    
}

- (void)disMisAction
{
    [self.navigationController popViewControllerAnimated: YES];
}
- (void)didSelectInputDeviceCode
{
    InputDeviceNumViewController *inputDeviceVC = [[InputDeviceNumViewController alloc] initWithNibName:@"InputDeviceNumViewController" bundle:nil];
    [self.navigationController pushViewController:inputDeviceVC animated:YES];
}

#pragma mark  ImagePickerController

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
- (void)imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
     if (reader.sourceType == UIImagePickerControllerSourceTypeCamera){
     
         id<NSFastEnumeration> results =
         [info objectForKey: ZBarReaderControllerResults];
         ZBarSymbol *symbol = nil;
         for(symbol in results)
             break;
//         NSDictionary *dict=[symbol.data objectFromJSONString];
         LOG(@"dict = %@",symbol.data);
         InputDeviceNumViewController *inputDeviceVC = [[InputDeviceNumViewController alloc] initWithNibName:@"InputDeviceNumViewController" bundle:nil];
         inputDeviceVC.strCode = symbol.data;
         [self.navigationController pushViewController:inputDeviceVC animated:YES];
     }
}

#define mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineString = @"defineString";
    MeterDevViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeterDevViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.labTextTitle.textColor = [Common getColor:@"4cb9c1"];
    cell.btnDelete.tag = indexPath.section;
    cell.btnAddUser.tag = indexPath.section;
    cell.btnAddUserB.tag = indexPath.section;
    [self showLoadMeterDevViewCell:cell cellForRowInSection:indexPath];
    
    
    [cell.btnDelete addTarget:self action:@selector(didDeleteCellData:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAddUser addTarget:self action:@selector(didUserInfoDataA:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAddUserB addTarget:self action:@selector(didUserinfoDataB:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
#define  BLOOD  IsEnglish ? @"Digital blood pressure monitor" : @"电子血压计"
- (void)showLoadMeterDevViewCell:(MeterDevViewCell *)cell cellForRowInSection:(NSIndexPath *)indexPath
{
    [cell.imageMeter sd_setImageWithURL:self.arrData[indexPath.section][@"thumb"] placeholderImage:[UIImage imageNamed:@"deviceslist_icon_B02G"]];
    
    cell.labTextTitle.text = [NSString stringWithFormat:@"%@（%@）",BLOOD,self.arrData[indexPath.section][@"type"]];
    
    cell.labNSCodeNum.text = self.arrData[indexPath.section][@"SNcode"];
    
    NSString *a_roleName = self.arrData[indexPath.section][@"A_rolename"];
    NSString *b_roleNmae = self.arrData[indexPath.section][@"B_rolename"];
    if ([self isTitleBlank:a_roleName]) {
        [cell.btnAddUser setImage:[UIImage imageNamed:@"meterDev_Add.png"] forState:UIControlStateNormal];
    }else{
        [cell.btnAddUser setImage:nil forState:UIControlStateNormal];
        [cell.btnAddUser setTitle:a_roleName forState:UIControlStateNormal];
    }
    
    if ([self isTitleBlank:b_roleNmae]) {
        [cell.btnAddUserB setImage:[UIImage imageNamed:@"meterDev_Add.png"] forState:UIControlStateNormal];
    }else{
        [cell.btnAddUserB setImage:nil forState:UIControlStateNormal];
        [cell.btnAddUserB setTitle:b_roleNmae forState:UIControlStateNormal];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary *dic = self.arrData[section];
    
    if ([self isTitleBlank:dic[@"A_rolename"]] || [self isTitleBlank:dic[@"B_rolename"]]) {
        return 50;
    }else{
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
//    footView.layer.borderWidth = 1;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 12, 12)];
    img.image = [UIImage imageNamed:@"感叹"];
    [footView addSubview:img];
    
    
    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(WIDTHADDX(img), 0, 290, 50)];
//    labText.layer.borderWidth = 1;
    labText.textColor = [UIColor darkGrayColor];
    labText.font = [UIFont systemFontOfSize:13];
    labText.numberOfLines = 0;
    [footView addSubview:labText];
    
   NSDictionary *dic = self.arrData[section];
   
    if ([self isTitleBlank:dic[@"A_rolename"]]) {
        if ([self isTitleBlank:dic[@"B_rolename"]]) {
            labText.text = IsEnglish ? @"Please bind an user, if not, the measurement data can not be upload": @"请绑定用户，如果未绑定，测量数据将无法上传!";
        }else{
            labText.text = IsEnglish ? @"Please bind an user (Two users can be binded in one device, if one device is used by only one user,  A/B is suggested to binded with this user) to make sure all date can be uploaded.": @"请绑定用户（可以绑定两个不同用户，如果只有一个用户使用，建议将A/B同时绑定该用户）以确保所有数据都能上传！";
        }
        
    }else
    {
        if ([self isTitleBlank:dic[@"B_rolename"]])
        {
            labText.text = IsEnglish ? @"Please bind an user (Two users can be binded in one device, if one device is used by only one user,  A/B is suggested to binded with this user) to make sure all date can be uploaded.": @"请绑定用户（可以绑定两个不同用户，如果只有一个用户使用，建议将A/B同时绑定该用户）以确保所有数据都能上传！";
        }else{
            
        }
    }
    return footView;
}

#pragma  添加绑定成员信息
- (void)didUserInfoDataA:(UIButton *)btn
{
    _userIndex = btn.tag;
    _userType = 0;
    [self showDatePickerView];
    
}
- (void)didUserinfoDataB:(UIButton *)btn
{
    _userIndex = btn.tag;
    _userType = 1;
    [self showDatePickerView];
}
#pragma 删除数据
- (void)didDeleteCellData:(UIButton *)btn
{
    [self.arrData removeObjectAtIndex:btn.tag];
    [[SavaData shareInstance] savaArray:self.arrData KeyString:DeviceSN_Code];
    [self.baseTableView reloadData];
}

#pragma mark 选择picker 信息完成操作

- (IBAction)didSelectPickerViewFinsh {
    if (_userStr.length >0) {
        //选择绑定成员完成
        NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:self.arrData[_userIndex]];
        if (_userType ==0) {
            //A用户
            [dicUser setObject:_userStr forKey:@"A_rolename"];
        }else{
            [dicUser setObject:_userStr forKey:@"B_rolename"];
        }
        
        [self.arrData replaceObjectAtIndex:_userIndex withObject:dicUser];
        [self.baseTableView reloadData];
        [[SavaData shareInstance] savaArray:self.arrData KeyString:DeviceSN_Code];
        [self addMeterDeviceActionUser];
        
        [self didHiddenPickerView];
    }else{
          [self.view addHUDLabelView:IsEnglish ? @"User is not indentified, please select again": @"不确定你选择的用户，请重选" Image:nil afterDelay:2.0f];
    }
    
    
}

- (IBAction)cancelPickViewOrHidden {
    [self didHiddenPickerView];
}

#pragma mark 绑定测试血压计成员信息
- (void)addMeterDeviceActionUser
{
    NSString *typeUser = @"A";
    if (_userType == 1) {
        typeUser = @"B";
    }
    NSDictionary *dic = @{langType:language,
                          @"uid":USERID,
                          @"roleid":@(_roleid),
                          @"type":typeUser,
                          @"sncode":self.arrData[_userIndex][@"SNcode"]
                        };
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)dic withURL:Api_RoleBinding withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);

            [self.view addHUDLabelView:SaveSuccessd Image:nil afterDelay:2.0f];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
    }];
}
#pragma mark 显示pickerView

- (void)showDatePickerView
{
    CGRect rect = _viewPickerBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _viewPickerBg.frame = rect;
    if (!_viewPickerBg.superview) {
        [self.view addSubview:_viewPickerBg];
    }
    

    _viewHead.backgroundColor = [Common getColor:@"4cb9c1"];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _viewPickerBg.frame;
        frame.origin.x = 0;
        frame.origin.y = HEIGHT(self.view) - _viewPickerBg.frame.size.height;
        _viewPickerBg.frame = frame;
    }];
    
    [_pickerView reloadAllComponents];
    

}
- (void)didHiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _viewPickerBg.frame;
        rect.origin.x = 0;
        rect.origin.y = SCREEN_HEIGHT;
        _viewPickerBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_viewPickerBg removeFromSuperview];
    }];
    
    
}

#pragma  mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arrUserInfo.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _arrUserInfo[row][@"name"];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _userStr = [[NSString stringWithFormat:@"%@",_arrUserInfo[row][@"name"]] copy];
    _roleid = [_arrUserInfo[row][@"roleid"] integerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
