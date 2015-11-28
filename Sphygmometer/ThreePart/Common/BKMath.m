//
//  BKMath.m
//  ClassLIbShow
//
//  Created by Bernie Tong on 13-9-26.
//  Copyright (c) 2013年 Bernie Tong. All rights reserved.
//

#import "BKMath.h"
#import <math.h>

#define kIsPhone @"^[1][358][0-9]{9}$"
#define kIsDigital @"^[0-9]*$"
#define kIsLetter @"^[A-Za-z]+$"
#define kIsLetter09 @"^[A-Za-z0-9]+$"
#define kIsLetter09_ @"^\\w+$"
#define kIsEmail @"^[\\w\\-\\.]+@[\\w\\-\\.]+(\\.\\w+)+$"



static BKMath *instance = nil;

@implementation BKMath



#pragma mark NSObject

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}


#pragma mark BKMath (class methods)

+ (BKMath *)shared
{
    if (instance == nil)
    {
        instance = [[BKMath alloc] init];
    }
    
    return instance;
}


#pragma mark BKMath (private)
- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}



#pragma mark BKMath

+ (BOOL)predicate_phone:(NSString *)modelphone {
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kIsPhone];
    if (![predicate_phone evaluateWithObject:modelphone]) {
        [[BKMath shared] showMessage:@"电话号码输入错误"];
        return NO;
    }
    return YES;
}



+ (BOOL)predicate_digital:(NSString *)string {
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kIsDigital];
    if (![predicate_phone evaluateWithObject:string]) {
        [[BKMath shared] showMessage:@"不是数字"];
        return NO;
    }
    return YES;
}


+ (BOOL)predicate_digital:(NSString *)string withIndex:(NSInteger)index {
    
    if (index < string.length) {
        NSString *predicateString = [string substringWithRange:NSMakeRange(index, 1)];
        
        NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kIsDigital];
        if (![predicate_phone evaluateWithObject:predicateString]) {
//            [[BKMath shared] showMessage:@"不是数字"];
            return NO;
        }
        return YES;
    } else {
//        [[BKMath shared] showMessage:@"字符串长度过短"];
        return NO;
    }
    

}


+ (BOOL)predicate_createAZazString:(NSString *)string {
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kIsLetter];
    if (![predicate_phone evaluateWithObject:string]) {
        [[BKMath shared] showMessage:@"不是由字母组成"];
        return NO;
    }
    return YES;
}



+ (BOOL)predicate_createAZaz09String:(NSString *)string {
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kIsLetter09];
    if (![predicate_phone evaluateWithObject:string]) {
        [[BKMath shared] showMessage:@"不是由数字和26个英文字母组成"];
        return NO;
    }
    return YES;
}


+ (BOOL)predicate_createAZaz09and_String:(NSString *)string {
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kIsLetter09_];
    if (![predicate_phone evaluateWithObject:string]) {
        [[BKMath shared] showMessage:@"不是由数字、26个英文字母或者下划线组成"];
        return NO;
    }
    return YES;
}



+ (BOOL)predicate_email:(NSString *)string {
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kIsEmail];
    if (![predicate_phone evaluateWithObject:string]) {
        [[BKMath shared] showMessage:@"邮箱不正确"];
        return NO;
    }
    return YES;
    
}


+ (BOOL)predicate_idCard:(NSString *)string {
    
    if (string.length != 18) {
        [[BKMath shared] showMessage:@"身份证格式不正确"];
        return NO;
    }
    
    NSBundle *budle = [NSBundle mainBundle];
    NSString *filePath = [budle pathForResource:@"idcardareacode" ofType:@".plist"];
    NSArray *areacode = [NSArray arrayWithContentsOfFile:filePath];
    
    NSString *areacodeString = [string substringWithRange:NSMakeRange(0, 6)];
    NSLog(@"areaCodeString = %@",areacodeString);
    
    BOOL isIn = NO;
    for (NSString *code in areacode) {
        
        if ([code isEqualToString:areacodeString]) {
            isIn = YES;
            break;
        }
        
    }
    
    if (isIn) {
        NSLog(@"合法地区");
    } else {
        NSLog(@"非法地区");
        [[BKMath shared] showMessage:@"非法地区"];
        return NO;
    }
    
    NSString *year = [string substringWithRange:NSMakeRange(6, 4)];
    NSLog(@"year = %@",year);
    
    NSString *month = [string substringWithRange:NSMakeRange(10, 2)];
    NSLog(@"month = %@",month);
    
    NSString *day = [string substringWithRange:NSMakeRange(12, 2)];
    NSLog(@"year = %@",day);
    
    NSString *sBrithday = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter1 setDateFormat:@"yyyy"];
    
    NSString *currentYear = [dateFormatter1 stringFromDate:[NSDate date]];
    
    NSLog(@"currentYear = %@",currentYear);
    [dateFormatter1 release];
    
    
    if ([year integerValue] > 1900 && [year integerValue] < [currentYear integerValue]) {
        NSLog(@"年合法");
    } else {
        NSLog(@"年非合法");
        [[BKMath shared] showMessage:@"年非合法"];
        return NO;
    }
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter2 dateFromString:sBrithday];
    [dateFormatter2 release];
    
    if (date) {
        NSLog(@"出生日期合法");
    } else {
        NSLog(@"出生日期非法");
        [[BKMath shared] showMessage:@"出生日期非法"];
        return NO;
    }
    
    /** 每位加权因子 */
    NSArray *power = [[NSArray alloc] initWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    
    int iSum = 0;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSString *temp = [string substringToIndex:17];
    
    NSLog(@"%@",temp);
    
    for (int i = 0; i < temp.length; i++) {
        [tempArray addObject:[temp substringWithRange:NSMakeRange(i, 1)]];
    }
    
    if (power.count == tempArray.count) {
        for (int i = 0; i < tempArray.count; i++) {
            for (int j = 0; j < power.count; j++) {
                if (i == j) {
                    iSum = iSum + [tempArray[i] integerValue] * [power[j] integerValue];
                }
            }
        }
    }
    [power release];
    
    NSString *sCode = nil;
    switch (iSum % 11) {
        case 10:
            sCode = @"2";
            break;
        case 9:
            sCode = @"3";
            break;
        case 8:
            sCode = @"4";
            break;
        case 7:
            sCode = @"5";
            break;
        case 6:
            sCode = @"6";
            break;
        case 5:
            sCode = @"7";
            break;
        case 4:
            sCode = @"8";
            break;
        case 3:
            sCode = @"9";
            break;
        case 2:
            sCode = @"x";
            break;
        case 1:
            sCode = @"0";
            break;
        case 0:
            sCode = @"1";
            break;
    }
    
    NSString *code18 = [string substringWithRange:NSMakeRange(17, 1)];

    if ([sCode caseInsensitiveCompare:code18] == NSOrderedSame) {
        NSLog(@"身份证合法");
        return YES;
    } else {
        NSLog(@"身份证非法");
        [[BKMath shared] showMessage:@"身份证非法"];
        return NO;
    }


    return NO;
}


+ (float)calculateTwoPiontDistance:(CGPoint)firstPoint withSecondPoint:(CGPoint)secondPoint {
    float offsetX = (firstPoint.x - secondPoint.x) * (firstPoint.x - secondPoint.x);
    float offsetY = (firstPoint.y - secondPoint.y) * (firstPoint.y - secondPoint.y);
    
    float distance = sqrtf(offsetX + offsetY);
    return distance;
}


+ (UIColor *)getColor:(NSString *)hexColor {
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


+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha {
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


+ (UIColor *)getColor:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
