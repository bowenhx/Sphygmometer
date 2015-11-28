//
//  HomeViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-7-2.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "HomeViewController.h"
#import "MemberCell.h"
#import "EditMemberViewController.h"
#import "DeviceViewController.h"
#import "DataVesselObj.h"
#import "RegionViewController.h"
#import "AppDelegate.h"
#import "YFJLeftSwipeDeleteTableView.h"
#import "UIImageView+WebCache.h"

@interface WeatherLocationView: UIView

@property (nonatomic , strong)UIImageView   *imageView1;
@property (nonatomic , strong)UIImageView   *imageView2;
@property (nonatomic , strong)UIImageView   *imageLine;

@property (nonatomic , strong)UILabel       *degreeRangeLab1;
@property (nonatomic , strong)UILabel       *degreeRangeLab2;
@property (nonatomic , strong)UILabel       *nonceLab1;
@property (nonatomic , strong)UILabel       *nonceLab2;

//@property (nonatomic , strong)UIButton      *locationBtn1;
//@property (nonatomic , strong)UIButton      *locationBtn2;
@property (nonatomic , strong)UIButton      *cityBtn1;
@property (nonatomic , strong)UIButton      *cityBtn2;

@end

@implementation WeatherLocationView

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
    _degreeRangeLab1.font = SYSTEMFONT(12.0);
    _degreeRangeLab1.textColor = [UIColor darkGrayColor];
    _degreeRangeLab1.text = @"18°C~25°C";
    [_imageView1 addSubview: _degreeRangeLab1];
    
    //最小温度
    _nonceLab1= [[UILabel alloc] initWithFrame: CGRectMake(5,HEIGHTADDY(_degreeRangeLab1) + 10, 70, 20)];
    _nonceLab1.backgroundColor = [UIColor clearColor];
    _nonceLab1.font = SYSTEMFONT(18.0);
    _nonceLab1.textColor = [Common getColor: @"000000"];
    _nonceLab1.text = @"21°C";
    [_imageView1 addSubview: _nonceLab1];
    
