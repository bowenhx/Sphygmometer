//
//  BaseViewController.h
//  BloodPressure
//
//  Created by Guibin on 14-5-9.
//  Copyright (c) 2014年 深圳呱呱网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "UIViewExtend.h"
#import "DataVesselObj.h"
@interface BaseViewController : UIViewController

@property (nonatomic , strong) NSString *titleImageName;
@property (nonatomic , strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *rightbtn;
@property (nonatomic, strong) UILabel *navTitleLable;

- (void)tapBackBtn;

//点击右按钮
- (void) tapRightBtn;

//判断字符串是否为空
- (BOOL)isTitleBlank:(NSString *)str;
//-(void)setViewOrientation:(UIInterfaceOrientation )orientation;
@end


//@interface UINavigationController (navCtrl)

//@end