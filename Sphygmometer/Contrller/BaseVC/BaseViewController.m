//
//  BaseViewController.m
//  BloodPressure
//
//  Created by Guibin on 14-5-9.
//  Copyright (c) 2014年 深圳呱呱网络科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize rightbtn = _rightbtn;
@synthesize navTitleLable = _navTitleLable;

- (void)loadView{
    [super loadView];
    
    if (kIsIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"导航条背景ios7.png"] forBarMetrics: UIBarMetricsDefault];
        
    }else{
        [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"导航条背景ios6.png"] forBarMetrics: UIBarMetricsDefault];
    
    }
    
    
   
//    [self.navigationItem setHidesBackButton:YES];
    
    //标题
    _navTitleLable = [[UILabel alloc] initWithFrame: CGRectMake(80, 20, 160, 24)];
    _navTitleLable.backgroundColor = [UIColor clearColor];
    _navTitleLable.font = GETBOLDFONT(22.0);
    _navTitleLable.textColor = [UIColor blackColor];
    _navTitleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _navTitleLable;
   
    
    //返回按钮
    UIImage *backImage = [UIImage imageNamed: @"返回箭头绿色.png"];
    _backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [_backBtn setImage: backImage forState: UIControlStateNormal];
    [_backBtn addTarget: self action: @selector(tapBackBtn) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView: _backBtn];
    left.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = left;
    
    //右按钮
    _rightbtn = [UIButton buttonWithType: UIButtonTypeCustom];
    _rightbtn.frame = CGRectMake(0, 0, 60, 30);
    _rightbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _rightbtn.titleLabel.font = GETBOLDFONT(18.0);
    [_rightbtn addTarget: self action: @selector(tapRightBtn) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView: _rightbtn];
    right.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.backgroundColor = RGBCOLOR(237.0, 237.0, 237.0);
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击右按钮
- (void)tapRightBtn{

}

//点击左按钮
- (void)tapBackBtn{
    [self.navigationController popViewControllerAnimated: YES];
}
- (void)setTitleImageName:(NSString *)titleImageName{
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:titleImageName]];
    [self.navigationItem setTitleView:titleImageView];
}

//判断字符串是否为空
- (BOOL)isTitleBlank:(NSString *)str {
    if (str == nil && [str length] == 0)return YES;
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) return YES;
    return NO;
}
//- (void)setTitle:(NSString *)title{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 260, 44)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setText:title];
//    [label setTextAlignment: NSTextAlignmentCenter];
//    [label setFont:[UIFont systemFontOfSize:18.0]];
//    [label setTextColor:[UIColor blackColor]];
//    [self.navigationItem setTitleView:label];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//	return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//}
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

@end
//
//@implementation UINavigationController (navCtrl)
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}


//@end
