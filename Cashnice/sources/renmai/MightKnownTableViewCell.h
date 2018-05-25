//
//  MightKnownTableViewCell.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MightKnownTableViewCellDelegate <NSObject>

- (void)mutualFriendListAction:(NSInteger)indexRow;

@end

@interface MightKnownTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) IBOutlet HeadImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *sepLine;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;
@property (weak, nonatomic) IBOutlet UILabel *friNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commPromptLabel;


@property (weak, nonatomic) IBOutlet UIView *commView;
@property (weak, nonatomic) IBOutlet UIView *sepView;

@property (weak, nonatomic) id<MightKnownTableViewCellDelegate> delegate;

@end
