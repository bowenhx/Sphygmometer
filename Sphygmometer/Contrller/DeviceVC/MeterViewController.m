//
//  MeterViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-15.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "MeterViewController.h"
#import "CBUUID+StringExtraction.h"
#import "LGBluetooth.h"
#import "DataVesselObj.h"
#import "AddMemberViewController.h"
#import "ScanDeviceListViewController.h"
#import "CBCentDeviceData.h"

#define kServer_UUID      @"e7810a71-73ae-499d-8c15-faa9aef0c3f2"
#define kCharact_UUID     @"bef8d6c9-9c21-4c9e-b632-bd58c1009f9f"   //特性


#define BLERX_DATA_VALUE_PRESSURE_LEN   7
#define BLERX_DATA_VALUE_FINISHED_LEN   17
#define BLERX_DATA_VALUE_BATTERY_LEN    8


@interface MeterViewController ()<UIAlertViewDelegate,CBCentralManagerDelegate>
{
    
    __weak IBOutlet UIView *_viewHeaderBg;
    __weak IBOutlet UIImageView *_imageHead;
    __weak IBOutlet UILabel *_labTitle;
    __weak IBOutlet UILabel *_labNumber;
    
    __weak IBOutlet UIImageView *_imageStatus;
    __weak IBOutlet UIImageView *_imageBattery;
    
    __weak IBOutlet UILabel *_labStatus;
    __weak IBOutlet UILabel *_labBattery;
    
    __weak IBOutlet UILabel *_labStatusText;
    
    __weak IBOutlet UIButton *_btnBegin;
    

    BOOL        _flagErr;
    BOOL        _isBegin;
    
    __block BOOL        _isAfresh;      //检测设备是否连接上
    
    
}
//@property (nonatomic, strong) LGPeripheral *myPer;
@property (nonatomic, strong) NSTimer     *timer;

@property (nonatomic , strong) NSTimer     *afreshTimer;


@end

@implementation MeterViewController
//@synthesize myPer = _myPer;
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
    _viewHeaderBg.backgroundColor = [Common getColor:@"4cb9c1"];
    _isBegin = NO;
    
    [CBCentDeviceData shareInstance].cbcentral.delegate = self;
    [self showData];
}
- (void)showData
{
    _isAfresh = NO;

    _labTitle.text = [DataVesselObj shareInstance].titleName;
    
    if (isiPhone5 == NO) {
        CGRect labFrame =  _labStatusText.frame;
        labFrame.origin.y -= 20;
        _labStatusText.frame = labFrame;
        
        CGRect btnFrame = _btnBegin.frame;
        btnFrame.origin.y -= 20;
        _btnBegin.frame = btnFrame;
    }
    
    [LGCentralManager sharedInstance];
    
    
    
    //保存数据和重测成功触发通知
     [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshShowMeterStare) name:refreshListNotificationCenter object:nil];
    
    //重新连接蓝牙通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afreshMeterData) name:AfreshListNotificationCenter object:nil];
    
    
    if ([DataVesselObj shareInstance].isInterlinkStatus == NO) {
        [self notificationPeripheralDidDisconnect];
        [self initNSTimaer];
        //扫描设备
        [self showCentralManager];
    }else{
        [self notificationPeripheralDidConnect];
    }
   
    
    [CBCentDeviceData shareInstance].notificationCenterBlock = ^(NSInteger index)
    {
        switch (index) {
            case 0:
            {
                [self.view addHUDLabelView:IsEnglish ? @"Bluetooth device disconnected" : @"蓝牙已断开！" Image:nil afterDelay:2.f];
                [self notificationPeripheralDidDisconnect];
                [self initNSTimaer];
            }
                break;
            case 1:
            {
                 [self notificationPeripheralDidConnect];
            }
                break;
            case 2:
            {
                [self notificationPeripheralConnectionErrorDomain];
            }
                break;
                
            default:
                break;
        }
    };
    
    
    
}
- (void)initNSTimaer
{
    _afreshTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                    target:self
                                                  selector:@selector(afreshTimerData:)
                                                  userInfo:nil
                                                   repeats:YES];
    [_afreshTimer fire];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    
    [self inValidate];
}
- (void)inValidate
{
    if ([_afreshTimer isValid]) {
        [_afreshTimer invalidate];
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    _isAfresh = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_headImage != nil) {
        _imageHead.layer.cornerRadius = 80;
        _imageHead.image = _headImage;
    }else{
        _imageHead.image = [UIImage imageNamed:@"头像.png"];
    }
    
}
- (void)afreshMeterData
{
    if ([DataVesselObj shareInstance].isInterlinkStatus == NO) {
        //扫描设备
        [self showCentralManager];
    }else{
          [self.view addHUDLabelView:IsEnglish ? @"Connected": @"蓝牙已链接" Image:nil afterDelay:2.0f];
    }
   
}
- (void)showCentralManager
{
    //4秒扫描一次外部设备
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:2
                                                         completion:^(NSArray *peripherals)
     {
         if (peripherals.count) {
             [[DataVesselObj shareInstance].arrLGPeripheral removeAllObjects];
             for (LGPeripheral *nowPer in peripherals) {
                 if (nowPer.name.length >1) {
                     
                     LOG(@"  %@",nowPer.name);
                     [self testPeripheral:nowPer];
                     _isAfresh = YES;
                     [[DataVesselObj shareInstance].arrLGPeripheral addObject:nowPer];
                 }
                 break;
             }
             if (!_isAfresh) {
                 LOG(@"打开》检测蓝牙计时器");
                 [DataVesselObj shareInstance].isInterlinkStatus = NO;
                 [_afreshTimer fire];
             }else{
                 LOG(@"关闭》检测蓝牙计时器");
                [self inValidate];
             }

         }
      }];
    
    
}



