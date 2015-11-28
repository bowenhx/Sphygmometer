//
//  FileManagerClass.h
//  FetalInstrument
//
//  Created by gugu on 14-4-29.
//  Copyright (c) 2014年 深圳市呱呱网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerClass : NSObject

//判断该文件是否存在
+ (BOOL) judgePlistFileIsExit: (NSString *)filePath;

//获取完整路径
+ (NSString *) getCompleteFilePath: (NSString *)fileName withDirectoryName: (NSString *)directoryName;

//创建目录
+ (BOOL)createPlistDirectory;

//获取Documents目录下文件完整路径
+ (NSString *) getDocumentsFilePath: (NSString *)fileName;

//获取Documents路径
+ (NSString *) getDocumentsPath;

//删除Plist文件
+ (void) deletePlistFile: (NSString *)deletePath;

//创建文件目录
+ (BOOL)createFileDirectory: (NSString *)directoryName;

@end
