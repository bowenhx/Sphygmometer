//
//  Common.h
//  SouthernFund
//
//  Created by jianle chen on 13-12-3.
//  Copyright (c) 2013年 深圳市呱呱网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//根IP
#define KBaseUrl @"http://i.gugubaby.com/project_jumper/sc/app_api/"

typedef enum{
    ChineseLanguage = 0,    //简体中文
    TraditionalLanguage,    //繁体中文
    EnglishLanguage,        //英文

} CurrentSystemLanguageType;


@interface Common : NSObject

+ (void)setSessionKey:(NSString *)sessionkey;

+ (NSString *)getSessionKey;

+ (BOOL)isLogin;

+ (void)clearSessionKey;

+ (BOOL)isLoginSinaWeibo;

+ (BOOL)isLoginTencetWeibo;

+ (UIColor *)getColor:(NSString *)hexColor;
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;

+ (NSString *) addNewCharacter: (NSString *)textString withType: (NSInteger)type;

//返回显示*号的手机号码,type为1是手机号，type为2是银行卡号
+ (NSString *) replaceStringWithStar: (NSString *)string withType: (NSInteger)type;

+ (UIImage *)screenWindowImage;

//判断系统语言
+ (CurrentSystemLanguageType)getPreferredLanguage;

//根据当前系统语言返回请求的语言参数
+ (NSString *) getCurrentLanguageString;

//时间戳转换为字符串
+ (NSString *) changeTimeToString: (NSString *)changeString withType: (NSInteger)type;

// 获取音频路径
+ (NSString *) getLocalVedioPath: (NSString *)vedioName;

//获取根路径
+ (NSString *) getDocumentPath;

@end

