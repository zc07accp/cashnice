//
//  MightKnownTableViewCell.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShouxinCellDelegate<NSObject>

@required
- (void)buttonClicked:(NSInteger)buttonIndex row:(NSInteger)rowIndex targetNum:(int)num;

@end

@interface ShouxinCell : UITableViewCell
@property(strong, nonatomic) id<ShouxinCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) IBOutlet HeadImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelArray;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_w;


@property (assign, nonatomic) int targetNum;
@end