//    //本地
//    _locationBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    _locationBtn1.frame = CGRectMake(WIDTHADDX(_degreeRangeLab1) + 10, 5, 60, 16);
//    _locationBtn1.backgroundColor = [Common getColor: @"62BFD1"];
//    _locationBtn1.titleLabel.font = SYSTEMFONT(14);
//    [_locationBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_locationBtn1 setTitle:@"本地" forState:UIControlStateNormal];
//    [_imageView1 addSubview: _locationBtn1];
    
    
    //城市
    _cityBtn1 = [UIButton buttonWithType: UIButtonTypeCustom];
    _cityBtn1.frame = CGRectMake(WIDTHADDX(_degreeRangeLab1)-20, 15, 80, 21);
    _cityBtn1.backgroundColor = [UIColor clearColor];
    _cityBtn1.titleLabel.font = GETBOLDFONT(22.0);
    [_cityBtn1 setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [_cityBtn1 setTitle: @"深圳" forState: UIControlStateNormal];
    _cityBtn1.tag = 1;
    [_imageView1 addSubview: _cityBtn1];
    
    [self addSubview: _imageView1];
    
    
    
    //天气详情分隔背景
//    UIImage *lineImage = [UIImage imageNamed: @"天气背景.png"];
    _imageLine = [[UIImageView alloc] initWithFrame: CGRectMake(5, HEIGHTADDY(_imageView1)-1, WIDTH(self)-5, 2)];
    _imageLine.image = [UIImage imageNamed:@"icon_image_scrobg"];
//    [_imageLine setBackgroundColor:[UIColor darkGrayColor]];
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
    _degreeRangeLab2.font = SYSTEMFONT(12.0);
    _degreeRangeLab2.textColor = [UIColor darkGrayColor];
    _degreeRangeLab2.text = @"15°C~19°C";
    [_imageView2 addSubview: _degreeRangeLab2];
    
    //最小温度
    _nonceLab2 = [[UILabel alloc] initWithFrame: CGRectMake(5,HEIGHTADDY(_degreeRangeLab2) + 10, 70, 20)];
    _nonceLab2.backgroundColor = [UIColor clearColor];
    _nonceLab2.font = SYSTEMFONT(18.0);
    _nonceLab2.textColor = [Common getColor: @"000000"];
    _nonceLab2.text = @"22°C";
    [_imageView2 addSubview: _nonceLab2];
    
    //家庭
//    _locationBtn2 = [UIButton  buttonWithType:UIButtonTypeCustom];
//    _locationBtn2.frame = CGRectMake(WIDTHADDX(_degreeRangeLab2) + 10, 5, 60, 16);
//    _locationBtn2.backgroundColor = [Common getColor:@"CCCC66"];
//    _locationBtn2.titleLabel.font = SYSTEMFONT(14);
//    [_locationBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_locationBtn2 setTitle:@"家庭" forState:UIControlStateNormal];
//    [_imageView2 addSubview: _locationBtn2];
    
    //城市
    _cityBtn2 = [UIButton buttonWithType: UIButtonTypeCustom];
    _cityBtn2.frame = CGRectMake(WIDTHADDX(_degreeRangeLab2)-20, 15, 80, 21);
    _cityBtn2.titleLabel.font = GETBOLDFONT(22.0);
    [_cityBtn2 setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [_cityBtn2 setTitle:@"" forState: UIControlStateNormal];
    _cityBtn2.tag = 2;
    [_imageView2 addSubview: _cityBtn2];
    
    [self addSubview: _imageView2];
}
@end

@interface HomeViewController ()<UIAlertViewDelegate,BMKMapViewDelegate,BMKGeneralDelegate>
{
    WeatherLocationView    *_locationView;
    UIImageView     *_weatherImg;
    
    BMKMapView                      *_mapView;      //地图定位当前城市
    
    NSMutableArray  *_arrData;
    
    NSInteger       _cityIndex;
    NSMutableArray  *_headImageArr;
    
    NSString           *_webUrl;
    __block BOOL        isChangeVC;
    
    //定位的城市名字
    NSString *cityRange;
    NSString *cityName;
    NSString *province;
}
@property (nonatomic, strong) YFJLeftSwipeDeleteTableView *memberTable;
@end

@implementation HomeViewController

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
    
    [self initLoadData];
}

