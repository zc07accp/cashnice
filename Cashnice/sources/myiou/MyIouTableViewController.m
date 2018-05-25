//
//  MyIouListViewController.m
//  Cashnice
//
//  Created by a on 16/7/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyIouTableViewController.h"
#import "MyIouTableViewCell.h"
#import "IocInfoViewController.h"
#import "MyIouOptionTableViewDelegate.h"

@interface MyIouTableViewController () <UITableViewDelegate, UITableViewDataSource, OptionTableViewTarget> {
    
    NSInteger   rowCount;
    int         curPage;
    int         pageCount;
    int         totalCount;
    int         stage;
    NSDate      *lastDate;
    NSTimer     *promptInitTimer;
}

@property (strong, nonatomic) MKNetworkOperation *operation;
@property (strong, nonatomic) NSMutableArray *    dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headPromptLoan;
@property (weak, nonatomic) IBOutlet UILabel *headPromptInterest;
@property (weak, nonatomic) IBOutlet UILabel *headPromptWan;
@property (weak, nonatomic) IBOutlet UILabel *headPromptYuan;
@property (weak, nonatomic) IBOutlet UIImageView *optionPromotImage;

@property (weak, nonatomic) IBOutlet UILabel *valueLoanLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueInterestLabel;

@property (weak, nonatomic) IBOutlet UITableView *optionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *optionArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;
@property (weak, nonatomic) IBOutlet UIControl *coveredView;

@property (strong, nonatomic) MyIouOptionTableViewDelegate *optionDelegate;
@property (assign, nonatomic) NSUInteger orderOption;   //排序号
@property (assign, nonatomic) CGFloat savedHeadViewHeight;
@property (strong, nonatomic) UILabel *vLabel;
@property (strong, nonatomic) UILabel *promptView;

@end

@implementation MyIouTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rowCount                  = 0;
    curPage                   = 1;
    pageCount                 = 0;
    totalCount                = 0;
    
    //self.orderOption          = !self.isHistorical ? 1 : 2;
    if (0 == self.orderOption) {
        self.orderOption          =  2;
    }
    self.optionDelegate.selectedIndex = self.orderOption;
    [self.optionView reloadData];
    
    [self setNavButton];
    
    if (self.iouListPageType == IouListPageTypeCreditor) {
        self.headPromptLoan.text = @"出借总额";
        //self.orderTitleLabel.text = @"出借日期从远到近";
        
        if (self.isHistorical) {
            self.title = @"历史";
            self.headPromptInterest.text = @"出借收益";
        }else{
            [self setRightNavBar];
            
            self.title = @"我的出借";
            self.headPromptInterest.text = @"待实现收益";
        }
    }else{
        //self.orderTitleLabel.text = @"借入日期从远到近";
        
        if (self.isHistorical) {
            self.title = @"历史";
            self.headPromptLoan.text = @"借款总额";
            self.headPromptInterest.text = @"支付利息";
        }else{
            [self setRightNavBar];
            
            self.title = @"我的借款";
            self.headPromptLoan.text = @"待还借款";
            self.headPromptInterest.text = @"预计利息";
        }
    }
    
    self.tableView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
    
    [self setupView];
    [self flashPromotView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"借条列表"];
    //请求数据
    [self connectToServer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"借条列表"];
}

- (void)flashPromotView{
    [self setPrmptViewUIWithNumber:self.prespecifiedCount];
    [self showPromptView];
    promptInitTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hidePromptView) userInfo:nil repeats:NO];
}

- (void)setupView{
    self.valueLoanLabel.font =
    self.valueInterestLabel.font = [UtilFont systemNormal:25];
    self.headPromptLoan.font =
    self.headPromptInterest.font = [UtilFont systemNormal:18];
    self.orderTitleLabel.font =
    self.headPromptWan.font =
    self.headPromptYuan.font = [UtilFont systemLargeNormal];
    
    self.optionViewHeight.constant = 0.0f;
    self.savedHeadViewHeight = self.headViewHeight.constant = [ZAPP.zdevice getDesignScale:92];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.optionView.dataSource = self.optionDelegate;
    self.optionView.delegate = self.optionDelegate;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
    
    self.tableView.header.backgroundColor =
    self.tableView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
}

- (void)rightNavItemAction{
    [self pushHistoricalView];
}

- (void)setRightNavBar{
    [super setNavRightBtn];
    [self.rightNavBtn setTitle:@"历史" forState:UIControlStateNormal];
}

- (void)pushHistoricalView {
    MyIouTableViewController *history = ZMYIOU(@"MyIouTableViewController");
    history.iouListPageType = self.iouListPageType;
    history.isHistorical = YES;
    [self.navigationController pushViewController:history animated:YES];
}

