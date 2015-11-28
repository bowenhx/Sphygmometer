//
//  FamilyViewCell.h
//  Sphygmometer
//
//  Created by Guibin on 14-5-15.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labText;
@property (weak, nonatomic) IBOutlet UIImageView *imageStatus;
@property (weak, nonatomic) IBOutlet UILabel *labValuePercent;
@property (weak, nonatomic) IBOutlet UILabel *labValueNum;
@property (weak, nonatomic) IBOutlet UILabel *labValueTime;

@end
