//
//  RegionViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-6-4.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#import "RegionViewController.h"
#import "CountyViewController.h"
@interface RegionViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BMKMapViewDelegate,BMKGeneralDelegate>
{
    __weak IBOutlet UISearchBar     *_searchBar;
    
    
    __weak IBOutlet     UIButton    *_btnLocation;
    
    __weak IBOutlet UILabel         *_labLocation;
    __weak IBOutlet UITableView     *_tableView;
    
    
    
    BMKMapView                      *_mapView;
    
    //定位的城市名字
    NSString *cityRange;
    NSString *cityName;
    NSString *province;
    
    NSMutableArray      *_arrData;
}
@end

@implementation RegionViewController

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
    self.navTitleLable.text = IsEnglish ? @"Select a city": @"选择城市";
    
    [self initView];
    
    [self initLoadData];
}
- (void)initView
{
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    [_searchBar setBarTintColor:[UIColor whiteColor]];
    if (kIsIOS7 == NO) {
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
        _searchBar.backgroundColor = [UIColor whiteColor];
    }
    
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
}

- (void)initLoadData
{
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:nil withURL:Api_AllCityList withType:GET completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            _arrData = [[NSMutableArray alloc] initWithArray:content[@"data"]];
            
            
            [_tableView reloadData];
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
        
    }];
}
- (IBAction)locationSelectCity {
    if (_labLocation.text.length >1) {
        [self searchData:_labLocation.text];
    }
}

- (NSMutableArray *)sectionForRowCitys:(NSInteger)section
{
    NSMutableArray *arr = _arrData[section][@"citys"];
    if (arr.count >0) {
        return arr;
    }
    return nil;
}

#pragma  mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self sectionForRowCitys:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineString = @"defineString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineString];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defineString];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = [self sectionForRowCitys:indexPath.section][indexPath.row][@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CountyViewController *countyVC = [[CountyViewController alloc] initWithNibName:@"CountyViewController" bundle:nil];
    countyVC.countyName = [self sectionForRowCitys:indexPath.section][indexPath.row][@"name"];
    countyVC.cid = [[self sectionForRowCitys:indexPath.section][indexPath.row][@"id"] integerValue];
    [self.navigationController pushViewController:countyVC animated:YES];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _arrData[section][@"name"];
}
#pragma mark - searchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search %@", searchBar.text);
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    if ([self isTitleBlank:searchBar.text]) {
         [self.view addHUDLabelView:IsEnglish ? @"Please enter key words": @"请输入搜索地区" Image:nil afterDelay:2.0f];
    }else{
         [self searchData:searchBar.text];
    }
   
}
- (void)searchData:(NSString *)text
{
    [self.view addHUDActivityView: Loading];
    NSDictionary *dic = @{@"key":text};
    [[Connection shareInstance] requestWithParams:[NSMutableDictionary dictionaryWithDictionary:dic] withURL:Api_CitySearch withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS) {
            
             LOG(@"data = %@",content[@"data"]);
            CountyViewController *countyVC = [[CountyViewController alloc] initWithNibName:@"CountyViewController" bundle:nil];
            countyVC.countyName = content[@"data"][0][@"name"];
            countyVC.cid = [content[@"data"][0][@"id"] integerValue];
            [self.navigationController pushViewController:countyVC animated:YES];
            
//            [self.baseTableView reloadData];
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
    }];
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
    _labLocation.text = IsEnglish ? @"Fail in locating": @"定位失败，请重试！";
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
                _labLocation.text = placemark.locality;
                NSLog(@"cityName %@",cityName);//获取城市名
                NSLog(@"province %@ ++",province);
            }else {
                
                //获取城市名
                cityName = placemark.locality;
                province = placemark.administrativeArea;
                cityRange = [placemark.subLocality copy];
//                _labelSubLocality.text = [NSString stringWithFormat:@"%@ %@",cityName,cityRange];
                _labLocation.text = placemark.locality;
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

@end
