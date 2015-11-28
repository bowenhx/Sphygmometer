//
//  CBCentDeviceData.m
//  Sphygmometer
//
//  Created by Guibin on 14-9-24.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "CBCentDeviceData.h"
#import "DataVesselObj.h"
@implementation CBCentDeviceData
static CBCentDeviceData *_shareInstance = nil;
+ (CBCentDeviceData *)shareInstance
{
    if (!_shareInstance) {
        _shareInstance = [[CBCentDeviceData alloc] init];
    }
    return _shareInstance;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)init
{
    self = [super init];
    if (self) {
        _cbcentral = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        [self addNotificationCenter];
    }
    return self;
}

- (void)addNotificationCenter
{
    
    
    //注册通知：连接成功； 连接断开； 连接错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPeripheralDidConnect:) name:kLGPeripheralDidConnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPeripheralDidDisconnect:) name:kLGPeripheralDidDisconnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPeripheralConnectionErrorDomain:) name:kLGPeripheralConnectionErrorDomain object:nil];
}
#pragma mark -检测蓝牙设备是否断开
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *messtoshow = nil;
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            messtoshow = [NSString stringWithFormat:@"State unknown, update imminent."];
            break;
        }
        case CBCentralManagerStateResetting:
        {
            messtoshow=[NSString stringWithFormat:@"The connection with the system service was momentarily lost, update imminent."];
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            messtoshow=[NSString stringWithFormat:@"The platform doesn't support Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            messtoshow=[NSString stringWithFormat:@"The app is not authorized to use Bluetooth Low Energy"];
            [DataVesselObj shareInstance].isInterlinkStatus = NO;
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered off."];
            [DataVesselObj shareInstance].isInterlinkStatus = NO;
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered on and available to use."];
            
            
            //--- it works, I Do get in this area!
            
            break;
        }
            
    }
    NSLog(@"CBCentralManager = %@",messtoshow);
}
#pragma 蓝牙检测通知
#pragma mark 设备连接通知
/**
 *  通知-连接成功
 *
 *  @param notification notf
 */
- (void)notificationPeripheralDidConnect:(NSNotification *)notification{
    NSLog(@"notification-PeripheralDidConnect");
    //    self.textView.text = @"connect OK";
    
    
    [DataVesselObj shareInstance].isInterlinkStatus = YES;
    if (_notificationCenterBlock) {
        _notificationCenterBlock (1);
    }
    
    //    _labBattery.text = @"100%";
}
/**
 *  通知-连接断开
 *
 *  @param notification notf
 */
- (void)notificationPeripheralDidDisconnect:(NSNotification *)notification{
    NSLog(@"notification-PeripheralDidDisconnect");
    
    [DataVesselObj shareInstance].isInterlinkStatus = NO;
    if (_notificationCenterBlock) {
        _notificationCenterBlock (0);
    }
    //    _labBattery.text = @"100%";
}
/**
 *  通知-连接出错
 *
 *  @param notification notf
 */
- (void)notificationPeripheralConnectionErrorDomain:(NSNotification *)notification{
    
    [DataVesselObj shareInstance].isInterlinkStatus = NO;
    if (_notificationCenterBlock) {
        _notificationCenterBlock (2);
    }
    
    //    self.textView.text = [NSString stringWithFormat:@"%@\t\n%@", self.textView.text, @"ConnectionErrorDomain"];
}


@end
