//
//  ShowTitleView.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-23.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "ShowTitleView.h"
@implementation ArrowsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor redColor].CGColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef ref = CGColorCreateCopyWithAlpha(_colorBg.CGColor,1.f);
    CGContextSetStrokeColorWithColor(context, ref); //线框颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextSetFillColorWithColor(context, _colorBg.CGColor);//填充颜色
    CGContextStrokePath(context);
    
    /**
     *  画三角
     */
    
    CGPoint point = rect.origin;
    CGPoint sPoints[3];//坐标点
    if (_isDown) {
        sPoints[0] =CGPointMake(point.x+15, 0);//坐标1
        sPoints[1] =CGPointMake(point.x+10, 10);//坐标2
        sPoints[2] =CGPointMake(point.x+20, 10);//坐标3
    }else{
        sPoints[0] =CGPointMake(point.x+10, 0);//坐标1
        sPoints[1] =CGPointMake(point.x+20, 0);//坐标2
        sPoints[2] =CGPointMake(point.x+15, 10);//坐标3
    }
   
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}
- (void)reloadArrowsView
{
    [self setNeedsDisplay];
}
@end


@implementation ShowTitleView
{
    CGPoint myPoint;
    
    NSMutableArray      *_arrText;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor yellowColor].CGColor;
        _arrText = [[NSMutableArray alloc] initWithCapacity:0];
        myPoint = CGPointMake(107, 0);
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    UIColor *color = [UIColor whiteColor];
    
    CGColorRef ref = CGColorCreateCopyWithAlpha(_colorBg.CGColor,1.f);
    CGContextSetStrokeColorWithColor(context, ref); //线框颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextSetFillColorWithColor(context, _colorBg.CGColor);//填充颜色
    CGContextStrokePath(context);
    
    float height = 0;

    /**
     *  画矩形
     */
    height = rect.size.height - 10;
    
    CGContextAddRect(context,CGRectMake(0,0, rect.size.width,height));//画方框
    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
    
    //画图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"时间白色" ofType:@"png"];
    //    UIImage *imageTime = [UIImage imageNamed:@"时间"];
    UIImage *imageTime = [UIImage imageWithContentsOfFile:path];
    //    [img drawInRect:CGRectMake(2, 2, img.size.width, img.size.height)];
    CGImageRef image = imageTime.CGImage;
    CGContextSaveGState(context);
    CGRect touchRect = CGRectMake(-4, -7, imageTime.size.width,imageTime.size.height);
    CGContextDrawImage(context, touchRect, image);
    CGContextRestoreGState(context);

    /**
     *  画时间：
     */
    CGContextSetRGBFillColor (context, 1, 1, 1, 1.f);
    [_dicData[@"time"] drawAtPoint:CGPointMake(15, 2) withFont:[UIFont systemFontOfSize:10.f]];
   
    /**
     *  画文字详情
     */
    if (_arrText.count >0) {
        [_arrText removeAllObjects];
    }
    
    [_arrText addObject:@[_dicData[@"sys"],@"mmhg"]];
    [_arrText addObject:@[_dicData[@"dia"],@"mmhg"]];
    [_arrText addObject:@[_dicData[@"pul"],@"bpm"]];
    
    for (int i = 0; i<_arrText.count; i++) {
        NSString *textNum = _arrText[i][0];
        
        NSString *unit = _arrText[i][1];
        [textNum drawAtPoint:CGPointMake(2+i*60, 20) withFont:[UIFont systemFontOfSize:12.f]];
        [unit drawAtPoint:CGPointMake(22+i*60, 22) withFont:[UIFont systemFontOfSize:10.f]];
    }
   
    /**
     *  画竖线
     */
    CGContextMoveToPoint(context, rect.size.width-30, 0);
    CGContextAddLineToPoint(context, rect.size.width-30,height);
    CGContextStrokePath(context);
    
    
    //button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(rect.size.width-30, 0, 30, height);
    [button setImage:[UIImage imageNamed:@"测量图标"] forState:UIControlStateNormal];
    [self addSubview:button];
    
    [button addTarget:self action:@selector(selectDetailPage) forControlEvents:UIControlEventTouchUpInside];
}
- (void)selectDetailPage
{
    if (_showType == 0) {
         [[NSNotificationCenter defaultCenter] postNotificationName:SelectDetailNotificationCenter object:@(self.tag)];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NewlydetaileDataNotificationCenter object:@(self.tag)];
    }
   
}

- (void)reloadViewLine
{
    [self setNeedsDisplay];
}

@end
