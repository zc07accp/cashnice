//
//  InvestmentDetailController.m
//  YQS
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentDetailController.h"
#import "InvestmentDetailCell.h"
#import "InvestmentDetailFooterCell.h"
#import "LoanProgressView.h"

@interface InvestmentDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger rowCount;
    int currentpage;
    int pageCount;
    int totalCount;
}


@property (weak, nonatomic) IBOutlet UILabel *investmentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *wanLabel;

@property (weak, nonatomic) IBOutlet UILabel *annualInvestmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualInvestmentRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@property (weak, nonatomic) IBOutlet UILabel *cycleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cycleDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeWanLabel;

@property (weak, nonatomic) IBOutlet UILabel *investmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentPeoLabel;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;

@property (strong, nonatomic) NSMutableArray *betArray;
@property (strong, nonatomic) NSDictionary *betLoan;
@property (weak, nonatomic) IBOutlet LoanProgressView *loanProgressView;



@end

@implementation InvestmentDetailController


BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];
    
    [self connectToServer];
    
    [self setupUI];
}

- (void)setupUI{
    
    self.contentWidth.constant = [UIScreen mainScreen].bounds.size.width;
    self.headViewHeight.constant = [ZAPP.zdevice getDesignScale:75];
    
    self.timeView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    self.annualInvestmentRateLabel.font =
    self.cycleDayLabel.font =
    self.guaranteeCountLabel.font =
    self.investmentNumLabel.font =
    self.investmentsCountLabel.font = [UtilFont systemNormal:22];
    self.wanLabel.font =
    self.annualInvestmentLabel.font =
    self.percentLabel.font =
    self.cycleTimeLabel.font =
    self.dayLabel.font =
    self.guaranteeLabel.font =
    
    self.guaranteeWanLabel.font =
    
    self.investmentPeoLabel.font =
    self.investmentLabel.font = [UtilFont systemLargeNormal];
    [Util setScrollHeader:self.scrollView target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    
    [Util setScrollFooter:self.scrollView target:self footer:@selector(rf)];
    
}

- (void)rhManul {
    currentpage = 0;
    [self connectToServer];
}

- (void)rf {
    currentpage++;
    [self connectToServer];
}

- (void)setTimeItemView {
    
    [[self.timeView viewWithTag:1100] removeFromSuperview];
    InvestDetailItemView *items = [[InvestDetailItemView alloc] initWithFrame:self.timeView.bounds];
    items.tag = 1100;
    
    items.itemsDataArray = @[
//  @{@"title":@"借款单号", @"content":self.betLoan[@"orderno"]},
                             @{@"title":@"发布日期", @"content":[NSString stringWithFormat:@"%@",self.betLoan[@"loan_starttime"]]}
                            ];
    [items setUpView];
    
    items.top = 0;      items.left = 0;
    self.timeViewHeight.constant = items.height;
    [self.timeView addSubview:items];
}

- (void)setData {
    
    NSDictionary *betDict = ZAPP.myuser.gerenMyBetDetail;
    
    self.betLoan = betDict[@"loan"];
    
    self.title = self.betLoan[@"loan_title"];
    
    [self setHeadViewData];
    [self setTimeItemView];
    
    currentpage    = [Util curPage:betDict];
    pageCount  = [Util pageCount:betDict];
    totalCount = [Util totalCount:betDict];
    
    if (currentpage == 0) {
        [self.betArray removeAllObjects];
    }
    
    int cnt = (int)[[betDict objectForKey:@"itemCount"] intValue];
    if (cnt > 0) {
        [self.betArray insertPage:currentpage objects:betDict[@"bets"]];
    }
    
    self.scrollView.footer.hidden = ((currentpage + 1) >= pageCount);
    
    rowCount = [self.betArray count];
    [self.scrollView.header endRefreshing];
    [self.scrollView.footer endRefreshing];
    

    [self setupProgress];
    [self.tableView reloadData];
    
    if (self.tableViewHeight.constant < self.tableView.contentSize.height) {
        
        self.tableViewHeight.constant = self.tableView.contentSize.height;
    }
    
}

- (void)loseData {
    [self.scrollView.header endRefreshing];
    [self.scrollView.footer endRefreshing];
}

- (void)setHeadViewData {
    
    NSDictionary * loanDict  = self.betLoan;
    //年化利率
    NSInteger loanrate = [loanDict[@"rate"] integerValue];
    self.annualInvestmentRateLabel.text = [NSString stringWithFormat:@"%ld",loanrate];
    //担保人数
    NSInteger guarantorCount = [loanDict[@"warranty_count"] integerValue];
    self.guaranteeCountLabel.text = [NSString stringWithFormat:@"%ld", guarantorCount];
    
    //金额
    double mainVal = [loanDict[@"main_vel"] doubleValue];
    CGFloat wan = mainVal ;
    self.investmentsCountLabel.text = [Util formatRMBWithoutUnit:@(wan)];
    
    //借款周期
    int loaddaycnt = [[loanDict objectForKey:@"daycount"] intValue];
    self.cycleDayLabel.text = [NSString stringWithFormat:@"%ld", (long)loaddaycnt];
    //投资人数
    NSInteger betcount = [[loanDict objectForKey:@"ul_bet_count"] integerValue];
    self.investmentNumLabel.text =[NSString stringWithFormat:@"%ld", (long)betcount] ;

}

- (void)connectToServer
{
    bugeili_net
    progress_show
    
    WS(ws);
    
    [ZAPP.netEngine getMyBetDetailWithPageIndex:currentpage pagesize:DEFAULT_PAGE_SIZE complete:^{
        [ws setData];
        progress_hide
    } error:^{
        [ws loseData];
        progress_hide
    } loanid:self.loanId];
}

- (void)setupProgress {
    CGFloat loanProgress = [self.betLoan[@"ul_progress"] doubleValue];
    self.loanProgressView.progress = loanProgress;
    self.loanProgressView.status = self.betLoan[@"loan_status_label"];
    self.loanProgressView.bold = YES;
    
    NSInteger loanState = [self.betLoan[@"loan_status"] integerValue];

    NSInteger isoverdue = [self.betLoan[@"isoverdue"] integerValue]; //是否逾期
    
    if (isoverdue) {
        //逾期
        self.loanProgressView.status = self.betLoan[@"loan_status_label"];
        self.loanProgressView.remarkable = YES;
    }else{
        //未逾期
        if (loanState == 1) {
            //筹款中
            self.loanProgressView.status = nil;//[Util percentProgress:loanProgress];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.betArray.count > 0) {
//        return 30;
//    }else{
//        return 0;
//    }
    return self.betArray.count  + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = indexPath.row;
    if (self.betArray.count == 0 || self.betArray.count <= row) {
        return [ZAPP.zdevice getDesignScale:60];
    }
    
    NSDictionary *bet = self.betArray[row];
    InvestDetailItemView  *items = [self setupDetailItemsViewWithDict:bet];
    
    return items.height + [ZAPP.zdevice getDesignScale:30];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.betArray.count > 0 && indexPath.row < self.betArray.count) {
        static NSString *identifier = @"InvestmentDetailCell";
        InvestmentDetailCell * cell = (InvestmentDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *v = [cell viewWithTag:1001];
        [v removeFromSuperview];
        
        NSDictionary *bet = self.betArray[indexPath.row];
        
        InvestDetailItemView  *items = [self setupDetailItemsViewWithDict:bet];
        items.tag = 1001;
        
        items.top = 0;      items.left = 0;
        
        cell.detailItemsViewHeight.constant = items.height;
        
        cell.detailItemsView.backgroundColor = [UIColor clearColor];
        
        [cell.detailItemsView addSubview:items];
        [cell setNeedsLayout];
        
        return cell;
    }else{
        static NSString *identifier = @"footer";
        InvestmentDetailFooterCell * cell = (InvestmentDetailFooterCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        NSDictionary *betDict = ZAPP.myuser.gerenMyBetDetail;
        NSString *contentStr = nil;
        NSInteger loan_status = [self.betLoan[@"loan_status"] integerValue];
        NSString *total_val = [Util formatRMB:@([betDict[@"total_val"] doubleValue])];
        NSString *total_interest = [Util formatRMB:@([betDict[@"total_interest"] doubleValue])];
        if (loan_status == 3) {
            contentStr = [NSString stringWithFormat:@"投资总计：%@  收益总计：%@", total_val, total_interest];
        }else{
            contentStr = [NSString stringWithFormat:@"投资总计：%@  预计收益：%@", total_val, total_interest];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.text = contentStr;
        return cell;
    }
}

- (InvestDetailItemView *) setupDetailItemsViewWithDict:(NSDictionary *)itemsDict {
    InvestDetailItemView *items = [[InvestDetailItemView alloc] initWithFrame:self.timeView.bounds];
    
    NSInteger loan_status = [self.betLoan[@"loan_status"] integerValue];
    NSInteger isoverdue = [self.betLoan[@"isoverdue"] integerValue];
    if (isoverdue) {
        //逾期
        items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"投资金额", @"预计收益", @"投资时间", /*@"投资单号",*/ @"收回日期"] infoDict:itemsDict];
    }else{
        if (loan_status == 3) {
            //3：完成还款
            items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"投资金额", @"收益金额", @"投资时间",/* @"投资单号",*/ @"收回日期历史"] infoDict:itemsDict];
        }else if(loan_status == 7){
            // 退款中
            items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"投资金额", @"预计收益", @"投资时间",/* @"投资单号"*/] infoDict:itemsDict];
        }else if(loan_status == 1){
            // 筹款中
            items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"投资金额", @"预计收益", @"投资时间", /*@"收回日期"@"投资单号"*/] infoDict:itemsDict];
        }
        else{
            items.itemsDataArray = [self itemsArrayFromIndexArray:@[@"投资金额", @"预计收益", @"投资时间", /*@"投资单号",*/@"收回日期"] infoDict:itemsDict];
        }
    }
    [items setUpView];
    return items;
}

