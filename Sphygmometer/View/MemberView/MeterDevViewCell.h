//
//  MeterDevViewCell.h
//  Sphygmometer
//
//  Created by Guibin on 14-6-19.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol MeterDeviceDelegate <NSObject>
//
//- (void)didDelegateCellData:(NSInteger)index;
//
//@end

@interface MeterDevViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageMeter;
@property (weak, nonatomic) IBOutlet UILabel *labTextTitle;
@property (weak, nonatomic) IBOutlet UILabel *labNSCodeNum;


@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UIButton *btnAddUser;
@property (weak, nonatomic) IBOutlet UIButton *btnAddUserB;


@end
