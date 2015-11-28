//
//  EditMemberViewController.m
//  Sphygmometer
//
//  Created by Guibin on 14-5-19.
//  Copyright (c) 2014年 cai. All rights reserved.
//

#define  editUser_Image_Add         5
#define  editUser_Image_Change      10

#import "EditMemberViewController.h"
#import "BKMath.h"
#import "MemberViewController.h"
#import "UIImage+UIImageExt.h"
#import "UIImageView+WebCache.h"

@interface EditMemberViewController ()<
                                        UITextFieldDelegate,
                                        UIPickerViewDataSource,
                                        UIPickerViewDelegate,
                                        UIActionSheetDelegate,
                                        UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate
                                        >

{

    __weak IBOutlet UIView *_viewBg;                //背景view
    __weak IBOutlet UIView *_headView;              //上面蓝色view，放有头像等
    __weak IBOutlet UIButton *_btnDelect;           //右边删除button
    __weak IBOutlet UIImageView *_imageHead;

    
    
//    IBOutlet UITextField *_textFieldName;           //输入名称
    
    __weak IBOutlet UIButton *_btnEditName;         //编辑姓名btn
    __weak IBOutlet UIButton *_btnSort1;            //四个类别button
    __weak IBOutlet UIButton *_btnSort2;
    __weak IBOutlet UIButton *_btnSort3;
    __weak IBOutlet UIButton *_btnSort4;
    
    __weak IBOutlet UIButton *_btnMan;              //性别中的男
    __weak IBOutlet UIButton *_btnWoman;            //性别中的女
    
    __weak IBOutlet UILabel *_labBirthday;
    __weak IBOutlet UILabel *_labHeight;
    __weak IBOutlet UILabel *_labWeight;
    
    __weak IBOutlet UIView *_viewFootSex;           //显示性别view
    
    IBOutlet UIView *_datePickViewBg;               //日期选择器背景view
    __weak IBOutlet UIDatePicker *_pickerDate;      //pickerView 日期选择器
    __weak IBOutlet UIView *_pickerHeadView;        //选择器header View
    
    IBOutlet UIView *_pickerViewBg;                 //身高体重选择器
    __weak IBOutlet UIPickerView *_pickerView;
    __weak IBOutlet UIView *_pickerHeadView2;
    __weak IBOutlet UILabel *_pickLabTitle;
    
    __weak IBOutlet UIButton *_btnFinishSave;
    
    
    
    NSMutableArray  *_pickData1;
    NSMutableArray  *_pickData2;
    
    NSString        *_dateStr;                      //日期选择保存
    NSInteger       _indexType;         //身高与体重类型
    
    NSMutableArray        *_arrBtn;
    
    BOOL                _isNews;           //是否添加新头像
}
@property (nonatomic , strong)NSDictionary *dicUser;
@end

