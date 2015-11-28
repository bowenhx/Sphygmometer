//
//  BKCalendar.h
//  ClassLIbShow
//
//  Created by Bernie Tong on 13-9-26.
//  Copyright (c) 2013年 Bernie Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKCalendar : NSObject

//单例
+ (BKCalendar *)shared;

/**
 *	@brief	把时间转换成当前时间
 *
 *	@param 	date 	传入时间
 *
 *	@return	转换后的当前时间
 */
+ (NSDate *)changeDateToLocalDate:(NSDate *)date;

/**
 *	@brief	取得当前日期前几天或后几天日期
 *
 *	@param 	idx 	传入间隔数：比当前日前的idx为负数 比当前日后的idx为正数
 *
 *	@return	目标日期
 */
+ (NSDate *)getDateOldOrNewDateWithNowDate:(NSInteger )idx;


/**
 *	@brief	取得明天的时间
 *
 *	@param 	nowDate   时间
 *
 *	@return	明天时间
 */
+ (NSDate *)getTomorrowDate:(NSDate *)nowDate;

/**
 *	@brief	格式化时间
 *
 *	@param 	date 	待格式化的时间
 *	@param 	dateFormatString 	格式
 *
 *	@return	格式化后的字符串
 */
+ (NSString *)changeDateStyle:(NSDate *)date withDateFormat:(NSString *)dateFormatString;


/**
 *	@brief	根据时间字符串格式化得出对应时间
 *
 *	@param 	dateString 	时间字符串
 *	@param 	dateFormatString 	格式
 *
 *	@return	格式化后得到的时间
 */
+ (NSDate *)getDateWithDateString:(NSString *)dateString withDateFormat:(NSString *)dateFormatString;


/**
 *	@brief	取得传入时间是星期几
 *
 *	@param 	date 	传入时间
 *
 *	@return	星期几
 */
+ (NSString *)getWeekDay:(NSDate *)date;

/**
 *	@brief	取得传入时间的小时数
 *
 *	@param 	date 	传入时间
 *
 *	@return	小时数
 */
+ (NSInteger)getHours:(NSDate *)date;

/**
 *	@brief	取得传入时间的日数
 *
 *	@param 	date 	传入时间
 *
 *	@return	日数
 */
+ (NSInteger)getDay:(NSDate *)date;

/**
 *	@brief	取得传入时间的月数
 *
 *	@param 	date 	传入时间
 *
 *	@return	月数
 */
+ (NSInteger)getMonth:(NSDate *)date;

/**
 *	@brief	取得传入时间的年数
 *
 *	@param 	date 	传入时间
 *
 *	@return	年数
 */
+ (NSInteger)getYear:(NSDate *)date;

/**
 *	@brief	比较两个时间相差多少天
 *
 *	@param 	fromDate 	比较时间1
 *	@param 	toDate 	比较时间2
 *
 *	@return	相差的天数
 */
+ (NSInteger)getDays:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
