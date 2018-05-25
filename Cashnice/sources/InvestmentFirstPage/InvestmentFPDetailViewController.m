//
//  InvestmentFPDetailViewController.m
//  YQS
//
//  Created by a on 16/5/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentFPDetailViewController.h"
#import "InvestmentAction.h"
#import "AllShouxinPeople.h"
#import "DetailItemView.h"
#import "LoanProgressView.h"
#import "InvestmentDetailViewController.h"
#import "JieKuanUtil.h"
#import "BILLWebViewUtil.h"
#import "InvestHistoryViewController.h"

@interface InvestmentFPDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView   *scrollView;
@property (weak, nonatomic) IBOutlet UIView *detailContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailContentViewHeight;

@property (weak, nonatomic) IBOutlet UIView *detailDatetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailDatetViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *yuanPromtLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentPromtLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *mainValPromtLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainValLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *guarantorPrmpt;
@property (weak, nonatomic) IBOutlet UILabel *guarantorCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *investerPrompt;
@property (weak, nonatomic) IBOutlet UILabel *investerCntLabel;

@property (weak, nonatomic) IBOutlet UIImageView *guaranteeLineRightImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inventerLineRightImgeViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeLineImageView;

@property (weak, nonatomic) IBOutlet UIButton *repayActionButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;

@property (weak, nonatomic) IBOutlet LoanProgressView *loanProgressView;
@end

static const NSUInteger kLargeFontSize = 22;

@implementation InvestmentFPDetailViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.repayActionButton.titleLabel.font = [UtilFont systemButtonTitle];
    [self connectToServer:NO];
    if (self.loanInfoDict) {
        [self refreshViewData];
    }
    
    [Util setScrollHeader:self.scrollView target:self header:@selector(connectToServer:) dateKey:[Util getDateKey:self]];
}

- (void)setupView {
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.detailContentView.backgroundColor = [UIColor clearColor];
    self.detailDatetView.backgroundColor = [UIColor clearColor];
    self.repayActionButton.hidden = YES;
    
    [self setNavButton];
    
    self.rateLabel.font =
    self.mainValLabel.font =
    [UtilFont systemNormal:kLargeFontSize];
    
    self.investerPrompt.font =
    self.investerCntLabel.font =
    self.infoLabel1.font =
    self.infoLabel2.font =
    self.guarantorPrmpt.font =
    self.guarantorCntLabel.font =
    self.mainValPromtLabel.font =
    self.ratePromptLabel.font =
    self.yuanPromtLabel.font =
    self.percentPromtLabel.font =
    [UtilFont systemLargeNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self connectToServer:YES];
    [MobClick beginLogPageView:@"投资详情"];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        BOOL enabled = self.navigationController.interactivePopGestureRecognizer.enabled;
        //self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        //interactivePopGestureRecognizer
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"投资详情"];
}

- (void)connectToServer:(BOOL)hideProgress {
    bugeili_net
    if (! hideProgress) {
        progress_show
    }
    
    [ZAPP.netEngine getLoanDetailWithLoanID:[NSString stringWithFormat:@"%ld", (long)self.loanid] complete:^{
        
        progress_hide
        self.loanInfoDict = ZAPP.myuser.loanDetailDict;
        
        [self refreshViewData];
        
        [self.scrollView.header endRefreshing];
        
    } error:^{
        
        progress_hide
        [self.scrollView.header endRefreshing];
    }];
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
    
    [self setDetailItemView];
    [self setDetailDateView];
    [self setupProgress];
    
    UIView *investerCntLabelAlignView;
    if ([JieKuanUtil isPrivilegedWithLoan:self.loanInfoDict]) {
        //抵押用户
        self.guaranteeLineImageView.image = [UIImage imageNamed:@"pledge.png"];
        self.guarantorPrmpt.text = @"抵押用户";
        self.guarantorCntLabel.text = @"";
        investerCntLabelAlignView = self.guaranteeLineRightImageView;
        
    }else{
        investerCntLabelAlignView = self.guarantorCntLabel;
        
    }
//    //处理右箭头与数字的对齐
//    [self.investerCntLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.investerCntLabel.superview);
//        make.centerX.mas_equalTo(investerCntLabelAlignView);
//    }];
}

- (void)setDetailDateView {
    
    NSInteger loanstatus = [self.loanInfoDict[@"loanstatus"] integerValue];
    
    NSInteger itemsViewTag = 1110;
    UIView *view = [self.detailDatetView viewWithTag:itemsViewTag];
    if (view) {
        [view removeFromSuperview];
    }
    
    UIView *viwe = [self.detailDatetView viewWithTag:101];
    [viwe removeFromSuperview];
    
    DetailItemView *items = [DetailItemView new];
    items.tag = 101;
    
    if (0 == loanstatus) {
        //审核中的借款
        UIView *dataView = self.detailDatetView.superview;
        [self.detailDatetView.superview addConstraint:[NSLayoutConstraint constraintWithItem:dataView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f] ];
        dataView.hidden = YES;
        return;
    }else if(1 == loanstatus) {
        //筹款中
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"筹款截止", @"发布日期"]];
    }else if(loanstatus == 3)
    {
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"发布日期", @"已还款日期"]];
    }else
    {
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"发布日期", @"还款日期"]];
    }
    
    [items setUpView];
    
    items.top = 0;      items.left = 0;
    self.detailDatetViewHeight.constant = items.height;
    
    [self.detailDatetView addSubview:items];
}

