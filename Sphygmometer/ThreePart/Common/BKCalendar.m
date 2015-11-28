//
//  BKCalendar.m
//  ClassLIbShow
//
//  Created by Bernie Tong on 13-9-26.
//  Copyright (c) 2013年 Bernie Tong. All rights reserved.
//

#import "BKCalendar.h"

static BKCalendar *instance = nil;

@implementation BKCalendar

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


#pragma mark BKCalendar (class methods)

+ (BKCalendar *)shared
{
    if (instance == nil)
    {
        instance = [[[BKCalendar alloc] init] autorelease];
    }
    
    return instance;
}


#pragma mark BKCalendar (private)



#pragma mark BKCalendar

+ (NSDate *)changeDateToLocalDate:(NSDate *)date {
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    
    return localDate;
}



+ (NSDate *)getDateOldOrNewDateWithNowDate:(NSInteger )idx {
    NSTimeInterval timeInterval = 60 * 60 * 24 * idx;
    NSDate *toDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:[NSDate date]];
    return [BKCalendar changeDateToLocalDate:toDate];
}



+ (NSDate *)getTomorrowDate:(NSDate *)nowDate {
    NSTimeInterval timeInterval = 60*60*24;
    NSDate *toDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:nowDate];
    return [BKCalendar changeDateToLocalDate:toDate];
}



+ (NSString *)changeDateStyle:(NSDate *)date withDateFormat:(NSString *)dateFormatString {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:dateFormatString];
//    [dateFormatter setWeekdaySymbols:[NSArray arrayWithObjects:@"星期日",
//                                      @"星期一",
//                                      @"星期二",
//                                      @"星期三",
//                                      @"星期四",
//                                      @"星期五",
//                                      @"星期六",nil]];

    return [dateFormatter stringFromDate:date];
}



+ (NSDate *)getDateWithDateString:(NSString *)dateString withDateFormat:(NSString *)dateFormatString {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:dateFormatString];
//    [dateFormatter setWeekdaySymbols:[NSArray arrayWithObjects:@"星期日",
//                                      @"星期一",
//                                      @"星期二",
//                                      @"星期三",
//                                      @"星期四",
//                                      @"星期五",
//                                      @"星期六",nil]];
    
    return [dateFormatter dateFromString:dateString];
}



+ (NSString *)getWeekDay:(NSDate *)date {
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    [canlendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [canlendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSLog(@"%d",dateComponents.weekday);
    
    NSArray *array = [[[NSArray alloc] initWithObjects:@"星期日",
                      @"星期一",
                      @"星期二",
                      @"星期三",
                      @"星期四",
                      @"星期五",
                      @"星期六", nil] autorelease];
    
    return [array objectAtIndex:dateComponents.weekday - 1];
}




+ (NSInteger)getHours:(NSDate *)date {
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    [canlendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [canlendar components:NSCalendarUnitHour fromDate:[BKCalendar changeDateToLocalDate:date]];
    
    return dateComponents.hour;
}



+ (NSInteger)getDay:(NSDate *)date {
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    [canlendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [canlendar components:NSCalendarUnitDay fromDate:[BKCalendar changeDateToLocalDate:date]];
    
    return dateComponents.day;
}



+ (NSInteger)getMonth:(NSDate *)date {
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    [canlendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [canlendar components:NSCalendarUnitMonth fromDate:[BKCalendar changeDateToLocalDate:date]];
    
    return dateComponents.month;
}



+ (NSInteger)getYear:(NSDate *)date {
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    [canlendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [canlendar components:NSCalendarUnitYear fromDate:[BKCalendar changeDateToLocalDate:date]];
    
    return dateComponents.year;
}



+ (NSInteger)getDays:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    [canlendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSUInteger unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *components = [canlendar components:unitFlags fromDate:[BKCalendar changeDateToLocalDate:fromDate] toDate:[BKCalendar changeDateToLocalDate:toDate] options:0];
    
    return [components day];
}

@end
