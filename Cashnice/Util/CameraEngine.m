//
//  CameraMain.m
//  NavTab
//
//  Created by zeng on 12-3-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraEngine.h"
#import "UIImageAddational.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
//#import "tzim"

//#import "TZTestCell.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
//#import "UIView+Layout.h"
//#import "LxGridViewFlowLayout.h"
//#import "TZImageManager.h"
//#import "TZVideoPlayerController.h"

@interface  CameraEngine()<TZImagePickerControllerDelegate>

@end


@implementation CameraEngine
@synthesize fileName,filePath,imgDensity;
@synthesize delegate,imgsavepathtype;

-(id)init{
    if (self = [super init]) {
        imgDensity = 1.0;
        //		isPhoto = TRUE;
    }
    
    return self;
}


-(void)startCameraTakeVideo:(id)_par
{
    par = _par;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
        imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        
        //        self.picker = imagePickerController;
        //        [imagePickerController release];
        
        //		[_par presentModalViewController:imagePickerController animated:YES];
        [_par presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
    }
    else {
        NSString *mess = nil;
        mess = @"您的设备无法调用摄像头";
        [delegate CameraFailed:-1 Err:mess];
    }
}
-(void)startCameraTakePhoto:(id)_par;
{
    par = _par;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
        imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing=self.allowediting;
        imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        
        [_par presentViewController:imagePickerController animated:YES completion:^{
        }];
        
    }
    else {
        
        NSString *mess = nil;
        mess = @"您的设备无法调用摄像头";
        [delegate CameraFailed:-1 Err:mess];
        
    }
}

-(void)openPhotoAlbum:(id)_par editable:(BOOL)allowEdit
{
    
    par = _par;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
        imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage,nil];
        imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        imagePickerController.allowsEditing=allowEdit;
        
        [_par presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
        
        mediaoperation = OpenLibrary;
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [par dismissViewControllerAnimated:YES completion:nil];
    
    if ([delegate respondsToSelector:@selector(CameraCanceled)]) {
        [delegate CameraCanceled];
    }
}

- (void)imagePickerController:(UIImagePickerController *)apicker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (mediaoperation == TakePhoto) {
        if ([mediaType isEqualToString:@"public.image"]){
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            //对照品尺寸进行压缩
            UIImage *newImg = [UIImage imageRedraw:image];
            [self saveImgToAlbum:newImg];
            
            
            
            [par dismissViewControllerAnimated:YES completion:^{
                
                if ([delegate respondsToSelector:@selector(CameraDidTakePhotoFinished:)]) {
                    [delegate CameraDidTakePhotoFinished:newImg];
                }
                
                if ([delegate respondsToSelector:@selector(CameraDidDismissModal:)]) {
                    [delegate CameraDidDismissModal:image];
                }}];
        }
        
        
    }
    else if(mediaoperation==TakeVideo){
        if ([mediaType isEqualToString:@"public.movie"]){
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            if (url) {
                UISaveVideoAtPathToSavedPhotosAlbum([url path],nil, nil, nil);
            }
        }
    }
    else if(mediaoperation==OpenVideo){
        if ([mediaType isEqualToString:@"public.movie"]){
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            if (url) {
                if ([delegate respondsToSelector:@selector(CameraDidSelectedVideoFromAlbum:)]) {
                    [delegate CameraDidSelectedVideoFromAlbum:[url path]];
                }
            }
        }
    }
    else if (mediaoperation == OpenLibrary) {
        
        if ([mediaType isEqualToString:@"public.image"]){
            
            UIImage *image = nil;
            if(apicker.allowsEditing){
                image = [info objectForKey:UIImagePickerControllerEditedImage];
            }else{
                image = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            
            
            NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
            self.picAssetUrl=assetURL;
            
            UIImage *newImg = image;
            if(!_avoidCompressIMGQuailty){
                 //对照片尺寸进行压缩
                 newImg = [UIImage imageRedraw:image];
            }

            
            
            [par dismissViewControllerAnimated:YES completion:^{
                if ([delegate respondsToSelector:@selector(CameraDidChosePhotoFromAlbum:)]) {
                    [delegate CameraDidChosePhotoFromAlbum:newImg];
                }
                
            }];
        }
        
        
        
    }
    
    
    
}

-(void)handleError:(NSString*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error
                                                   delegate:nil cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
}

-(void)saveImgToAlbum:(UIImage *)img{
    //存到系统相册
    UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}



#pragma mark Error Check

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    
}

- (void)errorCheck:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    //	DLog(@"error = %@", [error localizedDescription]);
    /*
     NSString *informText;
     NSNumber *number = (NSNumber *)contextInfo;
     int index = [number intValue];
     
     if(error)
     informText = [error localizedDescription];
     else
     {
     informText = @"Finished!";
     }
     
     if (index >= [tempPictures count] - 1) {
     lblWatermark.text = @"bobgeen";
     [currentPickerController dismissModalViewControllerAnimated:NO];
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Inform"
     message:informText
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     }
     else {
     [self savePhotos:index+1];
     }
     */
    
    
}

#pragma mark get/show the UIView we want
//Find the view we want in camera structure.
-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}

