//
//  WIOU_SetMoneyCell.m
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "WIOU_SetMoneyCell.h"
#import "IOU.h"


@implementation WIOU_SetMoneyCell
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField.text.length>0) {
//        self.textField.text = [Util UndoRMB:textField.text];
//    }
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

     if(self.InputText){
        self.InputText(textField.text);
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (range.location>9) {
        return NO;
    }

    if ([string length]) {
        
        NSString* regex = @"^[0-9]\\d*$";
        NSPredicate* pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [pre evaluateWithObject:string];
        
    }
    
    return YES;
}


@end
