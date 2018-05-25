//
//  HaoyouRecordHeaderTableViewCell.h
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HaoyouRecordHeaderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@end
