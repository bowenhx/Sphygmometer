//
//  LifeOfViewController.m
//  Sphygmometer
//
//  Created by gugu on 14-5-13.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "LifeOfViewController.h"
#import "LifeOfDetailController.h"

@interface LifeOfViewController ()
{
    NSInteger       _pageOld;
    
    
}
@property (nonatomic, strong) LifeHeadView *menuView;
@property (nonatomic, strong) UIScrollView *lifeScroll;
@property (nonatomic, strong) NSMutableArray *tableArray;       //table数组
@property (nonatomic, strong) NSMutableArray *tempArr;          //存储临时数据
@end

@implementation LifeOfViewController

@synthesize menuView = _menuView;
@synthesize lifeScroll = _lifeScroll;
@synthesize tableArray = _tableArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) loadView{

    [super loadView];
    
    [self initView];
    
    _pageOld = 0;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.backBtn.hidden = YES;
    
    self.navTitleLable.text = IsEnglish ? @"Health": @"养生";
    
    _tempArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initDataTypeId:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshColorData) name:CollectDataNotificationCenter object:nil];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view removeHUDActivityView];
}
- (void) initView{
    //菜单
    _menuView = [[LifeHeadView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), 40)];
    _menuView.delegate = self;
    [self.view addSubview: _menuView];
    
    _lifeScroll = [[UIScrollView alloc] initWithFrame: CGRectMake(0, HEIGHTADDY(_menuView), WIDTH(self.view), kIsIOS7 ? HEIGHT(self.view) - 148 : HEIGHT(self.view) - 128)];
    _lifeScroll.backgroundColor = [UIColor clearColor];
    _lifeScroll.scrollEnabled = YES;
    _lifeScroll.pagingEnabled = YES;
    _lifeScroll.showsHorizontalScrollIndicator = NO;
    _lifeScroll.showsVerticalScrollIndicator = NO;
    _lifeScroll.contentSize = CGSizeMake(WIDTH(self.view) * 5, HEIGHT(_lifeScroll));
    _lifeScroll.delegate = self;
//    _lifeScroll.layer.borderWidth = 2;
//    _lifeScroll.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview: _lifeScroll];
    
    _tableArray = [[NSMutableArray alloc] init];
    
    //新闻view
    for (int i = 0; i < 5; i++) {
        PublickTableView *tempTable = [[PublickTableView alloc] initWithFrame:CGRectMake(WIDTH(self.view) * i, 0, WIDTH(self.view), HEIGHT(_lifeScroll)) typeIndex:i];
        tempTable.delegate = self;
        [_lifeScroll addSubview: tempTable];
        [_tableArray addObject: tempTable];
        
    }

}
#pragma  mark 通知刷新收藏列表

- (void)refreshColorData
{
    [self showCollectList:5];
}
- (void)showCollectList:(NSInteger)index
{
    //显示收藏数据
    NSArray *collectData = [SavaData parseArrFromFile:CollectFile];
    PublickTableView *tempView = _tableArray[index-1];
    [tempView refreshTabShowData:collectData];
}
- (void)initDataTypeId:(NSInteger)typeID
{
    LOG(@"typeID = %d",typeID);
    if (_pageOld == typeID) return;
    
    if (typeID == 5) {
        //刷新收藏列表
        [self showCollectList:typeID];
        _pageOld = typeID;
        return;
    };
    
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"typeid":@(typeID),@"size":@(10),@"page":@(1)} withURL:Api_NewsList withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            PublickTableView *tempView = _tableArray[typeID-1];
            [tempView refreshTabShowData:content[@"data"]];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
        
        [self loadHeadViewShowImage:typeID];
    }];
    
    _pageOld = typeID;
}
- (void)loadHeadViewShowImage:(NSInteger)typeID
{
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"typeid":@(typeID),@"size":@(10)} withURL:Api_NewsTop withType:POST completed:^(id content, ResponseType responseType) {
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            PublickTableView *tempView = _tableArray[typeID-1];
            [tempView refreshHeadShowView:content[@"data"]];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
        
    }];
}


#pragma mark LifeHeadViewDelegate
//处理按钮点击事件
- (void) handlLifeHeadBtn:(NSInteger)index{
    
    [_lifeScroll scrollRectToVisible: CGRectMake(WIDTH(self.view) * index, 0, WIDTH(self.view), HEIGHT(_lifeScroll)) animated: YES];
    
    [self initDataTypeId:index+1];
//    PublickTableView *currentTable = (PublickTableView *)[_tableArray objectAtIndex: index];

}

#pragma mark PublickTableDelegate
//处理cell点击事件
- (void) handlePublickTableBtn:(NSInteger)typeID articleTitle:(NSString *)title html_url:(NSString *)url
{
    LifeOfDetailController *lifeNewsVC = [[LifeOfDetailController alloc] initWithNibName:@"LifeOfDetailController" bundle:nil];
    lifeNewsVC.titleString = title;
    lifeNewsVC.newsWebUrl = url;
    lifeNewsVC.typeID = typeID;
    
    lifeNewsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lifeNewsVC animated: YES];

}
#pragma mark ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageViewWidth = _lifeScroll.frame.size.width;
    int page = floor((_lifeScroll.contentOffset.x - pageViewWidth / 2) / pageViewWidth) + 1;
    [self didSelectGlideDirection:page];
    
    [self initDataTypeId:page+1];
}

- (void)didSelectGlideDirection:(int)page
{
    [UIView animateWithDuration:0.3 animations:^{
        _menuView.bottomLineImg.frame = CGRectMake(WIDTH(_menuView.bottomLineImg)*page, Y(_menuView.bottomLineImg), WIDTH(_menuView.bottomLineImg), HEIGHT(_menuView.bottomLineImg));
    }];
    
    [_lifeScroll setContentOffset:CGPointMake(page*320, 0) animated:YES];
    
    [_menuView.btnArray enumerateObjectsUsingBlock:^(UIButton *btnSelect , NSUInteger index , BOOL *stop)
    {
        if (btnSelect.tag == page) {
            btnSelect.selected = YES;
        }else{
            btnSelect.selected = NO;
        }
    }];
}

#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