- (void)setDetailItemView {
    
    //根据借款状态设置
    NSArray *itemsDataArray;
    NSInteger loanState = [self.loanInfoDict[@"loanstatus"] integerValue];
    NSInteger isoverdue = [self.loanInfoDict[@"isoverdue"] integerValue];
    
    if (loanState == 3 || isoverdue) {
        itemsDataArray = [self itemsArrayFromIndexArray:@[@"利息总额",@"借款天数",@"筹款天数"]];
    }else{
        itemsDataArray = [self itemsArrayFromIndexArray:@[@"已筹金额",@"借款天数",@"筹款天数"]];
    }
    [self.repayActionButton setTitle:@"我要投资" forState:UIControlStateNormal];
    
    if (1 == loanState) {   //正在借款
        self.repayActionButton.hidden = NO;
    }else{
        self.repayActionButton.hidden = YES;
    }
    
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
    CGFloat  progress = [self.loanInfoDict[@"loanprogress"] doubleValue];
    self.loanProgressView.bold = YES;
    self.loanProgressView.progress =[self.loanInfoDict[@"loanprogress"] doubleValue];
    if (progress == 100) {
        self.loanProgressView.status = self.loanInfoDict[@"loanstatuslabel_short"];
    }
//    self.loanProgressView.status = self.loanInfoDict[@"loanstatuslabel_short"];

    NSInteger isoverdue = [self.loanInfoDict[@"isoverdue"] integerValue];
    NSInteger loanstatus = [self.loanInfoDict[@"loanstatus"] integerValue];
    if (loanstatus == 2 && isoverdue) {
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

    return @{@"已筹金额":@{@"title":@"已筹金额",@"content":@([self.loanInfoDict[@"loanedmainval"] integerValue]),@"underline":@(YES)},
             @"借款天数":@{@"title":@"借款天数",@"content":[NSString stringWithFormat:@"%@天", @([self.loanInfoDict[@"interestdaycount"] integerValue])]},
             @"利息总额":@{@"title":@"利息总额",@"content":@([self.loanInfoDict[@"repayableinterestval"] doubleValue]),@"underline":@(YES)},
             @"筹款天数":@{@"title":@"筹款天数",@"content":[NSString stringWithFormat:@"%@天", @([self.loanInfoDict[@"loandaycount"] integerValue])]},
             @"筹款截止":@{@"title":@"筹款截止",@"content": self.loanInfoDict[@"loanendtime"] == nil ? @"" : self.loanInfoDict[@"loanendtime"]},
             @"发布日期":@{@"title":@"发布日期",@"content": self.loanInfoDict[@"audit_time"] == nil ? @"" : self.loanInfoDict[@"audit_time"]},
             @"还款日期":@{@"title":@"还款日期",@"content": self.loanInfoDict[@"repayendtime"] == nil ? @"" : self.loanInfoDict[@"repayendtime"]},
             @"已还款日期":@{@"title":@"还款日期",@"content": self.loanInfoDict[@"ur_time"] == nil ? @"" : self.loanInfoDict[@"ur_time"]},
             };
}

- (IBAction)InvestmentAction:(id)sender {
    
    InvestmentAction *action = ZINVSTFP(@"InvestmentAction");
   
    action.loadDict = self.loanInfoDict;
    
    action.loanid = [self.loanInfoDict[@"loanid"] integerValue];
    
    /* 测试使用
    InvestmentDetailViewController *action = ZINVSTFP(@"InvestmentDetailViewController");
    action.betid = @"1111";
    */
    [self.navigationController pushViewController:action animated:YES];
}

- (IBAction)guaranteeAction:(id)sender {
    if ([JieKuanUtil isPrivilegedWithLoan:self.loanInfoDict]) {
        // 抵押用户详情
        [BILLWebViewUtil presentPrivilegedUserWithViewController:self];
    }else{
        
        AllShouxinPeople *guaranteen    = ZSEC(@"AllShouxinPeople");
        int loanid = [[self.loanInfoDict objectForKey:NET_KEY_LOANID] intValue];
        [guaranteen setLoanID:loanid];
        [guaranteen setLoanDict:self.loanInfoDict];
        guaranteen.title = @"担保人";
        [self.navigationController pushViewController:guaranteen animated:YES];
    }
}

- (IBAction)investAction:(id)sender {
    
    InvestHistoryViewController *ihvc = ZINVST(@"InvestHistoryViewController");
    ihvc.loanId = self.loanid;
    [self.navigationController pushViewController:ihvc animated:YES];

}


@end