#pragma mark 点击右按钮
- (void) tapRightBtn{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:IsEnglish ? @"Are you sure to log out?" : @"你确定退出登录吗？" delegate:self cancelButtonTitle:Cancel otherButtonTitles:Verify, nil];
    [alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backBtn.hidden = YES;
    
    self.navTitleLable.text = IsEnglish ? @"Family member" : @"家庭成员";
	
    UIImage *rightImage = [UIImage imageNamed: @"登录头像.png"];
    self.rightbtn.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    [self.rightbtn setBackgroundImage:rightImage forState: UIControlStateNormal];
    
    _headImageArr = [NSMutableArray array];
    
     [self showDataList];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isChangeVC = NO;
    [_headImageArr setArray:[SavaData parseArrFromFile:USER_HEAD_IMAGE]];
    
    [self loadDataOrRefersh];
    [_mapView viewWillAppear];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (CHECK_NETWORK) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //把无网络添加的成员提交到服务器
            NSMutableArray *cacheArr = [SavaData parseArrFromFile:UserMemberList];
            for (NSDictionary *dic in cacheArr) {
                if ([dic[@"roleid"] integerValue] ==0) {
                    [self refershMemberUserInfo:dic];
                }
            }
            
        });

    }else
    {
        [self showDataList];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isChangeVC = YES;
    [_mapView viewWillDisappear];
    
}
- (void)showDataList
{
//     [SavaData writeArrToFile:@[] FileName:UserMemberList];
    [_arrData setArray:[SavaData parseArrFromFile:UserMemberList]];
    
    if (_arrData.count ) {
        [DataVesselObj shareInstance].headImageUrl = _arrData[0][@"headimg"];
        [DataVesselObj shareInstance].titleName = _arrData[0][@"name"];
        [DataVesselObj shareInstance].roleid = [_arrData[0][@"roleid"] integerValue];
        
        [_memberTable reloadData];
    }
    
    
    // 获取天气信息
    double delayInSeconds = 2.f;
    dispatch_time_t requeTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(requeTime, dispatch_get_main_queue(), ^(void){
        NSDictionary *dicCity = [[SavaData shareInstance] printDataDic:User_Family_City];
        if (dicCity.allKeys.count) {
            //注册用户第一次进入
            [self weatherChange:dicCity[@"county"] cityStr:dicCity[@"name"] :YES];
        }else{
            //非注册用户第一登录进入
            [self weatherChange:@"" cityStr:@"" :YES];
        }
       
    });
}
- (void)initLoadData
{
    _cityIndex = 0;
    isChangeVC = NO;
    _arrData = [[NSMutableArray alloc] init];
    [DataVesselObj shareInstance].cityIndex = 100;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataOrRefersh) name:AddOrRefershMemberNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityData:) name:CountySelectNSNotificationCenter object:nil];

}
#define mark 获取天气信息
- (void)weatherChange:(NSString *)location cityStr:(NSString *)cityStr :(BOOL)all
{
    if (isChangeVC) {
        return;
    }
    //本地城市
     NSDictionary *dic = [SavaData parseDicFromFile:User_File];

    NSDictionary *dicCity =@{
                             langType:language,
                            @"local":dic[@"user_cityname"],
                            @"family":location,
                            @"uid":USERID,
                            @"county":cityStr
                              };
    
    //把数据提交到网络
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)dicCity withURL:Api_Weather withType:POST completed:^(id content, ResponseType responseType) {
        
        if (responseType == SUCCESS)
        {
            if (!isChangeVC) {
                LOG(@"天气预报数据 = %@",content[@"data"]);
                NSDictionary *dicWeather = content[@"data"];
//            LOG(@"famail1 = %@,\n2= %@,\n3= %@,\n4= %@,\n5= %@,\n6= %@,\n7= %@,\n8 = %@",dicWeather[@"family_maxtemp"],dicWeather[@"family_mintemp"],dicWeather[@"family_realtemp"],dicWeather[@"family_weather"],dicWeather[@"local_maxtemp"],dicWeather[@"local_mintemp"],dicWeather[@"local_realtemp"],dicWeather[@"local_weather"]);
//            NSString *degree1 = [ ];
                if (isChangeVC) {
                    return;
                }
                if (all) {
                    //本地
                    _locationView.degreeRangeLab1.text = [NSString stringWithFormat:@"%@~%@",dicWeather[@"local_mintemp"],dicWeather[@"local_maxtemp"]];
                    _locationView.nonceLab1.text = dicWeather[@"local_realtemp"];
                    
                    //家庭
                    _locationView.degreeRangeLab2.text = [NSString stringWithFormat:@"%@~%@",dicWeather[@"family_mintemp"],dicWeather[@"family_maxtemp"]];
                    _locationView.nonceLab2.text = dicWeather[@"family_realtemp"];
                    
                    //家庭区县
                      [_locationView.cityBtn2 setTitle:dicWeather[@"family_name"] forState:UIControlStateNormal];
                   
                }else{
                    //家庭
                    _locationView.degreeRangeLab2.text = [NSString stringWithFormat:@"%@~%@",dicWeather[@"family_mintemp"],dicWeather[@"family_maxtemp"]];
                    _locationView.nonceLab2.text = dicWeather[@"family_realtemp"];
                    
                    //家庭区县
                    [_locationView.cityBtn2 setTitle:dicWeather[@"family_name"] forState:UIControlStateNormal];
                }
                
                NSString *weatherStr = dicWeather[@"local_weather"];
                [self showWeatherImageBg:weatherStr];
                
            }
           
            
        } else if (responseType == FAIL) {
//            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
        
    }];
}

