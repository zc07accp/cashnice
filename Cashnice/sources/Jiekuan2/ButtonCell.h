//
//  JiekuanTableViewCell.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonCellDelegate<NSObject>

@required
- (void)buttonPressedFromCell;

@end
/**
 *  used in QuerenHuanxi
 */
@interface ButtonCell : UITableViewCell
@property(strong, nonatomic) id<ButtonCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *button;


@end
