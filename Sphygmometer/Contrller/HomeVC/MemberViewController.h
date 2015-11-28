//
//  MemberViewController.h
//  Sphygmometer
//
//  Created by Guibin on 14-7-2.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const EditMemberNameNotificationCenter = @"editMemberNameNotificationCenter";
@interface MemberViewController : BaseViewController

@property (nonatomic , copy)NSString *userName;
@end
