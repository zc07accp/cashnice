//
//  MyLoansDetailViewController.m
//  YQS
//
//  Created by a on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyLoansDetailViewController.h"

#import "DetailItemView.h"
#import "RepaymentViewController.h"
#import "AllShouxinPeople.h"
#import "LoanProgressView.h"


@interface MyLoansDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *detailContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailContentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *detailDatetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailDatetViewHeight;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;
//@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@property (weak, nonatomic) IBOutlet UILabel *mainValPromtLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanPromtLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentPromtLabel;
@property (weak, nonatomic) IBOutlet UILabel *howPrmptLable;
@property (weak, nonatomic) IBOutlet UILabel *mainValLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *guarantorPrmpt;
@property (weak, nonatomic) IBOutlet UILabel *guarantorCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *investerPrompt;
@property (weak, nonatomic) IBOutlet UILabel *investerCntLabel;
@property (weak, nonatomic) IBOutlet UIButton *repayActionButton;
@property (weak, nonatomic) IBOutlet LoanProgressView *loanProgressView;

@end

static const NSUInteger kLargeFontSize = 22;

@implementation MyLoansDetailViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];

    [self setInfoView];
    
    if (self.loanInfoDict) {
        [self refreshViewData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self connectToServer];
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
    [UtilFont systemNormal:kLargeFontSize];
    
    self.investerCntLabel.font =
    self.investerPrompt.font =
    self.guarantorPrmpt.font =
    self.guarantorCntLabel.font =
    self.mainValPromtLabel.font =
    self.ratePromptLabel.font =
    self.yuanPromtLabel.font =
    self.percentPromtLabel.font =
    self.howPrmptLable.font =
    [UtilFont systemLargeNormal];
}

- (void)refreshViewData {
    self.title =  self.loanInfoDict[@"loantitle"];
    
    //借款总额
    NSInteger mainVal = [self.loanInfoDict[@"loanmainval"] integerValue];
//    CGFloat wan = mainVal / 1e4;
    self.mainValLabel.text = [Util formatRMBWithoutUnit:@(mainVal)];

    //年转化率
    NSInteger loanrate = [self.loanInfoDict[@"loanrate"] integerValue];
    self.rateLabel.text = [NSString stringWithFormat:@"%ld", (long)loanrate];
    
    //担保人数
    NSInteger guarantorCount = [self.loanInfoDict[@"warrantycount"] integerValue];
    self.guarantorCntLabel.text = [NSString stringWithFormat:@"%ld", (long)guarantorCount];
    
    //投资人数
    NSInteger investerCount = [self.loanInfoDict[@"betcount"] integerValue];
    self.investerCntLabel.text = [NSString stringWithFormat:@"%ld", (long)investerCount];
    
    [self setDetailItemView];
    [self setDetailDateView];
    [self setupProgress];
    [self setInfoView];
    
    [self.view setNeedsLayout];
}

- (void)connectToServer {
    bugeili_net
    progress_show
    [ZAPP.netEngine getMyLoanDetailWithLoanID:[NSString stringWithFormat:@"%ld",(long)self.loanid] complete:^{
        self.loanInfoDict = ZAPP.myuser.loanDetailDict;
        progress_hide
    } error:^{
        progress_hide
    }];
}

- (void)setLoanInfoDict:(NSDictionary *)loanInfoDict {
    _loanInfoDict = loanInfoDict;
    [self performSelectorOnMainThread:@selector(refreshViewData) withObject:nil waitUntilDone:YES];
    
}

