//
//  LifeCell.h
//  Sphygmometer
//
//  Created by Guibin on 14-5-16.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeCell : UITableViewCell

@property (nonatomic, strong) UIImageView *thumbImg;        //图片
@property (nonatomic, strong) UILabel *titleLable;           //标题
@property (nonatomic, strong) UILabel *contentLable;        //内容

@end
