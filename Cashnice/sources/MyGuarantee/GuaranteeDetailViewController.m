//
//  InvestmentFPDetailViewController.m
//  YQS
//
//  Created by a on 16/5/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuaranteeDetailViewController.h"
#import "AllShouxinPeople.h"
#import "DetailItemView.h"
#import "RepaymentViewController.h"

#import "LoanProgressView.h"

@interface GuaranteeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *detailContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailContentViewHeight;

@property (weak, nonatomic) IBOutlet UIView *detailDatetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailDatetViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *mainValPromtLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainValLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *guarantorPrmpt;
@property (weak, nonatomic) IBOutlet UILabel *guarantorCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *investerPrompt;
@property (weak, nonatomic) IBOutlet UILabel *investerCntLabel;

@property (weak, nonatomic) IBOutlet UIButton *repayActionButton;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet LoanProgressView *loanProgressView;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *guaranteeTotalYuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeTotalCntLabel;

@end

static const NSUInteger kLargeFontSize = 22;

@implementation GuaranteeDetailViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    //[self connectToServer];
    if (self.loanInfoDict) {
        [self refreshViewData];
    }
}

- (void)setupView {
    self.view.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    self.detailContentView.backgroundColor = [UIColor clearColor];
    self.detailDatetView.backgroundColor = [UIColor clearColor];
    self.repayActionButton.hidden = YES;
    
    self.repayActionButton.titleLabel.font = CNFont_32px;
    
    [self setNavButton];
    
    self.rateLabel.font =
    self.mainValLabel.font =
    self.guaranteeTotalCntLabel.font =
    [UtilFont systemNormal:kLargeFontSize];
    
    self.investerPrompt.font =
    self.investerCntLabel.font =
    self.amountLabel.font =
    self.guarantorPrmpt.font =
    self.guarantorCntLabel.font =
    self.mainValPromtLabel.font =
    self.guaranteeTotalLabel.font =
    self.ratePromptLabel.font =
    self.precentLabel.font =
    self.guaranteeTotalYuanLabel.font =
    [UtilFont systemLargeNormal];
}


- (void)connectToServer {
    bugeili_net
    progress_show
    
    WS(ws);

    
    [ZAPP.netEngine getLoanDetailWithLoanID:[NSString stringWithFormat:@"%ld", (long)self.loanid] complete:^{
        progress_hide
        ws.loanInfoDict = ZAPP.myuser.loanDetailDict;
        [ws refreshViewData];
    } error:^{
        progress_hide
    }];
}

- (IBAction)repayAction:(id)sender{
    RepaymentViewController *vc = ZLOAN(@"RepaymentViewController");
    vc.dataDict = self.loanInfoDict;
    vc.repaymentType = RepaymentViewTypeGuarantee;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshViewData {
    self.title =  self.loanInfoDict[@"loantitle"];
    
    //借款总额
    NSInteger mainVal = [self.loanInfoDict[@"loanmainval"] integerValue];
    CGFloat wan = mainVal ;
    self.mainValLabel.text = [Util formatRMBWithoutUnit:@(wan)];
    
    //年转化率
    double loanrate = [self.loanInfoDict[@"loanrate"] doubleValue];
    self.rateLabel.text = [NSString stringWithFormat:@"%@", [Util formatFloat:@(loanrate)]];
    
    //担保人数
    NSInteger guarantorCount = [self.loanInfoDict[@"warrantycount"] integerValue];
    self.guarantorCntLabel.text = [NSString stringWithFormat:@"%ld", (long)guarantorCount];
    
    //投资人数
    NSInteger investerCount = [self.loanInfoDict[@"betcount"] integerValue];
    self.investerCntLabel.text = [NSString stringWithFormat:@"%ld", (long)investerCount];
    //担保总额
    CGFloat warrantyval = [self.loanInfoDict[@"warrantyval"] doubleValue];
    self.guaranteeTotalCntLabel.text = [Util formatRMBWithoutUnit:@(warrantyval)];
    

    [self setDetailItemView];
    [self setDetailDateView];
    [self setupProgress];
    
    [self.view setNeedsLayout];
}

- (void)setDetailDateView {
    
    NSInteger loanstatus = [self.loanInfoDict[@"loanstatus"] integerValue];
    
    NSInteger itemsViewTag = 1110;
    UIView *view = [self.detailDatetView viewWithTag:itemsViewTag];
    if (view) {
        [view removeFromSuperview];
    }
    
    DetailItemView *items = [DetailItemView new];
    items.tag = itemsViewTag;
    
    if (0 == loanstatus) {
        //审核中的借款  不显示
        UIView *dataView = self.detailDatetView.superview;
        [self.detailDatetView.superview addConstraint:[NSLayoutConstraint constraintWithItem:dataView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f] ];
        dataView.hidden = YES;
        return;
    }else if(7 == loanstatus || loanstatus == 1) {
        //退款中||筹款中
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"筹款截止", @"发布日期"]];
    }else if(3 == loanstatus){
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"发布日期", @"还款日期历史"]];
    }else{
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"发布日期", @"还款日期"]];
    }
    [items setUpView];
    
    items.top = 0;      items.left = 0;
    self.detailDatetViewHeight.constant = items.height;
    
    [self.detailDatetView addSubview:items];
}

