//
//  MightKnownTableViewCell.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BankCellDelegate<NSObject>

@required
- (void)buttonClickedrow:(NSInteger)rowIndex;

@end

@interface BankCell : UITableViewCell
@property(strong, nonatomic) id<BankCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *backupLabel;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelArray;

@end