//扫描设备
- (IBAction)scanDeviceAction:(UIButton *)sender {
    ScanDeviceListViewController *scanDeviceVC = [[ScanDeviceListViewController alloc] initWithNibName:@"ScanDeviceListViewController" bundle:nil];
    [self.navigationController pushViewController:scanDeviceVC animated:YES];
}

- (IBAction)backAction:(UIButton *)sender {
    if (_isBegin) {
        [[[UIAlertView alloc] initWithTitle:nil message:IsEnglish ? @"Measurement is not completed, stop it will cancel this measurement? Yes/No": @"还未完成一次完整测量，停止将取消当前测量！是否取消？" delegate:self cancelButtonTitle:IsEnglish ? @"YES": @"是" otherButtonTitles:IsEnglish ? @"NO": @"否", nil] show];
    }else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
- (void)afreshTimerData:(NSTimer *)timer
{
    if (_isAfresh) {
        [timer invalidate];
        return;
    }

    [self notificationPeripheralDidDisconnect];
    //扫描设备
    [self showCentralManager];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isAfresh"]) {
        
        CGFloat new = [change[NSKeyValueChangeNewKey] floatValue];
        CGFloat old = [change[NSKeyValueChangeOldKey] floatValue];
        if (new == old) {
          
        }
    }
}

- (void)testFinishPushDetaile:(NSDictionary *)dic
{
    [DataVesselObj shareInstance].scanDevShow = 1;
    AddMemberViewController *addMemberVC = [[AddMemberViewController alloc] initWithNibName:@"AddMemberViewController" bundle:nil];
    addMemberVC.memberType = 1;
    addMemberVC.dicInfor = dic;
    [self presentViewController:addMemberVC animated:YES completion:nil];
}

#define LabText  IsEnglish ? @"Device is connected, wear the cuff correctly; make sure the blue arrow pointed down, and red arrow pionted up; The cuff is 2 cm away from the elbow !": @"设备已连接，检查配戴正确，蓝色箭头朝下，红色箭头朝上；离肘关节2厘米！"

#define Start  IsEnglish ? @"Start": @"开始"

#define Stop  IsEnglish ? @"Stop": @"停止"

#define Measurement IsEnglish ? @"Measuring now, please don't move and keep cuff at your heart level.": @"正在测量中，请不要移动保持臂带中心与心脏同一高度！"

- (void)refreshShowMeterStare
{
    _labStatusText.text = LabText;
    
    _isBegin = NO;
    
    _labNumber.text = @"000";
    _btnBegin.userInteractionEnabled = YES;
    [_btnBegin setTitle:Start forState:UIControlStateNormal];
    [_btnBegin setBackgroundImage:[UIImage imageNamed:@"长按钮"] forState:UIControlStateNormal];
    [_btnBegin setBackgroundImage:[UIImage imageNamed:@"长按钮1"] forState:UIControlStateHighlighted];
    
    //扫描设备
//    [self showCentralManager];
}

