//
//  HaoyouRecordTableViewCell.h
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  used in QuerenHuanxi
 */
@interface HuanxiCell2 : UITableViewCell <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lixiLabel;
@end
