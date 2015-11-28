//
//  FamilyViewController.h
//  Sphygmometer
//
//  Created by Guibin on 14-5-15.
//  Copyright (c) 2014年 cai. All rights reserved.
//

//成员血压详细数据页面

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ShareView:UIView
@property (nonatomic , strong)UIButton *btnWeixin;
@property (nonatomic , strong)UIButton *btnEmail;
@property (nonatomic , strong)UIButton *btnCancel;


@end

@interface FamilyViewController : BaseViewController


@end