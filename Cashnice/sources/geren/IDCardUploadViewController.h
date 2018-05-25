//
//  IDCardUploadViewController.h
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@protocol IDCardUploadDelegate<NSObject>
-(void)IDCardCertifiedUploaded:(NSString *)name cardNumber:(NSString *)cardNumber;
@end

@interface IDCardUploadViewController : CustomViewController
@property (weak, nonatomic) id<IDCardUploadDelegate> delegate;
@end
