//
//  LifeCell.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-16.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "LifeCell.h"

@implementation LifeCell

@synthesize thumbImg = _thumbImg;
@synthesize titleLable = _titleLable;
@synthesize contentLable = _contentLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //缩略图
        _thumbImg = [[UIImageView alloc] initWithFrame: CGRectMake(8, 7, 62, 37)];
        [self addSubview: _thumbImg];
        
        //标题
        _titleLable = [[UILabel alloc] initWithFrame: CGRectMake(WIDTHADDX(_thumbImg) + 6, 10, 250, 15)];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.font = SYSTEMFONT(17.0);
        _titleLable.textColor = [UIColor blackColor];//[Common getColor: @"363636"];
        [self addSubview: _titleLable];
        
        //内容
        _contentLable = [[UILabel alloc] initWithFrame: CGRectMake(WIDTHADDX(_thumbImg) + 6, HEIGHTADDY(_titleLable) + 5, 250, 12)];
        _contentLable.backgroundColor = [UIColor clearColor];
        _contentLable.font = SYSTEMFONT(14.0);
        _contentLable.textColor = [Common getColor: @"818181"];
        [self addSubview: _contentLable];
        
        //箭头
        UIImage *detailImage = [UIImage imageNamed: @"养生箭头.png"];
        UIImageView *detailImg = [[UIImageView alloc] initWithFrame: CGRectMake(WIDTHADDX(_contentLable) + 18, 15, detailImage.size.width, detailImage.size.height)];
        detailImg.image = detailImage;
        [self addSubview: detailImg];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