@implementation EditMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userDic:(NSDictionary *)dic
{
    _dicUser = [dic copy];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headView.backgroundColor = [Common getColor:@"4cb9c1"];
    
    [self initShowView];
    
    [self initData];
}
- (void)initData
{
    _dateStr = @"";
    _isNews = NO;
    if (_dicUser.allKeys.count >0) {
        _btnDelect.hidden = NO;
        [_btnEditName setTitle:_dicUser[@"name"] forState:UIControlStateNormal];
        _labBirthday.text = _dicUser[@"birthday"];
        
        [DataVesselObj unitTypeWeightType:0 textNumber:_dicUser[@"weight"] backBlock:^(NSString *unit,NSString *value){
             _labWeight.text = [NSString stringWithFormat:@"%@ %@",value,unit];
        }];
        
        [DataVesselObj unitTypeWeightType:1 textNumber:_dicUser[@"height"] backBlock:^(NSString *unit,NSString *value){
            _labHeight.text = [NSString stringWithFormat:@"%@ %@",value,unit];
        }];
        
        if ([_dicUser[@"sex"] intValue] == 1) {
            [self selectManAction:nil];
        }else{
            [self selectWomanAction:nil];
        }
        
        [_imageHead sd_setImageWithURL:_dicUser[@"headimg"]  placeholderImage:[UIImage imageNamed:@"头像.png"]];
        
        
//        NSMutableArray *arrInfo = [SavaData parseArrFromFile:USER_HEAD_IMAGE];
//        for (NSDictionary *dic in arrInfo) {
//            if ([dic[@"name"] isEqualToString:_btnEditName.titleLabel.text]) {
//                UIImage *img = [UIImage imageWithData:dic[@"headImage"]];
//                [_btnHeadImage setImage:img forState:UIControlStateNormal];
//            }
//        }
        
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
}
- (void)initShowView
{
    _viewBg.backgroundColor = RGBCOLOR(237.0, 237.0, 237.0);
//    _btnEditName.layer.borderWidth = 1;
    
    _arrBtn = [NSMutableArray array];
    _pickData1 = [NSMutableArray array];
    _pickData2 = [NSMutableArray array];
    
    _indexType =0;
    
    for (int i = 30; i<230; i++) {
        [_pickData1 addObject:@(i)];
    }
    
    for (int i = 20; i<200; i++) {
        [_pickData2 addObject:@(i)];
        float flo = i + .5;
        [_pickData2 addObject:@(flo)];
    }
    
    if (isiPhone5 == NO) {
        CGRect btnFrame = _btnFinishSave.frame;
        btnFrame.origin.y -= 10;
        _btnFinishSave.frame = btnFrame;
    }
    
    [_arrBtn addObject:_btnSort1];
    [_arrBtn addObject:_btnSort2];
    [_arrBtn addObject:_btnSort3];
    [_arrBtn addObject:_btnSort4];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectEditNameCenter:) name:EditMemberNameNotificationCenter object:nil];
}
- (BOOL)isContentFinish
{
    if ([_btnEditName.titleLabel.text isEqualToString:IsEnglish ? @"Enter the user name" : @"请输入测量人名称"]) {
        [self.view addHUDLabelView:IsEnglish ? @"Enter the user name" : @"请输入测量人名称" Image:nil afterDelay:2.0f];
        return NO;
    }else if (_btnMan.selected == NO && _btnWoman.selected == NO)
    {
        [self.view addHUDLabelView:IsEnglish ? @"Please select sex": @"请选择性别" Image:nil afterDelay:2.0f];
        return NO;
    }else if (![BKMath predicate_digital:_labBirthday.text withIndex:0]){
        [self.view addHUDLabelView:IsEnglish ?@"Please select a birthday": @"请选择生日" Image:nil afterDelay:2.0f];
        return NO;
    }else if (![BKMath predicate_digital:_labHeight.text withIndex:0])
    {
        [self.view addHUDLabelView:IsEnglish ?@"Please select height":@"请选择身高" Image:nil afterDelay:2.0f];
        return NO;
    }else if (![BKMath predicate_digital:_labWeight.text withIndex:0])
    {
        [self.view addHUDLabelView:IsEnglish ?@"Please select weight":@"请选择体重" Image:nil afterDelay:2.0f];
        return NO;
    }else
       return YES;
}
- (void)setUserHeadImageAction
{
    //保存头像到本地
    UIImage *imageHead = _imageHead.image;
    LOG(@"image = %@",imageHead);
    if (imageHead !=nil) {
        NSMutableArray *arrImg = [SavaData parseArrFromFile:USER_HEAD_IMAGE];
        NSMutableArray  *arrImage = [NSMutableArray arrayWithArray:arrImg];
        __block BOOL isEqual = NO;
        __block int i = 0;
        __block int change = 0;
        
        if (arrImage.count >0) {
            NSMutableDictionary *dicChange = [NSMutableDictionary dictionary];
            [arrImage enumerateObjectsUsingBlock:^(NSDictionary *dicID, NSUInteger index, BOOL *stop)
             {
                 //修改头像
                 if ([dicID[@"name"] isEqualToString:_btnEditName.titleLabel.text]) {
                     isEqual = YES;
                     [dicChange setDictionary:dicID];
                     NSData *imageData = UIImageJPEGRepresentation(_imageHead.image, 0.5);
                     [dicChange setObject:imageData forKey:@"headImage"];
                     change = i;
                 }
                 i ++;
             }];
            
            //替换掉修改之后的头像
            if (isEqual)
            {
                [arrImage replaceObjectAtIndex:change withObject:dicChange];
            }else
            {
                //之前不存在该成员，添加该成员头像
                NSData *imageData = UIImageJPEGRepresentation(_imageHead.image, 0.5);
                [arrImage addObject:@{@"name":_btnEditName.titleLabel.text,@"headImage":imageData}];
                
            }
            
        }else
        {
            //之前不存在该成员，添加该成员头像
            NSData *imageData = UIImageJPEGRepresentation(_imageHead.image, 0.5);
            [arrImage addObject:@{@"name":_btnEditName.titleLabel.text,@"headImage":imageData}];
        }
        
        [SavaData writeArrToFile:arrImage FileName:USER_HEAD_IMAGE];
    }
}
//用户信息字典
- (NSDictionary *)editUserInforDictionaryAdd:(NSInteger)index
{
    NSInteger year = [SavaData getUserYearCountNumber:_labBirthday.text];
    
    NSInteger sex = 0;
    if (_btnMan.selected == YES) {
        sex = 1;
    }else{
        sex = 2;
    }
    
    if (index == 0) {
        NSDictionary *dic = @{
                              @"uid":USERID,
                              @"name":_btnEditName.titleLabel.text,
                              @"birthday":_labBirthday.text,
                              @"year":@(year),
                              @"weight":_labWeight.text,
                              @"height":_labHeight.text,
                              @"sex":@(sex)
                              };
        return dic;
    }else{
        LOG(@"roleid = %@",_dicUser[@"roleid"]);
        //判断编辑是否是离线添加的成员   ： 离线添加的成员没有用户id故制作编辑使用
        if ([self isTitleBlank:_dicUser[@"roleid"]]) {
            NSDictionary *dic = @{
                                  @"uid":USERID,
                                  @"name":_btnEditName.titleLabel.text,
                                  @"birthday":_labBirthday.text,
                                  @"year":@(year),
                                  @"weight":_labWeight.text,
                                  @"height":_labHeight.text,
                                  @"sex":@(sex)
                                  };
            return dic;
        }else{
            NSDictionary *dic = @{
                                  @"uid":USERID,
                                  @"roleid":_dicUser[@"roleid"],
                                  @"name":_btnEditName.titleLabel.text,
                                  @"birthday":_labBirthday.text,
                                  @"year":@(year),
                                  @"weight":_labWeight.text,
                                  @"height":_labHeight.text,
                                  @"sex":@(sex)
                                  };
            return dic;
        }
        
    }
    
}
#pragma mark 完成后保存成员信息
//选择保存
- (IBAction)selectSaveDataAction:(UIButton *)sender {
    
    if ([self isContentFinish]) {
        if (_memberType == memberTypeAdd) {
            /**
             *  添加成员信息
             */
            
            NSDictionary *dic = [self editUserInforDictionaryAdd:0];
            
            if (CHECK_NETWORK) {
                [self.view addHUDActivityView:Loading];
                
                
                NSURL *registerUrl = [NSURL URLWithString:[BASE_REQUEST_URL stringByAppendingString:Api_RoleAdd]];
                ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:registerUrl];
                
                
                request.shouldAttemptPersistentConnection = NO;
                 [request setRequestMethod:@"POST"];
                
                for (id aKey in dic) {
                    [request setPostValue:[dic objectForKey:aKey] forKey:aKey];
                }
                if (_isNews) {
                    NSData *data = UIImagePNGRepresentation(_imageHead.image);
                    [request addData:data withFileName:@"headimg.png" andContentType:@"image/png" forKey:@"headimg"];
                }
                [request setPostValue:language forKey:langType];
               [request setUserInfo:@{@"tag": @(editUser_Image_Add)}];
                [request setTimeOutSeconds:15.0];
                [request setDelegate:self];
                [request startAsynchronous];
                
                
                //把数据提交到网络
//                [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)dic withURL:Api_RoleAdd withType:POST completed:^(id content, ResponseType responseType) {
//                    [self.view removeHUDActivityView];
//                    
//                    if (responseType == SUCCESS)
//                    {
//                        LOG(@"data = %@",content[@"data"]);
//                        
//                        [self.view addHUDLabelView:@"添加成员成功" Image:nil afterDelay:2.0f];
//                        
//                        //刷新成员列表
////                        [[NSNotificationCenter defaultCenter] postNotificationName:AddOrRefershMemberNotification object:nil];
//                        [self performSelector:@selector(didDisMisVC:) withObject:nil afterDelay:1.f];
//                    } else if (responseType == FAIL) {
//                        [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
//                    }
//                    
//                }];
            }else{
                /**
                 *  无网络时添加数据
                 */
                NSMutableArray *arrUser = [NSMutableArray arrayWithArray:[SavaData parseArrFromFile:UserMemberList]];
                [arrUser addObject:dic];
                
                [SavaData writeArrToFile:arrUser FileName:UserMemberList];
                
                [self.view addHUDLabelView:IsEnglish ?@"Add user successfully":@"添加成员成功" Image:nil afterDelay:2.0f];
                
                //刷新成员列表
//                [[NSNotificationCenter defaultCenter] postNotificationName:AddOrRefershMemberNotification object:nil];
                [self performSelector:@selector(didDisMisVC:) withObject:nil afterDelay:1.f];
                
                //设置用户头像处理
                [self setUserHeadImageAction];
            }
            
           
            
        }else{
            /**
             *  编辑成员信息
             */
            
            NSDictionary *dic = [self editUserInforDictionaryAdd:1];
            
            if (CHECK_NETWORK) {
                [self.view addHUDActivityView:Loading];
                
                NSURL *registerUrl = [NSURL URLWithString:[BASE_REQUEST_URL stringByAppendingString:Api_RoleEdit]];
                ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:registerUrl];
                
                
                request.shouldAttemptPersistentConnection = NO;
                [request setRequestMethod:@"POST"];
                
                for (id aKey in dic) {
                    [request setPostValue:[dic objectForKey:aKey] forKey:aKey];
                }
                if (_isNews) {
                    NSData *data = UIImagePNGRepresentation(_imageHead.image);
                    [request addData:data withFileName:@"headimg.png" andContentType:@"image/png" forKey:@"headimg"];
                }
                [request setPostValue:language forKey:langType];
                [request setUserInfo:@{@"tag": @(editUser_Image_Change)}];
                [request setTimeOutSeconds:15.0];
                [request setDelegate:self];
                [request startAsynchronous];
                
                
//                [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)dic withURL:Api_RoleEdit withType:POST completed:^(id content, ResponseType responseType) {
//                    [self.view removeHUDActivityView];
//                    
//                    if (responseType == SUCCESS)
//                    {
//                        LOG(@"data = %@",content[@"data"]);
//                        
//                        [self.view addHUDLabelView:@"修改成员成功" Image:nil afterDelay:2.0f];
//                        
//                        //刷新成员列表
////                        [[NSNotificationCenter defaultCenter] postNotificationName:AddOrRefershMemberNotification object:nil];
//                        [self performSelector:@selector(didDisMisVC:) withObject:nil afterDelay:1.f];
//                    } else if (responseType == FAIL) {
//                        [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
//                    }
//                    
//                }];
            }else{
                /**
                 *  无网络操作
                 */
                NSMutableArray *arrUser = [NSMutableArray arrayWithArray:[SavaData parseArrFromFile:UserMemberList]];
               
                NSInteger roleid = [_dicUser[@"roleid"] integerValue];
                
                if (roleid ==0) {
                    NSString *strName = _dicUser[@"name"];
                    BOOL isSame = NO;
                    for (int i=0; i<arrUser.count; i++) {
                        NSDictionary *userDic = arrUser[i];
                        if ([strName isEqualToString:userDic[@"name"]]) {
                            [arrUser replaceObjectAtIndex:i withObject:dic];
                            isSame = YES;
                            break;
                        }
                    }
                    //修改性别，重新添加用户
                    if (!isSame) {
                        [arrUser addObject:dic];
                    }
                    
                }else{
                    for (int i=0; i<arrUser.count; i++) {
                        NSDictionary *userDic = arrUser[i];
                        if (roleid == [userDic[@"roleid"] integerValue]) {
                            [arrUser replaceObjectAtIndex:i withObject:dic];
                            break;
                        }
                    }

                }
                
                [SavaData writeArrToFile:arrUser FileName:UserMemberList];
                
                [self.view addHUDLabelView:IsEnglish ?@"Modify user successfully":@"修改成员成功" Image:nil afterDelay:2.0f];
                
                //刷新成员列表
//                [[NSNotificationCenter defaultCenter] postNotificationName:AddOrRefershMemberNotification object:nil];
                [self performSelector:@selector(didDisMisVC:) withObject:nil afterDelay:1.f];
                
                //设置用户头像处理
                [self setUserHeadImageAction];
            }
            
            
            
        }
        
        
    }
    
}
- (void)showSelectButtonBg:(UIButton *)btn
{
    for (UIButton *button in _arrBtn) {
        if ([button isEqual:btn]) {
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [Common getColor:@"4cb9c1"].CGColor;
        }else{
            button.layer.borderWidth = 0;
            button.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

- (void)didSelectEditNameCenter:(NSNotification *)infor
{
    NSString *name = [infor object];
    
//    if (_dicUser.allKeys.count >0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_dicUser];
        [dic setObject:name forKey:@"name"];
        _dicUser = [dic copy];
//    }else{
        [_btnEditName setTitle:name forState:UIControlStateNormal];
//    }
    
}

//编辑姓名
- (IBAction)didSelectEditName {
    MemberViewController *memberVC = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
    memberVC.userName = _dicUser[@"name"];
    [self.navigationController pushViewController:memberVC animated:YES];
}


//选择性别
- (IBAction)selectSexAction:(UIButton *)sender {
    _viewFootSex.hidden = NO;
    _viewBg.backgroundColor = [UIColor grayColor];
    _viewBg.alpha = 0.7f;
    _viewBg.userInteractionEnabled = NO;
    [self showSelectButtonBg:sender];
}
//选择生日
- (IBAction)selectBirthdayAction:(UIButton *)sender {
     [self showDatePickView];
     [self showSelectButtonBg:sender];
}
//选择身高
- (IBAction)selectHeightAction:(UIButton *)sender {
    _indexType = 1;
    
    NSString *height = _dicUser[@"height"];
    
    if ([UNITS_TYPE_DATA[@"height"] intValue] == 0) {
        [self showDatePickerView2:HeightCm reload:height.length >1 ? [height intValue] - 30 : 120];
    }else{
        [self showDatePickerView2:HeithtFt reload:height.length >1 ? [height intValue] - 30 : 120];
    }
    
     [self showSelectButtonBg:sender];
}
//选择体重
- (IBAction)selectWeightAction:(UIButton *)sender {
    _indexType = 2;
//    NSString *weight = _dicUser[@"weight"];
//    double weiNum = [weight doubleValue];
    if ([UNITS_TYPE_DATA[@"weight"]intValue] == 0) {
        [self showDatePickerView2:WeightKg reload:60];
    }else{
        [self showDatePickerView2:WeightLb reload:60];
    }
    
    [self showSelectButtonBg:sender];
}
//选择男
- (IBAction)selectManAction:(UIButton *)sender {
    _viewFootSex.hidden = YES;
    _btnMan.selected = YES;
    _btnWoman.selected = NO;
    [self refershTabViewPage];
}
//选择女
- (IBAction)selectWomanAction:(UIButton *)sender {
    _viewFootSex.hidden = YES;
    _btnWoman.selected = YES;
    _btnMan.selected = NO;
    [self refershTabViewPage];
}

//恢复view背景色
- (void)refershTabViewPage
{
    _viewBg.backgroundColor = RGBCOLOR(237.0, 237.0, 237.0);
    _viewBg.alpha = 1.0f;
    _viewBg.userInteractionEnabled = YES;
}


#pragma mark 更换头像
- (IBAction)didChangeHeaderImageAction:(UIButton *)sender {
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:IsEnglish ?@"Select portrait":@"选择头像" delegate:self cancelButtonTitle:Cancel destructiveButtonTitle:nil otherButtonTitles:IsEnglish ? @"Photograph": @"拍照",IsEnglish ? @"From the album selection": @"从相册选取", nil];
    [ac showInView:self.view];
}
//退出
- (IBAction)didDisMisVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//删除操作
- (IBAction)didDeleteAction:(UIButton *)sender {
    [self.view addHUDActivityView:Loading];
    
    [[Connection shareInstance] requestWithParams:(NSMutableDictionary *)@{langType:language,@"uid":USERID,@"roleid":_dicUser[@"roleid"]} withURL:Api_RoleDelete withType:POST completed:^(id content, ResponseType responseType) {
        [self.view removeHUDActivityView];
        
        if (responseType == SUCCESS)
        {
            LOG(@"data = %@",content[@"data"]);
            
            [self removeMember];
            
            
            [self.view addHUDLabelView:IsEnglish ?@"Delete successfully":@"删除成功" Image:nil afterDelay:2.0f];
            [self performSelector:@selector(didDisMisVC:) withObject:nil afterDelay:1.f];
            
        } else if (responseType == FAIL) {
            [self.view addHUDLabelView:content Image:nil afterDelay:2.0f];
        }
    }];
}
- (void)removeMember
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[SavaData parseArrFromFile:UserMemberList]];
    NSInteger roleid = [_dicUser[@"roleid"]integerValue];
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        if (roleid == [dic[@"roleid"] integerValue]) {
            [arr removeObjectAtIndex:i];
        }
    }
    
    [SavaData writeArrToFile:arr FileName:UserMemberList];
}
- (void)showImagePickerVC:(NSInteger)index
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if (index == 0) {
        //拍照
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
    }else{
        //选照片
         imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma  mark ActionsSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (buttonIndex == 2) {
        return;
   }else{
       [self showImagePickerVC:buttonIndex];
   }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _isNews = YES;
     UIImage *image = info[UIImagePickerControllerEditedImage];
    
    image = [image scalingImageByRatio];//调整图片像素
    image = [image fixOrientation];
    NSData *data = [image compressedData:0.6];
    image = [UIImage imageWithData:data];
//    image = [DataVesselObj circleImage:image withParam:75];//剪裁成圆角
    _imageHead.image = image;
//    [_btnHeadImage setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 选择身高体重pickerView
- (IBAction)didSelectCancelAction2:(UIButton *)sender {
    [self didHiddenPickerView2];
}
- (IBAction)didSelectFinishAction2:(UIButton *)sender {
    [self didHiddenPickerView2];
}
- (void)showDatePickerView2:(NSString *)title reload:(NSInteger)row
{
    CGRect rect = _pickerViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _pickerViewBg.frame = rect;
    if (!_pickerViewBg.superview) {
        [self.view addSubview:_pickerViewBg];
    }
    
    _pickLabTitle.text = title;
    _pickerHeadView2.backgroundColor = [Common getColor:@"4cb9c1"];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _pickerViewBg.frame;
        frame.origin.x = 0;
        frame.origin.y = HEIGHT(self.view) - _pickerViewBg.frame.size.height;
        _pickerViewBg.frame = frame;
    }];
    [_pickerView selectRow:row inComponent:0 animated:YES];
    [_pickerView reloadAllComponents];
}
- (void)didHiddenPickerView2
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _pickerViewBg.frame;
        rect.origin.x = 0;
        rect.origin.y = SCREEN_HEIGHT;
        _pickerViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_pickerViewBg removeFromSuperview];
    }];
}

