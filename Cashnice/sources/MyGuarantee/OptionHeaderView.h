//
//  OptionHeaderView.h
//  YQS
//
//  Created by a on 16/5/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>


@class OptionHeaderView;

@protocol OptionHeaderViewDelegate <NSObject>

- (void)optionHeaderDidTouched:(OptionHeaderView *)optionHeaderView active:(BOOL)active;

@end

@interface OptionHeaderView : UIView

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImageView *promotImage;
@property (nonatomic, weak) id<OptionHeaderViewDelegate> delegate;

@end
