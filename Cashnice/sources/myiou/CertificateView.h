//
//  CertificateView.h
//  Cashnice
//
//  Created by a on 16/7/30.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CertificateView;

@protocol CertificateViewDelegate <NSObject>
@optional
- (void)certificateView:(CertificateView *)certificateView didFinishPickingPhotos:(NSArray<UIImage *> *)photos;
- (void)certificatePickerDidCancel:(CertificateView *)certificateView;
@end



@interface CertificateView : UICollectionView

//当前选择的图片
@property (nonatomic, strong, readonly) NSArray<UIImage *> *certificates;
//最大可选择图片数，默认2
@property (nonatomic, assign) NSUInteger maxImagesCount;
//是否可选择图片操作
@property (nonatomic) BOOL userPerationEnabled;
//自适应高度
@property (nonatomic, readonly) CGFloat optimumHeight;

@property (nonatomic, weak) id<CertificateViewDelegate> certificateDelegate;

- (instancetype)initWithTargetViewController:(UIViewController *)target;
- (id)initWithFrame:(CGRect)frame targetViewController:(UIViewController *)target;

- (void)addPreviewImageURLs:(NSArray *)urls;
@end
