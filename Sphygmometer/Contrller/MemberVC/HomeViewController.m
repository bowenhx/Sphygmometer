//
//  HomeViewController.m
//  Sphygmometer
//
//  Created by gugu on 14-5-13.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "HomeViewController.h"
#import "MemberCell.h"
#import "EditMemberViewController.h"
#import "DeviceViewController.h"
@interface LocationView: UIView

@property (nonatomic , strong)UIImageView   *imageView1;
@property (nonatomic , strong)UIImageView   *imageView2;
@property (nonatomic , strong)UIImageView   *imageLine;

@property (nonatomic , strong)UILabel       *degreeRangeLab1;
@property (nonatomic , strong)UILabel       *degreeRangeLab2;
@property (nonatomic , strong)UILabel       *nonceLab1;
@property (nonatomic , strong)UILabel       *nonceLab2;

@property (nonatomic , strong)UIButton      *locationBtn1;
@property (nonatomic , strong)UIButton      *locationBtn2;
@property (nonatomic , strong)UIButton      *cityBtn1;
@property (nonatomic , strong)UIButton      *cityBtn2;

@end

@implementation LocationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self showView];
    }
    return self;
}
- (void)showView
{
    //天气详情背景1
    UIImage *backImage = [UIImage imageNamed: @"天气大背景.png"];
    _imageView1 = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self), HEIGHT(self)/2-1)];
    _imageView1.userInteractionEnabled = YES;
    _imageView1.image = backImage;
    
    //本地天气详情
    //温度范围
    _degreeRangeLab1 = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, 70, 12)];
    _degreeRangeLab1.backgroundColor = [UIColor clearColor];
    _degreeRangeLab1.font = SYSTEMFONT(10.0);
    _degreeRangeLab1.textColor = RGBCOLOR(126.0, 129.0, 136.0);
    _degreeRangeLab1.text = @"9 ~17c";
    [_imageView1 addSubview: _degreeRangeLab1];
    
    //最小温度
    _nonceLab1= [[UILabel alloc] initWithFrame: CGRectMake(5,HEIGHTADDY(_degreeRangeLab1) + 10, 70, 20)];
    _nonceLab1.backgroundColor = [UIColor clearColor];
    _nonceLab1.font = SYSTEMFONT(18.0);
    _nonceLab1.textColor = [Common getColor: @"000000"];
    _nonceLab1.text = @"14 C";
    [_imageView1 addSubview: _nonceLab1];
    
    //本地
    _locationBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn1.frame = CGRectMake(WIDTHADDX(_degreeRangeLab1) + 10, 5, 60, 16);
    _locationBtn1.backgroundColor = [Common getColor: @"62BFD1"];
    _locationBtn1.titleLabel.font = SYSTEMFONT(14);
    [_locationBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_locationBtn1 setTitle:@"本地" forState:UIControlStateNormal];
    [_imageView1 addSubview: _locationBtn1];
    
    
    //城市
    _cityBtn1 = [UIButton buttonWithType: UIButtonTypeCustom];
    _cityBtn1.frame = CGRectMake(WIDTHADDX(_degreeRangeLab1) + 10, HEIGHTADDY(_locationBtn1) + 5, 80, 21);
    _cityBtn1.backgroundColor = [UIColor clearColor];
    _cityBtn1.titleLabel.font = SYSTEMFONT(18.0);
    [_cityBtn1 setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [_cityBtn1 setTitle: @"深圳" forState: UIControlStateNormal];
    [_imageView1 addSubview: _cityBtn1];
    
    [self addSubview: _imageView1];
    
    
    
    //天气详情分隔背景
//    UIImage *lineImage = [UIImage imageNamed: @"天气背景.png"];
    _imageLine = [[UIImageView alloc] initWithFrame: CGRectMake(5, HEIGHTADDY(_cityBtn1)-1, WIDTH(self)-5, 2)];
    _imageLine.backgroundColor = [UIColor whiteColor];
//    _imageLine.image = lineImage;
    [self addSubview: _imageLine];
    
    
    /* --------------------------------------------------------------------------------------------*/
    
    //天气详情背景2
    _imageView2 = [[UIImageView alloc] initWithFrame: CGRectMake(0, HEIGHTADDY(_imageView1)+1, WIDTH(self), HEIGHT(self)/2-1)];
    _imageView2.userInteractionEnabled = YES;
    _imageView2.image = backImage;


    //温度范围
    _degreeRangeLab2 = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, 70, 12)];
    _degreeRangeLab2.backgroundColor = [UIColor clearColor];
    _degreeRangeLab2.font = SYSTEMFONT(10.0);
    _degreeRangeLab2.textColor = RGBCOLOR(126.0, 129.0, 136.0);
    _degreeRangeLab2.text = @"10 ~16c";
    [_imageView2 addSubview: _degreeRangeLab2];
    
    //最小温度
    _nonceLab2 = [[UILabel alloc] initWithFrame: CGRectMake(5,HEIGHTADDY(_degreeRangeLab2) + 10, 70, 20)];
    _nonceLab2.backgroundColor = [UIColor clearColor];
    _nonceLab2.font = SYSTEMFONT(18.0);
    _nonceLab2.textColor = [Common getColor: @"000000"];
    _nonceLab2.text = @"17 C";
    [_imageView2 addSubview: _nonceLab2];
    
    //家庭
    _locationBtn2 = [UIButton  buttonWithType:UIButtonTypeCustom];
    _locationBtn2.frame = CGRectMake(WIDTHADDX(_degreeRangeLab2) + 10, 5, 60, 16);
    _locationBtn2.backgroundColor = [Common getColor:@"CCCC66"];
    _locationBtn2.titleLabel.font = SYSTEMFONT(14);
    [_locationBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_locationBtn2 setTitle:@"家庭" forState:UIControlStateNormal];
    [_imageView2 addSubview: _locationBtn2];
    
    //城市
    _cityBtn2 = [UIButton buttonWithType: UIButtonTypeCustom];
    _cityBtn2.frame = CGRectMake(WIDTHADDX(_degreeRangeLab2) + 10, HEIGHTADDY(_locationBtn2) + 5, 80, 21);
    _cityBtn2.titleLabel.font = SYSTEMFONT(18.0);
    [_cityBtn2 setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [_cityBtn2 setTitle: @"呼和浩特" forState: UIControlStateNormal];
    [_imageView2 addSubview: _cityBtn2];
    
    [self addSubview: _imageView2];
}
@end

