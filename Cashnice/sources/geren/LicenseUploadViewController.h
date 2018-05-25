//
//  IDCardUploadViewController.h
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@protocol LicenseUploadDelegate<NSObject>
-(void)LicenseUploaded;
@end

@interface LicenseUploadViewController : CustomViewController

@property (weak, nonatomic) id<LicenseUploadDelegate> delegate;

@property (assign, nonatomic) NSUInteger authStatus;

@end
