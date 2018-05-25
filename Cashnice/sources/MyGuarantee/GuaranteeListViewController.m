//
//  GuaranteeListViewController.m
//  YQS
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuaranteeListViewController.h"
#import "GuaranteeListCell.h"
#import "GuaranteeOptionTableViewDelegate.h"
#import "OptionHeaderView.h"
#import "GuaranteeDetailViewController.h"
#import "BillInfoViewModel.h"
#import "BillInfoViewController.h"
#import "GuaranteeInfoViewModel.h"
#import "GuaDetailListViewController.h"
#import "GuaranteeConfirmingViewController.h"

@interface GuaranteeListViewController ()<UITableViewDelegate,UITableViewDataSource, OptionHeaderViewDelegate, GuaranteeOptionTableViewTarget>{
    NSInteger rowCnt;
    
    int     curPage;
    int     pageCount;
    int     totalCount;
    int     stage;
    NSDate *lastDate;
    
    BOOL goDetail;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *optionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewHeight;

@property (weak, nonatomic) IBOutlet UIControl *coveredView;
@property (strong, nonatomic) NSMutableArray *    dataArray;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewTop;
@property (strong, nonatomic) OptionHeaderView *optionHeaderView;


@property (strong, nonatomic) GuaranteeOptionTableViewDelegate *optionDelegate;
@property (assign, nonatomic) NSUInteger orderIndex;
@property (assign, nonatomic) CGFloat savedHeadViewHeight;

@property (strong, nonatomic) UILabel *vLabel;
@property (strong, nonatomic) UILabel *promptView;

@property (strong, nonatomic) MKNetworkOperation *op;


@end


@implementation GuaranteeListViewController
BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的担保"];
    rowCnt                    = 0;
    curPage                   = 0;
    pageCount                 = 0;
    totalCount                = 0;
    
    //self.orderOption          = !self.isHistorical ? 4 : 8;  //@"解冻日期从近到远"
    self.optionDelegate.selectedIndex = self.orderIndex;
    [self.optionView reloadData];
    
    [self setupView];
    
    //[self connectToServer];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutPromptView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self connectToServer];
    [MobClick beginLogPageView:@"我的担保列表"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"我的担保列表"];
}

- (void)setupView {
    self.title = self.isHistorical? @"担保历史" : @"我的担保";
    self.tableView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    
    self.optionViewTop.constant = [ZAPP.zdevice getDesignScale:40];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNavButton];
    if (! self.isHistorical) {
        //[self setRightNavBar];
        
        [self setNavRightBtn];
    }
    
    //[self.optionHeaderView setTitle:@"解冻日期从近到远"];
    
    self.optionViewHeight.constant = 0.0f;
    
    self.optionView.dataSource = self.optionDelegate;
    self.optionView.delegate = self.optionDelegate;
    self.optionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
}

- (void)connectToServer {
    bugeili_net
    progress_show
    
    WS(ws);

    
   [ZAPP.netEngine getGerenMyShouxinLoanListWithPageIndex:curPage pagesize:DEFAULT_PAGE_SIZE complete:^{
        [ws setData];
        progress_hide
    } error:^{
        [ws.tableView.header endRefreshing];
        [ws.tableView.footer endRefreshing];
        progress_hide
    } withStage:stage withOrder:[self orderOptionFromIndex:self.orderIndex] historic:self.isHistorical];
}


-(void)setNavRightBtn{
    [super setNavRightBtn];
    
    [self.rightNavBtn setTitle:@"历史" forState:UIControlStateNormal];
}

- (void)rightNavItemAction{
    [self pushHistoricalView];
}

- (void)setRightNavBar{
    
    /*
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 4, 45, 22)];
    editBtn.titleLabel.font = [UtilFont systemNormal:12.0f];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(pushHistoricalView) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"历史" forState:UIControlStateNormal];
    editBtn.backgroundColor = [UIColor clearColor];
    editBtn.layer.borderWidth = 1;
    editBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    editBtn.layer.cornerRadius = 5;
    editBtn.layer.masksToBounds = YES;
    
    UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 90)];
    [containerView1 addSubview:editBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:containerView1];
     */
}

