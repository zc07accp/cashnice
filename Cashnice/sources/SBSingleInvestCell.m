//
//  SBSingleInvestCell.m
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "SBSingleInvestCell.h"

@implementation SBSingleInvestCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = CN_TEXT_GRAY;
    
    if(ScreenWidth320){
        _textfield1.font = [UtilFont systemSmall];
        _textfield2.font = [UtilFont systemSmall];

    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.SingleInvestInputTextEditBegin) {
        self.SingleInvestInputTextEditBegin();
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
//    if (self.SingleInvestInputTextEditDone) {
//        self.SingleInvestInputTextEditDone(_textfield1.text, _textfield2.text);
//    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制输入的内容0-9
    if ([string length]) {
        
        NSString* regex = @"^[0-9]\\d*$";
        NSPredicate* pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

        if(![pre evaluateWithObject:string]){
            return NO;
        }
    }
    
    if (self.SingleInvestInputChanged) {
        
        NSString *rplaceStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (textField == _textfield1){
            self.SingleInvestInputChanged(rplaceStr, _textfield2.text);
        }else{
            self.SingleInvestInputChanged(_textfield1.text, rplaceStr);
        }
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (IBAction)finishEdit:(id)sender {
    
    [sender endEditing:YES];
    
}

-(void)configureField1Placeholder:(NSString *)ph1 field2:(NSString *)ph2{
    _textfield1.placeholder = ph1;
    _textfield2.placeholder = ph2;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.left = SEPERATOR_LINELEFT_OFFSET;
}


@end
