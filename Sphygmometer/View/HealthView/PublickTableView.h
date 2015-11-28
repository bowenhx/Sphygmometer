//
//  PublickTableView.h
//  Sphygmometer
//
//  Created by Guibin on 14-5-16.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

@class PublickTableView;

@protocol PublickTableDelegate <NSObject>

//处理cell点击事件
- (void) handlePublickTableBtn:(NSInteger)typeID articleTitle:(NSString *)title html_url:(NSString *)url;
@end

@interface PublickTableView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *lifeHomeTable;
@property (nonatomic, strong) StyledPageControl *pageControl;
@property (nonatomic, weak) id<PublickTableDelegate> delegate;

- (id)initWithFrame:(CGRect)frame typeIndex:(NSInteger)typeIndex;
- (void)refreshHeadShowView:(NSArray *)arr;
- (void)refreshTabShowData:(NSArray *)arr;
@end