#pragma mark 连接设备，开始测量

//开始测量
- (IBAction)beginAction:(UIButton *)sender {

    if (_isBegin) {
       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:IsEnglish ? @"Measurement is not completed, stop it will cancel this measurement? Yes/No": @"还未完成一次完整测量，停止将取消当前测量！是否取消？" delegate:self cancelButtonTitle:IsEnglish ? @"YES": @"是" otherButtonTitles:IsEnglish ? @"NO": @"否", nil];
        alertView.tag = 1000;
        [alertView show];
        
    }else{
        _isBegin = YES;
        _labStatusText.text = Measurement;
        [sender setTitle:Stop forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"扫描-按钮"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"扫描-按钮-1"] forState:UIControlStateHighlighted];
        Byte commandByte[6]        = {0x02,0x40,0xdc,0x01,0xa1,0x3c};
        NSData *commandData = [NSData dataWithBytes:commandByte length:7];
        
        //对应的服务特性发送写命令
        [LGUtils writeData:commandData charactUUID:kCharact_UUID serviceUUID:kServer_UUID peripheral:[DataVesselObj shareInstance].arrLGPeripheral[0] completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"start done & error : %@", error.description);
            }
            
            __block short mDataFactLen_pressure = 0;//计数器-测试时的压力数据的长度
            __block short mDataFactLen_finished = 0;//计数器-最终结果数据的长度
            __block short mDataBattery_change   = 0;//电池电量最终结果的长度
            __block Boolean bIsPressureDataHeader = false;//测试时发送的压力数据开始/未开始
            __block Boolean bIsFinishedDataHeader = false;//最终结果头部数据开始/未开始
            __block Boolean bIsBatteryDataValue = false; //检测电池电量
            
            __block NSMutableData *mutableDataFace = [NSMutableData data];
            
            //开启提醒监听
            
            [LGUtils setNotifyValue:YES charactUUID:kCharact_UUID serviceUUID:kServer_UUID peripheral:[DataVesselObj shareInstance].arrLGPeripheral[0] completion:^(NSError *error) {
                
            } onUpdate:^(NSData *data, NSError *error) {
                //接收数据的更新
                
                Byte headerList[3] = {0x02, 0x40, 0xdd};
                
                
                if (data != nil) {
                    Byte *dataByte = (Byte *)[data bytes];
                    int mStartFlag = 0;
                    if (data.length > 4) {
                        for (int i = 0; i < data.length -3; i++) {
                            //数据头判断是测试时传输的数据，还是测试完成后的最终结果
                            //测试时的数据头 ：0x0240dd02
                            //最终结果的数据头    ：0x0240dd0c
                            if (dataByte[i] == headerList[0] && dataByte[i+1] == headerList[1]  && dataByte[i+2] == headerList[2]) {
                                mStartFlag = i;
                                if (dataByte[i+3] == 0x02) {//测量压力值
                                    bIsPressureDataHeader = true;
                                    break;
                                }
                                if (dataByte[i+3] == 0x03) {//测量电量值
                                    bIsBatteryDataValue = true;
                                    break;
                                }
                                if (dataByte[i+3] == 0x0c) {//测量结果
                                    bIsFinishedDataHeader = true;
                                    break;
                                }
                                
                                NSLog(@"lsDataHeader true mStartFlag = %d", mStartFlag);
                            }
                        }
                    }
                    //压力值-测试时发送的数据
                    if (bIsPressureDataHeader == true) {
                        for (int i = mStartFlag; i < data.length; i++) {
                            [mutableDataFace appendBytes:&dataByte[i] length:1];
                            mDataFactLen_pressure++;
                            if (mDataFactLen_pressure == BLERX_DATA_VALUE_PRESSURE_LEN) {
                                break;
                            }
                        }
                        //压力值的长度
                        if (mDataFactLen_pressure == BLERX_DATA_VALUE_PRESSURE_LEN) {
                            mDataFactLen_pressure = 0;
                            NSLog(@"++ pressure mutableDataFace = %@ length = %lu", mutableDataFace, (unsigned long) mutableDataFace.length);
                            //-----------------------  开始解析  -----------------------/
                            [self decodeRecvRxPressureData:mutableDataFace];
                            //-------------------------------------------------------/
                            [mutableDataFace resetBytesInRange:NSMakeRange(0, mutableDataFace.length)];
                            [mutableDataFace setLength:0];
                            bIsPressureDataHeader = false;
                        }
                    }
                    //电池电量最终结果
                    if (bIsBatteryDataValue == true) {
                        for (int i = mStartFlag; i < data.length; i++) {
                            [mutableDataFace appendBytes:&dataByte[i] length:1];
                            mDataBattery_change++;
                            if (mDataBattery_change == BLERX_DATA_VALUE_BATTERY_LEN) {
                                break;
                            }
                        }
                        //电池电量值的长度
                        if (mDataBattery_change == BLERX_DATA_VALUE_BATTERY_LEN) {
                            mDataBattery_change = 0;
                            NSLog(@"++ pressure mutableDataFace = %@ length = %lu", mutableDataFace, (unsigned long) mutableDataFace.length);
                            //-----------------------  开始解析  -----------------------/
                            [self decodeRecvRxBatteryData:mutableDataFace];
                            //-------------------------------------------------------/
                            [mutableDataFace resetBytesInRange:NSMakeRange(0, mutableDataFace.length)];
                            [mutableDataFace setLength:0];
                            bIsBatteryDataValue = false;
                        }
                    }

                    //最终结果
                    if (bIsFinishedDataHeader == true) {
                        for (int i = mStartFlag; i < data.length; i++) {
                            [mutableDataFace appendBytes:&dataByte[i] length:1];
                            mDataFactLen_finished++;
                            if (mDataFactLen_finished == BLERX_DATA_VALUE_FINISHED_LEN) {
                                break;
                            }
                        }
                        //最终结果的数据长度
                        if (mDataFactLen_finished == BLERX_DATA_VALUE_FINISHED_LEN) {
                            NSLog(@"++ finished mutableDataFace = %@ length = %lu", mutableDataFace, (unsigned long) mutableDataFace.length);
                            mDataFactLen_finished = 0;
                            //-----------------------  开始解析  -----------------------/
                            [self decodeRecvRxFinishedData:mutableDataFace];
                            //-------------------------------------------------------/
                            [mutableDataFace resetBytesInRange:NSMakeRange(0, mutableDataFace.length)];
                            [mutableDataFace setLength:0];
                            bIsFinishedDataHeader = false;
                        }
                    }
                }
                
                
            }];
        }];;
    }
   
}


