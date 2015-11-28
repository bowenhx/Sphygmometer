//
//  DataDefine.h
//  BloodPressure
//
//  Created by Guibin on 14-5-9.
//  Copyright (c) 2014年 深圳呱呱网络科技有限公司. All rights reserved.
//

#ifndef BloodPressure_DataDefine_h
#define BloodPressure_DataDefine_h

#define LINKWEBVIEWURL      @"http://www.g-doing.com"




//#define BASE_REQUEST_URL @"http://i.gugubaby.com/project_jiemeisi/api/"

#define BASE_REQUEST_URL @"http://121.40.146.159/api/"


#define PHP_URL @"http://121.40.146.159/"


//百度地图的KEY
#define kBaiduMapKey @"bpIeRcaYumoTFi4exDTjLadk"

//检查网络
#define CHECK_NETWORK      [Connection checkNetwork]

#define USER_ID_SAVA        @"OWNUSERID"

//获取用户UID
#define USERID              [[SavaData shareInstance] printDataStr:USER_ID_SAVA]

//用户信息的缓存文件plist
#define User_File           [NSString stringWithFormat:@"user_%@.plist",USERID]

//缓存用户成员列表信息
#define UserMemberList     [NSString stringWithFormat:@"memberList_%@.plist",USERID]

//养生中 -- 存放临时数据
#define CollectTempDic  [NSString stringWithFormat:@"temp%@.plist",USERID]

//养生 --  收藏到本地数据
#define CollectFile  [NSString stringWithFormat:@"collect_%@.plist",USERID]

//设置-- 闹钟
#define Awoke   [NSString stringWithFormat:@"awoke_%@.plist",USERID]

/**
 *  监听点击一周测量结果详情页数据
 */
#define SelectDetailNotificationCenter @"selectDetailNotificationCenter"
/**
 *  监听点击最近时间测量结果详情数据
 */
#define NewlydetaileDataNotificationCenter @"newlydetaileDataNotificationCenter"

//单位名称字典
#define UnitsType  [NSString stringWithFormat:@"units_%@.plist",USERID]

//注册完成后，触发登录操作
#define RegisterFinishNotificationCenter @"registerFinishNotificationCenter"

//选择城市完成触发
#define CountySelectNSNotificationCenter @"countySelectNSNotificationCenter"

//改变tabBar选项触发
#define ChangeTabBarNotificationCenter  @"changeTabBarNotificationCenter"

//单位换算
#define UNITS_TYPE_DATA  [SavaData parseDicFromFile:UnitsType]

//设备SN号码
#define DeviceSN_Code [NSString stringWithFormat:@"device_SN_%@",USERID]


#define USER_HEAD_IMAGE [NSString stringWithFormat:@"user_image_%@.plist",USERID]

//保存用户家庭地址
#define User_Family_City [NSString stringWithFormat:@"family_%@",USERID]


#define kLGPeripheralDidConnect  @"lGPeripheralDidConnect"

#define kLGPeripheralDidDisconnect @"lGPeripheralDidDisconnect"

// Error Domains
#define kLGPeripheralConnectionErrorDomain  @"lGPeripheralConnectionErrorDomain"



//转化单位
#define UNITS_TYPE_WEIGHT 2.204622621849
#define UNITS_TYPE_HEIGHT 0.0328084
#define UNITS_TYPE_BLOOD  0.133

#ifndef PX_STRONG
#if __has_feature(objc_arc)
#define PX_STRONG strong
#else
#define PX_STRONG retain
#endif
#endif

#ifndef PX_WEAK
#if __has_feature(objc_arc_weak)
#define PX_WEAK weak
#elif __has_feature(objc_arc)
#define PX_WEAK unsafe_unretained
#else
#define PX_WEAK assign
#endif
#endif

#if __has_feature(objc_arc)
#define PX_AUTORELEASE(expression) expression
#define PX_RELEASE(expression) expression
#define PX_RETAIN(expression) expression
#else
#define PX_AUTORELEASE(expression) [expression autorelease]
#define PX_RELEASE(expression) [expression release]
#define PX_RETAIN(expression) [expression retain]
#endif

