//
//  DrawLineView.h
//  Sphygmometer
//
//  Created by Guibin on 14-5-16.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawLineView : UIView

- (void)showDataOrDraw:(NSArray *)arr;

- (void)reloadDataViewLine;
@end
