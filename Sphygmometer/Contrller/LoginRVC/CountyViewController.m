//
//  CountyViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-4.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "CountyViewController.h"
#import "RegisterViewController.h"
#import "DataVesselObj.h"
@interface CountyViewController ()

@end

@implementation CountyViewController

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


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navTitleLable.text = _countyName;
    
    [self initLoadData];
    
}
- (void)initLoadData
{
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"cid":@(_cid)} withURL:Api_CountyList withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            self.arrData = [content[@"data"] copy];
            
            
            [self.baseTableView reloadData];
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
    return self.arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineString = @"defineString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defineString];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = self.arrData[indexPath.row][@"name"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger countyID = [self.arrData[indexPath.row][@"id"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CountySelectNSNotificationCenter object:@{@"name":cell.textLabel.text,@"county":_countyName,@"countyID":@(countyID)}];
    
    if ([DataVesselObj shareInstance].cityIndex ==100) {
         [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    }else{
         [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

