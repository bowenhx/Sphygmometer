//
//  DeviceViewController.h
//  Sphygmometer
//
//  Created by Guibin on 14-5-15.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
typedef enum {
    memberTypeHiddenBack,
    memberTypeShowBack,
}memberType;
@interface DeviceViewController : BaseViewController

@property (nonatomic)memberType memberStatus;

@end
