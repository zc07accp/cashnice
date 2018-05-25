//
//  FabuJiekuanTableViewCell.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BindValidcodeCellDelegate<NSObject>

@required
- (void)sendPressed;

@optional
- (void)uploadIdCardPressed;

@end
/**
 *  发送验证码的cell
 */
@interface BindValidcodeCell : UITableViewCell


@property(strong, nonatomic) id<BindValidcodeCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *txtImg;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) IBOutlet UIButton *validButton;
@property (weak, nonatomic) IBOutlet UILabel *validLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

- (void)setUploadImageStyle;
@end
