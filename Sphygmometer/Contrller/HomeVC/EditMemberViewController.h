//
//  EditMemberViewController.h
//  Sphygmometer
//
//  Created by Guibin on 14-5-19.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    memberTypeEdit,
    memberTypeAdd,
}memberTypeDetail;

//static NSString  * const AddOrRefershMemberNotification = @"addOrRefershMemberNotification";

@interface EditMemberViewController : BaseViewController<ASIHTTPRequestDelegate>


@property (nonatomic)memberTypeDetail memberType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userDic:(NSDictionary *)dic;
@end
