//
//  JiekuanTableViewCell.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JiekuanTableViewCellDelegate<NSObject>

@required
- (void)nameButtonPressedWithIndex:(int)rowIndexHere;

@optional
- (void)huanKuanPressed:(int)rowIndexHere;
- (void)repayPressed:(int)rowIndexHere;
- (void)touziPressed:(int)rowIndexHere;
- (void)refabuPressed:(int)rowIndexHere;

@end


@interface JiekuanTableViewCell : UITableViewCell {
    LoanState _state;
}

@property (weak, nonatomic) IBOutlet UIButton *touziButton;
@property(strong, nonatomic) id<JiekuanTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *biaoti;

@property (weak, nonatomic) IBOutlet UIView *statebgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ligthGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *gray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *red;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *choukuanqi;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *deadline;
@property (weak, nonatomic) IBOutlet UILabel *t1;
@property (weak, nonatomic) IBOutlet UILabel *t2;
@property (weak, nonatomic) IBOutlet UILabel *t3;
@property (weak, nonatomic) IBOutlet UILabel *remainDays;
@property (weak, nonatomic) IBOutlet UILabel *lixi;
@property (weak, nonatomic) IBOutlet UILabel *totalamount;
@property (weak, nonatomic) IBOutlet UILabel *percent;
@property (weak, nonatomic) IBOutlet UILabel *authpeople;
@property (weak, nonatomic) IBOutlet UILabel *returnday;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choukuanheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceHeight;
@property (weak, nonatomic) IBOutlet UILabel *desc1;
@property (weak, nonatomic) IBOutlet UILabel *desc2;
@property (weak, nonatomic) IBOutlet UILabel *jiekuanren;

@property (weak, nonatomic) IBOutlet UILabel *lll1;
@property (weak, nonatomic) IBOutlet UILabel *lll2;
@property (weak, nonatomic) IBOutlet UILabel *lll3;
@property (weak, nonatomic) IBOutlet UILabel *lll4;
@property (weak, nonatomic) IBOutlet UILabel *lll5;
@property (weak, nonatomic) IBOutlet UILabel *lll6;
@property (weak, nonatomic) IBOutlet UILabel *lll7;
@property (weak, nonatomic) IBOutlet UIButton *huanKuanButton;
@property (weak, nonatomic) IBOutlet UIView *reFabu;
@property (weak, nonatomic) IBOutlet UIButton *reFabuButton;
@property (weak, nonatomic) IBOutlet UIView *repayButtonBg;
@property (weak, nonatomic) IBOutlet UIButton *repayButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_button_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_desc2_height;
@property (weak, nonatomic) IBOutlet UILabel *desc_my_loan;
@property (weak, nonatomic) IBOutlet UIView *lefttitlelabelsview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_content_w;


- (void)setJiekuanState:(LoanState)state;
//- (void)setNameButtonDisabled:(BOOL)dis;
- (void)setChoukuanQi:(BOOL)dis;
- (void)setDesc2Disabled:(BOOL)dis;
- (void)setRepaybuttonDisabled:(BOOL)dis;
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
