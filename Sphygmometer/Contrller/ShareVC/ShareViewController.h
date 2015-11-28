//
//  ShareViewController.h
//  SouthernFund
//
//  Created by jianle chen on 13-12-5.
//  Copyright (c) 2013年 深圳市呱呱网络科技有限公司. All rights reserved.
//

#import "SinaWeiBoSDK.h"

@interface ShareViewController : BaseViewController <SWeiBoSDKDelegate>
@property (nonatomic,assign) BOOL isTencent;
@property (nonatomic,copy) NSString *shareContent;
@property (nonatomic, retain) UIImage *shareImage;

- (void)shareWeiBo:(NSString *)content;
- (void)shareWeiBo:(NSString *)content withPicUrl:(NSString *)pic_url;
- (void)shareWeiBo:(NSString *)content withPicData:(UIImage *)image;
- (void)addFriend:(NSString *)name;
//- (void)clearAccountInfo;

@end
