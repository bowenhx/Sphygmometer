//
//  AwokeViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-11.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "AwokeViewController.h"
#import "AworkViewCell.h"
#import "EditAwokeViewController.h"
@interface AwokeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView *_footView;
    
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UIButton *_footBtn;
    NSMutableArray *_arrData;
}
@end

@implementation AwokeViewController

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
    self.navTitleLable.text = IsEnglish ? @"Remind": @"提醒";
//    self.rightbtn.hidden = NO;
//    [self.rightbtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [self.rightbtn setTitle:@"完成" forState:UIControlStateSelected];
    
     _arrData = [[NSMutableArray alloc] initWithCapacity:0];
    _tableView.tableFooterView = _footView;
    

    [_footBtn setTitle:IsEnglish ? @"New Remind" : @"新增提醒" forState:UIControlStateNormal];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_arrData setArray: [SavaData parseArrFromFile:Awoke]];
    [_tableView reloadData];
}
- (void)tapRightBtn
{
    self.rightbtn.selected = !self.rightbtn.selected;
}
#pragma  mark Add awoke
- (IBAction)addAwokeAction {
    EditAwokeViewController *editAwokeVC = [[EditAwokeViewController alloc] initWithNibName:@"EditAwokeViewController" bundle:nil];

    [self.navigationController pushViewController:editAwokeVC animated:YES];
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.btnSwitch.tag = indexPath.row;
    cell.labTime.text = _arrData[indexPath.row][@"time"];
    
    [cell.btnSwitch addTarget:self action:@selector(didSelectCancelAwork:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)didSelectCancelAwork:(UISwitch *)s
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditAwokeViewController *editAwokeVC = [[EditAwokeViewController alloc] initWithNibName:@"EditAwokeViewController" bundle:nil];
    [editAwokeVC refreshTabList:_arrData[indexPath.row]];
    [self.navigationController pushViewController:editAwokeVC animated:YES];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_arrData removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [SavaData writeArrToFile:_arrData FileName:Awoke];
        if (_arrData.count == 0) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