- (void)savePeripheralName:(NSString *)name
{
    NSMutableArray *arrName = [NSMutableArray arrayWithArray:[[SavaData shareInstance] printDataAry:@"periName"]];
    
    __block BOOL isSame = NO;
    [arrName enumerateObjectsUsingBlock:^(NSString *str , NSUInteger index, BOOL *stop)
    {
        if ([name isEqualToString:str]) {
            isSame = YES;
        }
    }];
    
    if (!isSame) {
        [arrName addObject:name];
        [[SavaData shareInstance] savaArray:arrName KeyString:@"periName"];
    }
//    NSLog(@"periName = %@",[[SavaData  shareInstance] printDataAry:@"periName"]);
}
/*
- (void)testPeripheral:(LGPeripheral *)peripheral
{
    __block typeof(self) bself = self;
    [peripheral connectWithCompletion:^(NSError *error) {
        
        //保存设备名字
        [bself savePeripheralName:peripheral.name];
        [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
            
            for (LGService *service in services) {
                if ([service.UUIDString isEqualToString:kServer_UUID]) {
                    [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                        
                        for (LGCharacteristic *charact in characteristics) {
                            NSLog(@"charact uuid : %@", charact.UUIDString);
                            
                            if ([charact.UUIDString isEqualToString:kCharact_UUID]) {
                                
                                Byte commandByte[6]        = {0x02,0x40,0xdc,0x01,0xa3,0x3e};//这个指令可以随便写，这里必须写一个指令给设备才能返回电量
                                NSData *commandData = [NSData dataWithBytes:commandByte length:6];
                                [charact writeValue:commandData completion:^(NSError *error) {
                                    [LGUtils setNotifyValue:YES charactUUID:kCharact_UUID serviceUUID:kServer_UUID peripheral:peripheral completion:^(NSError *error) {
                                        
                                    } onUpdate:^(NSData *data, NSError *error) {
                                        NSLog(@"link data : %@", data);
                                        Byte headerList[4] = {0x02, 0x40, 0xdd, 0x03};
                                        BOOL mBatteryStart = NO;
                                        if (data != nil) {
                                            Byte *dataByte = (Byte *)[data bytes];
                                            int mStartFlag = 0;
                                            
                                            if (data.length > 5) {
                                                for (int i = 0; i < data.length -4; i++) {
                                                    //数据头判断
                                                    if (dataByte[i] == headerList[0] && dataByte[i+1] == headerList[1]  && dataByte[i+2] == headerList[2] && dataByte[i+3] == headerList[3]) {
                                                        mStartFlag = i;
                                                        mBatteryStart = YES;
                                                        break;
                                                    }
                                                }
                                            }
                                            if (mBatteryStart) {
                                                NSMutableData *mutableDataFace = [NSMutableData data];
                                                for (int i = mStartFlag; i < data.length; i++) {
                                                    [mutableDataFace appendBytes:&dataByte[i] length:1];
                                                    if (mutableDataFace.length == BLERX_DATA_VALUE_BATTERY_LEN) {
                                                        break;
                                                    }
                                                }
                                                NSLog(@"mutableDataFace data : %@", mutableDataFace);
                                                mBatteryStart = NO;
                                                [bself decodeRecvRxBatteryData:mutableDataFace];
                                                
                                            }
                                        }
                                    }];
                                }];
                            }
                        }
                    }];
                }
            }
        }];
    }];
}
*/
- (void)testPeripheral:(LGPeripheral *)peripheral
{
    [peripheral connectWithCompletion:^(NSError *error) {
        //保存设备名字
        [self savePeripheralName:peripheral.name];
        [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
            
            for (LGService *service in services) {
                if ([service.UUIDString isEqualToString:kServer_UUID]) {
                    [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                        
                        for (LGCharacteristic *charact in characteristics) {
                            NSLog(@"charact uuid : %@", charact.UUIDString);
                            
                            if ([service.UUIDString isEqualToString:kServer_UUID]) {
                                [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                                    
                                    for (LGCharacteristic *charact in characteristics) {
                                        NSLog(@"charact uuid : %@", charact.UUIDString);
                                        
                                        if ([charact.UUIDString isEqualToString:kCharact_UUID]) {
                                            Byte commandByte[6]        = {0x02,0x40,0xdc,0x01,0xa3,0x3e};//这个指令可以随便写，这里必须写一个指令给设备才能返回电量
                                            NSData *commandData = [NSData dataWithBytes:commandByte length:6];
                                            [charact writeValue:commandData completion:^(NSError *error) {
                                                [LGUtils setNotifyValue:YES charactUUID:kCharact_UUID serviceUUID:kServer_UUID peripheral:peripheral completion:^(NSError *error) {
                                                    
                                                } onUpdate:^(NSData *data, NSError *error) {
                                                    NSLog(@"link data : %@", data);
                                                    Byte headerList[4] = {0x02, 0x40, 0xdd, 0x03};
                                                    BOOL mBatteryStart = NO;
                                                    if (data != nil) {
                                                        Byte *dataByte = (Byte *)[data bytes];
                                                        int mStartFlag = 0;
                                                        
                                                        if (data.length > 5) {
                                                            for (int i = 0; i < data.length -4; i++) {
                                                                //数据头判断
                                                                if (dataByte[i] == headerList[0] && dataByte[i+1] == headerList[1]  && dataByte[i+2] == headerList[2] && dataByte[i+3] == headerList[3]) {
                                                                    mStartFlag = i;
                                                                    mBatteryStart = YES;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                        if (mBatteryStart) {
                                                            NSMutableData *mutableDataFace = [NSMutableData data];
                                                            for (int i = mStartFlag; i < data.length; i++) {
                                                                [mutableDataFace appendBytes:&dataByte[i] length:1];
                                                                if (mutableDataFace.length == BLERX_DATA_VALUE_BATTERY_LEN) {
                                                                    break;
                                                                }
                                                            }
                                                            NSLog(@"mutableDataFace data : %@", mutableDataFace);
                                                            mBatteryStart = NO;
                                                            [self decodeRecvRxBatteryData:mutableDataFace];
                                                            
                                                        }
                                                    }
                                                }];
                                            }];
                                        }
                                    }
                                }];
                            }
                        }
                    }];
                }
            }
        }];
    }];

    
    
}


