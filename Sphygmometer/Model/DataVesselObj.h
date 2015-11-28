//
//  DataVesselObj.h
//  Sphygmometer
//
//  Created by Guibin on 14-6-13.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataVesselObj : NSObject 
+ (DataVesselObj *)shareInstance;

@property (nonatomic , copy)NSString *titleName; //成员信息
@property (nonatomic)NSInteger      roleid;
//@property (nonatomic , assign)NSInteger userIndex; //选中的成员标示
@property (nonatomic , copy)NSString  *headImageUrl;  //选中成员图象url
@property (nonatomic , strong)NSMutableArray *arrData;
@property (nonatomic)NSInteger      cityIndex;
@property (nonatomic)NSInteger      scanDevShow; //用来保存测量数据状态查看
@property (nonatomic , strong) NSMutableArray  *awokeTime; //存储重复时间
@property (nonatomic , strong)NSMutableArray    *awokeTempArr;//零时存储闹钟

@property (nonatomic) BOOL  isInterlinkStatus; //检测蓝牙是否链接状态

/**
 *  存储测量蓝牙设备值
 *
 */
@property (nonatomic , strong)NSMutableArray    *arrLGPeripheral;

/**
 *  计算心率值的当前view坐标值
 *
 */
+ (NSMutableArray *)showDataOrDraw:(NSArray *)arr size:(CGSize)size;


/**
 *  返回心率排序
 */
+ (NSMutableArray *)newlyHeartValueNumberTaxis:(NSMutableArray *)arrValue taxisTime:(NSInteger)times;

/**
 *  返回本地设置的单位
 *
 */
+ (void)unitTypeWeightType:(NSInteger)type textNumber:(NSString *)value backBlock:(void(^)(NSString *str,NSString *textNum))block;

/**
 *  根据本地单位做出单位计算
 *
 */
+ (NSMutableDictionary *)conversionUnitDataGht:(NSDictionary *)dicData;

/**
 *  血压单位展示
 *
 */
+ (NSMutableDictionary *)conversionUnitDataPull:(NSDictionary *)dicData;

#pragma 获取截屏图片
+ (UIImage *)getImageUIScreenFromViewBg;

//图片剪裁成圆形图
+ (UIImage *)circleImage:(UIImage*)image withParam:(CGFloat)inset;


+ ( UIImage *)getEllipseImageWithImage:( UIImage *)originImage;

+ (void)clearUserInfo;

@end
