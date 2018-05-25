//
//  MyLoansListViewController.m
//  YQS
//
//  Created by a on 16/5/3.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyLoansListViewController.h"
#import "MyLoansDetailViewController.h"
#import "MyLoansListCell.h"
#import "LoanOptionTableViewDelegate.h"
#import "LoanInfoViewModel.h"
#import "BillInfoViewController.h"

#import "LoanDetailListViewController.h"


@interface MyLoansListViewController () <UITableViewDelegate, UITableViewDataSource, LoanOptionTableViewTarget> {
    NSInteger rowCnt;
    int       curPage;
    int       pageCount;
    int       totalCount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headPromptLoan;
@property (weak, nonatomic) IBOutlet UILabel *headPromptInterest;
@property (weak, nonatomic) IBOutlet UILabel *headPromptWan;
@property (weak, nonatomic) IBOutlet UILabel *headPromptYuan;
@property (weak, nonatomic) IBOutlet UIImageView *optionPromotImage;

@property (weak, nonatomic) IBOutlet UILabel            *valueLoanLabel;
@property (weak, nonatomic) IBOutlet UILabel            *valueInterestLabel;

@property (weak, nonatomic) IBOutlet UITableView        *optionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewHeight;
@property (weak, nonatomic) IBOutlet UILabel            *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *optionArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;
@property (weak, nonatomic) IBOutlet UIControl          *coveredView;


@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) LoanOptionTableViewDelegate *optionDelegate;
@property (assign, nonatomic) NSUInteger orderOption;   //排序号
@property (assign, nonatomic) NSUInteger orderIndex ;   //排序选项行号
@property (assign, nonatomic) CGFloat savedHeadViewHeight;

@property (strong, nonatomic) UILabel *vLabel;
@property (strong, nonatomic) UILabel *promptView;

@end

@implementation MyLoansListViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    
    rowCnt                    = 0;
    curPage                   = 0;
    pageCount                 = 0;
    totalCount                = 0;
    
    self.optionDelegate.selectedIndex = self.orderIndex;
    [self.optionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [MobClick beginLogPageView:@"我的借款列表"];
    [self connectToServer];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick beginLogPageView:@"我的借款列表"];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutPromptView];
}

- (void)setupView {
    self.title = self.isHistorical? @"借款历史" : @"我的借款";
    
    self.savedHeadViewHeight = self.headViewHeight.constant = [ZAPP.zdevice getDesignScale:92];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNavButton];
    if (! self.isHistorical) {
        [self setRightNavBar];
        self.headPromptInterest.text = @"预计利息";
    }else{
        self.headPromptInterest.text = @"支付利息";
    }
    
    self.optionViewHeight.constant = 0.0f;
    
    self.valueLoanLabel.font =
    self.valueInterestLabel.font = [UtilFont systemNormal:25];
    
//    self.headPromptYuan.textColor =
//    self.headPromptWan.textColor =
//    self.headPromptLoan.textColor =
//    self.headPromptInterest.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.headPromptLoan.font =
    self.headPromptInterest.font = [UtilFont systemNormal:18];
    
    self.orderTitleLabel.font =
    self.headPromptWan.font =
    self.headPromptYuan.font = [UtilFont systemLargeNormal];
    
    self.optionView.dataSource = self.optionDelegate;
    self.optionView.delegate = self.optionDelegate;
    self.optionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
    
    self.tableView.header.backgroundColor =
    self.tableView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    
}

- (void)LoanOptionTableViewDidSelectedIndex:(NSInteger)index title:(NSString *)title image:(UIImage *)image isInited:(BOOL)inited {
    if (! inited) {
        [self.optionView reloadData];
        [self optionAction:nil];
    }
    
    self.orderOption = [self orderOptionFromIndex:index];
    self.orderIndex = index;
    
    //查询条件调整
    //self.orderOption = !self.isHistorical ? index : index == 3 ? 7 : index == 4 ? 8 : index;
    
    /*
    if (self.isHistorical) {
        //历史查询条件调整
        if (index == 3) {
            self.orderOption = 7;
        }else
        if (index == 4) {
            self.orderOption = 8;
        }else{
            self.orderOption = index;
        }
    }else{
        self.orderOption = index;
    }
    */
    
    self.orderTitleLabel.text = title;
    self.optionPromotImage.image = image;
    [self rhManul];
}