/**
 *  解析接收蓝牙数据  :  压力值
 *
 *  @param dataRecvAll 蓝牙数据
 */
- (void) decodeRecvRxPressureData: (NSData * ) dataRecvAll {
    NSLog(@"Pressure allData %@", dataRecvAll);
	Byte * dataByte = (Byte * )[dataRecvAll bytes];
	Byte cTemp[2];
	Byte mXOR = dataByte[1]; //记录异或结果
	//数据校验: 0x02  第一字节舍弃，异或长度  = len - 1
	for (int i = 2; i < dataRecvAll.length - 1; i++) {
		mXOR = mXOR ^ dataByte[i];
	}
	
    
	if (dataByte[dataRecvAll.length - 1] == mXOR) {
        cTemp[0] = dataByte[4]; //压力值
        cTemp[1] = dataByte[5];
		Byte mPressureValue = cTemp[0] * 256 + cTemp[1]; //转化为  int
//		self.textView.text = [NSString stringWithFormat:@"\t\n压力值: %d\t\n%@", mPressureValue, self.textView.text];
		NSLog(@"mPressureValue = %hhu", mPressureValue);
        _labNumber.text = [NSString stringWithFormat:@"%hhu",mPressureValue];
	} else {
		NSLog(@"erro : XOR is not correct！");
	}
}
/**
 *  解析电池电量数据 ：电量值
 *
 *  @return 电池电量
 */
