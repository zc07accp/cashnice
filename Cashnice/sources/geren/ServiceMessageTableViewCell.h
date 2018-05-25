//
//  ServiceMessageTableViewCell.h
//  YQS
//
//  Created by a on 16/1/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingTableViewCell.h"



@interface ServiceMessageTableViewCell : EditingTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rowRight;
@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;

@property (weak, nonatomic) IBOutlet UILabel *goDetailTagLabel;
//@property (weak, nonatomic) IBOutlet UIButton*goDetail;


@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (strong, nonatomic) void (^TapDetail)(void);

- (IBAction)tapDetail:(id)sender;

+ (CGFloat)cellHeightOfContentText: (NSString *)contextText isSys:(BOOL)isSys;

@property (nonatomic) BOOL shouldShowGoDetailLabel;

@end
