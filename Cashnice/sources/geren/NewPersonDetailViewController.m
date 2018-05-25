//
//  NewPersonDetailViewController.m
//  Cashnice
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NewPersonDetailViewController.h"
#import "NPDHeaderCell.h"
#import "NPDTitleCell.h"
#import "MeRouter.h"
#import "PersonInfoAPIEngine.h"
#import "CameraEngine.h"
#import "GetUserInfoEngine.h"

#import "PECropViewController.h"

#import "SinaCashierModel.h"
#import "SinaCashierWebViewController.h"

@interface NewPersonDetailViewController ()<CameraEngineDelegate>{
    
    NSString *headUrl;
    
    UIImage *newUploadHeadImageLocal;
    
    BOOL realNameIdentify;
    BOOL visaCountIdentify;
    BOOL cardIDIdentify;
    
    NSString *organizationname;//工作在
    NSString *organizationduty;//公司职务
    NSString *address;//通讯地址

    //控制头像一栏的四个认证标签
    NSMutableArray *headSectionIdentifyArr;
    
    NSDictionary *identifyArr;
    
    
}
@property (strong,nonatomic) NSArray *typeNameArr;
@property (strong,nonatomic) PersonInfoAPIEngine *engine;
@property (nonatomic,strong) CameraEngine *cameraEngine;
@property (strong, nonatomic) GetUserInfoEngine *getUserEngine;

@end

@implementation NewPersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    
    [self setNavButton];
    self.title = @"我的资料";
    
    [Util setScrollHeader:self.detailTableView target:self header:@selector(freshData) dateKey:[Util getDateKey:self]];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self requestData];
}

//-(void)refreshUserAbout{
////    [self.detailTableView reloadData];
//
//}

-(PersonInfoAPIEngine *)engine{
    
    WS(weakSelf)
    
    if(!_engine){
        _engine = [PersonInfoAPIEngine sharedInstance];
        _engine.userInfoFreshBlock =^{
            [weakSelf requestData];
        };
        
        _engine.visaFreshBlock =^{
            [weakSelf requestData];
        };
    }
    
    return _engine; 
}

-(GetUserInfoEngine *)getUserEngine{
    
    if (!_getUserEngine) {
        _getUserEngine = [[GetUserInfoEngine alloc]init];
    }
    return _getUserEngine;
}


-(CameraEngine *)cameraEngine{
    
    if(!_cameraEngine){
        
        _cameraEngine = [[CameraEngine alloc] init];
        _cameraEngine.delegate = self;
        _cameraEngine.avoidCompressIMGQuailty = YES;
    }
    
    return _cameraEngine;
}

//子类重写
-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:@[@"hh"]];
        [tempArr addObject:@[@"真实姓名",@"身份证号",@"手机号码"]];
        [tempArr addObject:@[@"营业执照"]];
        [tempArr addObject:@[@"我的银行卡"]];
        [tempArr addObject:@[@"工作在",@"职务",@"通信地址",@"邮箱地址",@"社会职务"]];

        _typeNameArr = tempArr;
    }
    
    return _typeNameArr;
}

-(void)freshData{
    
    POST_USERINFOFRESH_NOTI
//    [self requestData];
    
}

-(void)requestData{
    

    
    //成员变量控制，增加代码量，但减少了计算量，回头再考虑那种代码方式更合理
    
//    NSDictionary *dic = ZAPP.myuser.gerenInfoDict;
    
    headUrl = EMPTYSTRING_HANDLE([ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_HEADIMG]);
    realNameIdentify =  [[ZAPP.myuser getIdCard] length]>0?YES:FALSE;
    visaCountIdentify =  [ZAPP.myuser hasBankBinded];
    
    cardIDIdentify = [[ZAPP.myuser getIdCard] length] > 0;
    
    
    if (!_engine) {
        progress_show
    }
    
    WS(weakSelf)
    [self.engine getUserIdentifyResult:ZAPP.myuser.getUserID success:^(NSDictionary *identArr) {
        progress_hide
        [weakSelf.detailTableView.header endRefreshing];

        [weakSelf updateUI:identArr];
    } failure:^(NSString *error) {
        progress_hide
        [weakSelf.detailTableView.header endRefreshing];
        
    }];
    

}

