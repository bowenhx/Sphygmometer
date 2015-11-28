//
//  LifeHeadView.m
//  Sphygmometer
//
//  Created by gugu on 14-5-14.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "LifeHeadView.h"

@implementation LifeHeadView

@synthesize bottomLineImg = _bottomLineImg;
@synthesize btnArray = _btnArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [Common getColor: @"f4f4f4"];
        
        NSArray *nameArray = nil;
        
        if (IsEnglish) {
            nameArray = @[@"News",@"Health",@"Recipe",@"Favorite",@"Know-how"];
        }else{
           nameArray = @[@"热点",@"保健",@"食谱",@"常识",@"收藏"];
        }
        
        _btnArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < nameArray.count; i++) {
            UIButton *nameBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            nameBtn.frame = CGRectMake((WIDTH(self) / 5) * i, 0, WIDTH(self) / 5, 38);
            nameBtn.tag = i;
            
            if (i == 0) {
                nameBtn.selected = YES;
            }
            
            [nameBtn setTitle: [nameArray objectAtIndex: i] forState: UIControlStateNormal];
            [nameBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];//Common getColor: @"515151"
            [nameBtn setTitleColor: [Common getColor: @"4cb9c1"] forState: UIControlStateSelected];
            [nameBtn addTarget: self action: @selector(tapNameBtn:) forControlEvents: UIControlEventTouchUpInside];
            [self addSubview: nameBtn];
            [_btnArray addObject: nameBtn];
            
        }
        
        //下面的线
        UIImage *lineImage = [UIImage imageNamed: @"养生选中线.png"];
        _bottomLineImg = [[UIImageView alloc] initWithFrame: CGRectMake(0, 38, lineImage.size.width, lineImage.size.height)];
        _bottomLineImg.image = lineImage;
        [self addSubview: _bottomLineImg];
        
    }
    return self;
}

#pragma mark 按钮事件
- (void) tapNameBtn: (id)sender{
    UIButton *tempBtn = (UIButton *)sender;
    
    //改变按钮选中状态
    for (int k = 0; k < _btnArray.count; k++) {
        UIButton *oldBtn = (UIButton *)[_btnArray objectAtIndex: k];
        
        if (oldBtn.tag == tempBtn.tag) {
            oldBtn.selected = YES;
            
        }else{
            oldBtn.selected = NO;
            
        }
        
    }
    
    //改变线的位置
    CGRect imgFrame = _bottomLineImg.frame;
    imgFrame.origin.x = (WIDTH(self) / 5) * tempBtn.tag;
    _bottomLineImg.frame = imgFrame;
    
    [_delegate handlLifeHeadBtn: tempBtn.tag];

}

@end
