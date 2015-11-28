//
//  NewlyMebViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-26.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "NewlyMebViewController.h"
#import "NewlyMeberView.h"
#import "DataVesselObj.h"
#import "AddMemberViewController.h"
#define DataValue  [DataVesselObj shareInstance]
@interface NewlyMebViewController ()
{
    NewlyMeberView *_newlyView ;
    UILabel         *_textYear1;
    
    NSMutableArray *_arrBtn;
}
@property (nonatomic , strong)NSMutableArray       *arrData;
@end

@implementation NewlyMebViewController

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
    
    
    _arrData = [NSMutableArray array];
    _arrBtn = [NSMutableArray array];
    
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDetaileVC:) name:NewlydetaileDataNotificationCenter object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBarHidden = YES;
    
    [UIView animateWithDuration:0.0f animations:^{
        [self.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
         if(isiPhone5 == YES) {
            self.view.frame =  CGRectMake(0, 0, 568, 320);
             }
         else{
            self.view.frame = CGRectMake(0, 0, 480, 320);
         }
         self.view.backgroundColor = [Common getColor:@"4cb9c1"];
     }];

    
     [self initView];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)initView
{
    
    NSArray *btnText = IsEnglish ? @[@"last week",@"last month",@"last three months",@"last year"] : @[@"近一周",@"近一月",@"近三月",@"近一年"];
    float btnY = kIsIOS7 ? 20:0;
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
//        button.layer.borderWidth = 1;
        [button setBackgroundColor:RGBCOLOR(54, 160, 167)];
        [button setTitle:btnText[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(100+i*90, btnY, 70, 35);
        [button addTarget:self action:@selector(selectTimesAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (i==0) {
            [button setBackgroundColor:RGBCOLOR(28, 134, 142)];
        }
        [_arrBtn addObject:button];
    }
    
    float flotY = kIsIOS7 ? 60:40;
    _newlyView = [[NewlyMeberView alloc] initWithFrame:CGRectMake(10, flotY, WIDTH(self.view)-10-flotY-(kIsIOS7 ? 30 : 50), HEIGHT(self.view)-90)];
    _newlyView.layer.borderWidth = 1;
    _newlyView.layer.borderColor = [Common getColor:@"4cb9c1"].CGColor;
    LOG(@"data = %@",DataValue.arrData);
    _arrData = [DataVesselObj newlyHeartValueNumberTaxis:DataValue.arrData taxisTime:0];
    [_newlyView beginDrawLineData:_arrData];
    [self.view addSubview:_newlyView];
    
    
    _textYear1 = [[UILabel alloc] initWithFrame:CGRectMake(170, HEIGHTADDY(_newlyView)-5, WIDTH(self.view)- 300, 30)];
    _textYear1.text = [self showTextTimeValue:0];
    _textYear1.backgroundColor = [UIColor clearColor];
//    _textYear1.layer.borderWidth = 1;
    _textYear1.textColor = [UIColor whiteColor];
    _textYear1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_textYear1];
    
}
#define TO IsEnglish ? @"to" : @"至"
- (NSString *)showTextTimeValue:(NSInteger )index
{
    NSDateFormatter *formatter = [SavaData userDateFormatter];
    switch (index) {
        case 0:
        {
            NSTimeInterval secondsPerDay = 7 * 24 * 60 * 60;
            NSDate *today = [[NSDate alloc] init];
            NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
            
            NSString *time = [NSString stringWithFormat:@"%@ %@ %@",[formatter stringFromDate:yesterday],TO,[formatter stringFromDate:today]];
            
            return time;
        }
            break;
        case 1:
        {
            NSTimeInterval secondsPerDay = 30 * 24 * 60 * 60;
            NSDate *today = [[NSDate alloc] init];
            NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
            
            NSString *time = [NSString stringWithFormat:@"%@ %@ %@",[formatter stringFromDate:yesterday],TO,[formatter stringFromDate:today]];
            
            return time;
        }
            break;
        case 2:
        {
            NSTimeInterval secondsPerDay = 30*3 * 24 * 60 * 60;
            NSDate *today = [[NSDate alloc] init];
            NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
            
            NSString *time = [NSString stringWithFormat:@"%@ %@ %@",[formatter stringFromDate:yesterday],TO,[formatter stringFromDate:today]];
            
            return time;
        }
            break;
        case 3:
        {
            NSTimeInterval secondsPerDay = 365 * 24 * 60 * 60;
            NSDate *today = [[NSDate alloc] init];
            NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
            
            NSString *time = [NSString stringWithFormat:@"%@ %@ %@",[formatter stringFromDate:yesterday],TO,[formatter stringFromDate:today]];
            
            return time;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
- (void)selectDetaileVC:(NSNotification *)infor
{
    [DataVesselObj shareInstance].scanDevShow = 0;
    NSInteger index = [[infor object] integerValue];
    AddMemberViewController *addMemberVC = [[AddMemberViewController alloc] initWithNibName:@"AddMemberViewController" bundle:nil];
    addMemberVC.memberType = 1;
    addMemberVC.dicInfor = DataValue.arrData[index];
    [self presentViewController:addMemberVC animated:YES completion:nil];
}
- (IBAction)didSelectDisMisVC {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)selectTimesAction:(UIButton *)btn
{
    if (_arrData.count) {
        [_arrData removeAllObjects];
    }
    switch (btn.tag) {
        case 0:
        {
            _textYear1.text = [self showTextTimeValue:0];
            _arrData =  [DataVesselObj newlyHeartValueNumberTaxis:DataValue.arrData taxisTime:0];
           
        }
            break;
        case 1:
        {
            _textYear1.text = [self showTextTimeValue:1];
            _arrData = [DataVesselObj newlyHeartValueNumberTaxis:DataValue.arrData taxisTime:1];
        }
            break;
        case 2:
        {
            _textYear1.text = [self showTextTimeValue:2];
            _arrData = [DataVesselObj newlyHeartValueNumberTaxis:DataValue.arrData taxisTime:2];
        }
            break;
        case 3:
        {
            _textYear1.text = [self showTextTimeValue:3];
           _arrData=  [DataVesselObj newlyHeartValueNumberTaxis:DataValue.arrData taxisTime:3];
        }
            break;
            
        default:
            break;
    }
    
    [_arrBtn enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop)
    {
        if (button.tag ==btn.tag) {
            button.backgroundColor = RGBCOLOR(28, 134, 142);
        }else{
            button.backgroundColor = RGBCOLOR(54, 160, 167);
        }
    }];
    
     [_newlyView beginDrawLineData:_arrData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




