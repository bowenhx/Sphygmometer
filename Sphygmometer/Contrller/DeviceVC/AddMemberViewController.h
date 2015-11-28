//
//  AddMemberViewController.h
//  Sphygmometer
//
//  Created by Guibin on 14-6-17.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
static NSString *const refreshListNotificationCenter = @"RefreshListNotificationCenter";

typedef enum
{
    addMemberType = 0,      //添加血压测试数据
    detailMemberType = 1,   //显示详情成员数据
    
}memberType;

@interface AddMemberViewController : BaseViewController

@property (nonatomic , strong)NSDictionary *dicInfor;
@property (nonatomic)memberType memberType;
//@property (nonatomic)BOOL isShow;

@end