- (IBAction)optionAction:(id)sender {
    if (self.optionViewHeight.constant > 0) {
        self.optionViewHeight.constant = 0;
        self.coveredView.hidden = YES;
//        [self reclaimHeader];
    }else{
        self.optionViewHeight.constant = [ZAPP.zdevice getDesignScale:40]*4;
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

- (IBAction)coveredViewToched:(id)sender {
    [self optionAction:nil];
}

- (void)rhManul {
    curPage = 0;
    [self connectToServer];
}

- (void)rf {
    curPage++;
    [self connectToServer];
}

- (void)setData {
    
    NSDictionary *loansDict = ZAPP.myuser.gerenMyLoanList;
    //借款总额
    double loanMainVal = [loansDict[@"main_val"] doubleValue];
    self.valueLoanLabel.text = [Util formatRMBWithoutUnit:@(loanMainVal/1e4)];
    
    //预计利息
    double interest = [loansDict[@"interest_val"] doubleValue];
    self.valueInterestLabel.text = [Util formatRMBWithoutUnit:@(interest)];
    
    curPage    = [Util curPage:ZAPP.myuser.gerenMyLoanList];
    pageCount  = [Util pageCount:ZAPP.myuser.gerenMyLoanList];
    totalCount = [Util totalCount:ZAPP.myuser.gerenMyLoanList];
    
    if (! totalCount) {
        self.vLabel.hidden = NO;
        [self.vLabel setText:@"暂无借款"];
    }else{
        self.vLabel.hidden = YES;
    }
    NSString *  x = [Util intWithUnit:(int)totalCount unit:@""];
    self.promptView.text = [NSString stringWithFormat:@"共%@笔", x];
    [self.promptView sizeToFit];
    self.promptView.width += ([ZAPP.zdevice getDesignScale:30]);
    self.promptView.height = [ZAPP.zdevice getDesignScale:30];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    int cnt = (int)[[ZAPP.myuser.gerenMyLoanList objectForKey:NET_KEY_LOANCOUNT] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.gerenMyLoanList objectForKey:NET_KEY_LOANS]];
    }
    
    rowCnt = [self.dataArray count];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    [self performSelectorOnMainThread:@selector(ui) withObject:nil waitUntilDone:YES];
}

- (void)ui {
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
    [self.tableView reloadData];
}

- (void)connectToServer {
    bugeili_net
    progress_show
    
    [ZAPP.netEngine getOrderedLoanListWithPage:curPage pagesize:DEFAULT_PAGE_SIZE order:self.orderOption ishistoric:self.isHistorical complete:^{
        [self setData];
        progress_hide
    } error:^{
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        progress_hide
    }];
}

- (void)setRightNavBar{
    
    [super setNavRightBtn];
    [self.rightNavBtn setTitle:@"历史" forState:UIControlStateNormal];
    
    /*
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 4, 45, 22)];
    editBtn.titleLabel.font = [UtilFont systemNormal:12.0f];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(pushHistoricalView) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"历史" forState:UIControlStateNormal];
    editBtn.backgroundColor = [UIColor clearColor];
    editBtn.layer.borderWidth = 1;
    editBtn.layer.borderCol== -3or = [UIColor whiteColor].CGColor;
    editBtn.layer.cornerRadius = 5;
    editBtn.layer.masksToBounds = YES;
    
    UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 90)];
    [containerView1 addSubview:editBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:containerView1];
     */
}

- (void)rightNavItemAction{
    [self pushHistoricalView];
}

- (void)pushHistoricalView {
    MyLoansListViewController *history = ZLOAN(@"MyLoansListViewController");
    history.isHistorical = YES;
    [self.navigationController pushViewController:history animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:150.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:0];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor greenColor];