@interface HomeViewController ()<UIAlertViewDelegate>
{
    LocationView    *_locationView;
    NSMutableArray  *_arrData;
    
}
@end

@implementation HomeViewController

@synthesize memberTable = _memberTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView{

    [super loadView];
    
    [self initView];
    
    [self initLoadData];
}

#pragma mark 点击右按钮
- (void) tapRightBtn{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你确定退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backBtn.hidden = YES;
    
    self.navTitleLable.text = @"家族成员";
	
    UIImage *rightImage = [UIImage imageNamed: @"登录头像.png"];
    self.rightbtn.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    [self.rightbtn setBackgroundImage: rightImage forState: UIControlStateNormal];
    
}
- (void)initLoadData
{
    _arrData = [[NSMutableArray alloc] initWithArray:@[
                                                       @"爸爸",
                                                       @"妈妈",
                                                       @"哥哥",
                                                       @"姐姐"]
                                                      ];
}
#pragma mark --
- (void) initView{
    _memberTable = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), kIsIOS7 ? HEIGHT(self.view) - 104 : HEIGHT(self.view) - 88)];
    _memberTable.backgroundColor = [UIColor clearColor];
    _memberTable.dataSource = self;
    _memberTable.delegate = self;
    _memberTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _memberTable.allowsSelection = NO;
    
    _memberTable.tableFooterView = [self createFootView];
    _memberTable.tableHeaderView = [self createHeaderView];
    
    [self.view addSubview: _memberTable];
    
}

