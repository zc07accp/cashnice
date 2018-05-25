//
//  CameraEngineDelegate.h
//  NavTab
//
//  Created by  on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraEngineDelegate <NSObject>
-(void)CameraFailed:(int)_code Err:(NSString *)errormsg;
@optional
-(void)CameraCanceled;
-(void)CameraDidTakePhotoFinished:(UIImage *)_img;

-(void)CameraDidTakeVideoFinished:(NSString *)_videopath;
-(void)CameraDidChosePhotoFromAlbum:(UIImage *)_img;
-(void)CameraDidSelectedVideoFromAlbum:(NSString *)_videopath;
-(void)CameraDidDismissModal:(UIImage *)img;

-(void)CameraDidChoseMultiplePhotosFromAlbum:(NSArray *)_imgs;

@end
