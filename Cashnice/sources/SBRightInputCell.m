//
//  SBRightInputCell.m
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "SBRightInputCell.h"

@implementation SBRightInputCell

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
    
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo();
    }];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

-(void)setAccText:(NSString *)accText{
    self.accLabel.text = accText;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
//    if(self.InputText){
//        self.InputText(textField.text);
//    }
//    
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string length]) {
        
        NSString* regex = @"^[0-9]\\d*$";
        NSPredicate* pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if(![pre evaluateWithObject:string]){
            return NO;
        }
        
    }
    
    if (self.InputTextChanged) {
        
        NSString *rplaceStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
 
        self.InputTextChanged(rplaceStr);
     }

    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
 

- (IBAction)finishEdit:(id)sender {
    
    [sender endEditing:YES];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.left = SEPERATOR_LINELEFT_OFFSET;
}

@end
