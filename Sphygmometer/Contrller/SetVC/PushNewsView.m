//
//  PushNewsView.m
//  Sphygmometer
//
//  Created by Guibin on 14/12/31.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "PushNewsView.h"

@implementation PushNewsView
{
    UILabel     *_labTitle;
    UIWebView   *_webView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.borderColor = [UIColor redColor].CGColor;
//        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
        [self loadLayerView];
    }
    return self;
}
- (void)loadLayerView
{
    
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.bounds.size.width-100, 44)];
    _labTitle.backgroundColor = [UIColor clearColor];
    _labTitle.font = GETBOLDFONT(22.0);
    _labTitle.textColor = [UIColor blackColor];
    _labTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_labTitle];
    
    
    UIImage *backImage = [UIImage imageNamed: @"返回箭头绿色.png"];
    UIButton *butDis = [UIButton buttonWithType: UIButtonTypeCustom];
    butDis.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [butDis setImage: backImage forState: UIControlStateNormal];
    [butDis addTarget: self action: @selector(disMisView) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview:butDis];
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, self.bounds.size.height-44)];
//    _webView.layer.borderWidth = 1;
//    _webView.layer.borderColor = [UIColor yellowColor].CGColor;
    
    [self addSubview:_webView];
}
- (void)loadData:(NSString *)titleName webUrl:(NSString *)url
{
    LOG(@"titleName = %@",titleName);
    LOG(@"url = %@",url);
    _labTitle.text = titleName;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
- (void)disMisView
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
