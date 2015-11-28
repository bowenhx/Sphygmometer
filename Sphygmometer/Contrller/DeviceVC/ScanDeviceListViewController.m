//
//  ScanDeviceListViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-7-9.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "ScanDeviceListViewController.h"
#import "CBUUID+StringExtraction.h"
#import "LGBluetooth.h"

@interface ScanDeviceListViewController ()

@end

@implementation ScanDeviceListViewController

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
    self.navTitleLable.text = IsEnglish ? @"Searching bluetooth devices": @"扫描蓝牙设备";
    
    self.rightbtn.hidden = NO;
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(0.0f, 15.0f);
    [self.rightbtn setTitle:IsEnglish ? @"Searching": @"扫描" forState:UIControlStateNormal];
    self.rightbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.rightbtn setTitleColor:[Common getColor:@"4cb9c1"] forState:UIControlStateNormal];
    [self.rightbtn addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor grayColor];
    [testActivityIndicator startAnimating];
    
    [self.arrData setArray:[[SavaData  shareInstance] printDataAry:@"periName"]];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#define mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineString = @"defineString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:defineString];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.arrData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AfreshListNotificationCenter object:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
