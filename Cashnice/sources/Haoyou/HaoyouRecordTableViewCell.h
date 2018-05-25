//
//  HaoyouRecordTableViewCell.h
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YaoqingJiluCellDelegate<NSObject>

@required
- (void)souyaopressed:(int)rowindex;

@end


@interface HaoyouRecordTableViewCell : UITableViewCell <UIAlertViewDelegate>
@property(strong, nonatomic) id<YaoqingJiluCellDelegate> delegate;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouxinLabel;
@property (weak, nonatomic) IBOutlet UIButton *suoyaoButton;
@end
