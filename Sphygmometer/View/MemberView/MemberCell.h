//
//  MemberCell.h
//  Sphygmometer
//
//  Created by gugu on 14-5-13.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImg;        //头像按钮
@property (nonatomic, strong) UILabel *nameLable;       //名字
@property (nonatomic, strong) UIButton *editBtn;        //编辑按钮
@property (nonatomic , strong) UIButton *editImage;     //头像编辑
@end
