//
//  IOUDetailBtnCell.h
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"
#import "CNBlueBtn.h"

@interface IOUDetailBtnCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet CNBlueBtn *sureBtn;
@property (strong,nonatomic) void (^ButtonAction) (UIButton *btn);

-(void)configureTitle:(NSString *)title;

@end
