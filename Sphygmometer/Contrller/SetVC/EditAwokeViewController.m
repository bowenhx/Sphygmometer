//
//  EditAwokeViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-11.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "EditAwokeViewController.h"
#import "EditAwokeViewCell.h"
#import "PeriodViewController.h"
#import "DataVesselObj.h"
@interface EditAwokeViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIView *_footView;
    
    
    
    IBOutlet UIView *_datePickViewBg;               //日期选择器背景view
    __weak IBOutlet UIPickerView *_pickerDate;      //pickerView 日期选择器
    __weak IBOutlet UIView *_pickerHeadView;        //选择器header View
    __weak IBOutlet UIButton *_btnVerify;           //确定按钮
    
    NSMutableDictionary     *_dicData;
    NSMutableArray          *_hourArr;
    NSMutableArray          *_minuteArr;
    NSArray         *_arrType;
    
    NSInteger        _timeRow1;
    NSInteger        _timeRow2;
    
    BOOL            _isType;    //区别是时间设置还是位置设置
    NSString        *_locationStr;
    
   
}
@end

@implementation EditAwokeViewController

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
    

    [_btnVerify setTitle:Verify forState:UIControlStateNormal];

    self.baseTableView.tableFooterView = _footView;
    
    [self initData];
}

- (void)initData
{
    _dicData = [[NSMutableDictionary alloc] initWithDictionary:@{@"time":@"00:00",
//                                                                 @"location":@"本地",
                                                                 @"refrain":@""
                                                                 }];
    _isType = YES;
    _timeRow1 = 100;
    _timeRow2 = 100;
    _locationStr = IsEnglish ? @"Local site": @"本地";
    
    _hourArr = [NSMutableArray array];
    _minuteArr = [NSMutableArray array];
    
    for (int i= 0; i<60; i++) {
        NSString *str = @"";
        if (i<10) {
            str = [NSString stringWithFormat:@"0%d",i];
        }else{
            str = [NSString stringWithFormat:@"%d",i];
        }
        if (i<24) {
            [_hourArr addObject:str];
        }
        
        [_minuteArr addObject:str];
        
    }
    
    if (IsEnglish) {
        _arrType = @[@"Remind time",@"Repeat",@"Ringtone",@"Content"];
    }else{
        _arrType = @[
                     @"提醒时间",
                     //                 @"本地提醒",
                     @"重复",
                     @"铃声",
                     @"内容"
                     ];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangePeriodData:) name:ChangeRefrainNotificationCenter object:nil];
}

- (NSString *)periodObj:(NSInteger)i
{
    switch (i) {
        case 0: return @"一,";
        case 1: return @"二,";
        case 2: return @"三,";
        case 3: return @"四,";
        case 4: return @"五,";
        case 5: return @"六,";
        case 6: return @"七";
        default:
            break;
    }
    return nil;
}
- (void)refreshTabList:(NSDictionary *)dic
{
    [_dicData setDictionary:dic];
    [self.baseTableView reloadData];
}
- (void)didChangePeriodData:(NSNotification *)obj
{
    NSDictionary *dic = [obj object];
    [self refreshTabListCellForRow:dic];
}
- (void)refreshTabListCellForRow:(NSDictionary *)dic
{
    NSString *time = @"";
    for (int i= 0; i<7; i++) {
        NSString *swi = [NSString stringWithFormat:@"status%d",i];
        if ([dic[swi] boolValue] == YES) {
            if ([time isEqualToString:@""]) {
                time = [self periodObj:i];
            }else{
                time = [time stringByAppendingString:[self periodObj:i]];
            }
        }
    }
    if ([time isEqualToString:@""]) {
        return;
    }
    NSString *footStr = [time substringFromIndex:time.length-1];
    if ([footStr isEqualToString:@","]) {
        NSString *time2 = [time substringToIndex:time.length-1];
        NSString *endTime = [NSString stringWithFormat:@"%@%@",IsEnglish ? @"Weekly" : @"每周",time2];
        [_dicData setObject:endTime forKey:@"refrain"];
    }else{
        NSString *endTime = [NSString stringWithFormat:@"%@%@",IsEnglish ? @"Weekly" : @"每周",time];
        [_dicData setObject:endTime forKey:@"refrain"];
    }
    
    [self.baseTableView reloadData];
}
#pragma mark 确定操作
- (IBAction)editAwokeFinishAction {
    if ([self isTitleBlank:_dicData[@"refrain"]]) {
        [self.view addHUDLabelView:IsEnglish ?@"Please select repeat time": @"请选择重复时间" Image:nil afterDelay:2.0f];
        return;
    }
    UITextField *textField = (UITextField *)[self.baseTableView viewWithTag:10];
    NSString *content = @"";
    if (textField.text.length >0) {
        content = textField.text;
    }else{
        content = IsEnglish ? @"Time Is Up": @"实捷健康提醒您：血压测量时间到了！";
    }
    [_dicData setObject:content forKey:@"content"];
    
    NSMutableArray *awokeArr = [NSMutableArray arrayWithArray:[SavaData parseArrFromFile:Awoke]];
    [awokeArr addObject:_dicData];
    [SavaData writeArrToFile:awokeArr FileName:Awoke];
    
    //设置闹钟提醒时间
    [self setAwokeTime:content];
    [self tapBackBtn];
}