-(void)updateUI:(NSDictionary *)arr{
    
    identifyArr = arr;

    
    headSectionIdentifyArr = @[].mutableCopy;
    [headSectionIdentifyArr addObject:@{@"name":@"实名",
                                        @"identify":@(realNameIdentify)}];
    [headSectionIdentifyArr addObject:@{@"name":@"银行卡",
                                        @"identify":@(visaCountIdentify)}];

    [headSectionIdentifyArr addObject:@{@"name":@"公司职务",
                                        @"identify":@([[EMPTYOBJ_HANDLE(identifyArr[@"organizationduty"]) objectForKey:@"itemstatus"] boolValue])}];
    
    [headSectionIdentifyArr addObject:@{@"name":@"社会职务",
                                        @"identify":@([[EMPTYOBJ_HANDLE(identifyArr[@"socialfunc"]) objectForKey:@"itemstatus"] boolValue])}];

    
    organizationname = EMPTYSTRING_HANDLE([EMPTYOBJ_HANDLE(identifyArr[@"organizationname"]) objectForKey:@"itemvalue"]) ;
    organizationduty = EMPTYSTRING_HANDLE([EMPTYOBJ_HANDLE(identifyArr[@"organizationduty"]) objectForKey:@"itemvalue"]);
    address = EMPTYSTRING_HANDLE([EMPTYOBJ_HANDLE(identifyArr[@"address"]) objectForKey:@"itemvalue"]);
    [self.detailTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.typeNameArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section < self.typeNameArr.count) {
        NSArray *arr = self.typeNameArr[section];
        return  [arr count]+1;
    }
    
    return 0;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }else{
        
        NSArray *array = self.typeNameArr[indexPath.section];
        
        if (indexPath.row < array.count) {
            return LISTDETAIL_ROW_HEIGHT;
        }
    }
    
    return LISTDETAIL_SECTION_BLANK;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return LISTDETAIL_ROW_HEIGHT;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *_headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, _headerView.bounds.size.height)];
    _headerLabel.font = [UIFont systemFontOfSize:15];
     _headerLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY) ;
    _headerLabel.text = @"完成以下认证获得VIP权限";
    [_headerView addSubview:_headerLabel];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView*lineview = [[UIView alloc]initWithFrame:CGRectMake(SEPERATOR_LINELEFT_OFFSET, _headerView.frame.size.height-1, _headerLabel.frame.size.width, 1)];
    [lineview setBackgroundColor:CN_COLOR_DD_GRAY];
    [_headerView addSubview:lineview];
    
//    NSDictionary *dic = self.typeNameArr[section];
//    _headerLabel.text = [[dic allKeys] firstObject];
    
    return _headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            NPDHeaderCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"NPDHeaderCell_id"];
            [cell.creView fresh:headSectionIdentifyArr];
            
            if(newUploadHeadImageLocal){
                cell.headerImgView.layer.cornerRadius = cell.headerImgView.width/2;
                cell.headerImgView.layer.masksToBounds = YES;
                cell.headerImgView.image = newUploadHeadImageLocal;
            }else{
                [cell.headerImgView setHeadImgeUrlStr:headUrl];
            }
            
            cell.vipLabel.hidden = !([ZAPP.myuser getUserLevel] == UserLevel_VIP);
            cell.nameLabel.text = [ZAPP.myuser getUserRealName];