- (void)optionTableViewDidSelectedIndex:(NSInteger)index title:(NSString *)title image:(UIImage *)image isInited:(BOOL)inited  {
    
    self.orderOption = index;
    self.orderTitleLabel.text = title;
    self.optionPromotImage.image = image;
    
    if (! inited) {
        [self.optionView reloadData];
        [self optionAction:nil];
        
        [self rhManul];
    }
}

- (IBAction)optionAction:(id)sender {
    if (self.optionViewHeight.constant > 0) {
        self.optionViewHeight.constant = 0;
        self.coveredView.hidden = YES;
        
    }else{
        self.optionViewHeight.constant = [ZAPP.zdevice getDesignScale:40]*6;
        self.coveredView.hidden = NO;
        //[self foldHeader];
    }
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        nil;
    }];
    
    // 旋转箭头
    float angle = self.optionViewHeight.constant>0 ? M_PI : 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        self.optionArrow.transform = CGAffineTransformMakeRotation(angle);
    }];
}

- (void)connectToServer
{
    [self.operation cancel];
    bugeili_net
    progress_show
    __weak MyIouTableViewController *weakSelf = self;
    self.operation = [ZAPP.netEngine getMyIouListWithPageIndex:curPage pagesize:DEFAULT_PAGE_SIZE complete:^{
        MyIouTableViewController *strongSelf = weakSelf;
        [strongSelf setData];
        progress_hide
    } error:^{
        MyIouTableViewController *strongSelf = weakSelf;
        [strongSelf loseData];
        progress_hide
        
    } withIouType: self.iouListPageType historical:self.isHistorical andOrder:self.orderOption];
}

- (void)rhManul {
    curPage = 1;
    [self connectToServer];
}

- (void)rf {
    curPage++;
    [self connectToServer];
}

- (void)setData {
    curPage    = [Util curPage:ZAPP.myuser.gerenMyIouList];
    pageCount  = [Util pageCount:ZAPP.myuser.gerenMyIouList];
    totalCount = [Util totalCount:ZAPP.myuser.gerenMyIouList];
    
    double principal = [ZAPP.myuser.gerenMyIouList[@"principal"] doubleValue];
    double interest = [ZAPP.myuser.gerenMyIouList[@"interest"] doubleValue];
    self.valueLoanLabel.text = [Util formatRMBWithoutUnit:@(principal)];
    self.valueInterestLabel.text = [Util formatRMBWithoutUnit:@(interest)];
    
    if (! totalCount) {
        self.vLabel.hidden = NO;
        [self.vLabel setText:@"暂无数据"];
    }else{
        self.vLabel.hidden = YES;
    }
    
    [self setPrmptViewUIWithNumber:totalCount];
    
    if (curPage <= 1) {
        [self.dataArray removeAllObjects];
    }
    
//    int cnt = (int)[[ZAPP.myuser.gerenMyIouList objectForKey:@"list"] count];
    //if (cnt > 0) {
    [self.dataArray insertPage:curPage objects:[ZAPP.myuser.gerenMyIouList objectForKey:@"list"]];
    //}
    
    rowCount = [self.dataArray count];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    [self performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:YES];
}

- (void)setPrmptViewUIWithNumber:(NSInteger)number{
    
    NSString *  x = [Util intWithUnit:(int)number unit:@""];
    self.promptView.text = [NSString stringWithFormat:@"共%@笔", x];
    [self.promptView sizeToFit];
    self.promptView.width += ([ZAPP.zdevice getDesignScale:30]);
    self.promptView.height = [ZAPP.zdevice getDesignScale:30];
    [self layoutPromptView];
}

- (void)loseData {
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)refreshUI{
    //TODO
    //    //投资总额
    //    double loanMainVal = [ZAPP.myuser.gerenMyIouList[@"bets_total"] doubleValue];
    //    self.valueLoanLabel.text = [Util formatRMBWithoutUnit:@(loanMainVal)];
    //    //收益总额
    //    double interest = [ZAPP.myuser.gerenMyIouList[@"interest_val"] doubleValue];
    //    self.valueInterestLabel.text = [Util formatRMBWithoutUnit:@(interest)];
    
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
    [self.tableView reloadData];
}


- (IBAction)coveredViewToched:(id)sender {
    [self optionAction:nil];
}

