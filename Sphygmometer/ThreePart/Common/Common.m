//
//  Common.m
//  SouthernFund
//
//  Created by jianle chen on 13-12-3.
//  Copyright (c) 2013年 深圳市呱呱网络科技有限公司. All rights reserved.
//

#import "Common.h"
#import "ConstantConfig.h"
@implementation Common

//+ (UIColor *) getCurrentColor{
//    
//
//}

+ (void)setSessionKey:(NSString *)sessionkey {
    [[NSUserDefaults standardUserDefaults] setValue:sessionkey forKey:@"sessionkey"];
}

+ (NSString *)getSessionKey {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionkey"];
}

+ (void)clearSessionKey {
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"sessionkey"];
}

+ (BOOL)isLogin {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"sessionkey"] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionkey"] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLoginSinaWeibo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults valueForKey:@"sweibo_access_token"] || [[userDefaults valueForKey:@"sweibo_access_token"] isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isLoginTencetWeibo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults valueForKey:@"qweibo_access_token"] || [[userDefaults valueForKey:@"qweibo_access_token"] isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

+ (UIColor *)getColor:(NSString *)hexColor{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
    
}
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}

+ (NSString *) addNewCharacter: (NSString *)textString withType: (NSInteger)type{
    NSString *yearString = [textString substringWithRange: NSMakeRange(0, 4)];
    NSString *monthString = [textString substringWithRange: NSMakeRange(4, 2)];
    NSString *dateString = [textString substringWithRange: NSMakeRange(6, 2)];
    
    NSString *newString = @"";
    
    if (type == 1) {
        newString = [NSString stringWithFormat: @"%@-%@-%@",yearString,monthString,dateString];
        
    }else{
        newString = [NSString stringWithFormat: @"%@年%@月%@日",yearString,monthString,dateString];
    
    }
    
    
//    NSString *tempString = [textString stringByPaddingToLength: textString.length + 5 withString: @"-" startingAtIndex: 0];
//    tempString = [tempString stringByPaddingToLength: tempString.length + 1 withString: @"-" startingAtIndex: 7];
    
    return newString;

}

//获得屏幕图像
+ (UIImage *)screenWindowImage
{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [screenWindow.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark 判断系统语言
+ (CurrentSystemLanguageType)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if ([preferredLang isEqualToString: @"zh-Hans"]) {
        return ChineseLanguage;
        
    }else if ([preferredLang isEqualToString: @"zh-Hant"]){
        return TraditionalLanguage;
    
    }else{
        return EnglishLanguage;
    
    }
    
}

//根据当前系统语言返回请求的语言参数
+ (NSString *) getCurrentLanguageString{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if ([preferredLang isEqualToString: @"zh-Hans"]) {
        return @"sc";
        
    }else if ([preferredLang isEqualToString: @"zh-Hant"]){
        return @"ch";
        
    }else{
        return @"en";
        
    }

}

#pragma mark 时间戳转换为字符串
+ (NSString *) changeTimeToString: (NSString *)changeString withType: (NSInteger)type{
    
    NSDateFormatter *dateFromatter2 = [[NSDateFormatter alloc] init];
    
    if (type == 1) {
        [dateFromatter2 setDateFormat: @"yyyy年MM月"];
        
    }else if(type == 2){
        [dateFromatter2 setDateFormat: @"yyyy-MM-dd"];
    
    }else{
        [dateFromatter2 setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
        [dateFromatter2 setDateFormat: @"MMMM yyyy"];
    
    }
    
    NSString *showString = [dateFromatter2 stringFromDate: [NSDate dateWithTimeIntervalSince1970: [changeString floatValue]]];
    [dateFromatter2 release];
    
    return showString;
    
}

#pragma mark 获取音频路径
+ (NSString *) getLocalVedioPath: (NSString *)vedioName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *filePath = [basePath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@/%@.caf", kAudioFilePath,vedioName]];
    
    return filePath;
    
}

#pragma mark 获取根路径
+ (NSString *) getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return basePath;

}

@end
