//
//  BKNetStatus.h
//  ClassLIbShow
//
//  Created by Bernie Tong on 13-9-26.
//  Copyright (c) 2013年 Bernie Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface BKNetStatus : NSObject {
    Reachability *_reachDetector;
    BOOL         _isHaveNetwork;
}

@property (nonatomic, retain) Reachability *reachDetector;
@property BOOL         isHaveNetwork;

//单例
+ (BKNetStatus *)shared;

/**
 *	@brief	取得当前网络状态
 *
 *	@return	yes or no
 */
- (BOOL)haveNetWork;

@end
