//
//  FindDeviceViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-7-4.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "FindDeviceViewController.h"

#import "InputDeviceNumViewController.h"
@interface FindDeviceViewController ()<ZBarReaderDelegate>
{
    
    __weak IBOutlet UIView *_scanBg; //二维码扫描背景

    
    
    
}
@end

@implementation FindDeviceViewController

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
    
    self.title = IsEnglish ? @"Searching devices": @"设备扫描";
    
    
//    [self findDeviceTowCode];
}
- (void)findDeviceTowCode
{
    _scanBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_sweep_backg"]];
    self.readerDelegate = self;
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.supportedOrientationsMask = UIInterfaceOrientationPortrait;
    
    self.showsZBarControls = NO;
    self.enableCache = NO;
    
    self.cameraOverlayView = _scanBg;
    
}
/**
 *  手动输入SN码
 */
- (IBAction)didInputDeviceSNCodeAction {
    InputDeviceNumViewController *inputDeviceVC = [[InputDeviceNumViewController alloc] initWithNibName:@"InputDeviceNumViewController" bundle:nil];
    [self.navigationController pushViewController:inputDeviceVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
