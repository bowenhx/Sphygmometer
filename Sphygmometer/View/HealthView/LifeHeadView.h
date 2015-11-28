//
//  LifeHeadView.h
//  Sphygmometer
//
//  Created by gugu on 14-5-14.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LifeHeadViewDelegate <NSObject>

//处理按钮点击事件
- (void) handlLifeHeadBtn:(NSInteger)index;

@end

@interface LifeHeadView : UIView

@property (nonatomic, strong) UIImageView *bottomLineImg;       //线
@property (nonatomic, strong) NSMutableArray *btnArray;         //按钮数组
@property (nonatomic, weak) id<LifeHeadViewDelegate> delegate;

@end
