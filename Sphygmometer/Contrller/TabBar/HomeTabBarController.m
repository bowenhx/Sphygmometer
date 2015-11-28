//
//  RootViewCtrl.m
//  CarMobile
//
//  Created by Guibin on 14-4-14.
//  Copyright (c) 2014年 Guibin. All rights reserved.
//

#import "HomeTabBarController.h"
#import "HomeViewController.h"
#import "DeviceViewController.h"
#import "LifeOfViewController.h"
#import "SettingViewController.h"
#import "DataVesselObj.h"

@interface HomeTabBarPlaneView : UIView
{
//    UITabBarController          * _tabBarController;
    NSMutableArray              * _buttons;
}
@property (nonatomic, setter = setFlagCount:) int flag;
@property (nonatomic , strong)UITabBarController *tabBarController;
@end

@implementation HomeTabBarPlaneView
@synthesize tabBarController = _tabBarController;

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initSelf];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithUITabBarController:(UITabBarController *)tabBarController
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        _tabBarController = tabBarController;
        
        for(UIView * view in _tabBarController.tabBar.subviews)
        {
            if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")])
                [view removeFromSuperview];
        }
        
        [_tabBarController.tabBar addSubview:self];
        
        [self initSelf];
        [self setNeedsLayout];
    }
    return self;
}

- (void)initSelf
{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [Common getColor: @"4CB9C1"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectButtonsIndex:) name:ChangeTabBarNotificationCenter object:nil];
    
    NSArray *arrImage = IsEnglish ? @[@"home_bottom_1a",
                                      @"home_bottom_2a",
                                      @"home_bottom_3a",
                                      @"home_bottom_4a"] :
                        @[@"成员未选中.png",
                          @"设备未选中.png",
                          @"养生未选中.png",
                          @"设置未选中.png"
                          ];
    
    NSArray *arrSelectImage = IsEnglish ? @[@"home_bottom_1b",
                                            @"home_bottom_2b",
                                            @"home_bottom_3b",
                                            @"home_bottom_4b"] :
                                @[@"成员选中.png",
                                @"设备选中.png",
                                @"养生选中.png",
                                @"设置选中.png"
                                ];
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:_tabBarController.viewControllers.count];
    
    for (int i = 0; i < [_tabBarController.viewControllers count]; i++)
    {
        UIViewController * viewController = _tabBarController.viewControllers[i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
        
        [button setTitle:viewController.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:ColorWithString(@"#f07d00") forState:UIControlStateHighlighted];
//        [button setTitleColor:ColorWithString(@"#f07d00") forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        button.titleEdgeInsets = UIEdgeInsetsMake(28.f, 0, 0, 0);
        NSString *strimage = arrImage[i];
        NSString *highImage = arrSelectImage[i];
        UIImageView * ico = [[UIImageView alloc] initWithImage:[UIImage imageNamed:strimage]];//[UIColor whiteColor] toImage]
        ico.highlightedImage = [UIImage imageNamed:highImage];
        
        ico.tag = 666;
        [button addSubview:ico];
        
        [button setBackgroundColor:[UIColor clearColor]];
        
        if(_tabBarController.selectedViewController == viewController){
            button.enabled  = NO;
            ico.highlighted = YES;
        }
        else{
            button.enabled  = YES;
            ico.highlighted = NO;
        }
        
        
        [_buttons addObject:button];
        [self addSubview:button];
        
    }
    
}

CGRect CGRectAlignCenter( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = CGRectGetMidX( rect2 ) - rect1.size.width / 2.0f;
	rect1.origin.y = CGRectGetMidY( rect2 ) - rect1.size.height / 2.0f;
	return rect1;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = _tabBarController.tabBar.bounds;
    [_tabBarController.tabBar bringSubviewToFront:self];
    
    CGSize bound = self.bounds.size;
    
    CGRect buttonFrame = CGRectMake(0,0,bound.width/_buttons.count, bound.height);
    for (UIButton * button in _buttons)
    {
        button.frame = buttonFrame;
        buttonFrame.origin.x += buttonFrame.size.width;
        
        UIImageView * ico = (UIImageView *)[button viewWithTag:666];
//        CGRect ic®oFrame = CGRectMake(0, 0, 22, 22);
//        icoFrame = CGRectAlignCenter(icoFrame, button.bounds);
//        icoFrame.origin.y -= 8;
        ico.frame = button.bounds;
    }
    
}

- (void)clickButton:(UIButton *)button {
    NSUInteger indexOfButton = [_buttons indexOfObject:button];
    NSLog(@"indexOfButton: %d",indexOfButton);
    if (indexOfButton == 1) {
        if ([DataVesselObj shareInstance].titleName.length ==0) {
            [self.window addHUDLabelView:IsEnglish ? @"Please enter user's data": @"请添加成员数据" Image:nil afterDelay:2.0f];
            return;
        }
    }
    
    _tabBarController.selectedIndex = indexOfButton;
    
    for (UIButton * btn in _buttons)
    {
        UIImageView * ico = (UIImageView *)[btn viewWithTag:666];
        
        if(btn == button){
            ico.highlighted = YES;
            btn.enabled = NO;
        }else{
            ico.highlighted = NO;
            btn.enabled = YES;
        }
    }
}
- (void)didSelectButtonsIndex:(NSNotification *)info
{
    NSInteger index = [info.object integerValue];
    [self clickButton:_buttons[index]];
}


@end



@interface HomeTabBarController ()
{
    HomeTabBarPlaneView     *_tabBarView;
}
@property (nonatomic, strong) HomeTabBarPlaneView * tabBarView;
@property (nonatomic, assign) int buttonFlag;

@end

@implementation HomeTabBarController

+ (HomeTabBarController *)showRootView
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    HomeTabBarController *rootVC = [[HomeTabBarController alloc] init];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    DeviceViewController *deviceVC = [[DeviceViewController alloc] initWithNibName:@"DeviceViewController" bundle:nil];
    UINavigationController *deviceNav = [[UINavigationController alloc] initWithRootViewController:deviceVC];
    
    LifeOfViewController *lifeOfVC = [[LifeOfViewController alloc] init];
    UINavigationController *lifeOfNav = [[UINavigationController alloc] initWithRootViewController:lifeOfVC];
    
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    
    rootVC.viewControllers = @[homeNav,deviceNav,lifeOfNav,settingNav];
    
    [[UIApplication sharedApplication].delegate window].rootViewController = rootVC;

    return rootVC;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarView = [[HomeTabBarPlaneView alloc] initWithUITabBarController:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.
}
-(void)dealloc
{
    self.tabBarView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
