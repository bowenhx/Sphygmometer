//
//  BKNetStatus.m
//  ClassLIbShow
//
//  Created by Bernie Tong on 13-9-26.
//  Copyright (c) 2013年 Bernie Tong. All rights reserved.
//

#import "BKNetStatus.h"

static BKNetStatus *instance = nil;

@implementation BKNetStatus
@synthesize reachDetector = _reachDetector;
@synthesize isHaveNetwork = _isHaveNetwork;

#pragma mark NSObject

- (id)init
{
    if ((self = [super init]))
    {
        [self initCurrentNewwork];
    }
    return self;
}


#pragma mark BKNetStatus (class methods)

+ (BKNetStatus *)shared
{
    if (instance == nil)
    {
        instance = [[BKNetStatus alloc] init];
    }
    
    return instance;
}


#pragma mark BKNetStatus (private)
- (void)refrushCurrentNetworkStatus:(Reachability*)currentReach
{
    if ([currentReach isKindOfClass:[Reachability class]])
    {
        NetworkStatus netStatus = [currentReach currentReachabilityStatus];
        
        switch (netStatus)
        {
            case NotReachable:
            {
                self.isHaveNetwork = NO;
            }
				break;
            case ReachableViaWiFi:
                self.isHaveNetwork = YES;
                
                break;
            case ReachableViaWWAN:
                self.isHaveNetwork = YES;
                
                break;
            default:
                break;
        }
    }
}

- (void)currentInternetStatus
{
    [self refrushCurrentNetworkStatus:self.reachDetector];
}

- (void)rechabilityChanged:(NSNotification*)notification
{
    Reachability *currentReach = [notification object];
    [self refrushCurrentNetworkStatus:currentReach];
}

- (void)initCurrentNewwork
{
    self.reachDetector = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rechabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.reachDetector startNotifier];
    [self currentInternetStatus];
}

- (BOOL)haveNetWork
{
    [self currentInternetStatus];
    return self.isHaveNetwork;
}


#pragma mark BKNetStatus

@end
