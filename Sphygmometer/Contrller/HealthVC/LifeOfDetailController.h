//
//  LifeOfDetailController.h
//  Sphygmometer
//
//  Created by Guibin on 14-6-10.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
static NSString  * const CollectDataNotificationCenter = @"collectDataNotificationCenter";

@interface LifeOfDetailController : BaseViewController


@property (nonatomic, strong) UIWebView *lifeWebView;
@property (nonatomic, strong) NSString *titleString;            //标题
@property (nonatomic, strong) NSString *newsWebUrl;         //新闻地址
@property (nonatomic) NSInteger typeID;         //判断是否收藏
@end
