//
//  PushNewsViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-7-2.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "PushNewsViewController.h"
#import "WEBViewController.h"
@interface PushNewsViewController ()

@end

@implementation PushNewsViewController

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
    self.navTitleLable.text = IsEnglish ? @"News update": @"要闻推送";
    
    
    [self initData];
}
- (void)initData
{
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"size":@(999)} withURL:Api_PushNews withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            [self.arrData setArray:content[@"data"]];
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
    
    cell.textLabel.text = self.arrData[indexPath.row][@"title"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WEBViewController *webView = [[WEBViewController alloc] initWithNibName:@"WEBViewController" bundle:nil];
    webView.titleName = self.arrData[indexPath.row][@"title"];
    webView.webUrl = self.arrData[indexPath.row][@"url"];
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