- (void)showWeatherImageBg:(NSString *)weatherStr
{
    if ([weatherStr isEqual:[NSNull null]]) {
        
        //空字符串，赋值为空，指针是存在的，只是内容为空
        
    }else if (![self isTitleBlank:weatherStr]) {
        if ([weatherStr hasPrefix:@"晴"]) {
            _weatherImg.image = [UIImage imageNamed:@"晴天"];
        }
        else if ([weatherStr hasPrefix:@"阴"])
        {
            _weatherImg.image = [UIImage imageNamed:@"阴天"];
        }else if ([weatherStr hasPrefix:@"雨"])
        {
            _weatherImg.image = [UIImage imageNamed:@"下雨"];
        }else if ([weatherStr hasPrefix:@"雪"])
        {
            _weatherImg.image = [UIImage imageNamed:@"下雪"];
        }else{
            _weatherImg.image = [UIImage imageNamed:@"阴天"];
        }
    }
    if (isChangeVC) {
        return;
    }
    //获取广告链接
    [self didSelectWeatherPage:_weatherImg.image];
}
- (void)refershMemberUserInfo:(NSDictionary *)dic
{
    //把数据提交到网络
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)dic withURL:Api_RoleAdd withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
        
    }];
}
- (void)loadDataOrRefersh
{
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"uid":USERID} withURL:Api_RoleList withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            [_arrData setArray:content[@"data"]];
            
            if (_arrData.count >0) {
                [DataVesselObj shareInstance].headImageUrl = _arrData[0][@"headimg"];
                [DataVesselObj shareInstance].titleName = _arrData[0][@"name"];
                [DataVesselObj shareInstance].roleid = [_arrData[0][@"roleid"] integerValue];
                
                [SavaData writeArrToFile:_arrData FileName:UserMemberList];
            }
            
            [_memberTable reloadData];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
            
            if ([content isEqualToString:IsEnglish ? @"No user's information" : @"没有相关成员信息"]) {
                [SavaData writeArrToFile:@[] FileName:UserMemberList];
     
                [DataVesselObj shareInstance].titleName = @"";
                [DataVesselObj shareInstance].roleid = 0;
                
                [_arrData removeAllObjects];
                [_memberTable reloadData];
            }
            
        }
        
    }];
}
#pragma mark --
- (void) initView{
    _memberTable = [[YFJLeftSwipeDeleteTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    _memberTable.backgroundColor = [UIColor clearColor];
    _memberTable.dataSource = self;
    _memberTable.delegate = self;
    _memberTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _memberTable.allowsSelection = NO;
    
    _memberTable.tableFooterView = [self createFootView];
    _memberTable.tableHeaderView = [self createHeaderView];
    
    [self.view addSubview: _memberTable];
    
    
    //百度 map 添加
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.hidden = YES;
    _mapView.delegate = self;
    
    // 将地图添加到视图上
    [self.view addSubview:_mapView];
}

//创建FootView
- (UIView *) createFootView{
    
    UIView *addMemberView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), 80)];
    
    UIImage *footImage = [UIImage imageNamed: @"添加新成员背景未选.png"];
    UIButton *footBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    footBtn.frame = CGRectMake((WIDTH(self.view)-footImage.size.width)/2, 8, footImage.size.width, footImage.size.height);
    [footBtn setTitle:IsEnglish ? @"Add a new user" : @"新增一个新成员" forState: UIControlStateNormal];
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
    EditMemberViewController *editMemberVC = [[EditMemberViewController alloc] initWithNibName:@"EditMemberViewController" bundle:nil userDic:nil];
    editMemberVC.memberType = memberTypeAdd;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editMemberVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

//创建HeaderView
- (UIView *) createHeaderView{
    UIView *weatherView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), 178)];
    weatherView.userInteractionEnabled = YES;
    //天气背景
    _weatherImg = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, WIDTH(self.view), 178)];
    _weatherImg.userInteractionEnabled = YES;
    _weatherImg.image = [UIImage imageNamed:@"阴天"];
    [weatherView addSubview: _weatherImg];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchWeatherURl)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 1;
    [_weatherImg addGestureRecognizer:tapGesture];
    
    
