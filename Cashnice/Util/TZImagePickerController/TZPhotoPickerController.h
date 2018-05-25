//
//  TZPhotoPickerController.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@class TZAlbumModel;
@interface TZPhotoPickerController : CustomViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, strong) TZAlbumModel *model;

@property (nonatomic, copy) void (^backButtonClickHandle)(TZAlbumModel *model);

@property(nonatomic, assign) BOOL captureIDCardModel;
@property(nonatomic, assign) NSInteger cardType;
- (void)showAlbumAction;


@end
