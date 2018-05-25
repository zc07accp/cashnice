//
//  CertificatePreviewViewController.h
//  Cashnice
//
//  Created by a on 16/8/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "MyIouTableViewController.h"
#import "CertificateView.h"

@class IOUDetailUnit;

@interface CertificatePreviewViewController : CustomViewController

@property (nonatomic, strong) IOUDetailUnit *detailUnit;

@property(nonatomic,readonly) NSArray *finishedImageArr;

// 是否为借款人
@property (nonatomic) BOOL isDebter;
// 是否添加照片
@property (nonatomic) BOOL userPerationEnabled;

@property (nonatomic) BOOL certificateOnly;

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, strong) NSString* specialTitle;

@property (nonatomic, weak) id<CertificateViewDelegate> certificateViewDelegate;

@end