//    weatherImg.backgroundColor = [UIColor redColor];
    //天气详细内容
    _locationView = [[WeatherLocationView alloc] initWithFrame: CGRectMake(155, 26, WIDTH(self.view) - 155, 98)];
//    _locationView.layer.borderWidth = 1;
//    _locationView.layer.borderColor = [UIColor redColor].CGColor;
    
    /**
     *  取出用户城市信息
     *
     */
    
//    NSDictionary *dic = [SavaData parseDicFromFile:User_File];
//    if (dic.allKeys.count) {
//        [_locationView.cityBtn1 setTitle:dic[@"user_cityname"] forState:UIControlStateNormal];
//       
//    }
//    NSString *city = [[SavaData shareInstance] printDataStr:User_Family_City];
//    if ([self isTitleBlank:city]) {
//        [_locationView.cityBtn2 setTitle:dic[@"user_cityname"] forState:UIControlStateNormal];
//    }else{
//    [_locationView.cityBtn2 setTitle:city forState:UIControlStateNormal];
//    }
   
    [weatherView addSubview: _locationView];
   
    //本地
    UIButton *btnCity1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCity1.frame = CGRectMake(WIDTH(self.view)-30, 30, 28, 38);
    [btnCity1 setImage:[UIImage imageNamed:@"weather_location"] forState:UIControlStateNormal];
//    btnCity1.layer.borderWidth = 1;
//    btnCity1.layer.borderColor = [UIColor redColor].CGColor;
    btnCity1.tag = 0;
    [btnCity1 addTarget:self action:@selector(didSelectHiddenCityAction:) forControlEvents:UIControlEventTouchUpInside];
    [weatherView addSubview:btnCity1];
   
    //家庭
    UIButton *btnCity2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCity2.frame = CGRectMake(WIDTH(self.view)-30, HEIGHTADDY(btnCity1)+10, 28, 38);
    [btnCity2 setImage:[UIImage imageNamed:@"weather_family"] forState:UIControlStateNormal];
//    btnCity2.layer.borderWidth = 1;
//    btnCity2.layer.borderColor = [UIColor redColor].CGColor;
    btnCity2.tag = 1;
    [btnCity2 addTarget: self action: @selector(didSelectHiddenCityAction:) forControlEvents: UIControlEventTouchUpInside];
    [weatherView addSubview:btnCity2];
    
    
    [_locationView.cityBtn2 addTarget: self action: @selector(didSelectCityAction:) forControlEvents: UIControlEventTouchUpInside];
    
    