- (void)setDetailDateView {
    
    NSInteger loanstatus = [self.loanInfoDict[@"loanstatus"] integerValue];
    
    NSInteger itemsViewTag = 1110;
    UIView *view = [self.detailDatetView viewWithTag:itemsViewTag];
    [view removeFromSuperview];
    
    DetailItemView *items = [DetailItemView new];
    items.tag = itemsViewTag;
    if (0 == loanstatus) {
        //审核中的借款
        UIView *dataView = self.detailDatetView.superview;
        [self.detailDatetView.superview addConstraint:[NSLayoutConstraint constraintWithItem:dataView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f] ];
        dataView.hidden = YES;
        return;
    }else if(7 == loanstatus) {
        //退款中
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"筹款截止",@"发布日期"]];
    }else if(1 == loanstatus) {
        //筹款中
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"筹款截止", @"发布日期"]];
    }else if(3 == loanstatus) {
        //完成还款
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"发布日期", @"还款日期历史"]];
    }
    else{
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
    NSInteger isoverdue = [self.loanInfoDict[@"isoverdue"] integerValue]; //是否逾期
    if (loanState == 3 || loanState ==2 || isoverdue) {             //还款完成 or 借款已满 or 逾期
        itemsDataArray = [self itemsArrayFromIndexArray:@[@"利息总额",@"借款天数",@"筹款天数"]];
    }else if(loanState == 1 || loanState == 7){                           //正在借款
        itemsDataArray = [self itemsArrayFromIndexArray:@[@"已筹金额",@"预计利息",@"借款天数",@"筹款天数"]];
    }else if(loanState == 0){                           //0：等待审核
        itemsDataArray = [self itemsArrayFromIndexArray:@[@"预计利息",@"借款天数",@"筹款天数"]];
    }else{
        itemsDataArray = [self itemsArrayFromIndexArray:@[@"预计利息",@"借款天数",@"筹款天数"]];
    }
    
    if (isoverdue) {
        [self.repayActionButton setTitle:@"逾期还款" forState:UIControlStateNormal];
    }else{
        if (1 == loanState) {
            [self.repayActionButton setTitle:@"关闭借款" forState:UIControlStateNormal];
        }else{
            [self.repayActionButton setTitle:@"我要还款" forState:UIControlStateNormal];
        }
    }
    
    if (1 == loanState || 2 == loanState || isoverdue) {
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
    NSInteger loanState = [self.loanInfoDict[@"loanstatus"] integerValue];
    CGFloat loanProgress = [self.loanInfoDict[@"loanprogress"] doubleValue];
//    if (loanState != 1 && loanState != 7) {
//        loanProgress = 100;
//    }
    self.loanProgressView.progress = loanProgress;
    self.loanProgressView.bold = YES;
    
    self.loanProgressView.status = self.loanInfoDict[@"loanstatuslabel_short"];
    
    if (loanState == 1 ) {
        self.loanProgressView.status = nil;//[Util percentProgress:loanProgress];
    }
    NSInteger isoverdue = [self.loanInfoDict[@"isoverdue"] integerValue]; //是否逾期
    if (isoverdue) {
        self.loanProgressView.remarkable = YES;
    }
}

- (IBAction)repayAction:(id)sender {
    NSInteger loanState = [self.loanInfoDict[@"loanstatus"] integerValue];
    if (1 == loanState) {
        
//        CGFloat loaned = [[self.loanInfoDict objectForKey:NET_KEY_LOANEDMAINVAL] doubleValue];
//        int betcount = [[self.loanInfoDict objectForKey:NET_KEY_BETCOUNT] intValue];
//        if (loaned > 0 && betcount > 0) {
//            str = [NSString stringWithFormat:@"确定要关闭此次借款？系统将退还投资%@给%d位投资人(不计利息)", [Util formatRMB:@(loaned)], betcount];
//        }
//        NSString *str = @"是否关闭此借款？";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.myLoanDetailVC", nil) message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        [alert show];
        
    }else{
        
        RepaymentViewController *h = ZLOAN(@"RepaymentViewController");
        //h.delegate = self;
        //h.opRowHere = rowIndexHere;
        h.dataDict = self.loanInfoDict;
        [self.navigationController pushViewController:h animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            // 关闭借款
            bugeili_net
            
            progress_show
            [ZAPP.netEngine closeTheLoanWithComplete:^{
                
                progress_hide
                [Util toastStringOfLocalizedKey:@"tip.loanOff"];
                [self.navigationController popViewControllerAnimated:YES];
                
            } error:^{
                progress_hide
            } loanid:[NSString stringWithFormat:@"%ld", (long)self.loanid]];

        }
    }
    
}
- (IBAction)guaranteeAction:(id)sender {
    AllShouxinPeople *guaranteen    = ZSEC(@"AllShouxinPeople");
    int loanid = [[self.loanInfoDict objectForKey:NET_KEY_LOANID] intValue];
    [guaranteen setLoanID:loanid];
    guaranteen.title = @"担保人";
    [self.navigationController pushViewController:guaranteen animated:YES];
}

- (void)setInfoView {
    /*          去掉还款提示
    self.infoLable.font = [UtilFont systemSmallNormal];
    NSInteger loanstatus = [self.loanInfoDict[@"loanstatus"] integerValue];
    if (loanstatus == 3) {
        //完成还款
        self.infoViewHeight.constant = 0;
    }else{
        NSString *text = @"1. 在借款到期日22:00点前，将应还本息存入您的Cashnice账户即可；\n2. Cashnice平台将在借款到期日12:00点开始自动划转本息到投资人账户；\n3. Cashnice平台支持提前还款，点击还款按钮，给您的账户充值即可。";
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString : text];
        // 添加行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:[ZAPP.zdevice getDesignScale:10]];
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedText.string.length)];
        self.infoLable.attributedText = attributedText;
        self.infoLable.textColor =  ZCOLOR(COLOR_TEXT_GRAY);
        [self.infoLable sizeToFit];
        self.infoViewHeight.constant = self.infoLable.bounds.size.height + [ZAPP.zdevice getDesignScale:57];
    }
     */
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
             @"预计利息":@{@"title":@"预计利息",@"content":@([self.loanInfoDict[@"repayableinterestval"] doubleValue]),@"underline":@(YES)},
             @"利息总额":@{@"title":@"利息总额",@"content":@([self.loanInfoDict[@"repayableinterestval"] doubleValue]),@"underline":@(YES)},
             @"借款天数":@{@"title":@"借款天数",@"content":[NSString stringWithFormat:@"%@天", @([self.loanInfoDict[@"interestdaycount"] integerValue])]},
             @"筹款天数":@{@"title":@"筹款天数",@"content":[NSString stringWithFormat:@"%@天", @([self.loanInfoDict[@"loandaycount"] integerValue])]},
             @"筹款截止":@{@"title":@"筹款截止",@"content":self.loanInfoDict[@"loanendtime"] == nil ? @"" : self.loanInfoDict[@"loanendtime"]},
             @"发布日期":@{@"title":@"发布日期",@"content": self.loanInfoDict[@"audit_time"] == nil ? @"" : self.loanInfoDict[@"audit_time"]},
             @"还款日期":@{@"title":@"还款日期",@"content": self.loanInfoDict[@"repayendtime"] == nil ? @"" : self.loanInfoDict[@"repayendtime"]},
             @"还款日期历史":@{@"title":@"还款日期",@"content": self.loanInfoDict[@"ur_time"] == nil ? @"" :  self.loanInfoDict[@"ur_time"]},
             };
}

@end
