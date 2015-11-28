//
//  DrawLineView.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-16.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "DrawLineView.h"
#import "ShowTitleView.h"
#import "DataVesselObj.h"

@implementation DrawLineView
{
    NSArray  *_arrText;
    NSArray  *_arrColor;
    
    NSMutableArray      *_arrData;
    
    
   
    CGSize  verticalTextSize;           //vertical text size
    NSMutableArray      *_beforeArrData;
    
    
    ShowTitleView      *_showView;
    
    ArrowsView         *_arrowsView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        [self initView];
    }
    return self;
}
- (void)initView
{

    _arrData = [[NSMutableArray alloc] init];
    _beforeArrData = [[NSMutableArray alloc] initWithCapacity:0];
    if (IsEnglish) {
        _arrText = @[@"High",@"Midd",@"Mild",@"Norm",@"Best",@"Low"];
    }else{
         _arrText = @[@"重度",@"中度",@"轻度",@"正常",@"理想",@"偏低"];
    }
   
    
    _arrColor = @[RGBCOLOR(167, 114, 191),RGBCOLOR(253, 86, 85),RGBCOLOR(253, 154, 5),RGBCOLOR(241, 202, 12),RGBCOLOR(189, 219, 95),RGBCOLOR(112, 217, 199)];
}

- (void)showDataOrDraw:(NSArray *)arr
{
    [_beforeArrData setArray:arr];
    //计算坐标值
    [_arrData setArray:[DataVesselObj showDataOrDraw:arr size:self.frame.size]];
    
    [self setNeedsDisplay];
    
}