- (NSArray *)itemsArrayFromIndexArray:(NSArray *)indexArray infoDict:(NSDictionary *)infoDict {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:indexArray.count];
    for (int i = 0; i < indexArray.count; i++) {
        [tmp addObject:[self detailItemsFromDictionary:infoDict][indexArray[i]]];
    }
    return [tmp copy];
}

- (NSDictionary *)detailItemsFromDictionary:(NSDictionary *)infoDict {
    
    return @{@"投资金额":@{@"title":@"投资金额", @"content":[Util formatRMB:@([infoDict[@"ub_val"] doubleValue])]},
             @"收益金额":@{@"title":@"收益金额", @"content":[Util formatRMB:@([infoDict[@"receivable_interest_val"] doubleValue])]},
             @"预计收益":@{@"title":@"预计收益", @"content":[Util formatRMB:@([infoDict[@"receivable_interest_val"] doubleValue])]},
             @"投资时间":@{@"title":@"投资时间", @"content":infoDict[@"ub_time"] == nil ? @"" : infoDict[@"ub_time"]},
             @"投资单号":@{@"title":@"投资单号", @"content":[NSString stringWithFormat:@"%@",infoDict[@"ub_orderno"]] == nil ? @"" : [NSString stringWithFormat:@"%@",infoDict[@"ub_orderno"]]},
             @"收回日期":@{@"title":@"收回日期", @"content":[Util shortDateFromFullFormat:infoDict[@"repay_end_time"]] == nil ? @"" : [Util shortDateFromFullFormat:infoDict[@"repay_end_time"]]},
             @"收回日期历史":@{@"title":@"收回日期", @"content":[Util shortDateFromFullFormat:infoDict[@"repay_end_time"]] == nil ? @"" : [Util shortDateFromFullFormat:infoDict[@"repay_end_time"]]},
             };
}

- (NSMutableArray *)betArray {
    if (_betArray == nil) {
        _betArray = [NSMutableArray array];
    }
    return _betArray;
}

- (NSDictionary *)betLoan{
    if (! _betLoan) {
        _betLoan = nil;
    }
    return _betLoan;
}

@end
