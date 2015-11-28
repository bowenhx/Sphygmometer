//
//  UnitsViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-12.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "UnitsViewController.h"
#import "UnitViewCell.h"
@interface UnitsViewController ()
{
    NSArray     *_arrData;
    
    NSMutableDictionary *_dicUnits;
}
@end

@implementation UnitsViewController

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
    self.navTitleLable.text = IsEnglish ? @"Unit": @"单位";
    
    if (IsEnglish) {
        _arrData = @[@"Weight",@"Height",@"Blood pressure"];
    }else{
        _arrData = @[@"体重",@"身高",@"血压"];
    }
    
    
    LOG(@"unit_Type = %@",UNITS_TYPE_DATA);
    _dicUnits  = [[NSMutableDictionary alloc] initWithDictionary:UNITS_TYPE_DATA];
   
    if (_dicUnits.allKeys.count ==0) {
        [_dicUnits setObject:@"0" forKey:@"weight"];
        [_dicUnits setObject:@"0" forKey:@"height"];
        [_dicUnits setObject:@"0" forKey:@"blood"];
    }
    
    self.baseTableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view from its nib.
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
    UnitViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UnitViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.btnImage.tag = indexPath.row;
    cell.labTitle.text = _arrData[indexPath.row];
    
    if (_dicUnits.allKeys.count >0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.labLeft.text = @"kg";
                cell.labRight.text = @"lb";
                cell.btnImage.selected  = [_dicUnits[@"weight"] boolValue];
            }
                break;
            case 1:
            {
                cell.labLeft.text = @"cm";
                cell.labRight.text = @"ft";
                cell.btnImage.selected  = [_dicUnits[@"height"] boolValue];
            }
                break;
            case 2:
            {
                cell.labLeft.text = @"mmhg";
                cell.labRight.text = @"kpa";
                cell.btnImage.selected  = [_dicUnits[@"blood"] boolValue];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    [cell.btnImage addTarget:self action:@selector(selectUnitsType:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)selectUnitsType:(UIButton *)btn
{
    btn.selected = !btn.selected;
   
    switch (btn.tag) {
        case 0:
        {
            [_dicUnits setObject:@(btn.selected) forKey:@"weight"];

        }
            break;
        case 1:
        {
             [_dicUnits setObject:@(btn.selected) forKey:@"height"];
        }
            break;
        case 2:
        {
             [_dicUnits setObject:@(btn.selected) forKey:@"blood"];
        }
            break;
            
        default:
            break;
    }
    
    [SavaData writeDicToFile:_dicUnits FileName:UnitsType];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tapBackBtn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