//    
//    float btnH =  HEIGHT(_locationView)/2;
//    for (int i=0; i<2; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(155, 26+i*btnH, WIDTH(_locationView)-80,btnH);
////        btn.layer.borderWidth  = 1;
//        btn.tag = i;
//        [btn addTarget:self action:@selector(didSelectHiddenCityAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [weatherView addSubview:btn];
//    }
    
    return weatherView;

}
- (void)didTouchWeatherURl
{
    if (_webUrl) {
        NSString *urlString = [_webUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }else{
         [self.view addHUDLabelView:@"没有网络链接地址！" Image:nil afterDelay:2.0f];
    }
}
#pragma  mark 天气链接地址
- (void)didSelectWeatherPage:(UIImage *)image
{
    [[Connection shareInstance] requestWithParams:nil withURL:Api_TopImage withType:GET completed:^(id content, ResponseType responseType) {
        if (responseType == SUCCESS)
        {
            if (isChangeVC) {
                return;
            }
            LOG(@"data = %@",content[@"data"]);
            NSURL *url = [NSURL URLWithString:content[@"data"][@"imgsrc"]];
            _webUrl = [[NSString stringWithFormat:@"%@",content[@"data"][@"link"]] copy];
            
            [_weatherImg sd_setImageWithURL:url placeholderImage:image];
            LOG(@"link  = %@",content[@"data"][@"link"]);
            
        } else if (responseType == FAIL) {
            _webUrl = nil;
        }
    }];
}
#pragma mark 选择区县通知
- (void)changeCityData:(NSNotification *)infor
{
    NSDictionary *dic = [infor object];
    if (_cityIndex ==1) {
         [_locationView.cityBtn1 setTitle:dic[@"name"] forState:UIControlStateNormal];
    }else{
         [_locationView.cityBtn2 setTitle:dic[@"name"] forState:UIControlStateNormal];
        
        double delayInSeconds = 2.f;
        dispatch_time_t requeTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(requeTime, dispatch_get_main_queue(), ^(void){
            [self weatherChange:dic[@"county"] cityStr:dic[@"name"] :NO];
        });

    }
    
}
#pragma mark 隐藏城市view
- (void)didSelectHiddenCityAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        _locationView.imageView1.hidden = !_locationView.imageView1.hidden;
    }else{
        _locationView.imageView2.hidden = !_locationView.imageView2.hidden;
    }
    
    if (_locationView.imageView1.hidden == YES|| _locationView.imageView2.hidden == YES) {
        _locationView.imageLine.hidden = YES;
    }else{
        _locationView.imageLine.hidden = NO;
    }
    
}
//跳转选择城市界面
- (void)didSelectCityAction: (UIButton *)btn
{
    NSLog(@"选择城市");
    RegionViewController *regionCity = [[RegionViewController alloc] initWithNibName:@"RegionViewController" bundle:nil];
    _cityIndex = btn.tag;
    regionCity.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:regionCity animated:YES];
}
//本地
- (void)didSelectLocaltion1:(UIButton *)btn
{
    NSLog(@"本地");
    
//    if (_locationView.imageView1.hidden) {
//        _locationView.imageView2.hidden = NO;
//    }
}
//家庭
- (void)didSelectLocaltion2:(UIButton *)btn
{
    NSLog(@"家庭");
    
//    if (_locationView.imageView2.hidden) {
//        _locationView.imageView1.hidden = NO;
//    }
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *memberIndentified = @"memberindentified";
    
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier: memberIndentified];
    
    if (cell == nil) {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: memberIndentified];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.editImage.tag = indexPath.row;
    cell.editBtn.tag = indexPath.row;
   
    
    //名字
    cell.nameLable.text = _arrData[indexPath.row][@"name"];
    
    //头像
    [cell.headImg sd_setImageWithURL:_arrData[indexPath.row][@"headimg"] placeholderImage:[UIImage imageNamed:@"成员默认头像.png"]];//[self headImageCellForRow:cell.nameLable.text];
    
    [cell.editBtn addTarget:self action:@selector(didSelectEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editImage addTarget:self action:@selector(didSelectEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}
//添加成员头像
- (UIImage *)headImageCellForRow:(NSString *)name
{
    __block UIImage *headImage = [UIImage imageNamed:@"成员默认头像.png"];
    [_headImageArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger index, BOOL *stop){
        if ([dic[@"name"] isEqualToString:name]) {
            headImage = [UIImage imageWithData:dic[@"headImage"]];
        }
    }];
    
    return headImage;

}
- (void)didSelectEditBtn:(UIButton *)btn
{
    EditMemberViewController *editMemberVC = [[EditMemberViewController alloc] initWithNibName:@"EditMemberViewController" bundle:nil userDic:_arrData[btn.tag]];
    editMemberVC.memberType = memberTypeEdit;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editMemberVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberCell *cell = (MemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    
   [DataVesselObj shareInstance].headImageUrl = _arrData[indexPath.row][@"headimg"];
    [DataVesselObj shareInstance].titleName = cell.nameLable.text;
    [DataVesselObj shareInstance].roleid = [_arrData[indexPath.row][@"roleid"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeTabBarNotificationCenter object:@(1)];
    
//    DeviceViewController *deviceVC = [[DeviceViewController alloc] initWithNibName:@"DeviceViewController" bundle:nil];
//    deviceVC.memberStatus = memberTypeShowBack;
//    deviceVC.name = _arrData[indexPath.row][@"name"];
//    [self.navigationController pushViewController:deviceVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self remoDataListUserInfo:indexPath.row];
    }
}
- (void)remoDataListUserInfo:(NSInteger)index
{
    if (CHECK_NETWORK) {
        [self.view addHUDActivityView:Loading];
        
        [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{@"uid":USERID,@"roleid":_arrData[index][@"roleid"]} withURL:Api_RoleDelete withType:POST completed:^(id content, ResponseType responseType) {
            [self.view removeHUDActivityView];
            
            if (responseType == SUCCESS)
            {
                LOG(@"data = %@",content[@"data"]);
                
                //            [_dataArray removeObjectAtIndex:row];
                //            [_tableView reloadData];
                //
                [self removeUserHeadImageView:_arrData[index][@"name"]];
                [_arrData removeObjectAtIndex:index];
                [_memberTable reloadData];
                
                
                [SavaData writeArrToFile:_arrData FileName:UserMemberList];
                
                if (_arrData.count ==0) {
                    [DataVesselObj shareInstance].titleName = @"";
                    [DataVesselObj shareInstance].roleid = 0;
                    
                    [SavaData writeArrToFile:@[] FileName:UserMemberList];
                }
                
            } else if (responseType == FAIL) {
                [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
            }
        }];
    }else{
        //无网操作，保存本地,当有网络时数据可以恢复
        [self removeUserHeadImageView:_arrData[index][@"name"]];
        [_arrData removeObjectAtIndex:index];
        [_memberTable reloadData];
        
        [SavaData writeArrToFile:_arrData FileName:UserMemberList];
    }
    
}
#pragma 删除用户头像换成信息
- (void)removeUserHeadImageView:(NSString *)name
{
    for (int i=0; i<_headImageArr.count; i++) {
        NSDictionary *dic = _headImageArr[i];
        if ([dic[@"name"] isEqualToString:name]) {
            [_headImageArr removeObjectAtIndex:i];
        }
    }
    
    [SavaData writeArrToFile:_headImageArr FileName:USER_HEAD_IMAGE];

}
#pragma mark --AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        LOG(@"退出登录");
        [DataVesselObj clearUserInfo];
        //切换回登陆界面
        [[AppDelegate getAppDelegate] showLoginVC];
    }
}
#pragma mark - 定位
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView {
    NSLog(@"start locate");
    
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"local failed: %@",[error localizedDescription]);
    }
    
    [_locationView.cityBtn1 setTitle:IsEnglish ? @"Fail in locating" : @"定位失败" forState:UIControlStateNormal];
}
/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 在实际使用中，只需要 [mapView setShowsUserLocation:YES];    mapView.delegate = self;
 */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation {
    double localLatitude;
    double localLongitude;
    if (userLocation != nil) {
        NSLog(@"定位成功------纬度%f 经度%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    }
    
    localLatitude = userLocation.location.coordinate.latitude;
    localLongitude = userLocation.location.coordinate.longitude;
    //    NSString *lacation = [NSString stringWithFormat:@"%f,%f",localLatitude,localLongitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:localLatitude
                                                longitude:localLongitude];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            
            province = placemark.administrativeArea;
            if (province.length == 0) {
                //                province = placemark.locality;
                //                cityName = placemark.subLocality;
                 [_locationView.cityBtn1 setTitle:placemark.locality forState:UIControlStateNormal];
                NSLog(@"cityName %@",cityName);//获取城市名
                NSLog(@"province %@ ++",province);
            }else {
                
                //获取城市名
                cityName = placemark.locality;
                province = placemark.administrativeArea;
                cityRange = [placemark.subLocality copy];
                //                _labelSubLocality.text = [NSString stringWithFormat:@"%@ %@",cityName,cityRange];
                [_locationView.cityBtn1 setTitle:placemark.locality forState:UIControlStateNormal];
                NSLog(@"获取区域： %@", cityRange);//区域
                NSLog(@"获取街道地址: %@",placemark.thoroughfare);//获取街道地址
                NSLog(@"城市名： %@",cityName);//获取城市名
                NSLog(@"省份： %@",province);
            }
            break;
        }
    }];
    // 一次定位
    _mapView.showsUserLocation = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//	return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}
@end


