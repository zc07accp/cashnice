//
//  BillHeaderCell.h
//  Cashnice
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BillHeaderCellDelegate<NSObject>

-(void)didSelTextField:(BOOL)selStartDateField date:(NSDate *)date;
-(void)didBeginSearch;

@end

@interface BillHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *accumulatedLabel;

@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@property (weak, nonatomic) id<BillHeaderCellDelegate> delegate;

- (IBAction)search:(id)sender;

@end