- (void)btnClick:(UIButton*)btn {
    //
    //    MyIouTableViewController *history = ZINVST(@"MyIouTableViewController");
    //    history.isHistorical = YES;
    //    [self.navigationController pushViewController:history animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:150.0];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return rowCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *      CellIdentifier = @"MyIouTableViewCell";
    MyIouTableViewCell * cell       = (MyIouTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Cell Item
    NSDictionary *itemDict = [self.dataArray objectAtIndex:indexPath.section];
    NSInteger loanstatus = [itemDict[@"ui_status"] integerValue];
    NSInteger isoverdue = [itemDict[@"isOverDue"] integerValue];
    
    //标题
    if (self.iouListPageType == IouListPageTypeCreditor) {
        cell.loanTitleLabel.text = @"出借金额";
        cell.PromptDistributionTimeLable.text = @"出借日";
        cell.promptRepayTimeLabel.text = @"收回日";
        //借款人姓名（含标签）
        cell.loanStatusLabel.text = itemDict[@"borrower"];
        
    }else{
        cell.loanTitleLabel.text = @"借入金额";
        cell.PromptDistributionTimeLable.text = @"借入日";
        cell.promptRepayTimeLabel.text = @"还款日";
        //出借人姓名（含标签）
        cell.loanStatusLabel.text = itemDict[@"lender"];
    }
    
    //金额
    cell.mainValueLabel.text = [Util formatRMBWithoutUnit:@([itemDict[@"ui_loan_val"] doubleValue])];
    
    //还剩XX天
    cell.daysLeftLabel.text = itemDict[@"day_left"];
    
    //利息 //itemDict[@"ui_interest_val"] ;
    cell.valueInterestLable.text = [Util formatRMBWithoutUnit:@([itemDict[@"ui_interest_val"] doubleValue])];
    
    //利率
    CGFloat rate = [itemDict[@"ui_loan_rate"] doubleValue];
    cell.valueRateLabel.text =[NSString stringWithFormat:@"%@", [Util formatFloat:@(rate)]];
    
    cell.loanStatusLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    
    if (loanstatus == IOU_STATUS_REPAY_CONFIRM) {
        //已完成
        cell.thelastImage.image = [UIImage imageNamed:@"finish"];
    }else{
        if (isoverdue == 1) {
            //逾期
            cell.thelastImage.image = [UIImage imageNamed:@"overdue"];
            //if (self.iouListPageType == IouListPageTypeCreditor) {
            cell.loanStatusLabel.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
            //}
        }else{
            //进行中
            cell.thelastImage.image = [UIImage imageNamed:@"thelast"];
        }
    }
//    if (self.isHistorical) {
//        cell.valueInterestLable.text =[Util formatRMBWithoutUnit:@([itemDict[@"receivedinterestval"] doubleValue])];
//    }
    
    //借款日
    NSString *distributionTime = itemDict[@"ui_loan_start_date"];
    if ([distributionTime isKindOfClass:[NSString class]] && distributionTime.length >= 1) {
        cell.valueDistributionTimeLabel.text = [Util shortDateFromFullFormat:distributionTime];
        
        cell.PromptDistributionTimeLable.hidden =
        cell.valueDistributionTimeLabel.hidden = NO;
    }else{
        cell.PromptDistributionTimeLable.hidden =
        cell.valueDistributionTimeLabel.hidden = YES;
    }
    
    //还款日
    NSString *repayTime = itemDict[@"ui_loan_end_date"];   //借款的最后还款日期
    
    if (self.isHistorical) {
        repayTime = itemDict[@"format_repay_confirm_time"];//还款确认的时间
    }
    
    if ([repayTime isKindOfClass:[NSString class]] && repayTime.length >= 1) {
        //还款日期
        cell.valueRepayTimeLabel.text = [Util shortDateFromFullFormat:repayTime];
        
        cell.promptRepayTimeLabel.hidden =
        cell.valueRepayTimeLabel.hidden = NO;
    }else{
        cell.promptRepayTimeLabel.hidden =
        cell.valueRepayTimeLabel.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    IocInfoViewController *detail = ZMYIOU(@"IocInfoViewController");
    //TODO
    NSDictionary *item = [self.dataArray objectAtIndex:indexPath.section];
    detail.iouId = [item[@"ui_id"] integerValue];
    detail.ui_orderno = item[@"ui_orderno"];
    detail.iouListPageType = self.iouListPageType;
    //    InvestmentDetailController *detail = ZINVST(@"InvestmentDetailController");
    //    detail.loanId = [loanDict[@"loanid"] integerValue];
    //    detail.investDetailDict = loanDict;
    [self.navigationController pushViewController:detail animated:YES];
}


static CGFloat savedInvestOffsetY = 0.0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self scrollViewDidScrollForPromptView:scrollView];
    
    CGFloat offsetY =  scrollView.contentOffset.y;
    if (offsetY - savedInvestOffsetY > 4 && offsetY>0 &&
        //CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
        ![self.tableView.header isRefreshing] &&
        ![self.tableView.footer isRefreshing]) {
        [self foldHeader];
    }
    if ((self.tableView.contentSize.height < self.tableView.height && offsetY < -4)||
        (offsetY - savedInvestOffsetY < -4    &&
         //CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
         ![self.tableView.header isRefreshing] &&
         ![self.tableView.footer isRefreshing])) {
            [self reclaimHeader];
        }
    savedInvestOffsetY = offsetY;
}

