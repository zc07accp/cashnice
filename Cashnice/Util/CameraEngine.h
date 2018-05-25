//
//  CameraMain.h
//  NavTab
//
//  Created by zeng on 12-3-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "CameraEngineDelegate.h"

typedef enum{
	TakePhoto,
	TakeVideo,
	OpenLibrary,
    OpenVideo

}MediaOperation;

typedef enum{
    FileDontSave,                //拍照结束后，照片不保存
    FileSaveSystemPhotoLibrary,  //拍照结束后，照片保存到系统相册
    FileSaveCustomisePath        //拍照结束后，照片保存到自定义位置
}ImgFileSavedPathType;

 
@interface CameraEngine : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	
	NSString * fileName;
	NSString * filePath;
	
	/*
	 0.0 - 1.0
	 */
	float imgDensity;	
	id par;
	MediaOperation mediaoperation;
}
//@property(strong,nonatomic)UIImagePickerController *picker;
@property(strong, nonatomic) NSString *fileName;
@property(strong, nonatomic) NSString *filePath;
@property float imgDensity;
@property BOOL allowediting;
@property(assign, nonatomic) id<CameraEngineDelegate>delegate;
@property (nonatomic) BOOL avoidCompressIMGQuailty; //是否避免图片质量，默认为no
@property ImgFileSavedPathType imgsavepathtype;
@property (strong,nonatomic)NSURL *picAssetUrl;
/*
 把父类viewcontroller的指针传递归来
  */
-(void)startCameraTakePhoto:(id)_par;
-(void)startCameraTakeVideo:(id)_par;

-(void)openPhotoAlbum:(id)_par editable:(BOOL)allowEdi;
-(void)saveImgToAlbum:(UIImage *)img; //把照片保存到本地

+(BOOL)cameraAvailabled;


/**
 开启tz相机模式

 @param captureIDCard 是否拍摄身份证
 @param cardtype 如果选择身份证，正反面 0正  1反
 */
-(void)presentTZImagePicker:(BOOL)captureIDCard type:(NSInteger)cardtype;


+(UIImage*)cropCapRegionIDCard:(UIImage *)oriimgae;

@end


 

