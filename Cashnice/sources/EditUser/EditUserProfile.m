//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "EditUserProfile.h"
#import "EditIntro.h"
 
#import "FabuJiekuanTableViewCell.h"
#import "FabuStep2.h"
#import "EditProvince.h"
#import "NickNameEdit.h"
#import "UserDescEdit.h"
#import "NonRotateImgPicker.h"
#import "CameraEngine.h"

#import <AVFoundation/AVFoundation.h>

@interface EditUserProfile () {
	NSString *provineName;
	NSString *cityName;
	NSString *introText;
}

@property (strong, nonatomic) IBOutlet UITableView* table;
@property (strong, nonatomic) MKNetworkOperation *  op;
@property (strong, nonatomic) NSArray *             imageArray;
@property (strong, nonatomic) NSArray *             nameArray;

@property (nonatomic,strong) CameraEngine *cameraEngine;

@property (strong, nonatomic) UIImagePickerController * mypicker;

@end

@implementation EditUserProfile

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);

	provineName = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_provincename];
	cityName    = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_cityname];
	introText   = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_SHORTDESC];
    
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//     }];
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"编辑资料"];
	[self setTitle:@"编辑资料"];
	

	[self.table reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"编辑资料"];
}

- (void)selectImageButtonPressed {
    
    [self.cameraEngine presentTZImagePicker:NO type:0];
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.EditUserProfile", nil) message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从相机拍照", @"从照片选择", nil];
	alert.tag = 10;
	[alert show];
     */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            
            
#ifdef __IPHONE_8_0
            //跳入当前App设置界面,因为URLWithString:UIApplicationOpenSettingsURLString是iOS8之后新增的
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
#else
            //适配iOS7 ,跳入系统设置界面
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:General&path=Reset"]];
            
#endif
            
         }
    }else{
        if (buttonIndex != [alertView cancelButtonIndex]) {
            if (alertView.tag == 10) {
                if (buttonIndex == 1) {
                    [self selectFromCamera];
                }
                else if (buttonIndex == 2) {
                    [self selectFromPhoto];
                }
            }
        }
    }
    

}

- (void)selectFromCamera {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请前往[设置]-[隐私]-[相机]，开启Cashnice权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 999;
        [alertView show];

        return;
    }


    
    
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate      = self;
	picker.allowsEditing = NO;
	picker.sourceType    = UIImagePickerControllerSourceTypeCamera;

	[self.navigationController presentViewController:picker animated:YES completion:^{[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]; }];
}

- (void)selectFromPhoto {
	[self.navigationController presentViewController:self.mypicker animated:YES completion:^{[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]; }];
}


- (UIImagePickerController *)mypicker {
	if (_mypicker == nil) {
		_mypicker           = [[NonRotateImgPicker alloc] init];
		_mypicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
		_mypicker.delegate  = self;
	}
	return _mypicker;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}
- (BOOL)lastRow:(NSInteger)row {
	return row == 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return [ZAPP.zdevice getDesignScale:88];
	}
	return [ZAPP.zdevice getDesignScale:44];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return [ZAPP.zdevice getDesignScale:20];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}

- (NSArray *)imageArray {
	if (_imageArray == nil) {
		_imageArray =@[@"star", @"user", @"address", @"txt"];
	}
	return _imageArray;
}
- (NSArray *)nameArray {
	if (_nameArray == nil) {
		_nameArray = @[@"头像", @"昵称", @"常居地", @"个人简介"];
	}
	return _nameArray;
}

- (void)pickerDismissed {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)pickerSetImage:(UIImage *)img {
	[self.navigationController popViewControllerAnimated:NO];
	[self loadCropEditor:img];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FabuJiekuanTableViewCell *cell;
	static NSString *         CellIdentifier = @"cell";
	cell                = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell.sepLine.hidden = [self lastRow:indexPath.row];

	cell.txtImg.hidden   = NO;
	cell.moneyImg.hidden = YES;
	[cell.tf setEnabled:NO];
	cell.tf.text            = [self.nameArray objectAtIndex:indexPath.row];
	cell.txtImg.image       = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
	cell.detailImage.hidden = YES;

	if (indexPath.row == 0) {
		cell.detail.text        = @"";
		cell.detailImage.hidden = NO;
        cell.roundoutDetailImage = YES;
//		[cell.detailImage sd_setImageWithURL:[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_HEADIMG] placeholderImage:[Util imagePlaceholderPortrait]];
//        
        [cell.detailImage setHeadImgeUrlStr:[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_HEADIMG]];

	}
	else if (indexPath.row == 1) {
		cell.detail.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_NICKNAME];
	}
	else if (indexPath.row == 2) {
		cell.detail.text = [NSString stringWithFormat:@"%@ %@", provineName, cityName];
	}
	else if (indexPath.row == 3) {
		cell.detail.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_SHORTDESC]; //introText;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ((indexPath.row == 0)) {
		[self selectImageButtonPressed];
	}
	else if (indexPath.row == 1) {
		NickNameEdit *pro = ZEdit(@"NickNameEdit");
		[self.navigationController pushViewController:pro animated:YES];
	}
	else if (indexPath.row == 2) {
		EditProvince *pro = ZEdit(@"EditProvince");
		pro.delegate = self;
		[self.navigationController pushViewController:pro animated:YES];
	}
	else if (indexPath.row == 3) {
        
        /*
         * modify by cc
         *
		EditIntro *intro = ZEdit(@"EditIntro");
		intro.delegate = self;
		[self.navigationController pushViewController:intro animated:YES];
         */
        UserDescEdit *desc = ZEdit(@"UserDescEdit");
        [self.navigationController pushViewController:desc animated:YES];
	}
}

