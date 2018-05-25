//
//  IDUploadBtnCell.h
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDUploadBtnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic) BOOL available;

@property(strong,nonatomic)void (^uploadIDCardAction)();


@end