//判断系统语言是否是英语
#define IsEnglish       [SavaData isEnglish]

//判断系统语言要传的参数
#define langType    @"lang"
#define language  IsEnglish ? @"en" : @"ch"

#define Loading  IsEnglish ? @"Loading..." : @"正在加载..."

#define NetworkFail IsEnglish ? @"network link abnormal" : @"网络链接异常"

#define Cancel  IsEnglish ? @"Cancel" : @"取消"

#define Verify  IsEnglish ? @"Verify" : @"确定"

#define HeightCm  IsEnglish ? @"Height cm" : @"身高"

#define HeithtFt IsEnglish ? @"Height ft" : @"身高"

#define WeightKg IsEnglish ? @"Weight kg" : @"体重"

#define WeightLb IsEnglish ? @"Weight lb" : @"体重"



////////////
#define Severe  IsEnglish ? @"High" : @"重度"

#define Moderate  IsEnglish ? @"Midd" : @"中度"

#define Mild  IsEnglish ? @"Mild" : @"轻度"

#define Normal  IsEnglish ? @"Norm" : @"正常"

#define Optimal  IsEnglish ? @"Best" : @"理想"

#define Low  IsEnglish ? @"Low" : @"偏低"
//////////////////

//#define Severe  IsEnglish ? @"Severe hypertension" : @"重度"
//
//#define Moderate  IsEnglish ? @"Moderate hypertension" : @"中度"
//
//
//#define Mild  IsEnglish ? @"Mild hypertension" : @"轻度"
//
//#define Normal  IsEnglish ? @"Normal" : @"正常"
//
//#define Optimal  IsEnglish ? @"Optimal" : @"理想"
//
//#define Low  IsEnglish ? @"Low" : @"偏低"



#define SYS  IsEnglish ? @"SYS" : @"收缩压"

#define DIA  IsEnglish ? @"DIA" : @"舒张压"

#define HR  IsEnglish ? @"H.R." : @"心率"

#define SaveSuccessd IsEnglish ? @"Date Stored successfully": @"保存成功"

#define Remind IsEnglish ? @"Remind" : @"提醒"







/*-------------------------------------------------------------------------------------
     **   接口部分api
     **   这里写成宏方便调用
*/
//用户登录
#define Api_UserLogin @"user/login"

//用户注册
#define Api_UserRegister @"user/register"

//城市区县搜索
#define Api_CitySearch  @"region/search"

//一次性请求所有省份城市列表
#define Api_AllCityList  @"region/allcitys"

//省份列表
#define Api_ProvinceList @"region/province"

//城市列表
#define Api_RegionCity  @"region/city"

//区县列表
#define Api_CountyList @"region/county"


/*
 ********************************************* 用户信息 API  *************************
 */

//成员列表
#define Api_RoleList @"role/"

//添加成员
#define Api_RoleAdd   @"role/add"

//编辑成员
#define Api_RoleEdit @"role/edit"

//删除成员
#define Api_RoleDelete @"role/delete"

//绑定成员到血压计
#define Api_RoleBinding @"role/binding"

//成员测量历史记录
#define Api_RoleHistory @"role/history"

//删除历史记录
#define Api_RoleDeldata @"role/deldata"

//蓝牙测量数据提交服务器
#define Api_RoleBluePost @"role/postBlue"

/*
 ********************   养生  API **************
 */

//资讯列表
#define Api_NewsList @"news/index/"

//置顶资讯
#define Api_NewsTop @"news/top/"

/*
 *********************    其他  API  *****************
 */

//天气预报
#define Api_Weather @"weather"

//意见反馈
#define Api_FeedBack @"feedback/add"

//版本检测
#define Api_Version @"version/isupdate"

//远程闹钟
#define Api_ClockUrl @"clock"

//设备扫描
#define Api_Scanning @"scanning/"

//广告图片
#define Api_TopImage @"topimage"

//获取推送消息
#define Api_PushNews @"push"