- (void)setDetailItemView {
    
     //不再显示投资按钮  改为还担保金
    /*
     NSInteger loanState = [self.loanInfoDict[@"loanstatus"] integerValue];
     NSInteger isoverdue = [self.loanInfoDict[@"isoverdue"] integerValue];
     [self.repayActionButton setTitle:@"立即支付担保金" forState:UIControlStateNormal];
     if (2 == loanState && isoverdue) {   //逾期
         self.repayActionButton.hidden = NO;
     }else{
         self.repayActionButton.hidden = YES;
     }
     */
    
    NSArray *itemsDataArray;
    itemsDataArray = [self itemsArrayFromIndexArray:@[@"已筹金额",@"借款天数"]];
    
    NSInteger itemsViewTag = 1100;
    UIView *view = [self.detailContentView viewWithTag:itemsViewTag];
    if (view) {
        [view removeFromSuperview];
    }
    
    DetailItemView *items = [DetailItemView new];
    items.tag = 1100;
    
    items.itemsDataArray = itemsDataArray;
    
    [items setUpView];
    
    items.top = 0;      items.left = 0;
    self.detailContentViewHeight.constant = items.height;
    
    [self.detailContentView addSubview:items];
}


- (void)setupProgress {
    //进度条
    CGFloat loanProgress = [self.loanInfoDict[@"loanprogress"] doubleValue];
    self.loanProgressView.progress = loanProgress;
    self.loanProgressView.bold = YES;
    
    self.loanProgressView.status = self.loanInfoDict[@"loanStatusLabel_for_warranty_short"];
    
    NSInteger loanState = [self.loanInfoDict[@"loanstatus"] integerValue];
    if (loanState == 1) {
        self.loanProgressView.status = nil; //[Util percentProgress:loanProgress];
    }
    
    NSInteger isoverdue = [self.loanInfoDict[@"isoverdue"] integerValue];
    if (isoverdue) {
        self.loanProgressView.remarkable = YES;
    }
   
}

- (NSArray *)itemsArrayFromIndexArray:(NSArray *)indexArray {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:indexArray.count];
    for (int i = 0; i < indexArray.count; i++) {
        [tmp addObject:[self itemDicts][indexArray[i]]];
    }
    return [tmp copy];
}

- (NSDictionary *)itemDicts {
    
    return @{@"已筹金额":@{@"title":@"已筹金额",@"content":@([self.loanInfoDict[@"loanedmainval"] doubleValue]) ,@"underline":@(YES)},
             @"利息总额":@{@"title":@"利息总额",@"content":@([self.loanInfoDict[@"repayableinterestval"] doubleValue]),@"underline":@(YES)},
             @"预计利息":@{@"title":@"预计利息",@"content":@([self.loanInfoDict[@"repayableinterestval"] integerValue]),@"underline":@(YES)},
             @"借款天数":@{@"title":@"借款天数",@"content":[NSString stringWithFormat:@"%@天", @([self.loanInfoDict[@"interestdaycount"] integerValue])]},
             @"筹款天数":@{@"title":@"筹款天数",@"content":[NSString stringWithFormat:@"%@天", @([self.loanInfoDict[@"loandaycount"] integerValue])]},
             
             @"筹款截止":@{@"title":@"筹款截止",@"content": self.loanInfoDict[@"loanendtime"] == nil ? @"" : self.loanInfoDict[@"loanendtime"]},
             @"发布日期":@{@"title":@"发布日期",@"content": self.loanInfoDict[@"audit_time"] == nil ? @"" : self.loanInfoDict[@"audit_time"]},
             @"还款日期":@{@"title":@"还款日期",@"content": self.loanInfoDict[@"repayendtime"] == nil ? @"" : self.loanInfoDict[@"repayendtime"]},
             @"还款日期历史":@{@"title":@"还款日期",@"content": self.loanInfoDict[@"ur_time"] == nil? @"" : self.loanInfoDict[@"ur_time"]},
             };
}

- (IBAction)guaranteeAction:(id)sender {
    AllShouxinPeople *guaranteen    = ZSEC(@"AllShouxinPeople");
    int loanid = [[self.loanInfoDict objectForKey:NET_KEY_LOANID] intValue];
    [guaranteen setLoanID:loanid];
    guaranteen.title = @"担保人";
    [self.navigationController pushViewController:guaranteen animated:YES];
}

@end
