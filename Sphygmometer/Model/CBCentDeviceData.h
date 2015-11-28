//
//  CBCentDeviceData.h
//  Sphygmometer
//
//  Created by Guibin on 14-9-24.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h> //蓝牙库文件


@interface CBCentDeviceData : NSObject<CBCentralManagerDelegate>
+ (CBCentDeviceData *)shareInstance;

@property (nonatomic , readonly)CBCentralManager *cbcentral;


@property (nonatomic , copy) void (^notificationCenterBlock)(NSInteger center);


@end