#pragma  mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_indexType == 1) {
         return _pickData1.count;
    }else{
        return _pickData2.count;
    }
   
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_indexType == 1) {
        return [NSString stringWithFormat:@"%@",_pickData1[row]];
    }else{
        return [NSString stringWithFormat:@"%@",_pickData2[row]];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_indexType == 1) {
        _labHeight.text = [NSString stringWithFormat:@"%@",_pickData1[row]];
    }else{
        _labWeight.text = [NSString stringWithFormat:@"%@",_pickData2[row]];
    }
}
#pragma mark 选择完成操作PickerDate
- (IBAction)didSelectCancelAction:(UIButton *)sender {
    [self didHiddenPickerView];
}

#pragma mark 选择完成并保存
- (IBAction)didSelectFinishAction:(UIButton *)sender {
    _labBirthday.text = _dateStr;
    [self didHiddenPickerView];
}

- (IBAction)didSelectChangeFinishAction:(UIDatePicker *)sender {
    
    NSDate *date = [sender date];
    
    NSDateFormatter *formatter = [self userDateFormatter];
    _dateStr = [[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]] copy];
    LOG(@"datestr = %@",_dateStr);
}

- (NSDate *)getDateFromDateButton:(NSString *)birth
{
    NSDateFormatter *formatter = [self userDateFormatter];
    NSDate *date = [formatter dateFromString:birth];
    return date;
}
- (NSDateFormatter *)userDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}
- (void)showDatePickView
{
    CGRect rect = _datePickViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _datePickViewBg.frame = rect;
    if (!_datePickViewBg.superview) {
        [self.view addSubview:_datePickViewBg];
    }
    
    _pickerHeadView.backgroundColor = [SavaData getColor:@"4cb9c1" alpha:1.f];
    
    [_pickerDate setMinimumDate:[self getDateFromDateButton:@"1000-01-01"]];
    _labBirthday.text = [NSString stringWithFormat:@"%@",[[self userDateFormatter] stringFromDate:[_pickerDate date]]];
    
    [_pickerDate setMaximumDate:[NSDate date]];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _datePickViewBg.frame;
        frame.origin.x = 0;
        frame.origin.y = HEIGHT(self.view) - _datePickViewBg.frame.size.height;
        _datePickViewBg.frame = frame;
    }];
    
}
- (void)didHiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _datePickViewBg.frame;
        rect.origin.x = 0;
        rect.origin.y = SCREEN_HEIGHT;
        _datePickViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_datePickViewBg removeFromSuperview];
    }];
    
}