//            [self content:indexPath];
            cell.sex = [ZAPP.myuser getSex];
            return cell;
        }
        
    }else{
        
        NSArray *array = self.typeNameArr[indexPath.section];
        
        if (indexPath.row < array.count) {
            
            NPDTitleCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"NPDTitleCell_id"];

            cell.titleLabel.text = array[indexPath.row];
            cell.detailLabel.text = [self content:indexPath];
            cell.identified = [self hasIdentify:indexPath];

            cell.bottomLineHidden = [self hideBottomLine:indexPath];
            return cell;
            
        }

        
    }
    
    //空白区域
    return  [self cellForBlank:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self pickNewHeader];
        
    }else{
        NSArray *array = self.typeNameArr[indexPath.section];
        NSString *title = array[indexPath.row];
        UIViewController *dstDetail;
        
        if([title isEqualToString:@"真实姓名"]){
            
            if(cardIDIdentify){
                dstDetail =  [MeRouter IDCardIdentifiedViewController];
            }else{
                dstDetail = [MeRouter UserBindBankViewController];
            }
            
            //            dstDetail = [MeRouter UserBindBankViewController];
        }else if([title isEqualToString:@"我的银行卡"]){
            [self pushBankCardManger];
        }else if([title isEqualToString:@"身份证号"]){
            
            if(cardIDIdentify){
                dstDetail =  [MeRouter IDCardIdentifiedViewController];
            }else{
                dstDetail = [MeRouter UserBindBankViewController];
                
                //                dstDetail = [MeRouter IDCardUploadViewController:nil];
                
            }
            
        }else if([title isEqualToString:@"手机号码"]){
            dstDetail = [MeRouter editUserPhoneViewController];
        }else if([title isEqualToString:@"工作在"]){
            
            if(!cardIDIdentify){
                TOAST_LOCAL_STRING(@"tip.person.realidentify.no");
                return;
            }
            dstDetail = [MeRouter editUserWorkplace:organizationname];
        } else if([title isEqualToString:@"职务"]){
            if(!cardIDIdentify){
                TOAST_LOCAL_STRING(@"tip.person.realidentify.no");
                return;
            }
            dstDetail = [MeRouter editUserPosition:organizationduty];
        } else if([title isEqualToString:@"通信地址"]){
            if(!cardIDIdentify){
                TOAST_LOCAL_STRING(@"tip.person.realidentify.no");
                return;
            }
            dstDetail = [MeRouter editUserAddress:address];
        } else if([title isEqualToString:@"邮箱地址"]){
            if(!cardIDIdentify){
                TOAST_LOCAL_STRING(@"tip.person.realidentify.no");
                return;
            }
            dstDetail = [MeRouter editUserEmailViewController];
        } else if([title isEqualToString:@"社会职务"]){
            if(!cardIDIdentify){
                TOAST_LOCAL_STRING(@"tip.person.realidentify.no");
                return;
            }
            dstDetail = [MeRouter editUserSocietyViewController];
        } else if([title isEqualToString:@"营业执照"]){
//            if(!cardIDIdentify){
//                TOAST_LOCAL_STRING(@"tip.person.realidentify.no");
//                return;
//            }
            dstDetail = [MeRouter businessLicense];
        }
 
        [self.navigationController pushViewController:dstDetail animated:YES];
    }
    
}

- (UITableViewCell *)cellForBlank:(UITableView *)tableView {
    
    NSString *const cellForBlank_ID= @"cellForBlank";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellForBlank_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellForBlank_ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
    
}

-(BOOL)hideBottomLine:(NSIndexPath *)indexPath{
    
    NSArray *array = self.typeNameArr[indexPath.section];
    if (indexPath.row == array.count - 1) {
        return YES;
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)content:(NSIndexPath *)indexPath{
// 
//    if(indexPath.section == 0){
//        if (indexPath.row == 0) {
//            
//            return [ZAPP.myuser getUserRealNamepExplictly];
////            return [Util getNickNameUserOrRealName:ZAPP.myuser.gerenInfoDict];
////            [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_NICKNAME];
//        }
//    }
    
    NSArray *array = self.typeNameArr[indexPath.section];
    NSString *title = array[indexPath.row];
//    UIViewController *dstDetail;
//    if([title isEqualToString:@"真实姓名"]){
//        return [ZAPP.myuser getUserRealNamepExplictly];
////        [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_USERREALNAME];
//
//    }else
    
    if([title isEqualToString:@"手机号码"]){
        return [ZAPP.myuser getPhoneMask];
    }
    
    return nil;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self pickNewHeader];
    }else{
        NSArray *array = self.typeNameArr[indexPath.section];
        NSString *title = array[indexPath.row];
        UIViewController *dstDetail;
        if([title isEqualToString:@"我的银行卡"]){
            
            
            [self pushBankCardManger];
            
            
            
        }else if([title isEqualToString:@"身份证号"]){
//            [self.navigationController pushViewController:animated:YES];
            dstDetail = [MeRouter IDCardUploadViewController:nil];
        }else if([title isEqualToString:@"手机号码"]){
            dstDetail = [MeRouter editUserPhoneViewController];
        }else if([title isEqualToString:@"工作在"]){
            dstDetail = [MeRouter editUserWorkplace:@"Workplace"];
        } else if([title isEqualToString:@"职务"]){
            dstDetail = [MeRouter editUserPosition:@"position"];
        } else if([title isEqualToString:@"通信地址"]){
            dstDetail = [MeRouter editUserAddress:@"address"];
        } else if([title isEqualToString:@"邮箱地址"]){
            dstDetail = [MeRouter editUserEmailViewController];
        } else if([title isEqualToString:@"社会职务"]){
            dstDetail = [MeRouter editUserSocietyViewController];
        }
        
        [self.navigationController pushViewController:dstDetail animated:YES];
    }