#pragma mark 健康讯息
#define STATUS_5 IsEnglish ? @"Eating food with less salt, do not take in acrimony excitant food, eat more fresh fruit and vegetables, and avoid excited or emotional mood, quit smoking and wine, Keep monitoring blood pressure every day. Please turn to you doctor at any unnormal health condition." :  @"请您低盐饮食，低脂肪饮食。禁烟，酒，避免情绪激动。在医生指导下选择服用降压药。并每天定时监测血压情况。"

#define STATUS_4 IsEnglish ? @"Eating food with less salt, do not take in acrimony excitant food, eat more fresh fruit and vegetables, and avoid excited or emotional mood, quit smoking and wine, Keep monitoring blood pressure every day. Please turn to you doctor at any unnormal health condition." :  @"请您低盐饮食，低脂肪饮食。禁烟，酒，避免情绪激动。在医生指导下选择服用降压药。并每天定时监测血压情况。"

#define STATUS_3 IsEnglish ? @"If there is not any symptoms, please do not take any medicine. Body fitness can be adjusted and improved by the diet. Eating food with less salt, do not take in acrimony excitant food, eat more fresh fruit and vegetables, and avoid excited or emotional mood, quit smoking and wine, take some appropriate exercise and have rest in time. Keep monitoring blood pressure every day. Please turn to you doctor at any unnormal health condition." :  @"如果没有什么不适症状，可以不用药物，可从饮食习惯上调整改善。饮食清淡少盐，避免辛辣刺激性食物，多吃新鲜水果蔬菜，避免情绪激动，戒烟酒，适当锻炼，多休息。每天定时监测血压，注意观察血压变化，随时就诊。"

#define STATUS_2 IsEnglish ? @"Your blood pressure is normal, please keep a regular life, avoid long motionless; Keep eating food with low salt, low fat. Keep good reasonable working and resting habit ; Keep a good, positive and optimistic mood." :  @"您的血压是正常范围，请保持有规律的生活，避免久座不动；注意低盐低脂清淡饮食，合理的作息时间；保持良好的情绪，减少烦恼心情，积极乐观。"

#define STATUS_1 IsEnglish ? @"Now your blood pressure is in a state of ideal, continue to maintain a healthy lifestyle." :  @"目前您的血压处于非常理想的状态，继续保持健康的生活习惯。"

#define STATUS_0 IsEnglish ? @"You should choose healthy food easy to digest and nutritious. Do not excessive dieting, and three meals a day is indispensable. Take part in physical exercise to improve physical fitness. Increase nutrition, drink more water, eat more soup, daily salt slightly more than the average man; If there are obvious symptoms, turn to your doctor and take the treatment actively." :  @"您应当选择容易消化而营养丰富的健康食物，不要过度节食，一日三餐不可或缺。参加体育锻炼，改善体质，增加营养，多喝水，多吃汤，每日食盐略多于常人；要是有明显症状，必须给予积极治疗，改善症状。"






/*
 ** 数据库部分 表单结构-----------------------------------------------------------------------------------------------
 ** 关联数据库
 */

#define DBVersion   @"CREATE TABLE if not exists 'DBVersion'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,dbVersion integer)"

//收藏数据表结构
#define Collect(UIDNAME)[NSString stringWithFormat:@"CREATE TABLE if not exists 'Collect_%@'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,cname TEXT,cdescription TEXT,edescription TEXT,ename TEXT,formattime TEXT,listID INTEGER,jcsort TEXT,name TEXT,nid INTEGER,number INTEGER,offer INTEGER,pid INTEGER,rid INTEGER,workday INTEGER,collectTime TEXT,type1 TEXT,type2 TEXT,type3 TEXT)",UIDNAME]

//查询数据表
#define ReferData(UIDNAME)[NSString stringWithFormat:@"CREATE TABLE if not exists 'ReferData_%@'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,cname TEXT,cdescription TEXT,edescription TEXT,ename TEXT,formattime TEXT,listID INTEGER,jcsort TEXT,name TEXT,nid INTEGER,number INTEGER,offer INTEGER,pid INTEGER,rid INTEGER,workday INTEGER,collectTime TEXT,fields TEXT)",UIDNAME]




#endif
