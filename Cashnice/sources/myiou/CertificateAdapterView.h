//
//  CertificateAdapterView.h
//  Cashnice
//
//  Created by a on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertificateView.h"

@interface CertificateAdapterView : UIView


@property (nonatomic, weak)                 UIViewController *target;
@property (nonatomic, strong)               NSString *title;
@property (nonatomic, strong, readonly)     CertificateView *contentView;


//当前选择的图片
@property (nonatomic, strong, readonly) NSArray<UIImage *> *certificates;
@property (nonatomic, assign) NSUInteger maxImagesCount;
@property (nonatomic) BOOL userPerationEnabled;

@property (nonatomic, weak) id<CertificateViewDelegate> certificateViewDelegate;

- (void)addPreviewImageURLs:(NSArray *)urls;

@end