- (void)pushHistoricalView {
    GuaranteeListViewController *history = ZGUARANTEE(@"GuaranteeListViewController");
    history.isHistorical = YES;
    [self.navigationController pushViewController:history animated:YES];
}

- (void)setData {
    curPage    = [Util curPage:ZAPP.myuser.gerenMyShouxinLoanList];
    pageCount  = [Util pageCount:ZAPP.myuser.gerenMyShouxinLoanList];
    totalCount = [Util totalCount:ZAPP.myuser.gerenMyShouxinLoanList];
    
    if (! totalCount) {
        self.vLabel.hidden = NO;
        [self.vLabel setText:@"暂无担保"];
    }else{
        self.vLabel.hidden = YES;
    }
    self.promptView.text = [NSString stringWithFormat:@"共%@笔", @(totalCount)];
    [self.promptView sizeToFit];
    self.promptView.width += ([ZAPP.zdevice getDesignScale:30]);
    self.promptView.height = [ZAPP.zdevice getDesignScale:30];
    [self layoutPromptView];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    int cnt = (int)[[ZAPP.myuser.gerenMyShouxinLoanList objectForKey:NET_KEY_LOANCOUNT] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.gerenMyShouxinLoanList objectForKey:NET_KEY_LOANS]];
    }
    
    rowCnt = [self.dataArray count];
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    //设置tableview的总高度
//    CGFloat tableHeight = rowCnt * [ZAPP.zdevice getDesignScale:150.0];
//    self.tableViewHeight.constant = tableHeight;
    
    
    
    [self ui];
}
- (void)ui {
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
    [self.tableView reloadData];
    
    //self.tableViewHeight.constant = self.tableView.contentSize.height;
    //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.tableViewHeight.constant + 38);
    
    if (curPage == 0) {
        //self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)optionHeaderDidTouched:(OptionHeaderView *)optionHeaderView active:(BOOL)active {
    [self optionAction:nil];
}

- (void)guaranteeOptionTableViewDidSelectedIndex:(NSInteger)index title:(NSString *)title image:(UIImage *)image isInited:(BOOL)inited {
    if (! inited) {
        [self.optionView reloadData];
        [self optionAction:nil];
    }
    self.orderIndex = index;
    [self.optionHeaderView setTitle:title];
    self.optionHeaderView.promotImage.image = image;
    [self rhManul];
}
- (void)rhManul {
    curPage = 0;
    [self connectToServer];
}
- (void)rf {
    curPage++;
    [self connectToServer];
}
- (IBAction)coveredViewToched:(id)sender {
    [self optionAction:nil];
}

- (void)optionAction:(id)sender {
    if (self.optionViewHeight.constant > 0) {
        self.optionViewHeight.constant = 0;
        self.coveredView.hidden = YES;
        //[self reclaimHeader];
        
        self.optionHeaderView.isActive = NO;
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:150.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:40];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.optionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    //    if ( self.dataArray.count > 0) {
    //        return 2;
    //    }
    //    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GuaranteeListCell";
    GuaranteeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *itemDict = self.dataArray[indexPath.row];
    
    cell.loanTitleLabel.text = itemDict[@"loantitle"];
    
    //承保金额
    CGFloat warrantyval = [itemDict[@"warrantyval"] doubleValue];
    cell.mainValueLabel.text = [Util formatRMBWithoutUnit:@(warrantyval)];
    
    
    NSInteger loanstatus = [itemDict[@"loanstatus"] integerValue];
    //还款中...
    cell.daysLeftLabel.text = itemDict[@"loanstatuslabel_warranty"];
    
    NSInteger isoverdue = [itemDict[@"isoverdue"] integerValue];
    if (isoverdue == 1) {
        //逾期
        //宽限期
        NSInteger isgrace = [itemDict[@"isgrace"] integerValue];
        if (isgrace) {
            cell.thelastImage.image = [UIImage imageNamed:@"period"];
        }else{
            cell.thelastImage.image = [UIImage imageNamed:@"overdue"];
        }
        cell.loanStatusLabel.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
        cell.loanStatusLabel.text = itemDict[@"loanuser_warranty"];
    }else {
        //未逾期
        cell.loanStatusLabel.text = @"";
        if (loanstatus == 2) {
            //已满
            cell.thelastImage.image = [UIImage imageNamed:@"thelast"];
        }else if (loanstatus == 1 ) {
            //筹款中
            cell.thelastImage.image = [UIImage imageNamed:@"fundraising"];
        }else if (loanstatus == 3) {
            //完成还款
            cell.thelastImage.image = [UIImage imageNamed:@"finish"];
        }else if (loanstatus == 7) {
            //退款中
            cell.thelastImage.image = [UIImage imageNamed:@"drawback"];
        }else if (loanstatus == -3) {
            //担保确认中
            cell.thelastImage.image = [UIImage imageNamed:@"jk"];
        }
    }
    
    //借款金额
    double loanValue = [itemDict[@"loanmainval"] doubleValue];
    cell.valueInterestLable.text = [NSString stringWithFormat:@"%@", [Util formatRMBWithoutUnit:@(loanValue)]];
    
    //利率
//    NSInteger loanrate = [itemDict[@"loanrate"] integerValue];
//    cell.valueRateLabel.text = [Util percentInt:(int)loanrate];
    cell.valueRateLabel.text = [NSString stringWithFormat:@"%@",[Util formatFloat:@([itemDict[@"loanrate"] doubleValue])]];

    //担保日期
    NSString *distributionTime = itemDict[@"audit_time"];
    if (0 != loanstatus && [distributionTime isKindOfClass:[NSString class]] && distributionTime.length >= 10) {
        cell.valueDistributionTimeLabel.text = [Util shortDateFromFullFormat:distributionTime];
        cell.PromptDistributionTimeLable.hidden =
        cell.valueDistributionTimeLabel.hidden = NO;
    }else{
        cell.PromptDistributionTimeLable.hidden =
        cell.valueDistributionTimeLabel.hidden = YES;
    }
    
    //担保确认中不显示担保日期
    if (loanstatus == -3) {
        //担保确认中
        cell.PromptDistributionTimeLable.hidden =
        cell.valueDistributionTimeLabel.hidden = YES;
    }
    
    //解冻日期
    NSString *repayTime = itemDict[@"repayendtime"];
    if (loanstatus == 3) {
        repayTime = itemDict[@"ur_time"];
    }
    if (isoverdue == 1) {
        //cell.promptRepayTimeLabel.hidden =
        //cell.valueRepayTimeLabel.hidden = YES;
        
        //逾期显示解冻日期
        cell.valueRepayTimeLabel.text = [Util shortDateFromFullFormat:repayTime];
        cell.promptRepayTimeLabel.hidden =
        cell.valueRepayTimeLabel.hidden = NO;
        
    }else{
        if ((2 == loanstatus  || 3 == loanstatus)&&[repayTime isKindOfClass:[NSString class]] && repayTime.length >= 10) {
            //显示解冻日期
            cell.valueRepayTimeLabel.text = [Util shortDateFromFullFormat:repayTime];
            cell.promptRepayTimeLabel.hidden =
            cell.valueRepayTimeLabel.hidden = NO;
        }else{
            cell.promptRepayTimeLabel.hidden =
            cell.valueRepayTimeLabel.hidden = YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    GuaranteeDetailViewController * detail =ZGUARANTEE(@"GuaranteeDetailViewController") ;
    NSDictionary *itemDict = self.dataArray[indexPath.row];
    detail.loanid = [itemDict[@"loanid"] integerValue];
    detail.loanInfoDict = itemDict;
    [self.navigationController pushViewController:detail animated:YES];
    */
    
    NSDictionary *itemDict = self.dataArray[indexPath.row];
    NSInteger loanstatus = [itemDict[@"loanstatus"] integerValue];
    if (loanstatus == -3 && [itemDict[@"ulw_confirmed"] integerValue] == 0) {
        
        
            GuaranteeConfirmingViewController *c = [[GuaranteeConfirmingViewController alloc] init];
            c.loanInfo = itemDict;
            [self.navigationController pushViewController:c animated:YES];
        
        
        
    }else{
        NSUInteger loanid = [itemDict[@"loanid"] integerValue];
        BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyGuarantee loanId:loanid betId:0];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (OptionHeaderView *)optionHeaderView{
    if (! _optionHeaderView) {
        _optionHeaderView = [[OptionHeaderView alloc] init];
        _optionHeaderView.delegate = self;
    }
    return _optionHeaderView;
}
//CGFloat savedOffsetY = 0.0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self scrollViewDidScrollForPromptView:scrollView];
    
//    CGFloat offsetY =  scrollView.contentOffset.y;
//    if (offsetY - savedOffsetY > 4 && offsetY>0 &&
//        CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
//        ![self.tableView.header isRefreshing] &&
//        ![self.tableView.footer isRefreshing]) {
//        [self foldHeader];
//    }
//    if ((self.tableView.contentSize.height < self.tableView.height && offsetY < -4)||
//        (offsetY - savedOffsetY < -4    &&
//         CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
//         ![self.tableView.header isRefreshing] &&
//         ![self.tableView.footer isRefreshing])) {
//         [self reclaimHeader];
//        }
//    savedOffsetY = offsetY;
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
    if (offsetY > 200 || offsetY < - 200) {
        [self showPromptView];
    }
}

- (void)showPromptView{
    //[self.promptView setAlpha:0];
    [UIView animateWithDuration:.5f animations:^{
        [self.promptView setAlpha:1];
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
- (void)layoutPromptView{
    CGFloat promptViewSpacing = [ZAPP.zdevice getDesignScale:6];
    self.promptView.top = self.view.height - self.promptView.height - promptViewSpacing;
    self.promptView.left = (self.view.width - self.promptView.width)/2;
    [self.view layoutIfNeeded];
}

- (GuaranteeOptionTableViewDelegate *)optionDelegate {
    if (! _optionDelegate) {
        _optionDelegate = [[GuaranteeOptionTableViewDelegate alloc] init];
        _optionDelegate.delegate = self;
        //_optionDelegate.isHistorical = self.isHistorical;
    }
    return _optionDelegate;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSUInteger)orderIndexFromOption:(NSUInteger)option {
    NSUInteger index = 0;
    for (; index < 4; index ++) {
        if (option == [self orderOptionFromIndex:index]) {
            break;
        }
    }
    return index;
}

- (NSUInteger)orderOptionFromIndex:(NSUInteger)index{
    NSUInteger order = index;
    switch (index) {
        case 0:
        {
            order = !self.isHistorical ? 4 : 8;
            break;
        }
        case 1:
        {
            order = !self.isHistorical ? 3 : 7;
            break;
        }
        case 2:
        {
            order = 10;
            break;
        }
        case 3:
        {
            order = 9;
            break;
        }
        case 4:
        {
            order = 11;
            break;
        }
        case 5:
        {
            order = 12;
            break;
        }
            
        default:
            break;
    }
    return order;
}

- (NSString *)orderOptionUserDefaultKey{
    NSString *prefix = self.isHistorical? @"history-" : @"";
    return [NSString stringWithFormat:@"%@%@-%@",prefix, [ZAPP.myuser getUserID], @"guranteeOrderIndexKey"];
}

- (void)setOrderIndex:(NSUInteger)orderIndex{
    [Util setUserDefaultValue:[NSString stringWithFormat:@"%zd", orderIndex] withKey:[self orderOptionUserDefaultKey]];
}

- (NSUInteger)orderIndex{
    id value = [Util getValueFromUserDefaultWithKey:[self orderOptionUserDefaultKey]];
    return [value integerValue];
}

@end
