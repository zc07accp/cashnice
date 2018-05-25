//
//  IDUploadAddPhotoCell.h
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDUploadAddPhotoCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UIView *sucUploadView1;
@property (weak, nonatomic) IBOutlet UIView *sucUploadView2;


@property (weak, nonatomic) IBOutlet UIView *unUploadView1;
@property (weak, nonatomic) IBOutlet UIView *unUploadView2;

@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;

- (IBAction)uploadCardAction1:(id)sender;
- (IBAction)uploadCardAction2:(id)sender;

@property(strong,nonatomic)void (^tapSelPhoto1)();
@property(strong,nonatomic)void (^tapSelPhoto2)();

@property(nonatomic) BOOL hasDetectCard1Succ;
@property(nonatomic) BOOL hasDetectCard2Succ;

@end
