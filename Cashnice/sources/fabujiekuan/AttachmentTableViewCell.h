//
//  GeRenTableViewCell.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttachmentCellDelegate<NSObject>

@required
- (void)delePressed:(int)idx;

@end


@interface AttachmentTableViewCell : UITableViewCell
@property(strong, nonatomic) id<AttachmentCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *biaoti;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
