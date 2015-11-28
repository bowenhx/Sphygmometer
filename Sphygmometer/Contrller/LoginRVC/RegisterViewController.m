//
//  RegisterViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-16.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewCell.h"
#import "RegionViewController.h"
#import "DataVesselObj.h"
@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    __weak IBOutlet UIView *_viewBgSex;
    
    IBOutlet UIView *_datePickViewBg;
    __weak IBOutlet UIDatePicker *_pickerDate;
    __weak IBOutlet UIView *_headView;
    
    IBOutlet UIView *_footView;
    
    IBOutlet UITableView *_tableView;
    NSMutableDictionary  *_dicData;
    
    UITextField     *_myTextFiled;
    NSString    *_dateStr;
}
@end

@implementation RegisterViewController

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
    self.navTitleLable.text = IsEnglish ? @"Register": @"注册";
    
    [self initLoadView];
    
    _dicData = [[NSMutableDictionary alloc] init];
}
- (void)initLoadView
{
     [DataVesselObj shareInstance].cityIndex = 10;
    _tableView.tableFooterView = _footView;
    
    //这里注册通知，当选择县区完成后会触发，并修改区域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editCity:) name:CountySelectNSNotificationCenter object:nil];
}
//通知接收消息
- (void)editCity:(NSNotification *)infor
{
    NSDictionary *dicCity = [infor object];
    NSInteger countyID = [dicCity[@"countyID"] integerValue];
    [_dicData setObject:dicCity[@"name"] forKey:@"region"];
    [_dicData setObject:@(countyID) forKey:@"countyID"];
    [_tableView reloadData];
    
    [[SavaData shareInstance] savaDictionary:dicCity keyString:User_Family_City];
}
//选择男
- (IBAction)didSelectSexMamAction:(UIButton *)sender {
    [_dicData setObject:IsEnglish ? @"Male" : @"男" forKey:@"sex"];
    _viewBgSex.hidden = YES;
    [self refershTabViewPage];
    
}
//选择女
- (IBAction)didSelectSexWomanAction:(UIButton *)sender {
    [_dicData setObject:IsEnglish ? @"Female" : @"女" forKey:@"sex"];
    _viewBgSex.hidden = YES;
    [self refershTabViewPage];
    
}
//恢复tabView背景色
- (void)refershTabViewPage
{
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.alpha = 1.0f;
    _tableView.userInteractionEnabled = YES;
    [_tableView reloadData];
}

- (BOOL)userInfoFieldBlank
{
    if (_dicData.allKeys.count >0)  {
        if ([self isTitleBlank:_dicData[@"userID"]]) {
            [self.view addHUDLabelView:IsEnglish ? @"Please enter email add or mobile phone number": @"请输入邮箱或手机号码" Image:nil afterDelay:2.0f];
            return NO;
        }else if ([self isTitleBlank:_dicData[@"password"]])
        {
            [self.view addHUDLabelView:IsEnglish ? @"Enter the pass word": @"请输入密码" Image:nil afterDelay:2.0f];
            return NO;
        }else if (![_dicData[@"password"] isEqualToString:_dicData[@"password2"]])
        {
            [self.view addHUDLabelView:IsEnglish ? @"Not conformity for two times passwords": @"两次输入的密码不一致" Image:nil afterDelay:2.0f];
            return NO;
        }else if ([self isTitleBlank:_dicData[@"name"]])
        {
            [self.view addHUDLabelView:IsEnglish ? @"Please enter nickname": @"请输入昵称" Image:nil afterDelay:2.0f];
            return NO;
        }else if ([self isTitleBlank:_dicData[@"region"]])
        {
             [self.view addHUDLabelView:IsEnglish ? @"Please select region": @"请选择区域" Image:nil afterDelay:2.0f];
            return NO;
           
        }else if ([self isTitleBlank:_dicData[@"sex"]])
        {
            [self.view addHUDLabelView:IsEnglish ? @"Please select sex": @"请选择性别" Image:nil afterDelay:2.0f];
            return NO;
        }else if ([self isTitleBlank:_dicData[@"birthday"]])
        {
            [self.view addHUDLabelView:IsEnglish ? @"Please select age": @"请选择年龄" Image:nil afterDelay:2.0f];
            return NO;
        }else{
            return YES;
        }

    }else{
        [self.view addHUDLabelView:IsEnglish ? @"Please complete user's information": @"请完善用户信息" Image:nil afterDelay:2.0f];
       return NO;
    }
    
    
}
#pragma  mark 注册操作
- (IBAction)beginGoRegisterUserAction:(UIButton *)sender {
    
    if ([self userInfoFieldBlank]) {
        [self.view addHUDActivityView:Loading];
        NSString *sex = _dicData[@"sex"];
        NSInteger sexNum = 0;
        if ([sex isEqualToString:IsEnglish ? @"Male" : @"男"]) {
            sexNum = 1;
        }else{
            sexNum = 2;
        }
        NSInteger countyID = [_dicData[@"countyID"] integerValue];
        
        //计算用户年龄
        NSInteger year = [SavaData getUserYearCountNumber:_dicData[@"birthday"]];
        
        NSDictionary *dicInfo = @{langType:language,
                                  @"account":_dicData[@"userID"],
                                  @"password":_dicData[@"password2"],
                                  @"username":_dicData[@"name"],
                                  @"regionid":@(countyID),
                                  @"sex":@(sexNum),
                                  @"birthday":_dicData[@"birthday"],
                                  @"year":@(year)
                                  };
        LOG(@"dicInfo = %@",dicInfo);
        
        [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)dicInfo withURL:Api_UserRegister withType:POST completed:^(id content, ResponseType responseType) {
            [self.view removeHUDActivityView];
            
            if (responseType == SUCCESS)
            {
                LOG(@"data = %@",content[@"data"]);
                
                [self.view addHUDLabelView:IsEnglish ? @"Successful registration": @"注册成功" Image:nil afterDelay:2.0f];
                
                [self performSelector:@selector(tapBackBtn) withObject:nil afterDelay:2.f];
                
                [self performSelector:@selector(backBeginLoagin) withObject:nil afterDelay:1.f];
                
                
            } else if (responseType == FAIL) {
                [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
            }
            
        }];
    }
    
    
    
}
- (void)backBeginLoagin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RegisterFinishNotificationCenter object:@{@"account":_dicData[@"userID"],@"password":_dicData[@"password2"]}];
}

