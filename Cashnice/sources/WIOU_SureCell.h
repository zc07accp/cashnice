//
//  WIOU_SureCell.h
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"



@interface WIOU_SureCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (strong,nonatomic) void (^SelAgree) (BOOL agree);
@property (strong,nonatomic) void (^SeeAgree) ();
@property (strong,nonatomic) void (^WIOU_Sure) ();

-(void)configureSelAgree:(BOOL)agree fee:(CGFloat)fee;

@end