- (void) decodeRecvRxBatteryData: (NSData * ) dataRecvAll
{
    NSLog(@"Pressure allData %@", dataRecvAll);
	Byte * dataByte = (Byte * )[dataRecvAll bytes];
	Byte cTemp[3];
	Byte mXOR = dataByte[1]; //记录异或结果
	//数据校验: 0x02  第一字节舍弃，异或长度  = len - 1
	for (int i = 2; i < dataRecvAll.length - 1; i++) {
		mXOR = mXOR ^ dataByte[i];
	}
    
	if (dataByte[dataRecvAll.length - 1] == mXOR) {
        cTemp[0] = dataByte[4]; //电量值
        cTemp[1] = dataByte[5];
        cTemp[2] = dataByte[6];//电量百分比
		Byte mBatteryValue = cTemp[2];//cTemp[0] * 256 + cTemp[1]; //转化为  int
        //		self.textView.text = [NSString stringWithFormat:@"\t\n压力值: %d\t\n%@", mPressureValue, self.textView.text];
		NSLog(@"mBatteryValue = %hhu", mBatteryValue);
        _labBattery.text = [NSString stringWithFormat:@"%hhu％",mBatteryValue];
	} else {
		NSLog(@"erro : XOR is not correct！");
	}

}
/**
 *  解析接收蓝牙数据  :  最终结果
 *
 *  @param dataRecvAll 蓝牙数据
 */