//创建FootView
- (UIView *) createFootView{
    
    UIView *addMemberView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), 80)];
    
    UIImage *footImage = [UIImage imageNamed: @"添加新成员背景未选.png"];
    UIButton *footBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    footBtn.frame = CGRectMake(8, 8, footImage.size.width, footImage.size.height);
    [footBtn setTitle: @"新增一个新成员" forState: UIControlStateNormal];
    [footBtn setImage: [UIImage imageNamed: @"添加新成员按钮.png"] forState: UIControlStateNormal];
    [footBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 230, 0, 5)];
    [footBtn setTitleEdgeInsets: UIEdgeInsetsMake(8, 40, 8, 80)];
    [footBtn setBackgroundImage: footImage forState: UIControlStateNormal];
    [footBtn setBackgroundImage: [UIImage imageNamed: @"添加新成员背景选中.png"] forState: UIControlStateHighlighted];
    [footBtn addTarget: self action: @selector(tapFootBtn:) forControlEvents: UIControlEventTouchUpInside];
    [addMemberView addSubview: footBtn];
    
    return addMemberView;

}

//点击添加新成员按钮
- (void) tapFootBtn: (id)sender{
    EditMemberViewController *editMemberVC = [[EditMemberViewController alloc] initWithNibName:@"EditMemberViewController" bundle:nil];
    [self presentViewController:editMemberVC animated:YES completion:nil];
}

//创建HeaderView
- (UIView *) createHeaderView{
    UIView *weatherView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), 178)];
    
    //天气背景
    UIImageView *weatherImg = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), 178)];
    [weatherView addSubview: weatherImg];
    
    //天气详细内容
    _locationView = [[LocationView alloc] initWithFrame: CGRectMake(155, 26, WIDTH(self.view) - 155, 98)];
//    _locationView.layer.borderWidth = 1;
//    _locationView.layer.borderColor = [UIColor redColor].CGColor;
    
    //本地
    [_locationView.locationBtn1 addTarget:self action:@selector(didSelectLocaltion1:) forControlEvents:UIControlEventTouchUpInside];
    
    //本地城市
    [_locationView.cityBtn1 addTarget: self action: @selector(didSelectCityAction:) forControlEvents: UIControlEventTouchUpInside];
    
    //家庭
    [_locationView.locationBtn2 addTarget:self action:@selector(didSelectLocaltion2:) forControlEvents:UIControlEventTouchUpInside];
    
    //家庭城市
    [_locationView.cityBtn2 addTarget: self action: @selector(didSelectCityAction:) forControlEvents: UIControlEventTouchUpInside];
    
    [weatherView addSubview: _locationView];
    
    return weatherView;

}

//跳转选择城市界面
- (void)didSelectCityAction: (UIButton *)btn
{
    NSLog(@"选择城市");
}
//本地
- (void)didSelectLocaltion1:(UIButton *)btn
{
    NSLog(@"本地");
    _locationView.imageView1.hidden = !_locationView.imageView1.hidden;
    if (_locationView.imageView1.hidden) {
        _locationView.imageView2.hidden = NO;
    }
}
//家庭
- (void)didSelectLocaltion2:(UIButton *)btn
{
    NSLog(@"家庭");
    _locationView.imageView2.hidden = !_locationView.imageView2.hidden;
    if (_locationView.imageView2.hidden) {
        _locationView.imageView1.hidden = NO;
    }
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *memberIndentified = @"memberindentified";
    
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier: memberIndentified];
    
    if (cell == nil) {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: memberIndentified];
        
    }
    
    //头像
    cell.headImg.image = [UIImage imageNamed: @"成员默认头像.png"];
    
    //名字
    cell.nameLable.text = _arrData[indexPath.row];
    
    return cell;

}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviceViewController *deviceVC = [[DeviceViewController alloc] initWithNibName:@"DeviceViewController" bundle:nil];
    deviceVC.memberStatus = memberTypeShowBack;
    deviceVC.name = _arrData[indexPath.row];
    [self.navigationController pushViewController:deviceVC animated:YES];
}


#pragma mark --AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        LOG(@"退出登录");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