- (void)drawBaseLine:(CGRect)rect
{
    //draw rectangle
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(currentContext, path);
    [[UIColor clearColor] setFill];
    [[UIColor clearColor] setStroke];
    CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(currentContext, 1.f);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
    
    
    float itemHeight = rect.size.height / 6;
    //画横线
    for (int i = 0; i < _arrText.count; i++) {
        
        CGContextMoveToPoint(currentContext, rect.origin.x+30,itemHeight * i);
        CGContextAddLineToPoint(currentContext,
                                rect.size.width,
                                itemHeight * i);
       
        CGContextStrokePath(currentContext);
        
    }
    
   
    float interSize = (rect.size.height-_arrText.count*20)/7;
    //画文字状态
    for (int i=0; i<_arrText.count; i++) {
        CGContextSetRGBFillColor (currentContext, 0.5, 0.5, 0.5, 1.f);
        [_arrText[i] drawAtPoint:CGPointMake(0, interSize + interSize*i+20*i) withFont:[UIFont systemFontOfSize:12.f]];
    }
    
    //设置线的宽度
    CGContextSetLineWidth(currentContext, 3.f);
    //画健康状态线，竖线
    for (int i = 0; i< _arrColor.count; i++) {
        
        CGContextSetStrokeColorWithColor(currentContext,[_arrColor[i] CGColor]);
        
        CGContextMoveToPoint(currentContext, rect.origin.x+28,itemHeight * i);
        CGContextAddLineToPoint(currentContext,
                                rect.origin.x+28,
                                itemHeight * (i+1));

        CGContextStrokePath(currentContext);
    }
    
    
    
}
- (void)drawRect:(CGRect)rect
{
    
    if (_arrData.count == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [RGBCOLOR(221, 242, 245) setFill];
    
    CGPoint endPoint1 = [_arrData[_arrData.count-1] CGPointValue];
    [_arrData addObject:[NSValue valueWithCGPoint:CGPointMake(endPoint1.x, rect.size.height)]];
    [_arrData addObject:[NSValue valueWithCGPoint:CGPointMake(rect.origin.x+30, rect.size.height)]];
    [_arrData addObject:_arrData[0]];
    //画折线
    for (int i =0; i<_arrData.count; i++) {
        CGPoint point = [_arrData[i] CGPointValue];
        
        [[UIColor redColor] setStroke];
        if (i == 0 ) {
            CGContextMoveToPoint(context,point.x,point.y);
        }else{
            CGContextAddLineToPoint(context, point.x,point.y);
        }
       
        CGContextSetStrokeColorWithColor(context, RGBCOLOR(237, 237, 237).CGColor);
        CGContextSetLineWidth(context, 1.f);
        
       
    }
//    CGContextSetRGBStrokeColor(context, 237/255, 237/255, 237/255, .5);
    CGContextDrawPath(context,
                      kCGPathFillStroke);
    CGContextStrokePath(context);

    
    //画圆圈
    for (int i =0; i<_arrData.count-3; i++) {
        CGPoint point = [_arrData[i] CGPointValue];
        
        //        CGContextSetRGBStrokeColor(context,96/255,190/255,196/255,1.0);//画笔线的颜色
        CGContextSetStrokeColorWithColor(context,[RGBCOLOR(96, 190, 196) CGColor]);
        CGContextSetLineWidth(context, 1.0);//线的宽度
        CGContextAddArc(context,point.x , point.y, 3, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
        
       
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(point.x-16, point.y-16, 32, 32);
//        button.layer.borderWidth = 1;
        button.tag = i;
        [button addTarget:self action:@selector(didSelectShowView:) forControlEvents:UIControlEventTouchUpInside];
        
        if (point.y <20) {
            button.frame = CGRectMake(point.x-16, rect.origin.y, 32, 32);
        }
        
        [self addSubview:button];
    }
    [self drawBaseLine:rect];
}
- (void)didSelectShowView:(UIButton *)btn
{
    
    CGRect btnFrmae = btn.frame;
    if (!_showView) {
        //图片展示view
        _showView = [[ShowTitleView alloc] init];
        [self addSubview:_showView];
        
        //图片显示的三角形
        _arrowsView = [[ArrowsView alloc] init];
        [self addSubview:_arrowsView];
    }
    
    [_showView reloadViewLine];
    [_arrowsView reloadArrowsView];
    
    
    
    btnFrmae.size.width = 200;
    btnFrmae.size.height = 50;
    
//    LOG(@"之前 = %@",NSStringFromCGRect(btnFrmae));
    
    if (btnFrmae.origin.y <60)
    {
        if (btnFrmae.origin.x < 60) {
            btnFrmae.origin.x -= 20;
        }else if (btnFrmae.origin.x >200)
        {
            btnFrmae.origin.x -= 150;
        }else{
            btnFrmae.origin.x -= 55;
        }
        _arrowsView.isDown = YES;
        btnFrmae.origin.y += 40;
        //上三角
        _arrowsView.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y+ 31, btn.frame.size.width, 20);
    }else{
        if (btnFrmae.origin.x < 60) {
            btnFrmae.origin.x -= 20;
        }else if (btnFrmae.origin.x >200)
        {
            btnFrmae.origin.x -= 150;
        }else{
            btnFrmae.origin.x -= 100;
        }
        _arrowsView.isDown = NO;
        btnFrmae.origin.y -= 60;
        //下三角
        _arrowsView.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y-20, btn.frame.size.width, 20);
    }
    _showView.frame = btnFrmae;
//    LOG(@"btn.frame = %@",NSStringFromCGRect(btnFrmae));
    
    
    _showView.tag = btn.tag;
    _showView.showType = 0;
    _showView.dicData = _beforeArrData[btn.tag];
    _showView.colorBg = [self showColorStatu:_beforeArrData[btn.tag][@"val"]];
    _arrowsView.colorBg = _showView.colorBg;
    
}
- (UIColor *)showColorStatu:(NSString *)text
{
    if ([text isEqualToString:Severe]) {
        return _arrColor[0];
    }else if ([text isEqualToString:Moderate])
    {
        return _arrColor[1];
    }else if ([text isEqualToString:Mild])
    {
        return _arrColor[2];
    }else if ([text isEqualToString:Normal])
    {
        return _arrColor[3];
    }else if ([text isEqualToString:Optimal])
    {
        return _arrColor[4];
    }else if ([text isEqualToString:Low])
    {
        return _arrColor[5];
    }
    return nil;
}
- (void)reloadDataViewLine
{
    [_arrData removeAllObjects];
    for (UIButton *button in self.subviews) {
        [button removeFromSuperview];
    }
    
    if (_showView) {
        [_showView removeFromSuperview];
        _showView = nil;
    }
    if (_arrowsView) {
        [_arrowsView removeFromSuperview];
        _arrowsView = nil;
    }
    [self setNeedsDisplay];
}


@end