*/
- (void)pushBankCardManger{
    if ([ZAPP.myuser hasBankCardNumber]) {
        //已经绑卡
        __weak id weakSelf = self;
        SinaCashierModel *model = [[SinaCashierModel alloc] init];
        progress_show
        [model bankCardManagementWithsuccess:^(NSString *URL, NSData *Content) {
            progress_hide
            SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
            web.URLPath = URL;
            web.titleString = @"管理银行卡";
            web.completeHandle = weakSelf;
            
            web.navigationBackHandler = ^(void){
                [weakSelf complete];
            };
            
            [self.navigationController pushViewController:web animated:YES];
        } failure:^(NSString *error) {
            progress_hide
        }];
    }else{
        UIViewController *dstDetail = [MeRouter UserBindBankViewController];
        [self.navigationController pushViewController:dstDetail animated:YES];
    }
}


- (void)complete{
    
    POST_VISABANK_FRESH_NOTI
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[NewPersonDetailViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)pickNewHeader{

    [self.cameraEngine presentTZImagePicker:NO type:0];
//    [se];
    
//    [[PersonInfoAPIEngine sharedInstance] uploadHeaderImage:[UIImage imageNamed:@"di"] success:^(NSString *url) {
//        NSLog(@"url = %@", url);
//    }];

}

-(NSInteger)hasIdentify:(NSIndexPath *)indexPath{
    
    if(indexPath.section >= self.typeNameArr.count)return NO;
    NSArray *array = self.typeNameArr[indexPath.section];
    
    if(indexPath.row >= array.count)return NO;
    NSString *title = array[indexPath.row];
//    UIViewController *dstDetail;
   
    if([title isEqualToString:@"真实姓名"]){
        return realNameIdentify?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;

    }else if([title isEqualToString:@"身份证号"]){
        return cardIDIdentify?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;;

    }else if([title isEqualToString:@"手机号码"]){
        return [ZAPP.myuser hasPhone]?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;
    }else if([title isEqualToString:@"我的银行卡"]){
//        return [ZAPP.myuser hasPhone];
        return NPD_IDENTIFY_HIDDEN;
    }
    else if([title isEqualToString:@"工作在"]){
        
        return  [[EMPTYOBJ_HANDLE(identifyArr[@"organizationname"]) objectForKey:@"itemstatus"] boolValue]?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;
    }else if([title isEqualToString:@"职务"]){

        return  [[EMPTYOBJ_HANDLE(identifyArr[@"organizationduty"]) objectForKey:@"itemstatus"] boolValue]?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;
    }
    else if([title isEqualToString:@"通讯地址"]){
//        return [[EMPTYOBJ_HANDLE(identifyArr[@"address"]) objectForKey:@"itemstatus"] boolValue]?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;
        return NPD_IDENTIFY_HIDDEN;

    } else if([title isEqualToString:@"邮箱地址"]){
        return [ZAPP.myuser hasEmail]?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;
    }else if([title isEqualToString:@"社会职务"]){

        return [[EMPTYOBJ_HANDLE(identifyArr[@"socialfunc"]) objectForKey:@"itemstatus"] boolValue]?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;
    } else if([title isEqualToString:@"营业执照"]){
        return [ZAPP.myuser hasBusinessLicense]?NPD_IDENTIFIED:NPD_NOT_IDENTIFY;
    }
    
    return 2;
}

    /*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Camera

-(void)CameraDidChoseMultiplePhotosFromAlbum:(NSArray *)_imgs{
    
    if (_imgs.count) {
    
        UIImage *image = _imgs[0];
        
        
        
        [self loadCropEditor:image];

    }
    
}

-(void)CameraFailed:(int)_code Err:(NSString *)errormsg{
    

    
}
//
-(void)updateHeader:(UIImage *)image{

    newUploadHeadImageLocal = image;
    
    [self.detailTableView reloadData];
    
//    headUrl = EMPTYSTRING_HANDLE([ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_HEADIMG]);
//
////    headUrl = url;
//    [self.detailTableView reloadData];
}
//



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (croppedImage != nil) {
        
        //        WS(weakSelf)
        [self updateHeader:croppedImage];
        
        [[PersonInfoAPIEngine sharedInstance] uploadHeaderImage:croppedImage success:^(NSString *url) {
        }];
        
        
    }
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    //	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCropEditor:(UIImage *)theImage {
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate               = self;
    controller.image                  = theImage;
    controller.keepingCropAspectRatio = YES;
    controller.toolbarHidden          = YES;
    controller.cropAspectRatio        = 1;
    controller.rotationEnabled        = NO;
    
    //	[self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