- (void)setAwokeTime:(NSString *)content
{
    NSDate *pickerDate = [NSDate date];
    NSString *dateStr = [[NSString stringWithFormat:@"%@",pickerDate] substringToIndex:10];
    
    NSInteger hour = [[_dicData[@"time"] substringToIndex:2] integerValue];
    NSInteger minute = [[_dicData[@"time"] substringFromIndex:3] integerValue];
    
    NSString *hourStr = @"";
    NSString *minuteStr = @"";
    if (hour<13) {
        hourStr= [NSString stringWithFormat:@"0%d",hour];
    }else{
        hourStr= [NSString stringWithFormat:@"%d",hour];
    }
    
    if (minute <10) {
         minuteStr= [NSString stringWithFormat:@"0%d",minute];
    }else{
        minuteStr= [NSString stringWithFormat:@"%d",minute];
    }
    NSString *str = [NSString stringWithFormat:@"%@ %@:%@:00",dateStr,hourStr,minuteStr];
    
    NSDate *dateTime = [SavaData transformDateStrToDate:str];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:dateTime];
//    NSDate *timeWithoutDate = [calendar dateFromComponents:comps];
    
    NSMutableArray *arrNumber = [DataVesselObj shareInstance].awokeTime;
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    for (NSNumber *num in arrNumber) {
        localNotif.fireDate = dateTime;
        localNotif.timeZone = [NSTimeZone systemTimeZone];
        localNotif.repeatInterval = NSWeekCalendarUnit;
        localNotif.alertBody = content;
        localNotif.soundName = @"ping.caf";
        NSDictionary* info = [NSDictionary dictionaryWithObject:content forKey:@"Awok"];
        localNotif.userInfo = info;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        LOG(@"num = %@",num);
    }

    [[DataVesselObj shareInstance].awokeTime removeAllObjects];
    
    NSArray *arrCount = [[UIApplication sharedApplication] scheduledLocalNotifications];
    LOG(@"arrcount = %@",arrCount);
    
    
//    UILocalNotification *notification=[[UILocalNotification alloc] init];
//    if (notification!=nil)
//    {
//        NSDate *now=[NSDate new];
//
//
//        notification.fireDate = [now dateByAddingTimeInterval:10];
////        notification.repeatInterval = NSCalendarUnitWeekday;
//        notification.timeZone=[NSTimeZone defaultTimeZone];
//        notification.soundName = @"ping.caf";
//        //notification.alertBody=@"TIME！";
//        
//        notification.alertBody = [NSString stringWithFormat:@"%@时间到了!",content];
//        
//        NSDictionary* info = [NSDictionary dictionaryWithObject:content forKey:@"Awok"];
//        notification.userInfo = info;
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
//    }
}
- (UISwitch *)addCellForSwitch
{
    UISwitch *addSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH(self.view)-90, 7, 80, 25)];
    addSwitch.on = NO;
    [addSwitch addTarget:self action:@selector(setSwitchState:) forControlEvents:UIControlEventTouchUpInside];                                                                                                                        return addSwitch;
}
- (UITextField *)addTextFieldCellForContent
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH(self.view)-180, 7, 170, 30)];
    textField.tag = 10;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    textField.placeholder = IsEnglish ? @"Please enter the content": @"请输入内容";
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.backgroundColor = [UIColor clearColor];
    return textField;
}
- (void)setSwitchState:(UISwitch *)s
{
    
}


