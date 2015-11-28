//
//  ConstantConfig.h
//  BookingSystem
//
//  Created by gugu on 13-9-26.
//  Copyright (c) 2013年 cai. All rights reserved.
//

#ifndef BookingSystem_ConstantConfig_h
#define BookingSystem_ConstantConfig_h

// 安全释放对象
#define SAFETY_RELEASE(x)   {[(x) release]; (x)=nil;}

// 文字字体
#define DSFONT    @"MicrosoftYaHei"

// 获得特定字号的字体
#define GETFONT(x) [UIFont fontWithName:DSFONT size:(x)]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define GETBOLDFONT(x) [UIFont boldSystemFontOfSize:(x)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define SEPARATECOLOR           [UIColor colorWithRed:226.0/255.0f green:226.0/255.0f blue:226.0/255.0f alpha:1.0]

//共用的减去导航条跟tabbar的高度
#define CommonViewHeight(v) kIsIOS7 ? HEIGHT(v) - 108 : HEIGHT(v) - 88
//共用的减去导航条高度
#define CommonMinusNavHeight(v) kIsIOS7 ? HEIGHT(v) - 64 : HEIGHT(v) - 44

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)



#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height
#define HEIGHTADDY(v)           (v).frame.size.height + (v).frame.origin.y
#define WIDTHADDX(v)            (v).frame.size.width + (v).frame.origin.x

//图片宽高
#define ImageWidth(i)           (i).size.width
#define ImageHeight(i)          (i).size.height

//共用背景色
#define PublickBackColor [Common getColor: @"fafafa"]
//判断是否是ios8
#define kIsISO8 [UIDevice currentDevice].systemVersion.floatValue >= 8.0f

//判断是否是ios7
#define kIsIOS7 [UIDevice currentDevice].systemVersion.floatValue >= 7.0f

//判断是否是ios5
#define kIsIOS5 [UIDevice currentDevice].systemVersion.floatValue < 6.0f



//文本对齐方式
//右对齐
#define TextAlignmentStyleRight kIsIOS5 ? UITextAlignmentRight : NSTextAlignmentRight;
//左对齐
#define TextAlignmentStyleLeft kIsIOS5 ? UITextAlignmentLeft : NSTextAlignmentLeft;
//居中对齐
#define TextAlignmentStyleCenter kIsIOS5 ? UITextAlignmentCenter : NSTextAlignmentCenter;

//重新设置View的Frame
#define ViewFrame(v) kIsIOS7 ? CGRectMake(0,0,(v).frame.size.width,(v).frame.size.height - 20) : CGRectMake(0,0,(v).frame.size.width,(v).frame.size.height)

//皮肤切换全局通知
#define ThemeChangeNotification @"skin change"

//修改预产期通知
#define ModifyPeriodNofication @"modify period"

//修改右边栏选中状态的颜色
#define ModifyRightTextColor @"modifytextColor"

//以上是公用模块使用的宏
///////////////////////-------------------------分割线-----------------------/////////////////////////////////////////
//以下是单独模块使用的宏

#define PlaylevelGridCount  24  //横的格子数
#define PlayGridSeconds       10    //一格秒数

#define kChangeIndexViewNotication @"changeIndexViewNotication"

//插入耳机通知
#define InsertHeadsetNotification @"insert headset"

//音频路径
#define kAudioFilePath @"LocalDataFile/RecordVideo"

//保存胎动次数plist文件
#define FetalMoveFilePath @"LocalDataFile/FetalPlist"

//保存心率文件
#define RateValueFilePath @"LocalDataFile/RateValue"

//保存平均心率文件名
#define HeartRateFileName @"heartRateValue.plist"

//滑动页面时
#define SliderViewNotification @"slider View"

#endif
