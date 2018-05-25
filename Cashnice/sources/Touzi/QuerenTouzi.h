//
//  JiekuanDetailViewController.h
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 
#import "NextButtonViewController.h"

@protocol QuerenTouziDelegate<NSObject>

@required
- (void)touziOkDone;

@end




@interface QuerenTouzi : CustomViewController < NextButtonDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property(strong, nonatomic) id<QuerenTouziDelegate> delegate;

- (void)setTheDataDict:(NSDictionary *)dict;

@property (nonatomic, strong) NSString *betid;
@property (nonatomic, assign) BOOL fromTouzi;
@end
