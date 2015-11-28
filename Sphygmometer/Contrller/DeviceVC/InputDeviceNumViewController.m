//
//  InputDeviceNumViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-7-4.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "InputDeviceNumViewController.h"

@interface InputDeviceNumViewController ()
{
    __weak IBOutlet UITextField *_textField;
    
    __weak IBOutlet UIButton *_verifyBtn;
}
@end

@implementation InputDeviceNumViewController

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
    self.navTitleLable.text = IsEnglish ? @"Enter the SN code": @"输入设备SN";
    
    if (IsEnglish) {
        _textField.placeholder = @"Please enter the SN code of the device";
        
        [_verifyBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _textField.text = _strCode;
}
- (IBAction)didInputDeviceNumFinish
{
    if ([self isTitleBlank:_textField.text]) {
         [self.view addHUDLabelView:IsEnglish ? @"Please enter the SN code of the device": @"请输入设备的SN" Image:nil afterDelay:2.0f];
    }else
    {
        //把SN码提交服务器
        
        [self.view addHUDActivityView:Loading];
        
        [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language, @"uid":USERID,@"sn":_textField.text,@"mode":@(1)} withURL:Api_Scanning withType:POST completed:^(id content, ResponseType responseType) {
            [self.view removeHUDActivityView];
            
            if (responseType == SUCCESS)
            {
                LOG(@"data = %@",content[@"data"]);
                
                
                [self.view addHUDLabelView:SaveSuccessd Image:nil afterDelay:2.0f];
                [self performSelector:@selector(saveSNCodeFinle:) withObject:content[@"data"] afterDelay:1.f];
                
            } else if (responseType == FAIL) {
                [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
            }
        }];
        
       
    }
}

- (void)saveSNCodeFinle:(NSDictionary *)dicName
{
    //存入本地
    __block BOOL isEqual = NO;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[SavaData shareInstance] printDataAry:DeviceSN_Code]];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger index, BOOL *stop)
     {
         //判断是否保存过
         if ([dic[@"SNcode"] isEqualToString:_textField.text]) {
             isEqual = YES;
         }
     }];
    
    if (isEqual == NO) {
        [arr addObject:@{
                         @"SNcode":_textField.text,
                         @"A_rolename":dicName[@"A_rolename"],
                         @"B_rolename":dicName[@"B_rolename"],
                         @"type":dicName[@"type"],
                         @"thumb":dicName[@"thumb"]
                         }];
    }
    [[SavaData shareInstance] savaArray:arr KeyString:DeviceSN_Code];
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
