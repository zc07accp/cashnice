//
//  JiekuanDetailViewController.h
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 
#import "NextButtonViewController.h"
#import "TTTAttributedLabel.h"

@protocol QuerenShouxinDelegate<NSObject>

@required
- (void)shouxinOkdone;

@end


@interface QuerenShouxin: CustomViewController < NextButtonDelegate, TTTAttributedLabelDelegate >
@property(strong, nonatomic) id<QuerenShouxinDelegate> delegate;
@property (nonatomic, assign) BOOL allowFive;

@property (nonatomic, strong) NSString *uid;

@end
