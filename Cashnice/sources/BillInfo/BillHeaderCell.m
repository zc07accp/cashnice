//
//  BillHeaderCell.m
//  Cashnice
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillHeaderCell.h"

@implementation BillHeaderCell{
    NSDateFormatter *_dateFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _startTextField) {
        if(self.delegate){
        [self.delegate didSelTextField:YES date:[self getDateFromString:_startTextField.text]];
        }
//         [self openDatePicker:[Util dateMDByString:_startTextField.text]];
    }else{
        if(self.delegate){
        [self.delegate didSelTextField:NO date:[self getDateFromString:_endTextField.text]];
        }
//         [self openDatePicker:[Util dateMDByString:_endTextField.text]];
    }
    return NO;
}
-(NSDate *)getDateFromString:(NSString *)str{
   return [[self dateFormatter] dateFromString:str];
}

- (NSDateFormatter *)dateFormatter{
    if (! _dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    return _dateFormatter;
}



- (IBAction)search:(id)sender {
    if(self.delegate){
        [self.delegate didBeginSearch];
    }

}
@end
