//
//  MyInvestmentsListViewController.m
//  YQS
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyInvestmentsListViewController.h"
#import "Investment.h"
#import "Util.h"
#import "MyInvestmentsListCell.h"
#import "MyLoansListCell.h"
#import "InvestmentOptionTableViewDelegate.h"
#import "InvestmentInfoViewModel.h"
#import "BillInfoViewController.h"
#import "RedPackageWrapper.h"
#import "RedPackageWidget.h"

@interface MyInvestmentsListViewController ()<UITableViewDataSource, UITableViewDelegate, OptionTableViewTarget>{
    NSInteger rowCount;
    int currentpage;
    int pageCount;
    int totalPageCount;
    int stage;
    NSData * lastDate;
    
    
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

@property (strong, nonatomic) InvestmentOptionTableViewDelegate *optionDelegate;
@property (assign, nonatomic) NSUInteger orderOption;
@property (assign, nonatomic) CGFloat savedHeadViewHeight;
@property (strong, nonatomic) UILabel *vLabel;
@property (strong, nonatomic) UILabel *promptView;

@end

@implementation MyInvestmentsListViewController

BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];
    [self setupView];
    
    if (! self.isHistorical) {

        /*
        UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 4, 45, 22)];
        editBtn.titleLabel.font = [UtilFont systemNormal:12.0f];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setTitle:@"历史" forState:UIControlStateNormal];
        editBtn.backgroundColor = [UIColor clearColor];
        editBtn.layer.borderWidth = 1;
        editBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        editBtn.layer.cornerRadius = 5;
        editBtn.layer.masksToBounds = YES;
        
        UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, KNAV_SUBVIEW_MAXHEIGHT)];
        [containerView1 addSubview:editBtn];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:containerView1];
        */
        
        
        //Right Nav Buton
        [super setNavRightBtn];
        
        [self.rightNavBtn setTitle:@"历史" forState:UIControlStateNormal];
        
        stage = 1;
        
        self.headPromptInterest.text = @"待实现收益";
        
        if(0 == self.orderOption){
            //😶😶第三行😶😶//
            self.orderOption          = 2;  //@"投资日期从近到远",       //2
            self.orderTitleLabel.text = @"投资日期从近到远";
        }
        
    }else{
        stage = 2;
        if(0 == self.orderOption){
            self.orderOption          = 4;  //@"收回日期从近到远",       //4
            self.orderTitleLabel.text = @"收回日期从近到远";
        }
    }
    
    self.optionDelegate.selectedIndex = self.orderOption;
    [self.optionView reloadData];
    
    rowCount       = 0;
    currentpage    = 0;
    pageCount      = 0;
    totalPageCount = 0;
    
    //请求数据
    [self connectToServer];
    
}



- (void)rightNavItemAction{
    [self btnClick:nil];
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

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutPromptView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = self.isHistorical? @"投资历史" : @"我的投资";
    
    [MobClick beginLogPageView:@"我的投资列表"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"我的投资列表"];
}

- (void)optionTableViewDidSelectedIndex:(NSInteger)index title:(NSString *)title image:(UIImage *)image isInited:(BOOL)inited {
    [self.optionView reloadData];
    if (! inited) {
        [self optionAction:nil];
    }
    self.orderOption = index;
    self.orderTitleLabel.text = title;
    self.optionPromotImage.image = image;
    [self rhManul];
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
    
    __weak __typeof__(self) weakSelf = self;

        self.operation = [ZAPP.netEngine getGerenMyBetListWithPageIndex:currentpage pagesize:DEFAULT_PAGE_SIZE complete:^{
        [weakSelf setData];
        progress_hide
            
    } error:^{
        [weakSelf loseData];
        progress_hide

    } withStage:stage withOrder:self.orderOption];
}

- (void)rhManul {
    currentpage = 0;
    [self connectToServer];
}

- (void)rh {
    currentpage = 0;
    [self connectToServer];
    //[self.table.header beginRefreshing];
}

- (void)rhAppear {
    [self rh];
}

- (void)rf {
    currentpage++;
    
    [self connectToServer];
}

