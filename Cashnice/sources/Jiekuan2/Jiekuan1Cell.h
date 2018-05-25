//
//  JiekuanTableViewCell.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Jiekuan1Cell : UITableViewCell {
    LoanState _state;
}

@property (weak, nonatomic) IBOutlet UILabel *biaoti;

@property (weak, nonatomic) IBOutlet UIView *statebgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ligthGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *gray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *red;
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

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *changhuan;
@property (weak, nonatomic) IBOutlet UILabel *yihuanqing;




@end
