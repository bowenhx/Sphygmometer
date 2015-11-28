//
//  DataVesselObj.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-13.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "DataVesselObj.h"

@implementation DataVesselObj
static DataVesselObj * _shareInstance = nil;

+ (DataVesselObj *)shareInstance{
    if (!_shareInstance) {
        _shareInstance = [[DataVesselObj alloc] init];
    }
    return _shareInstance;
}
- (id)init
{
    self = [super init];
    if (self) {
        _titleName = [NSString stringWithFormat:@""];
        _arrData = [NSMutableArray array];
        _awokeTime = [[NSMutableArray alloc] initWithCapacity:0];
        _awokeTempArr = [[NSMutableArray alloc] initWithCapacity:0];
        _arrLGPeripheral = [[NSMutableArray alloc] initWithCapacity:0];
        _cityIndex = 0;
        _scanDevShow = 0;
        
    }
    return self;
}

+ (float)hypertensionRatioShowData:(NSInteger)value range:(NSInteger)i type:(BOOL)isHeight height:(float)height
{
    //每格占得的单位
    NSInteger rangeH = height/6;
    //高压值判断取值
    if (isHeight) {
        switch (i) {
            case 0:
            {
                if (value > 210) {
                    return 1.f;
                }else{
                    NSInteger v = value - 180;      //求取重度所占比例
                    return rangeH/30 * v + rangeH *i;
                }
            }
                break;
            case 1:
            {
                NSInteger v = value - 160;      //求取中度所占比例
                return rangeH/20 * v + rangeH *i;
            }
                break;
            case 2:
            {
                NSInteger v = value - 140;      //求取轻度所占比例
                return rangeH/20 * v + rangeH *i;
            }
                break;
            case 3:
            {
                NSInteger v = value - 120;      //求取正常所占比例
                return rangeH/20 * v + rangeH *i;
            }
                break;
            case 4:
            {
                NSInteger v = value - 90;      //求取理想所占比例
                return rangeH/30 * v + rangeH *i;
            }
                break;
            case 5:
            {
                //求取偏低所占比例
                return rangeH/90 * value + rangeH *i;
            }
                break;
            default:
                break;
        }
    }else{
        switch (i) {
            case 0:
            {
                if (value >140) {
                    return 1.f;
                }else{
                    NSInteger v = value - 110;      //求取重度所占比例
                    return rangeH/30 * v + rangeH *i;
                }
            }
                break;
            case 1:
            {
                NSInteger v = value - 100;      //求取中度所占比例
                return rangeH/10 * v + rangeH *i;
            }
                break;
            case 2:
            {
                NSInteger v = value - 90;      //求取轻度所占比例
                return rangeH/10 * v + rangeH *i;
            }
                break;
            case 3:
            {
                NSInteger v = value - 80;      //求取正常所占比例
                return rangeH/10 * v + rangeH *i;
            }
                break;
            case 4:
            {
                NSInteger v = value - 60;      //求取理想所占比例
                return rangeH/20 * v + rangeH *i;
            }
                break;
            case 5:
            {
                //求取偏低所占比例
                return rangeH/60 * value + rangeH *i;
            }
                break;
                
            default:
                break;
        }
    }
    return 0.f;
}
/**
 *  计算心率值的当前view坐标值
 *
 */
+ (NSMutableArray *)showDataOrDraw:(NSArray *)arr size:(CGSize)size
{
    int i = 0;
    NSInteger count = arr.count;
    NSMutableArray *arrData = [NSMutableArray array];
    for (NSDictionary *dicUser in arr) {
        NSInteger X = [dicUser[@"dia"] integerValue];
        NSInteger Y = [dicUser[@"sys"] integerValue];
        
        NSInteger        ratioX = 0;
        NSInteger        ratioY = 0;
        
        if (X > 60 && X <= 80) {            //理想
			ratioX = 4;
		} else if (X > 80 && X <= 90) {     //正常
			ratioX = 3;
		} else if (X > 90 && X <= 100) {    //轻度
			ratioX = 2;
		} else if (X > 100 && X <= 110) {   //中度
			ratioX = 1;
		} else if (X > 110) {               //重度
			ratioX = 0;
		} else if (X <= 60) {               //偏低
			ratioX = 5;
		}
        
        if (Y > 90 && Y <= 120) {
			ratioY = 4;
		} else if (Y > 120 && Y <= 140) {
			ratioY = 3;
		} else if (Y > 140 && Y <= 160) {
			ratioY = 2;
		} else if (Y > 160 && Y <= 180) {
			ratioY = 1;
		} else if (Y > 180) {
			ratioY = 0;
		} else if (Y <= 90) {
			ratioY = 5;
		}
        
        CGFloat endValue = ratioX <= ratioY ? ratioX : ratioY;
        if (ratioY == endValue) {//以高压值判断
            float value = [self hypertensionRatioShowData:Y range:ratioY type:YES height:size.height];
            [arrData addObject:[NSValue valueWithCGPoint:CGPointMake(31 + i*((size.width - 30)/count), value)]];
        }else{
            float value = [self hypertensionRatioShowData:X range:endValue type:NO height:size.height];
            [arrData addObject:[NSValue valueWithCGPoint:CGPointMake(31 + i*((size.width - 30)/count) ,value)]];
        }
        
        i ++;
    }
    
    return arrData;
}

