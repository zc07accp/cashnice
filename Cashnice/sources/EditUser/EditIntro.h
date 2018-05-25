//
//  NewBorrowViewController.h
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 
#import "NextButtonViewController.h"

@protocol EditIntroDelegate<NSObject>

@required
- (void)setIntroString:(NSString *)intro;

@end


@interface EditIntro : CustomViewController <  NextButtonDelegate, UITextViewDelegate>
@property(strong, nonatomic) id<EditIntroDelegate> delegate;

@end
