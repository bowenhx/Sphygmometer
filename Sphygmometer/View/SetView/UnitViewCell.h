//
//  UnitViewCell.h
//  Sphygmometer
//
//  Created by Guibin on 14-6-12.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labLeft;
@property (weak, nonatomic) IBOutlet UILabel *labRight;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;

@end