#pragma mark TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!isiPhone5) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect rect = _viewBg.frame;
            rect.origin.y -= 50;
            _viewBg.frame = rect;
        }];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (!isiPhone5) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect rect = _viewBg.frame;
            rect.origin.y = 0;
            _viewBg.frame = rect;
        }];
    }
    return YES;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
     [self.view removeHUDActivityView];
    
    NSData *data= [request responseData];
    NSDictionary *dicInfor = [data objectFromJSONData];
    LOG(@"message = %@",dicInfor[@"message"]);
    
    NSInteger tag = [request.userInfo[@"tag"] integerValue];
    
   
    
   
    if ([dicInfor[@"status"] integerValue] == 1) {
        if (tag == editUser_Image_Add) {
            [self.view addHUDLabelView:IsEnglish ?@"Add user successfully":@"添加成员成功" Image:nil afterDelay:2.0f];
        }else{
             [self.view addHUDLabelView:IsEnglish ?@"Modify user successfully":@"修改成员成功" Image:nil afterDelay:2.0f];
        }
        
        [self performSelector:@selector(didDisMisVC:) withObject:nil afterDelay:1.f];
    }else{
         [self.view addHUDLabelView:dicInfor[@"message"] Image:nil afterDelay:2.0f];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
     [self.view removeHUDActivityView];
     [self.view addHUDLabelView:NetworkFail Image:nil afterDelay:2.0f];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
