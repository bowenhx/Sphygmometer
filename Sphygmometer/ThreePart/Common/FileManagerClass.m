//
//  FileManagerClass.m
//  FetalInstrument
//
//  Created by gugu on 14-4-29.
//  Copyright (c) 2014年 深圳市呱呱网络科技有限公司. All rights reserved.
//

#import "FileManagerClass.h"
#import "ConstantConfig.h"
@implementation FileManagerClass

//判断该文件是否存在，不存在就创建
+ (BOOL) judgePlistFileIsExit: (NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //查找文件，如果不存在，就创建一个文件
    
    if ([fileManager fileExistsAtPath: filePath]) {
        
        return YES;
        
    }else{
        
       return [fileManager createFileAtPath: filePath contents: nil attributes: nil];

    }
    
}

//创建目录
+ (BOOL)createPlistDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //定义记录文件全名以及路径的字符串filePath
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [basePath stringByAppendingPathComponent: FetalMoveFilePath];
    
    //查找文件，如果不存在，就创建一个文件
    
    if (![fileManager fileExistsAtPath:filePath]) {
        
        return [fileManager createDirectoryAtPath: filePath withIntermediateDirectories: YES attributes:nil error:nil];
        
    }else{
        
        return YES;
    
    }
    

}

//创建文件目录
+ (BOOL)createFileDirectory: (NSString *)directoryName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //定义记录文件全名以及路径的字符串filePath
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [basePath stringByAppendingPathComponent: directoryName];
    
    //查找文件，如果不存在，就创建一个文件
    
    if (![fileManager fileExistsAtPath:filePath]) {
        
        return [fileManager createDirectoryAtPath: filePath withIntermediateDirectories: YES attributes:nil error:nil];
        
    }else{
        
        return YES;
        
    }
    
    
}

//获取完整路径
+ (NSString *) getCompleteFilePath: (NSString *)fileName withDirectoryName: (NSString *)directoryName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    basePath = [basePath stringByAppendingPathComponent: directoryName];
    
    NSString *filePath = [basePath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.plist", fileName]];
    
    return filePath;

}

//获取Documents目录下文件完整路径
+ (NSString *) getDocumentsFilePath: (NSString *)fileName{
    NSString *completePath = [[FileManagerClass getDocumentsPath] stringByAppendingPathComponent: fileName];
    
    return completePath;

}

//获取Documents路径
+ (NSString *) getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return basePath;

}

//获取音频文件路径
+ (NSString *) getCompleteFilePath: (NSString *)videoName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    basePath = [basePath stringByAppendingPathComponent: kAudioFilePath];
    
    NSString *videoPath = [basePath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.plist", videoName]];
    
    return videoPath;
    
}

//删除Plist文件
+ (void) deletePlistFile: (NSString *)deletePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *currentDeletePath = [FileManagerClass getCompleteFilePath: deletePath];
    
    [fileManager removeItemAtPath: currentDeletePath error: nil];

}


@end
