//
//  MemberCell.m
//  Sphygmometer
//
//  Created by gugu on 14-5-13.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell

@synthesize headImg = _headImg;
@synthesize nameLable = _nameLable;
@synthesize editBtn = _editBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //头像
        _headImg = [[UIImageView alloc] initWithFrame: CGRectMake(8, 18, 55, 55)];
        [self addSubview: _headImg];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:_headImg.frame];
        img.image = [UIImage imageNamed:@"head_member_head_before.png"];
        
        [self addSubview:img];
        
        _editImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _editImage.frame = _headImg.frame;
        [self addSubview:_editImage];
        
        //名字
        _nameLable = [[UILabel alloc] initWithFrame: CGRectMake(WIDTHADDX(_headImg) + 8, 25, 202, 20)];
        _nameLable.backgroundColor = [UIColor clearColor];
        _nameLable.font = SYSTEMFONT(18.0);
        _nameLable.textColor = [UIColor blackColor];//[Common getColor: @"515151"];
        [self addSubview: _nameLable];
        
        //编辑按钮
        UIImage *editImage = [UIImage imageNamed: @"编辑新成员按钮.png"];
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(WIDTHADDX(_nameLable) + 8, 18, editImage.size.width, editImage.size.height);
        [_editBtn setBackgroundImage: editImage forState: UIControlStateNormal];
        [self addSubview: _editBtn];
        
        //分隔线
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame: CGRectMake(WIDTHADDX(_headImg) + 6, HEIGHTADDY(_nameLable) + 8, 243, 1)];
        lineImg.backgroundColor = RGBCOLOR(190.0, 190.0, 190.0);
        [self addSubview: lineImg];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