-(void)addSomeElements:(UIViewController *)viewController
{
    UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
    
    UILabel*tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 200, 40)];
    tipLabel.text = @"测试标题";
    tipLabel.font = [UIFont boldSystemFontOfSize:18];
    tipLabel.textColor=[UIColor redColor];
    tipLabel.backgroundColor=[UIColor clearColor];
    
    [PLCameraView addSubview:tipLabel];
    
    
    //get bottom bar
    UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
    
    //Get bottom bar backgroud image
    UIImageView *bottomBarImageForCamera = [bottomBar.subviews objectAtIndex:1];
    
    //Set Bottom Bar backgroud Image
    UIImage *image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"crystalbar.png"]];
    bottomBarImageForCamera.image=image;
    
    UIButton *cancelButton=[bottomBarImageForCamera.subviews objectAtIndex:1];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    CGRect setFrame = cancelButton.frame;
    setFrame.origin.x = bottomBarImageForCamera.frame.size.width - (cancelButton.frame.size.width + cancelButton.frame.origin.x);
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    setBtn.frame = setFrame;
    [bottomBarImageForCamera addSubview:setBtn];
    [setBtn addTarget:self action:@selector(cameraSet) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect takephotoBtnrect=[[bottomBarImageForCamera.subviews objectAtIndex:0] frame];
    UIButton *takephotoBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [takephotoBtn setFrame:takephotoBtnrect];
    [takephotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [bottomBarImageForCamera addSubview:takephotoBtn];
    [takephotoBtn addTarget:self action:@selector(takePhoto) forControlEvents:
     UIControlEventTouchUpInside];
    takephotoBtn.frame=takephotoBtnrect;
    
    //确认界面
    UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];
    //	NSArray *arr = bottomBarImageForSave.
    UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];
    [retakeButton setTitle:@"重拍" forState:UIControlStateNormal];
    
    UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];
    [useButton setTitle:@"保存" forState:UIControlStateNormal];
    
    //    DLog(@"bottomBar.subviews count=%d",[bottomBar.subviews count]);
}

#pragma mark -
#pragma mark UINavigationControllerDelegate
/*
 - (void)navigationController:(UINavigationController *)navigationController
 willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
	Class cl = [viewController class];
	NSString *desc = [cl description];
	
	if ([desc isEqualToString:@"PLUICameraViewController"]) {
 [self addSomeElements:viewController];
	}
 }
 */

-(void)cameraSet{
    //    DLog(@"cameraSet");
}

-(void)takePhoto{
    //    DLog(@"iii");
    //    [self.picker takePicture];
}

+(BOOL)cameraAvailabled{
    
    NSString *mediaType = AVMediaTypeVideo;
    
    NSBundle*bundle =[NSBundle mainBundle];
    NSDictionary*info =[bundle infoDictionary];
    NSString*prodName =[info objectForKey:@"CFBundleDisplayName"];
    
    
    //检查相册是否可用
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusDenied) {
        
        NSString *msg = [NSString stringWithFormat:@"请前往系统设置->隐私->相机，开启%@权限", prodName];
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return NO;
    }
    
    
    //检查相册是否可用
    ALAuthorizationStatus  al_authStatus = [ALAssetsLibrary authorizationStatus];
    if (al_authStatus == ALAuthorizationStatusDenied) {
        
        NSString *msg = [NSString stringWithFormat:@"请前往系统设置->隐私->相片，开启%@权限", prodName];
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return NO;
        
    }
    
    
    return YES;
}

-(void)presentTZImagePicker:(BOOL)captureIDCard type:(NSInteger)cardtype{
    
    TZImagePickerController *imagePickerVc = nil;
    if (captureIDCard) {
        imagePickerVc =
        [[TZImagePickerController alloc] initWithMaxImagesCountCaptureCard:1 delegate:self cardType:cardtype];
    }else{
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    }

    imagePickerVc.photoWidth = 420;
    //拍摄身份证模式
    imagePickerVc.captureIDCardModel =captureIDCard;
    imagePickerVc.cardType = cardtype;
    
    // set appearance / 改变相册选择页的导航栏外观
    imagePickerVc.navigationBar.barTintColor = ZCOLOR(COLOR_NAV_BG_RED);
    imagePickerVc.navigationBar.tintColor = ZCOLOR(COLOR_NAV_BG_RED);
    UIBarButtonItem *tzBarItem, *BarItem;
    if (iOS9Later) {
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
    } else {
        tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
        BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
    }
    NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
    [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
//    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    //    imagePickerVc.navigationBar.barTintColor = [UIColor blueColor];
    //    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    //    imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    //    for (UIView *view in imagePickerVc.parentViewController.navigationItem .titleView.subviews)
    //    {
    //        if(view)
    //        {
    //            [view removeFromSuperview];
    //        }
    //    }
    //    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,90)];
    //    [titleView setBackgroundColor:[UIColor clearColor]];
    //    imagePickerVc.navigationItem.titleView = titleView;
    
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [ZAPP.window.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    if([self.delegate respondsToSelector:@selector(CameraDidChoseMultiplePhotosFromAlbum:)]){
        [self.delegate CameraDidChoseMultiplePhotosFromAlbum:photos];
    }
    
    
}

+(UIImage*)cropCapRegionIDCard:(UIImage *)oriimgae{
    
    
    CGSize imgSize = oriimgae.size;
    
    //iphone6为标准的尺寸
    CGFloat v = imgSize.width/375;
 
    
    UIImage *cropImage = [oriimgae imageFromCropRect:!ScreenInch4s?
                          CGRectMake(10*v, 210*v, (MainScreenWidth - 10*v*2)*v, 230*v):
                          CGRectMake(6*v, 120*v, (MainScreenWidth - 6*v*2)*v, 210*v)
                          ];
    
    UIImageWriteToSavedPhotosAlbum(cropImage, nil, nil, nil); //将截图存入相册

    
    
    return cropImage;
}


@end
