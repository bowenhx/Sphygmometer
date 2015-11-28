//
//  HomeViewController.h
//  Sphygmometer
//
//  Created by gugu on 14-5-13.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *memberTable;

@end
