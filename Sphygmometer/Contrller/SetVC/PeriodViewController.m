//
//  PeriodViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-12.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "PeriodViewController.h"
#import "AworkViewCell.h"
#import "DataVesselObj.h"
@interface PeriodViewController ()
{
    NSArray         *_arrData;
    
    NSMutableDictionary *_dicSwitch;
}
@end

@implementation PeriodViewController

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
    
    self.navTitleLable.text = IsEnglish ? @"Repeat": @"重复";
    
    if (IsEnglish) {
        _arrData = @[
            @"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"
                     ];
    }else{
        _arrData = @[
                     @"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"
                     ];
    }
   
    
    _dicSwitch = [[NSMutableDictionary alloc] init];
    for (int i= 0; i<7; i++) {
        NSString *swi = [NSString stringWithFormat:@"status%d",i];
        [_dicSwitch setObject:@"0" forKey:swi];
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (NSString *)selectCellSwitch:(NSString *)strNum
{
    if ([strNum hasSuffix:@"一"]) {
        return @"status0";
    }else if ([strNum hasSuffix:@"二"])
    {
        return @"status1";
    }else if ([strNum hasSuffix:@"三"])
    {
        return @"status2";
    }else if ([strNum hasSuffix:@"四"])
    {
        return @"status3";
    }else if ([strNum hasSuffix:@"五"])
    {
        return @"status4";
    }else if ([strNum hasSuffix:@"六"])
    {
        return @"status5";
    }else if ([strNum hasSuffix:@"七"])
    {
        return @"status6";
    }
    return nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //不为空
    if (![self isTitleBlank:_periodStr]) {
        NSString *string = [_periodStr substringFromIndex:2];
        NSArray *arr = [string componentsSeparatedByString:@","];
        for (NSString *strNum in arr) {
            if (strNum.length >0) {
                [_dicSwitch setObject:@"1" forKey:[self selectCellSwitch:strNum]];
            }
            
        }
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
    AworkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AworkViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }
    cell.btnSwitch.tag = indexPath.row;
    cell.labTime.text = _arrData[indexPath.row];
    
    NSString *swi = [NSString stringWithFormat:@"status%d",indexPath.row];
    cell.btnSwitch.on = [_dicSwitch[swi] boolValue];
    
    [cell.btnSwitch addTarget:self action:@selector(didSelectSwitch:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)didSelectSwitch:(UISwitch *)s
{
    NSString *swi = [NSString stringWithFormat:@"status%d",s.tag];
    [_dicSwitch setObject:@(s.on) forKey:swi];
    [self.baseTableView reloadData];
    
    BOOL isSame = NO;
    if ([DataVesselObj shareInstance].awokeTime.count >0) {
        for (NSNumber *number in [DataVesselObj shareInstance].awokeTime) {
            if (s.tag == [number integerValue]) {
                isSame = YES;
                break;
            }
        }
        
        if (isSame == NO) {
            if (s.tag == 6) {
                [[DataVesselObj shareInstance].awokeTime addObject:@(1)];
            }else{
                [[DataVesselObj shareInstance].awokeTime addObject:@(s.tag+2)];
            }
        }
    }else{
        if (s.tag == 6) {
            [[DataVesselObj shareInstance].awokeTime addObject:@(1)];
        }else{
            [[DataVesselObj shareInstance].awokeTime addObject:@(s.tag+2)];
        }
    }
    
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tapBackBtn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeRefrainNotificationCenter object:_dicSwitch];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