#pragma  mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrType.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineString = @"defineString";
    EditAwokeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EditAwokeViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    [self showLoadDataEditAwokeViewCell:cell cellForRowInSection:indexPath];
    return cell;
}
- (void)showLoadDataEditAwokeViewCell:(EditAwokeViewCell *)cell cellForRowInSection:(NSIndexPath *)indexPath
{
    cell.labType.text = _arrType[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.labContent.text = _dicData[@"time"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
//        case 1:
//        {
//            cell.labContent.text = _dicData[@"location"];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//            break;
        case 1:
        {
            cell.labContent.text = _dicData[@"refrain"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            cell.labContent.hidden = YES;
            [cell.contentView addSubview:[self addCellForSwitch]];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        }
            break;
        case 3:
        {
            cell.labContent.hidden = YES;
            [cell.contentView addSubview:[self addTextFieldCellForContent]];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            _isType = YES;
            [self showDatePickView];
        }
            break;
//        case 1:
//        {
//            _isType = NO;
//            [self showDatePickView];
//        }
//            break;
        case 1:
        {
            PeriodViewController *periodVC = [[PeriodViewController alloc] initWithNibName:@"PeriodViewController" bundle:nil];
            periodVC.periodStr = _dicData[@"refrain"];
            [self.navigationController pushViewController:periodVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self.baseTableView setContentOffset:CGPointMake(0, 25) animated:YES];
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITextField *textField = (UITextField *)[self.baseTableView viewWithTag:10];
//    if (textField.text.length >1) {
        [textField resignFirstResponder];
//    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma  mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _isType ? 2 : 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_isType) {
        if (component == 0) {
            return _hourArr.count;
        }else{
            return _minuteArr.count;
        }
    }else{
        return 2;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_isType) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%@",_hourArr[row]];
        }else{
            return [NSString stringWithFormat:@"%@",_minuteArr[row]];
        }
    }else{
        if (row ==0) {
            return IsEnglish ? @"Local site": @"本地";
        }else{
            return IsEnglish ? @"BPM": @"血压计";
        }
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isType) {
        if (component == 0) {
            _timeRow1 = row;
        }else{
            _timeRow2 = row;
        }
    }else{
        if (row == 0) {
            _locationStr = IsEnglish ? @"Local site": @"本地";
        }else{
            _locationStr = IsEnglish ? @"BPM": @"血压计";
        }
    }
    
}

#pragma mark DatePickerView


- (IBAction)hiddenDatePickerHeadViewAction {
    [self didHiddenPickerView];
}

- (IBAction)selectFinishDatePickDataAction {
    if (_isType) {
        NSString *hour = @"";
        
        if (_timeRow1 == 100) {
            if (_timeRow2 == 100) {
                hour = _dicData[@"time"];
            }else{
                hour = [NSString stringWithFormat:@"00:%@", _minuteArr[_timeRow2]];
            }
        }else{
            if (_timeRow2 == 100) {
                hour = [NSString stringWithFormat:@"%@:00", _hourArr[_timeRow1]];
            }else{
                hour = [NSString stringWithFormat:@"%@:%@", _hourArr[_timeRow1], _minuteArr[_timeRow2]];
            }
        }
        
        [_dicData setObject:hour forKey:@"time"];
    }else{
         [_dicData setObject:_locationStr forKey:@"location"];
    }
   
    [self.baseTableView reloadData];
    [self didHiddenPickerView];
    
}

- (void)showDatePickView
{
    CGRect rect = _datePickViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _datePickViewBg.frame = rect;
    if (!_datePickViewBg.superview) {
        [self.view addSubview:_datePickViewBg];
    }
    
    _pickerHeadView.backgroundColor = [SavaData getColor:@"4cb9c1" alpha:1.f];
    
//    [_pickerDate setMinimumDate:[self getDateFromDateButton:@"00-00"]];

    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _datePickViewBg.frame;
        frame.origin.x = 0;
        frame.origin.y = HEIGHT(self.view) - _datePickViewBg.frame.size.height;
        _datePickViewBg.frame = frame;
    }];
    
    [_pickerDate reloadAllComponents];
}
- (NSDate *)getDateFromDateButton:(NSString *)birth
{
    NSDateFormatter *formatter = [self userDateFormatter];
    NSDate *date = [formatter dateFromString:birth];
    return date;
}
- (void)didHiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _datePickViewBg.frame;
        rect.origin.x = 0;
        rect.origin.y = SCREEN_HEIGHT;
        _datePickViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_datePickViewBg removeFromSuperview];
    }];
    
}
- (NSDateFormatter *)userDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH-mm"];
    return formatter;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
