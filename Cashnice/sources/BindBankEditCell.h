//
//  BindBankEditCell.h
//  Cashnice
//
//  Created by a on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BindBankEditChanged <NSObject>

@required
- (void)textFiledValueChanged:(id)sender;

@end

@interface BindBankEditCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) id<BindBankEditChanged> delegate;

- (void)setTitle:(NSString *)title andPlaceholder:(NSString *)placeholder;
- (IBAction)textFiledValueChanged:(id)sender;

@end
