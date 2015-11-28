//
//  BKMath.h
//  ClassLIbShow
//
//  Created by Bernie Tong on 13-9-26.
//  Copyright (c) 2013年 Bernie Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface BKMath : NSObject

//单例
+ (BKMath *)shared;

/**
 *	@brief	验证手机号码
 *
 *	@param 	modelphone 	手机号码
 *
 *	@return	YES or No
 */
+ (BOOL)predicate_phone:(NSString *)modelphone;

/**
 *	@brief	判断字符是否为数字
 *
 *	@param 	string 	待判断字符串
 *
 *	@return	YES or NO
 */
+ (BOOL)predicate_digital:(NSString *)string;

/**
 *	@brief	判断字符串第index位是否为数字
 *
 *	@param 	string 	待判断字符串
 *	@param 	index 	索引
 *
 *	@return	YES or NO
 */
+ (BOOL)predicate_digital:(NSString *)string withIndex:(NSInteger)index;

/**
 *	@brief	验证由26个英文字母组成的字符串
 *
 *	@param 	string 	待判断字符串
 *
 *	@return	YES or NO
 */
+ (BOOL)predicate_createAZazString:(NSString *)string;

/**
 *	@brief	验证由数字和26个英文字母组成的字符串
 *
 *	@param 	string 	待判断字符串
 *
 *	@return	YES or NO
 */
+ (BOOL)predicate_createAZaz09String:(NSString *)string;

/**
 *	@brief	验证由数字、26个英文字母或者下划线组成的字符串
 *
 *	@param 	string 	待判断字符串
 *
 *	@return	YES or NO
 */
+ (BOOL)predicate_createAZaz09and_String:(NSString *)string;

/**
 *	@brief	验证email
 *
 *	@param 	string 	待判断字符串
 *
 *	@return	YES or NO
 */
+ (BOOL)predicate_email:(NSString *)string;

/**
 *	@brief	验证身份证格式
 *
 *	@param 	string 	身份证字符串
 *
 *	@return	YES OR NO
 */
+ (BOOL)predicate_idCard:(NSString *)string;

/**
 *	@brief	计算两点的距离
 *
 *	@param 	firstPoint 	第一点
 *	@param 	secondPoint 	第二点
 *
 *	@return	返回距离
 */
+ (float)calculateTwoPiontDistance:(CGPoint)firstPoint withSecondPoint:(CGPoint)secondPoint;

/**
 *	@brief	转换把给出的颜色值如：686868 转换为 UIColor
 *
 *	@param 	hexColor 	颜色值
 *
 *	@return	转换后的颜色值
 */
+ (UIColor *)getColor:(NSString *)hexColor;

/**
 *	@brief	转换把给出的颜色值如：686868 转换为 UIColor 带透明度
 *
 *	@param 	hexColor 	颜色值
 *	@param 	alpha 	透明度
 *
 *	@return	转换后的颜色值
 */
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;

/**
 *	@brief  转换把给出的颜色值如：144，155，255 转换为 UIColor
 *
 *	@param 	red 	红色
 *	@param 	green 	绿色
 *	@param 	blue 	蓝色
 *	@param 	alpha 	透明度
 *
 *	@return	转换后的颜色值
 */
+ (UIColor *)getColor:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

@end
