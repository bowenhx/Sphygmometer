//
//  SetCell.m
//  Sphygmometer
//
//  Created by gugu on 14-5-14.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

@synthesize nameLable = _nameLable;
@synthesize detailImg = _detailImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //名字
        _nameLable = [[UILabel alloc] initWithFrame: CGRectMake(20, 20, 235, 15)];
        _nameLable.backgroundColor = [UIColor clearColor];
        _nameLable.font = SYSTEMFONT(18.0);
        _nameLable.textColor = [UIColor blackColor];
        [self addSubview: _nameLable];
        
        //箭头
        _detailImg = [[UIImageView alloc] initWithFrame: CGRectMake(WIDTHADDX(_nameLable) + 30, 0, 45, 50)];
        [self addSubview: _detailImg];
        
    }
    return self;
}

@end
