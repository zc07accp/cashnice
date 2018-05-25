//
//  JiekuanTableViewCell.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Jiekuan2CellDelegate<NSObject>

@required
- (void)detailPressed:(int)rowIndex;
- (void)namePressed:(int)rowIndex;

@end

@interface Jiekuan2Cell : UITableViewCell {
    LoanState _state;
}

@property(strong, nonatomic) id<Jiekuan2CellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *biaoti;

@property (weak, nonatomic) IBOutlet UIView *statebgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ligthGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *gray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *red;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *hiddenViews;
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

@property (weak, nonatomic) IBOutlet UIButton *kefuButton;
@property (weak, nonatomic) IBOutlet UIButton *dingdanButton;
@property (weak, nonatomic) IBOutlet UILabel *shihuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *huankuanShijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *yinghuanLixiLabel;
@property (weak, nonatomic) IBOutlet UILabel *huankuanQixian;
@property (weak, nonatomic) IBOutlet UILabel *yinghuanBenjin;
@property (weak, nonatomic) IBOutlet UILabel *huankuanState;
@property (weak, nonatomic) IBOutlet UILabel *zhifushijian;
@property (weak, nonatomic) IBOutlet UILabel *shifubenjin;
@property (weak, nonatomic) IBOutlet UILabel *touzizhuangtai;
- (void)setJiekuanState:(LoanState)state;
@property (weak, nonatomic) IBOutlet UILabel *yujishouyi;
@property (weak, nonatomic) IBOutlet UILabel *dingdanhao;
@property (weak, nonatomic) IBOutlet UILabel *jiekuanren;

@property (weak, nonatomic) IBOutlet UIButton *nameButton;
- (void)setNameButtonDisabled:(BOOL)dis;
- (void)setDingdanButtonDisabled:(BOOL)dis;

@property (nonatomic, assign) int rowIndex;
- (void)setChoukuanQi:(BOOL)dis;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *choukuanqi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choukuanheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_w;
@end