- (void)setIntroString:(NSString *)intro {
	introText = intro;
	[self.table reloadData];
	[self connectToCommitIntro:intro];
}

- (void)selecteWith:(int)province city:(int)city {
	provineName = [ZAPP.zprovince getProvinceName:province];
	cityName    = [ZAPP.zprovince getCityName:province cityindex:city];
	[self.table reloadData];
	[self connectToCommitProvince:provineName city:cityName];
}

- (void)setData {
    [Util toastStringOfLocalizedKey:@"tip.alreadySaved"];
}

- (void)loseData {
}

- (void)connectToCommitProvince:(NSString *)pro city:(NSString *)city {
	[self.op cancel];
	bugeili_net
	progress_show
    
    __weak __typeof__(self) weakSelf = self;

	self.op = [ZAPP.netEngine commitProvinceCityWithComplete:^{[weakSelf setData]; progress_hide} error:^{[weakSelf loseData]; progress_hide} province:pro city:city];
}

- (void)connectToCommitIntro:(NSString *)intro {
	[self.op cancel];
	bugeili_net
	progress_show
    
    __weak __typeof__(self) weakSelf = self;
    
	self.op = [ZAPP.netEngine commitIntroWithComplete:^{[weakSelf setData]; progress_hide} error:^{[weakSelf loseData]; progress_hide} intro:intro];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	//ZCLICK

	UIImage *ximage = [info objectForKey:UIImagePickerControllerOriginalImage];
	if (ximage && ximage.size.width > 0 && ximage.size.height>0 ) {
		[self.navigationController dismissViewControllerAnimated:YES completion:^{[self loadCropEditor:ximage]; }];
	}
	else {
		[[UIApplication sharedApplication]
		 setStatusBarStyle:UIStatusBarStyleLightContent];
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)setDataPostUrl {
    [Util toastStringOfLocalizedKey:@"tip.savedSuccess"];
	[self.table reloadData];
}

- (void)connectToCommitHeadUrl:(NSString *)url {
    
    __weak __typeof__(self) weakSelf = self;

	self.op = [ZAPP.netEngine postHeadUrlWithComplete:^{[weakSelf setDataPostUrl]; progress_hide} error:^{[weakSelf loseData]; progress_hide} headrul:url];
}

- (void)setData:(NSDictionary *)imgServerDict {
	if (imgServerDict != nil) {
		NSString *    str = [imgServerDict objectForKey:NET_KEY_URL];
		if ([str notEmpty]) {
			[self connectToCommitHeadUrl:str];
			return;
		}
	}


    [Util toastStringOfLocalizedKey:@"tip.uploadFail"];
	progress_hide
}

- (void)connectUploadImage:(UIImage *)image {
	[self.op cancel];
	bugeili_net
	progress_show
    
    __weak __typeof__(self) weakSelf = self;

	self.op = [ZAPP.netEngine uploadImageFromFile:@"head.jpg" image:image completionHandler:^(NSDictionary* s){[weakSelf setData:s]; } errorHandler:^{[weakSelf loseData]; progress_hide}];
}




-(CameraEngine *)cameraEngine{
    
    if(!_cameraEngine){
        
        _cameraEngine = [[CameraEngine alloc] init];
        _cameraEngine.delegate = self;
        _cameraEngine.avoidCompressIMGQuailty = YES;
    }
    
    return _cameraEngine;
}

#pragma mark - Camera

-(void)CameraDidChoseMultiplePhotosFromAlbum:(NSArray *)_imgs{
    
    if (_imgs.count) {
        
        UIImage *image = _imgs[0];
        
        
        
        [self loadCropEditor:image];
        
    }
    
}

-(void)CameraFailed:(int)_code Err:(NSString *)errormsg{
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[[UIApplication sharedApplication]
	 setStatusBarStyle:UIStatusBarStyleLightContent];

	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
	[[UIApplication sharedApplication]
	 setStatusBarStyle:UIStatusBarStyleLightContent];

	if (croppedImage != nil) {
		[self connectUploadImage:croppedImage];

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
