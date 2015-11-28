//
//  LoginViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-16.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewCell.h"
#import "RegisterViewController.h"
#import "HomeTabBarController.h"
#import "BaiduLoginViewController.h"

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UIView *_viewFoot;
    
    
    __weak IBOutlet UIButton *_btnRegister;
    __weak IBOutlet UIButton *_btnBaiduLogin;
    
    __weak IBOutlet UIImageView *_imageLine;
    
    
    UITextField         *_textField;
    
}
@property (nonatomic , strong) NSMutableDictionary     *dicInfo;
@end

@implementation LoginViewController

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
    self.backBtn.hidden = YES;
    self.navTitleLable.text = IsEnglish ? @"Login": @"登录";
    
     _tableView.tableFooterView = _viewFoot;
    
    
    [self initView];
   
    //账户信息字典
    self.dicInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    //这里注册通知，当注册成功后，返回触发登录操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFinish:) name:RegisterFinishNotificationCenter object:nil];
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
- (void)initView
{

    if (kIsIOS7) {
        _imageLine.hidden = NO;
    }
    [_btnRegister setTitleColor:[Common getColor:@"24b3be"] forState:UIControlStateNormal];
    [_btnBaiduLogin setTitleColor:[Common getColor:@"24b3be"] forState:UIControlStateNormal];
    
}
- (void)registerFinish:(NSNotification *)infor
{
    [self.dicInfo setDictionary:[infor object]];
    
    [_tableView reloadData];
    
    [self beginLoginAction];
}

- (IBAction)didSelectLoginAction:(UIButton *)sender {
    [self resignKeyboard];
    if ([self isTitleBlank:_dicInfo[@"account"]]) {
        [self.view addHUDLabelView:IsEnglish ? @"Please enter email add or mobile phone number": @"请输入账号" Image:nil afterDelay:2.0f];
    }else if ([self isTitleBlank:_dicInfo[@"password"]])
    {
        [self.view addHUDLabelView:IsEnglish ? @"Enter the pass word": @"请输入密码" Image:nil afterDelay:2.0f];
    }else{
         [self beginLoginAction];
    }
   
}
- (IBAction)didSelectRegisterAction:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
- (IBAction)didSelectBaiduCloudAction:(UIButton *)sender {
    
    BaiduLoginViewController * baiduLoginVC = [[BaiduLoginViewController alloc] initWithNibName:@"BaiduLoginViewController" bundle:nil];
    [self.navigationController pushViewController:baiduLoginVC animated:YES];
    
//    [[[UIAlertView alloc] initWithTitle:nil message:@"暂未开放该功能！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}
#pragma mark 开始登录
- (void)beginLoginAction
{
    [_dicInfo setObject:language forKey:langType];
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:_dicInfo withURL:Api_UserLogin withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            
            //保存用户ID
            NSString *userid = [NSString stringWithFormat:@"%@",content[@"data"][@"user_id"]];
            [[SavaData shareInstance] savadataStr:userid KeyString:USER_ID_SAVA];
            [[SavaData shareInstance] savaDataInteger:userid.integerValue KeyString:USER_ID_SAVA];;
            
            [SavaData setUserId:userid];
            //存入用户信息
            [SavaData writeDicToFile:content[@"data"] FileName:User_File];
            
            LOG(@"userid = %@--- userFile = %@",[SavaData getUserId],[SavaData parseDicFromFile:User_File]);
            
            [SavaData setUserInfoData:userid];
            
            NSLog(@"userINforid = %@",[SavaData getOutUserFile]);
            
            //进入主界面
             [HomeTabBarController showRootView];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
        
    }];
}
#pragma  mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineString = @"defineString";
    LoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LoginViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.delegate = self;
    }
    cell.textField.tag = indexPath.row;
    
    if (indexPath.row ==0) {
        NSString *account = _dicInfo[@"account"];
        cell.textField.placeholder = account.length >0 ? account : Email_Language;
    }else{
        NSString *password = _dicInfo[@"password"];
        cell.textField.placeholder = password.length >0 ?password : Password_Language;
        cell.textField.secureTextEntry = YES;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma  mark TextFiled
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _textField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![self isTitleBlank:textField.text]) {
        if (textField.tag ==0) {
            [_dicInfo setObject:textField.text forKey:@"account"];
        }else{
            [_dicInfo setObject:textField.text forKey:@"password"];
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.tag ==0) {
        [[_tableView viewWithTag:1] becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)resignKeyboard
{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