+ (NSDate *)transformDateStrToDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateStr];
}

/**
 *  返回心率排序
 */

+ (NSMutableArray *)newlyHeartValueNumberTaxis:(NSMutableArray *)arrValue taxisTime:(NSInteger)times
{
   return [self taxisCompareWeekTime:arrValue type:times];
}

+ (NSMutableArray *)taxisCompareWeekTime:(NSMutableArray *)arrData type:(NSInteger)type
{
    
    NSTimeInterval extends;
    NSMutableArray *timeData = [NSMutableArray array];
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    NSDate *start;
    switch (type) {
        case 0:
        {
            if (NO == kIsIOS7) {
                BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval:&extends forDate:today];
                
                if(!success)
                    return nil;
            }else{
                NSTimeInterval secondsPerDay = 7 * 24 * 60 * 60;
                start = [today dateByAddingTimeInterval: -secondsPerDay];
            }
           
        }
            break;
        case 1:
        {
            if (kIsIOS7 == NO) {
                BOOL success= [cal rangeOfUnit:NSMonthCalendarUnit startDate:&start interval: &extends forDate:today];
                
                if(!success)
                    return nil;
            }else{
                NSTimeInterval secondsPerDay = 30 * 24 * 60 * 60;
                start = [today dateByAddingTimeInterval: -secondsPerDay];
            }
        }
            break;

        case 2:
        {
 
            if (kIsIOS7 == NO) {
                BOOL success= [cal rangeOfUnit:NSCalendarUnitYear startDate:&start interval: &extends forDate:today];

                if(!success)
                return nil;
            }else{
                NSTimeInterval secondsPerDay = 30*3 * 24 * 60 * 60;

                start = [today dateByAddingTimeInterval: -secondsPerDay];
            }
            
        }
            break;

        case 3:
        {
             if (kIsIOS7 == NO) {
                 BOOL success= [cal rangeOfUnit:NSCalendarUnitYear startDate:&start interval: &extends forDate:today];

                 if(!success)
                 return nil;
             }else{
                 NSTimeInterval secondsPerDay = 365 * 24 * 60 * 60;
                 start = [today dateByAddingTimeInterval: -secondsPerDay];
             }

        }
            break;
        default:
            break;
    }
    
   
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    NSTimeInterval todayStartValue = [today timeIntervalSinceReferenceDate];
    
    [arrData enumerateObjectsUsingBlock:^(NSDictionary *dicData , NSUInteger index, BOOL *stop)
     {
         /**
          *  将时间转化时间戳  time = "2014-06-13 10:08:01";
          */
         
         NSString *interval = dicData[@"time"];
         NSDate *date = [self transformDateStrToDate:interval];
         NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];

         if (kIsIOS7 == YES) {
             if(dateInSecs > dayStartInSecs && dateInSecs < todayStartValue){
                 [timeData addObject:dicData];
             }
         }else{
             if(dateInSecs > dayStartInSecs || dateInSecs < (dayStartInSecs+extends)){
                 [timeData addObject:dicData];
             }
         }
         

     }];
    
    return timeData;
}

+ (void)unitTypeWeightType:(NSInteger)type textNumber:(NSString *)value backBlock:(void(^)(NSString *str,NSString *textNum))block
{
    NSDictionary *dic = UNITS_TYPE_DATA;
        
    switch (type) {
        case 0:
        {//体重
            if ([dic[@"weight"] integerValue] == 0){
                block (@"kg",value);
            }else{
                float floDia = [value floatValue] * UNITS_TYPE_WEIGHT;
                NSString *diaStr = [NSString stringWithFormat:@"%.0f",floDia];
                block (@"lb",diaStr);
            }
        }
            break;
        case 1:
        {//身高
            if ([dic[@"height"] integerValue] == 0){
                block (@"cm",value);
            }else
            {
                float floDia = [value floatValue] * UNITS_TYPE_HEIGHT;
                NSString *diaStr = [NSString stringWithFormat:@"%.0f",floDia];
                block (@"ft",diaStr);
            }
        }
            break;
        case 2:
        {//血压
            if ([dic[@"blood"] integerValue] == 0){
                block (@"mmhg",value);
            }else
            {
                float floDia = [value floatValue] * UNITS_TYPE_BLOOD;
                NSString *diaStr = [NSString stringWithFormat:@"%.0f",floDia];
                block (@"kpa",diaStr);
            }
        }
            break;
            
        default:
            break;
    }
    
}
/**
 *  根据本地单位做出单位计算
 *
 */