- (void)setData {
    currentpage    = [Util curPage:ZAPP.myuser.gerenMyBetList];
    pageCount  = [Util pageCount:ZAPP.myuser.gerenMyBetList];
    totalPageCount = [Util totalCount:ZAPP.myuser.gerenMyBetList];
    
    if (! totalPageCount) {
        self.vLabel.hidden = NO;
        [self.vLabel setText:@"暂无投资"];
    }else{
        self.vLabel.hidden = YES;
    }
    NSString *  x = [Util intWithUnit:(int)totalPageCount unit:@""];
    self.promptView.text = [NSString stringWithFormat:@"共%@笔", x];
    [self.promptView sizeToFit];
    self.promptView.width += ([ZAPP.zdevice getDesignScale:30]);
    self.promptView.height = [ZAPP.zdevice getDesignScale:30];
    
    if (currentpage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    int cnt = (int)[[ZAPP.myuser.gerenMyBetList objectForKey:NET_KEY_BETScount] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:currentpage objects:[ZAPP.myuser.gerenMyBetList objectForKey:NET_KEY_BETS]];
    }
    
    rowCount = [self.dataArray count];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    [self performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:YES];
}
- (void)loseData {
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)refreshUI{
    //投资总额
    double loanMainVal = [ZAPP.myuser.gerenMyBetList[@"bets_total"] doubleValue];
    self.valueLoanLabel.text = [Util formatRMBWithoutUnit:@(loanMainVal)];
    //收益总额
    double interest = [ZAPP.myuser.gerenMyBetList[@"interest_val"] doubleValue];
    self.valueInterestLabel.text = [Util formatRMBWithoutUnit:@(interest)];
    
    self.tableView.footer.hidden = ((currentpage + 1) >= pageCount);
    [self.tableView reloadData];
    if (currentpage == 0) {
        //self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


- (IBAction)coveredViewToched:(id)sender {
    [self optionAction:nil];
}

- (void)btnClick:(UIButton*)btn {
    
    MyInvestmentsListViewController *history = ZINVST(@"MyInvestmentsListViewController");
    history.isHistorical = YES;
    [self.navigationController pushViewController:history animated:YES];
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
    
    static NSString *      CellIdentifier = @"MyInvestmentsListCell";
    MyLoansListCell * cell       = (MyLoansListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *betDict = [self.dataArray objectAtIndex:indexPath.section];
    [cell updateForInvestment:betDict];
    
    if (self.isHistorical) {
        //receivedinterestval 已还利息
        cell.valueInterestLable.text =[Util formatRMBWithoutUnit:@([betDict[@"receivedinterestval"] doubleValue])];
    }
     
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = [_dataArray objectAtIndex:indexPath.section];
    NSDictionary * loanDict      = [dict objectForKey:NET_KEY_LOAN];
    
    NSUInteger loanid = [loanDict[@"loanid"] integerValue];
    NSUInteger betid = [dict[@"betid"] integerValue];
    
    /*
    InvestmentDetailController *detail = ZINVST(@"InvestmentDetailController");
     */
    //InvestmentInfoViewModel *investmentVM = [[InvestmentInfoViewModel alloc] initWithLoanId:loanid betid:betid];
    BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyInvestment loanId:loanid betId:betid];
    [self.navigationController pushViewController:vc animated:YES];
}


CGFloat savedInvestOffsetY = 0.0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self scrollViewDidScrollForPromptView:scrollView];
    
    CGFloat offsetY =  scrollView.contentOffset.y;
    if (offsetY - savedInvestOffsetY > 4 && offsetY>0 &&
        CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
        ![self.tableView.header isRefreshing] &&
        ![self.tableView.footer isRefreshing]) {
        [self foldHeader];
    }
    if ((self.tableView.contentSize.height < self.tableView.height && offsetY < -4)||
        (offsetY - savedInvestOffsetY < -4    &&
        CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
        ![self.tableView.header isRefreshing] &&
        ![self.tableView.footer isRefreshing])) {
        [self reclaimHeader];
    }
    savedInvestOffsetY = offsetY;
}

bool isInvestHeadViewAlive = NO;

- (void)reclaimHeader{
    if (self.headViewHeight.constant > 0 || isInvestHeadViewAlive) {
        return;
    }
    
    DLog();
    
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
    
    DLog();
    
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
    if (offsetY > 200 || offsetY < - 200) {
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
        _optionDelegate = [[InvestmentOptionTableViewDelegate alloc] init];
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
    return [NSString stringWithFormat:@"%@%@-%@",prefix, [ZAPP.myuser getUserID], @"investmentOrderOptionKey"];
}

- (void)setOrderOption:(NSUInteger)orderOption{
    [Util setUserDefaultValue:[NSString stringWithFormat:@"%zd", orderOption] withKey:[self orderOptionUserDefaultKey]];
}

- (NSUInteger)orderOption{
    id value = [Util getValueFromUserDefaultWithKey:[self orderOptionUserDefaultKey]];
    return [value integerValue];
}

@end
