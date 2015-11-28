//
//  WEBViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-7-2.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "WEBViewController.h"


@interface WEBViewController ()<UIWebViewDelegate>
{
    
}
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation WEBViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navTitleLable.text = _titleName;
    [self initLoadView];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)initLoadView
{
    NSLog(@"_webUrl = %@",_webUrl);
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), CommonMinusNavHeight(self.view))];
    _webView.delegate = self;
//    _webView.layer.borderWidth = 1;
//    _webView.layer.borderColor = [UIColor redColor].CGColor;
    //    _webView.delegate = self;
    [self.view addSubview:_webView];
    
     [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = [NSString stringWithFormat:@"document.body.style.fontSize='43';document.body.style.color='%@'",@"#4b4b4b"];
    [webView stringByEvaluatingJavaScriptFromString:str];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
