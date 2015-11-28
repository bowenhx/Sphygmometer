//
//  ShowTitleView.h
//  ;
//
//  Created by Guibin on 14-6-23.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  画view上面的箭头
 */
@interface ArrowsView : UIView

@property (nonatomic)UIColor *colorBg;

@property (nonatomic)BOOL isDown;       //决定是上箭头还是下箭头

- (void)reloadArrowsView;
@end

/**
 *  画显示view数据等
 */
typedef enum {
    showWeekDataType =0,
    showNewlyDataType = 1,
}showDataType;

@interface ShowTitleView : UIView

@property (nonatomic)UIColor *colorBg;
@property (nonatomic , strong)NSDictionary *dicData;
@property (nonatomic )showDataType showType;

- (void)reloadViewLine;
@end
