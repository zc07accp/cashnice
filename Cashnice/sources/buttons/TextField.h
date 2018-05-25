//
//  TextField.h
//  YQS
//
//  Created by l on 3/31/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"

@interface TextField : CustomViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIView *sepLine;

@end
