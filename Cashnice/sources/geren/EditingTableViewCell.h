//
//  EditingTableViewCell.h
//  YQS
//
//  Created by a on 16/1/29.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EditingTableViewCell;

@protocol EditingTableViewCellDelegate

@optional

@property (nonatomic, readonly, getter=isPseudoEditing) BOOL pseudoEdit;
- (void)selectCell:(EditingTableViewCell *)cell;

@end

@interface EditingTableViewCell : UITableViewCell

- (void)configureCell:(NSDictionary *)infoDictionary;
@property (nonatomic, assign) id <EditingTableViewCellDelegate> delegate;

@end
