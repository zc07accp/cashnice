//
//  WIOU_SetMoneyCell.h
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"
#import "CNTitleDetailArrowCell.h"

@interface WIOU_SetMoneyCell : CNTitleDetailArrowCell<UITextFieldDelegate>

@property IBOutlet UITextField *textField;
@property (strong,nonatomic) void (^InputText) (NSString* text);

@end
