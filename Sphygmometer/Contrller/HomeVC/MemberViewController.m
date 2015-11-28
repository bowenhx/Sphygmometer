//
//  MemberViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-7-2.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "MemberViewController.h"

@interface MemberViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UITableView *_tableView;
    
    
    
    NSArray         *_arrData;
}
@end

@implementation MemberViewController

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
    
    self.navigationController.navigationBar.hidden = NO;
    self.rightbtn.hidden = NO;
    
    if (IsEnglish) {
        _arrData = @[
                     @"Father",@"Mother",@"Grandfather",@"Grandmother",@"Me"
                     ];
    }else{
        _arrData = @[
                     @"爸爸",@"妈妈",@"爷爷",@"奶奶",@"我"
                     ];
    }
   
    if (IsEnglish) {
        _textField.placeholder = @"Please enther the user name";
    }else{
        _textField.placeholder = @"请输入测量人名称";
    }
    
    
    UIImage *rightImage = [UIImage imageNamed: @"edit_name_right"];
    self.rightbtn.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    [self.rightbtn setBackgroundImage:rightImage forState: UIControlStateNormal];
   
}
- (void)tapRightBtn
{
    if (![self isTitleBlank:_textField.text]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EditMemberNameNotificationCenter object:_textField.text];
        
         [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.view addHUDLabelView:IsEnglish ? @"Please enther the user name" : @"请输入测量人名称" Image:nil afterDelay:2.0f];
    }
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self isTitleBlank:_userName]) {
        _textField.text = _userName;
    }
}

#pragma  mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineString = @"defineString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defineString];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    
    cell.textLabel.text = _arrData[indexPath.row];
    
    if ([_arrData[indexPath.row] isEqualToString:_userName]) {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    _textField.text = cell.textLabel.text;
    _userName = _textField.text;
    [tableView reloadData];
}
#pragma mark TextField
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)tapBackBtn
{
    if (![self isTitleBlank:_textField.text]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:EditMemberNameNotificationCenter object:_textField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
