//
//  JiekuanDetailViewController.h
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
#import "NextButtonViewController.h"
#import "NextButton2.h"
#import "QuerenHuanxi.h"

@protocol JiekuanDetailViewControllerDelegate<NSObject>

@optional
- (void)changeTabToGeren;

- (void)huanRowDone:(int)rowHere;

@end


@interface JiekuanDetailViewController : CustomViewController <UITableViewDataSource, UITableViewDelegate, NextButtonDelegate, NextButton2Delegate, UIAlertViewDelegate, QuerenHuanXiDelegate>
@property(strong, nonatomic) id<JiekuanDetailViewControllerDelegate> delegate;

@property (strong, nonatomic) NSDictionary *dataDict;
@property (nonatomic, assign) BOOL enterFromPreview;
@property (nonatomic, assign) int opRowHuankuan;

//deprecated
@property (nonatomic, assign) BOOL hideNameAlways;//从我授信的借款进入，隐藏借款人名称；此值直接set到JiekuanInfo中并生效

@end
