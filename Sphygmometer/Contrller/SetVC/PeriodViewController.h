//
//  PeriodViewController.h
//  Sphygmometer
//
//  Created by Guibin on 14-6-12.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * const ChangeRefrainNotificationCenter = @"changeRefrainNotificationCenter";

@interface PeriodViewController : BaseTableViewController

@property (nonatomic , copy)NSString *periodStr;

@end
