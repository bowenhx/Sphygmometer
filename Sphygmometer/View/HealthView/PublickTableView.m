//
//  PublickTableView.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-16.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "PublickTableView.h"
#import "LifeCell.h"
#import "UIImageView+WebCache.h"
#import "ButtonHeadImage.h"


@interface PublickTableView()
{
    UIScrollView    *_headScroll;
}
@property (nonatomic , strong)NSMutableArray *arrHeadData;
@property (nonatomic , strong)NSMutableArray *arrListData;
@end

@implementation PublickTableView

@synthesize lifeHomeTable = _lifeHomeTable;
@synthesize pageControl = _pageControl;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame typeIndex:(NSInteger)typeIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _lifeHomeTable = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
        _lifeHomeTable.backgroundColor = [UIColor clearColor];
        _lifeHomeTable.dataSource = self;
        _lifeHomeTable.delegate = self;
        if (typeIndex <4) {
            _lifeHomeTable.tableHeaderView = [self createLifeHeadView];
        }
        [self addSubview: _lifeHomeTable];
        
        _arrHeadData = [[NSMutableArray alloc] initWithCapacity:0];
        _arrListData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark 创建头部view
- (UIView *) createLifeHeadView{
    UIView *tempHeadView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self), 170)];
    
    _headScroll = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self), HEIGHT(tempHeadView))];
    _headScroll.userInteractionEnabled = YES;
    _headScroll.backgroundColor = [UIColor clearColor];
    _headScroll.pagingEnabled = YES;
    _headScroll.delegate = self;
    _headScroll.showsHorizontalScrollIndicator = NO;
    _headScroll.bounces = NO;
    
    [tempHeadView addSubview: _headScroll];
    
    //分页标签
    _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(220.0f, 142, 100, 22)];
    _pageControl.pageControlStyle = PageControlStyleDefault;
   
    [_pageControl setCoreNormalColor:[UIColor whiteColor]];
    [_pageControl setCoreSelectedColor:RGBCOLOR(65.0, 171.0, 179.0)];
    [tempHeadView addSubview: _pageControl];
    
    return tempHeadView;

}

#pragma mark 点击手势事件
- (void) tapHeadImg: (ButtonHeadImage *)btn{
    [_delegate handlePublickTableBtn:btn.typeID articleTitle:btn.title html_url:btn.url];

    [SavaData writeDicToFile:_arrHeadData[btn.tag] FileName:CollectTempDic];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [_pageControl setCurrentPage: currentPage];
    
}
- (void)refreshHeadShowView:(NSArray *)arr
{
    if (_arrHeadData.count >0) {
        [_arrHeadData removeAllObjects];
    }
    [_arrHeadData setArray:arr];
    
    NSInteger count = [arr count];
    _headScroll.contentSize = CGSizeMake(WIDTH(self) * count, 170);
    _pageControl.numberOfPages = count;
    
    UIImage *testImage = [UIImage imageNamed: @"养生大图.png"];
    for (int i = 0; i < count; i++) {
        //图片
        UIImageView *headImg = [[UIImageView alloc] initWithFrame: CGRectMake(WIDTH(self) * i, 0, WIDTH(self), HEIGHT(_headScroll))];
        [headImg sd_setImageWithURL:arr[i][@"thumb"] placeholderImage:testImage];
        headImg.userInteractionEnabled = YES;
        
        //点击图片上面的button
        ButtonHeadImage *button = [ButtonHeadImage buttonWithType:UIButtonTypeCustom];
        button.frame = headImg.frame;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        button.typeID = [arr[i][@"id"] integerValue];
        button.title = arr[i][@"title"];
        button.url = arr[i][@"html_url"];
        [button addTarget:self action:@selector(tapHeadImg:) forControlEvents:UIControlEventTouchUpInside];
        [_headScroll addSubview: headImg];
        [_headScroll addSubview: button];
        
        //半透明背景
        UIImage *backImage = [UIImage imageNamed: @"养生半透明背景.png"];
        UIImageView *backImg = [[UIImageView alloc] initWithFrame: CGRectMake(WIDTH(self) * i, 135, backImage.size.width, backImage.size.height)];
        backImg.image = backImage;
        [_headScroll addSubview: backImg];
        
        //标题
        UILabel *headTitleLable = [[UILabel alloc] initWithFrame: CGRectMake(8 + WIDTH(self) * i, 146, 240, 16)];
        headTitleLable.backgroundColor = [UIColor clearColor];
        headTitleLable.font = SYSTEMFONT(17.0);
        headTitleLable.textColor = [UIColor whiteColor];
        headTitleLable.text = arr[i][@"title"];
        [_headScroll addSubview: headTitleLable];
        
    }
}
- (void)refreshTabShowData:(NSArray *)arr
{
    if (_arrListData.count >0) {
        [_arrListData removeAllObjects];
    }
    [_arrListData setArray:arr];
    [_lifeHomeTable reloadData];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrListData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *memberIndentified = @"memberindentified";
    
    LifeCell *cell = [tableView dequeueReusableCellWithIdentifier: memberIndentified];
    
    if (cell == nil) {
        cell = [[LifeCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: memberIndentified];
        
    }
    
    //图片
    [cell.thumbImg sd_setImageWithURL:_arrListData[indexPath.row][@"thumb"] placeholderImage:[UIImage imageNamed: @"养生小兔.png"]];
    
    //标题
    cell.titleLable.text = _arrListData[indexPath.row][@"title"];
    
    //内容
    cell.contentLable.text = _arrListData[indexPath.row][@"description"];
    
    return cell;
    
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSString *title = _arrListData[indexPath.row][@"title"];
    NSString *url = _arrListData[indexPath.row][@"html_url"];
    [_delegate handlePublickTableBtn:[_arrListData[indexPath.row][@"id"] integerValue] articleTitle:title html_url:url];
    
    [SavaData writeDicToFile:_arrListData[indexPath.row] FileName:CollectTempDic];
}



@end
