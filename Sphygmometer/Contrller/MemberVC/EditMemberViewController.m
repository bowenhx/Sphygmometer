//
//  EditMemberViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-19.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "EditMemberViewController.h"

@interface EditMemberViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UIView *_headView;
    __weak IBOutlet UIButton *_btnDelect;
    
    IBOutlet UITextField *_textFieldName;
    
    __weak IBOutlet UIButton *_btnMan;
    __weak IBOutlet UIButton *_btnWoman;
    __weak IBOutlet UILabel *_labBirthday;
    __weak IBOutlet UILabel *_labHeight;
    __weak IBOutlet UILabel *_labWeight;
    
}
@end

@implementation EditMemberViewController

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
    _headView.backgroundColor = [Common getColor:@"4cb9c1"];
}
//选择保存
- (IBAction)selectSaveDataAction:(UIButton *)sender {
}

//选择性别
- (IBAction)selectSexAction:(UIButton *)sender {
}
//选择生日
- (IBAction)selectBirthdayAction:(UIButton *)sender {
}
//选择身高
- (IBAction)selectHeightAction:(UIButton *)sender {
}
//选择体重
- (IBAction)selectWeightAction:(UIButton *)sender {
}



//更换头像
- (IBAction)didChangeHeaderImageAction:(UIButton *)sender {
}
//退出
- (IBAction)didDisMisVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//删除操作
- (IBAction)didDeleteAction:(UIButton *)sender {
}
#pragma mark TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