static bool isInvestHeadViewAlive = NO;
- (void)reclaimHeader{
    if (self.headViewHeight.constant > 0 || isInvestHeadViewAlive) {
        return;
    }
    isInvestHeadViewAlive = YES;
    self.headViewHeight.constant = self.savedHeadViewHeight;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        isInvestHeadViewAlive = NO;
    }];
}
- (void)foldHeader{
    if (self.headViewHeight.constant <= 2.0 || isInvestHeadViewAlive) {
        return;
    }
    isInvestHeadViewAlive = YES;
    self.headViewHeight.constant = 0.0;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        isInvestHeadViewAlive = NO;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate){
        [self hidePromptView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self hidePromptView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}
- (void)scrollViewDidScrollForPromptView:(UIScrollView *)scrollView{
    CGFloat offsetY =  scrollView.contentOffset.y;
    if (offsetY > 20 || offsetY < - 20) {
        [self showPromptView];
    }
}

- (void)showPromptView{
    //[self.promptView setAlpha:0];
    [UIView animateWithDuration:.5f animations:^{
        [self.promptView setAlpha:1];;
    } completion:^(BOOL finished) {
        self.promptView.hidden = NO;
    }];
}
- (void)hidePromptView{
    [self.promptView setAlpha:1];
    [UIView animateWithDuration:.5f animations:^{
        [self.promptView setAlpha:0];
    } completion:^(BOOL finished) {
        self.promptView.hidden = YES;
        if (promptInitTimer) {
            [promptInitTimer invalidate];
            promptInitTimer = nil;
        }
    }];
}

- (UILabel *)promptView{
    if (! _promptView) {
        _promptView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _promptView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
        _promptView.textAlignment = NSTextAlignmentCenter;
        
        CGFloat cornerRadius = [ZAPP.zdevice getDesignScale:15];
        _promptView.layer.cornerRadius = cornerRadius;
        _promptView.layer.masksToBounds = YES;
        _promptView.hidden = YES;
        [self.view addSubview:_promptView];
        
        _promptView.font = [UtilFont systemLargeNormal];
        _promptView.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    }
    return _promptView;
}

- (UILabel *)vLabel{
    if (! _vLabel) {
        _vLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _vLabel.height = self.view.height/2;
        _vLabel.textAlignment = NSTextAlignmentCenter;
        _vLabel.font = [UIFont systemFontOfSize:20.0f];
        _vLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        _vLabel.hidden = YES;
        [self.tableView addSubview:_vLabel];
    }
    return  _vLabel;
}

- (InvestmentOptionTableViewDelegate *)optionDelegate {
    if (! _optionDelegate) {
        _optionDelegate = [[MyIouOptionTableViewDelegate alloc] init];
        _optionDelegate.iouListPageType = self.iouListPageType;
        _optionDelegate.isHistorical = self.isHistorical;
        _optionDelegate.delegate = self;
    }
    return _optionDelegate;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)layoutPromptView{
    CGFloat promptViewSpacing = [ZAPP.zdevice getDesignScale:6];
    self.promptView.top = self.view.height - self.promptView.height - promptViewSpacing;
    self.promptView.left = (self.view.width - self.promptView.width)/2;
    [self.view layoutIfNeeded];
}

- (NSString *)orderOptionUserDefaultKey{
    NSString *prefix = self.isHistorical? @"history-" : @"";
    return [NSString stringWithFormat:@"%@%@-%@-%@",prefix, [ZAPP.myuser getUserID], @"iouOrderIndexKey", @(self.iouListPageType)];
}

- (void)setOrderOption:(NSUInteger)orderOption{
    [Util setUserDefaultValue:[NSString stringWithFormat:@"%zd", orderOption] withKey:[self orderOptionUserDefaultKey]];
}

- (NSUInteger)orderOption{
    id value = [Util getValueFromUserDefaultWithKey:[self orderOptionUserDefaultKey]];
    return [value integerValue];
}
@end