- (void) decodeRecvRxFinishedData: (NSData * ) dataRecvAll {
    NSLog(@"Finished allData %@", dataRecvAll);
    NSMutableDictionary *dicInfor = [NSMutableDictionary dictionary];
	Byte * dataByte = (Byte * )[dataRecvAll bytes];
	Byte cTemp[2];
	short value;
	Byte mXOR = dataByte[1]; //记录异或结果
	//数据校验
	for (int i = 2; i < dataRecvAll.length-1; i++) {
		mXOR = mXOR ^ dataByte[i];
	}
    
	if (dataByte[dataRecvAll.length - 1] == mXOR)
	{

        _flagErr = YES;
        //判断是否出现错误
        for (int i = 5; i < 9; i++) {
            if (dataByte[i] != 0xff) {
                _flagErr = NO;
            }
        }
        if (_flagErr) {
            cTemp[0] = dataByte[11];
            cTemp[1] = dataByte[12];
            value = cTemp[0] * 256 + cTemp[1]; //转化为  int
            short mErrorValue = value;
            _labStatusText.text = [self errorCodeType:mErrorValue];
//            self.textView.text = [NSString stringWithFormat:@"\t\n错误: %hd\t\n%@", mErrorValue, self.textView.text];
            return;
        }


        
		//高血压
		cTemp[0] = dataByte[5];
		cTemp[1] = dataByte[6];
		value = cTemp[0] * 256 + cTemp[1]; //转化为  int
        
		Byte mBloodHValue = value;
//        self.textView.text = [NSString stringWithFormat:@"\t\n收缩压: %d\t\n%@", mBloodHValue, self.textView.text];
		NSLog(@"mBloodHValue = %hhu", mBloodHValue);
        
		//低血压
		cTemp[0] = dataByte[7];
		cTemp[1] = dataByte[8];
		value = cTemp[0] * 256 + cTemp[1]; //转化为  int
		short mBloodLValue = value;
//        self.textView.text = [NSString stringWithFormat:@"\t\n舒张压: %hd\t\n%@", mBloodLValue, self.textView.text];
		NSLog(@"mBloodLValue = %hd", mBloodLValue);
        
		//心率
		cTemp[0] = dataByte[11];
		cTemp[1] = dataByte[12];
		value = cTemp[0] * 256 + cTemp[1]; //转化为  int
		short mHeartValue = value;
//        self.textView.text = [NSString stringWithFormat:@"\t\n心跳: %hd\t\n%@", mHeartValue, self.textView.text];
		NSLog(@"mHeartValue = %hd", mHeartValue);
        
//        [_btnValue1 setTitle:_dicInfor[@"dia"] forState:UIControlStateNormal];
//        [_btnValue2 setTitle:_dicInfor[@"sys"] forState:UIControlStateNormal];
//        [_btnValue3 setTitle:_dicInfor[@"pul"] forState:UIControlStateNormal];
        [dicInfor setObject:[NSString stringWithFormat:@"%hd",mBloodLValue] forKey:@"dia"];
        [dicInfor setObject:[NSString stringWithFormat:@"%hhu",mBloodHValue] forKey:@"sys"];
        [dicInfor setObject:[NSString stringWithFormat:@"%hd",mHeartValue] forKey:@"pul"];
        
        if (_isBegin) {
            [self testFinishPushDetaile:dicInfor];
        }
        
	}else {
		NSLog(@"erro : XOR is not correct！Finished Data");
	}
    
}
#pragma mark 测量出错错误码判断类型
- (NSString *)errorCodeType:(short)index
{
    [self errorStatusChange];
    switch (index) {
        case 0:
        {
            //
        }
            break;
        case 1:
        {
            return IsEnglish ? @"error:sensor vibrate error": @"测量错误:传感器震荡异常";
        }
            break;
        case 2:
        {
            return IsEnglish ? @"error:No detection of heart beat or boold pressure": @"测量错误:检测不到足够的心跳或算不出血压";
        }
            break;
        case 3:
        {
            return IsEnglish ? @"error:result abnormal": @"测量错误:测量结果异常";
        }
            break;
        case 4:
        {
            return IsEnglish ? @"error:cuff too lose or air leek": @"测量错误:袖带过松或漏气";
        }
            break;
        case 5:
        {
            return IsEnglish ? @"error:airpipe is blocked": @"测量错误:气管被堵住";
        }
            break;
        case 6:
        {
            return IsEnglish ? @"error:too much pressure fluctuation": @"测量错误:测量时压力波动大";
        }
            break;
        case 7:
        {
            return IsEnglish ? @"error:pressure is beyond the limit": @"测量错误:压力超过上限";
        }
            break;
        case 8:
        {
            return IsEnglish ? @"error:demarcated date is abnormal or non-demarcated": @"测量错误:标定数据异常或未标定";
        }
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"error:%hd",index];
}
//测量错误按钮状态变化
- (void)errorStatusChange
{
    _isBegin = NO;
    _labNumber.text = @"000";
    _btnBegin.userInteractionEnabled = YES;
    _labStatusText.text = LabText;
    [_btnBegin setTitle:Start forState:UIControlStateNormal];
    [_btnBegin setBackgroundImage:[UIImage imageNamed:@"长按钮"] forState:UIControlStateNormal];
    [_btnBegin setBackgroundImage:[UIImage imageNamed:@"长按钮1"] forState:UIControlStateHighlighted];
}

#define Connected  IsEnglish ? @"Connected": @"已连接";

#define Unconnected IsEnglish ? @"Unconnected": @"未连接";


#pragma mark 设备连接通知
/**
 *  通知-连接成功
 *
 *  @param notification notf
 */
