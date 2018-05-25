//
//  GYBankCardFormatTextField.h
//  GYBankCardFormat
//
//  Created by Gary on 14-5-29.
//  Copyright (c) 2014年 蒲晓涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GYTextFieldForametTypeBankCard,
    GYTextFieldForametTypePhoneNumber,
} GYTextFieldForametType;

@interface GYBankCardFormatTextFieldDelate : NSObject <UITextFieldDelegate>

- (id)initWithTextField:(UITextField *)textField;
- (id)initWithTextField:(UITextField *)textField andTextFieldForametType:(GYTextFieldForametType) formatType;

@end