+ (NSMutableDictionary *)conversionUnitDataGht:(NSDictionary *)dicData
{
    NSMutableDictionary *dicInfo = [NSMutableDictionary dictionaryWithDictionary:dicData];
    NSInteger weight = [dicData[@"weight"] integerValue];
    NSInteger height = [dicData[@"height"] integerValue];
    float numWei = 0.f;
    float numHei = 0.f;
    
    NSDictionary *dic = UNITS_TYPE_DATA;
    if (dic.allKeys.count) {

        if ([dic[@"weight"] integerValue] == 0) {
            numWei = weight * UNITS_TYPE_WEIGHT;
            NSString *lb = [NSString stringWithFormat:@"%.1f",numWei];
            [dicInfo setObject:lb forKey:@"weight"];
        }
        
        if ([dic[@"height"] integerValue] == 0)
        {
            numHei = height * UNITS_TYPE_HEIGHT;
            NSString *ft = [NSString stringWithFormat:@"%.1f",numHei];
            [dicInfo setObject:ft forKey:@"height"];
        }
        
        return dicInfo;
    }
    return dicInfo;;
}
/**
 *  血压单位展示
 *
 */
+ (NSMutableDictionary *)conversionUnitDataPull:(NSDictionary *)dicData
{
    NSMutableDictionary *dicInfo = [NSMutableDictionary dictionaryWithDictionary:dicData];
  
    NSInteger dia = [dicData[@"dia"] integerValue];
    NSInteger sys = [dicData[@"sys"] integerValue];
    
    NSDictionary *dic = UNITS_TYPE_DATA;
    if (dic.allKeys.count >0) {
        
        if ([dic[@"blood"] integerValue] ==0) {
            float floDia = dia * UNITS_TYPE_BLOOD;
            float floSys = sys * UNITS_TYPE_BLOOD;
            
            NSString *diaStr = [NSString stringWithFormat:@"%.0f",floDia];
            NSString *sysStr = [NSString stringWithFormat:@"%.0f",floSys];
            [dicInfo setObject:diaStr forKey:@"dia"];
            [dicInfo setObject:sysStr forKey:@"sys"];
            
            return dicInfo;
        }
    }
    return dicInfo;
}


#pragma 获取截屏图片
+ (UIImage *)getImageUIScreenFromViewBg{
    
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
//    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
//    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
}
//图片剪裁成圆形图
+ (UIImage *)circleImage:(UIImage*)image withParam:(CGFloat)inset
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 3.0f, image.size.height - inset * 1.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
//    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
+ ( UIImage *)getEllipseImageWithImage:( UIImage *)originImage

{
    
    CGFloat padding = 1 ; // 圆形图像距离图像的边距
    
    UIColor * epsBackColor = [ UIColor greenColor ]; // 图像的背景色
    
    CGSize originsize = originImage. size ;
    
    CGRect originRect = CGRectMake ( 0 , 0 , originsize. width , originsize.height );
    
    UIGraphicsBeginImageContext (originsize);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext ();
    
    // 目标区域。
    
    CGRect desRect =  CGRectMake (padding, padding,originsize. width -(padding* 2 ), originsize. height -(padding* 2 ));
    
    // 设置填充背景色。
    
    CGContextSetFillColorWithColor (ctx, epsBackColor. CGColor );
    
    UIRectFill (originRect); // 真正的填充
    
    // 设置椭圆变形区域。
    
    CGContextAddEllipseInRect (ctx,desRect);
    
    CGContextClip (ctx); // 截取椭圆区域。
    
    [originImage drawInRect :originRect]; // 将图像画在目标区域。
    
    UIImage * desImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return desImage;
    
}

+ (void)clearUserInfo
{
    [DataVesselObj shareInstance].titleName = @"";
    [DataVesselObj shareInstance].roleid = 0;
    
    [SavaData writeArrToFile:@[] FileName:UserMemberList];
    [SavaData writeDicToFile:nil FileName:User_File];
    [[SavaData shareInstance] savadataStr:nil KeyString:USER_ID_SAVA];
    [[SavaData shareInstance] savaDictionary:nil keyString:User_Family_City];
    [SavaData writeArrToFile:nil FileName:USER_HEAD_IMAGE];
    [SavaData removeUserDataManager];
}



@end