- (void)notificationPeripheralDidConnect{
    NSLog(@"notification-PeripheralDidConnect");
//    self.textView.text = @"connect OK";
    
    _labNumber.text = @"000";
    _btnBegin.userInteractionEnabled = YES;
    _labStatusText.text = LabText;
    _imageStatus.image = [UIImage imageNamed:@"连接"];
    _labStatus.text = Connected;
    _imageBattery.image = [UIImage imageNamed:@"连接电池"];
    
    [DataVesselObj shareInstance].isInterlinkStatus = YES;
    _isBegin = NO;
    _isAfresh = YES;
}
/**
 *  通知-连接断开
 *
 *  @param notification notf
 */
- (void)notificationPeripheralDidDisconnect{
    NSLog(@"通知--- 蓝牙连接断开");
     _labNumber.text = @"000";
    _btnBegin.userInteractionEnabled = NO;
    _labStatusText.text = IsEnglish ? @"Detecting device...": @"正在检测设备中...";
    _imageStatus.image = [UIImage imageNamed:@"未连接"];
    _labStatus.text = Unconnected;
    _imageBattery.image = [UIImage imageNamed:@"未连接-电池"];
    [_btnBegin setTitle:Start forState:UIControlStateNormal];
    [_btnBegin setBackgroundImage:[UIImage imageNamed:@"长按钮"] forState:UIControlStateNormal];
    [_btnBegin setBackgroundImage:[UIImage imageNamed:@"长按钮1"] forState:UIControlStateHighlighted];
     _isBegin = NO;
    [DataVesselObj shareInstance].isInterlinkStatus = NO;
    _isAfresh = NO;
    
}
/**
 *  通知-连接出错
 *
 *  @param notification notf
 */
- (void)notificationPeripheralConnectionErrorDomain{
    NSLog(@"通知--- 蓝牙连接出错");
     _isBegin = NO;
    [self.view addHUDLabelView:IsEnglish ? @"Error Connected ！": @"连接出错！" Image:nil afterDelay:2.f];
    [DataVesselObj shareInstance].isInterlinkStatus = NO;
//    self.textView.text = [NSString stringWithFormat:@"%@\t\n%@", self.textView.text, @"ConnectionErrorDomain"];
}
- (void)testHexText:(NSData *)aData{
    Byte *bytes = (Byte *)[aData bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[aData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff]; ///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
}
#pragma mark All
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LOG(@"alert.tag = %d buttonIndex = %d",alertView.tag,buttonIndex);
    
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            _labNumber.text = @"000";
            [self showChangeDeviceMeterStatus];
        }else{
     
        }

    }else{
        if (buttonIndex == 0) {
            [self showChangeDeviceMeterStatus];
        }
    }
    
}
- (void)showChangeDeviceMeterStatus{
    _isBegin = NO;
    _labStatusText.text = LabText;
    [_btnBegin setTitle:Start forState:UIControlStateNormal];
    [_btnBegin setBackgroundImage:[UIImage imageNamed:@"长按钮"] forState:UIControlStateNormal];
    [_btnBegin setBackgroundImage:[UIImage imageNamed:@"长按钮1"] forState:UIControlStateHighlighted];
    
    Byte commandByte[6]        = {0x02,0x40,0xdc,0x01,0xa2,0x3f};
    NSData *commandData = [NSData dataWithBytes:commandByte length:7];
    
    //对应的服务特性发送写命令
    [LGUtils writeData:commandData charactUUID:kCharact_UUID serviceUUID:kServer_UUID peripheral:[DataVesselObj shareInstance].arrLGPeripheral[0] completion:^(NSError *error) {
        if (error != nil) {
            NSLog(@"stop done & error : %@", error.description);
        }
    }];

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
            [self.view addHUDLabelView:IsEnglish ? @"Bluetooth device disconnected": @"蓝牙已断开！" Image:nil afterDelay:2.f];
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered off."];
            [DataVesselObj shareInstance].isInterlinkStatus = NO;
            [self notificationPeripheralDidDisconnect];
             [_afreshTimer fire];
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered on and available to use."];
            [DataVesselObj shareInstance].isInterlinkStatus = YES;
//            [self notificationPeripheralDidConnect];
            //--- it works, I Do get in this area!
            
            break;
        }
            
    }
    NSLog(@"CBCentralManager = %@",messtoshow);
}

@end