#pragma  mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <4) {
        static NSString *defineString = @"defineString";
        LoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LoginViewCell" owner:self options:nil]objectAtIndex:0];
            cell.textField.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textField.tag = indexPath.row;
        
        if (indexPath.row ==0) {
            NSString *userID = _dicData[@"userID"];
            if (userID.length >0) {
                cell.textField.text = userID;
            }else {
                cell.textField.placeholder = Email_Language;
            }
        }else if (indexPath.row == 1){
            NSString *password = _dicData[@"password"];
            if (password.length >0) {
                cell.textField.text = password;
            }else {
                cell.textField.placeholder = Password_Language;
            }
            cell.textField.secureTextEntry = YES;
        }else if (indexPath.row ==2){
            NSString *pass2 = _dicData[@"password2"];
            if (pass2.length >0) {
                cell.textField.text = pass2;
            }else {
                cell.textField.placeholder = IsEnglish ? @"Confirm password": @"确认密码";
            }
            cell.textField.secureTextEntry = YES;
        }else{
            NSString *name = _dicData[@"name"];
            if (name.length >0) {
                cell.textField.text = name;
            }else {
                cell.textField.placeholder = IsEnglish ? @"Please enter nickname": @"输入昵称";
            }
        }
        return cell;
    }else {
        static NSString *defineString = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defineString];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        switch (indexPath.row) {
            case 4:{
                NSString *region = _dicData[@"region"];
                cell.textLabel.text = region.length >0 ? region : Region_Language;
            }
                break;
            case 5:{
                NSString *sex = _dicData[@"sex"];
                cell.textLabel.text = sex.length >0 ? sex : Sex_Language;
            }
                
                break;
            case 6:{
                NSString *age = _dicData[@"birthday"];
                cell.textLabel.text = age.length >0 ? age : Age_Language;
            }
               
                break;
            default:
                break;
        }
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 4) {
        RegionViewController *regionVC = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
        [self.navigationController pushViewController:regionVC animated:YES];
        
    }else if (indexPath.row ==5)
    {
        _viewBgSex.hidden = NO;
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.alpha = 0.6f;
        _tableView.userInteractionEnabled = NO;
        
    }else if (indexPath.row ==6)
    {
        [self showDatePickView];
    }
}
- (void)showDatePickView
{
    CGRect rect = _datePickViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _datePickViewBg.frame = rect;
    if (!_datePickViewBg.superview) {
        [self.view addSubview:_datePickViewBg];
    }
    
    _headView.backgroundColor = [SavaData getColor:@"4cb9c1" alpha:1.f];
    
    [_pickerDate setMinimumDate:[self getDateFromDateButton:@"1000-01-01"]];
    
    
    [_pickerDate setMaximumDate:[NSDate date]];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _datePickViewBg.frame;
        frame.origin.x = 0;
        frame.origin.y = HEIGHT(self.view) - _datePickViewBg.frame.size.height;
        _datePickViewBg.frame = frame;
    }];

}
- (void)didHiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _datePickViewBg.frame;
        rect.origin.x = 0;
        rect.origin.y = SCREEN_HEIGHT;
        _datePickViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_datePickViewBg removeFromSuperview];
    }];
    
}
- (IBAction)didSelectCancelAction:(UIButton *)sender {
    [self didHiddenPickerView];
}

- (IBAction)didSelectFinishAction:(UIButton *)sender {
    [_dicData setObject:_dateStr.length >0 ? _dateStr :@"" forKey:@"birthday"];
    [self didHiddenPickerView];
    [_tableView reloadData];
}


#pragma mark 选择生日
- (IBAction)didSelectChangeFinishAction:(UIDatePicker *)sender {
    
    NSDate *date = [sender date];
   
    NSDateFormatter *formatter = [SavaData userDateFormatter];
    _dateStr = [[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]] copy];
    LOG(@"datestr = %@",_dateStr);
}
- (NSDate *)getDateFromDateButton:(NSString *)birth
{
    NSDateFormatter *formatter = [SavaData userDateFormatter];
    NSDate *date = [formatter dateFromString:birth];
    return date;
}

#pragma mark textField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _myTextFiled = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![self isTitleBlank:textField.text]) {
        if (textField.tag ==0) {
            [_dicData setObject:textField.text forKey:@"userID"];
        }else if (textField.tag ==1)
        {
            [_dicData setObject:textField.text forKey:@"password"];
        }else if (textField.tag ==2)
        {
            [_dicData setObject:textField.text forKey:@"password2"];
        }else{
            [_dicData setObject:textField.text forKey:@"name"];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 3) {
         [textField resignFirstResponder];
    }else{
        [[_tableView viewWithTag:textField.tag +1] becomeFirstResponder];
    }
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_myTextFiled isFirstResponder]) {
        [_myTextFiled resignFirstResponder];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