//    return view;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
//    if ( self.dataArray.count > 0) {
//        return 2;
//    }
//    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyLoansListCell";
    MyLoansListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *itemDict = self.dataArray[indexPath.section];
    
    [cell updateForLoan:itemDict];    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *selectedLoan = self.dataArray[indexPath.section];
    NSInteger loanid = [selectedLoan[@"loanid"] integerValue];
    
    BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyLoan loanId:loanid betId:0];
    [self.navigationController pushViewController:vc animated:YES];
}

CGFloat savedOffsetY = 0.0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self scrollViewDidScrollForPromptView:scrollView];
    
    CGFloat offsetY =  scrollView.contentOffset.y;
    if (offsetY - savedOffsetY > 4 && offsetY>0 &&
        CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
        ![self.tableView.header isRefreshing] &&
        ![self.tableView.footer isRefreshing]) {
        [self foldHeader];
    }
    if ((self.tableView.contentSize.height < self.tableView.height && offsetY < -4)||
        (offsetY - savedOffsetY < -4    &&
        CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
        ![self.tableView.header isRefreshing] &&
        ![self.tableView.footer isRefreshing])) {
        [self reclaimHeader];
    }
    savedOffsetY = offsetY;
}

bool isHeadViewAlive = NO;

- (void)reclaimHeader{
    if (self.headViewHeight.constant > 0 || isHeadViewAlive) {
        return;
    }
    isHeadViewAlive = YES;
    self.headViewHeight.constant = self.savedHeadViewHeight;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        isHeadViewAlive = NO;
    }];
}
- (void)foldHeader{
    if (self.headViewHeight.constant <= 2.0 || isHeadViewAlive) {
        return;
    }
    isHeadViewAlive = YES;
    self.headViewHeight.constant = 0.0;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        isHeadViewAlive = NO;
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
    DLog();

    //[self.promptView setAlpha:0];
    [UIView animateWithDuration:.5f animations:^{
        [self.promptView setAlpha:1];;
    } completion:^(BOOL finished) {
        self.promptView.hidden = NO;
    }];
}
- (void)hidePromptView{
    
    DLog();
    [self.promptView setAlpha:1];
    [UIView animateWithDuration:.5f animations:^{
        [self.promptView setAlpha:0];
    } completion:^(BOOL finished) {
        self.promptView.hidden = YES;
    }];
}

- (UILabel *)promptView{
    if (! _promptView) {
        _promptView = [[UILabel alloc] init];
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

- (LoanOptionTableViewDelegate *)optionDelegate {
    if (! _optionDelegate) {
        _optionDelegate = [[LoanOptionTableViewDelegate alloc] init];
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

- (NSUInteger)orderIndexFromOption:(NSUInteger)option {
    NSUInteger index = 0;
    for (; index < 4; index ++) {
        if (option == [self orderOptionFromIndex:index]) {
            break;
        }
    }
    return index;
}

- (NSUInteger)orderOptionFromIndex:(NSUInteger)index {
    NSInteger order = 0;
    switch (index) {
        case 0:
        {
            order =  self.isHistorical ? 8 : 4;
            break;
        }
        case 1:
        {
            order =  self.isHistorical ? 7 : 3;;
            break;
        }
        case 2:
        {
            order = 5;
            break;
        }
        case 3:
        {
            order = 6;
            break;
        }
        default:
            break;
    }
    return order;
}

- (NSString *)orderOptionUserDefaultKey{
    NSString *prefix = self.isHistorical? @"history-" : @"";
    return [NSString stringWithFormat:@"%@%@-%@",prefix, [ZAPP.myuser getUserID], @"loanOrderIndexKey"];
}

- (void)setOrderIndex:(NSUInteger)orderIndex{
    [Util setUserDefaultValue:[NSString stringWithFormat:@"%zd", orderIndex] withKey:[self orderOptionUserDefaultKey]];
}

- (NSUInteger)orderIndex{
    id value = [Util getValueFromUserDefaultWithKey:[self orderOptionUserDefaultKey]];
    return [value integerValue];
}

@end
