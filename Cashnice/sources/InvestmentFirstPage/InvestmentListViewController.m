//
//  InvestmentListViewController.m
//  YQS
//
//  Created by a on 16/5/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentListViewController.h"
#import "InvestmentFPDetailViewController.h"
#import "InvestmentListCell.h"
#import "InvestmentAction.h"
#import "AllShouxinPeople.h"
#import "PaddingView.h"


@interface InvestmentListViewController () <UITableViewDelegate, UITableViewDataSource, InvestmentListCellDelegate> {
    NSInteger rowCnt;
    int       curPage;
    int       pageCount;
    int       totalCount;
    
    NSDate *lastDate;
    
    NSMutableArray *cachedProgressData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation InvestmentListViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    rowCnt                    = 0;
    curPage                   = 0;
    pageCount                 = 0;
    totalCount                = 0;
    
    cachedProgressData = [[NSMutableArray alloc] init];
}


- (void)setupView {
    self.title = @"投资";
    self.tableView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
    self.tableView.footer.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self rhManul];
    
    self.title = @"投资";
}

- (void)rhManul {
    SharedTrigger
    curPage = 0;
    [self connectToServer];
}

- (void)rf {
    curPage++;
    [self connectToServer];
}

- (void)setData {
    curPage = [Util curPage:ZAPP.myuser.loanListDict];
    pageCount = [Util pageCount:ZAPP.myuser.loanListDict];
    totalCount = [Util totalCount:ZAPP.myuser.loanListDict];
    
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    int cnt = [[ZAPP.myuser.loanListDict objectForKey:NET_KEY_LOANCOUNT] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.loanListDict objectForKey:NET_KEY_LOANS]];
    }
    
    rowCnt = [self.dataArray count];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
    [self.tableView reloadData];
}

- (void)loseData {
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)connectToServer {
    bugeili_net
    progress_show
    
    WS(ws);
    
    [ZAPP.netEngine getLoanListWithPageIndex:curPage pagesize:DEFAULT_PAGE_SIZE complete:^{
        [ws setData];
        progress_hide
    } error:^{
        [ws loseData];
        progress_hide
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:150.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0;
    }
    return [ZAPP.zdevice getDesignScale:10];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.dataArray.count > 1) {
//        return 1;
//    }else{
//        return 0;
//    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"InvestmentListCell";
    InvestmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.section;
    cell.delegate = self;
    
    NSDictionary *loanDict = self.dataArray[indexPath.section];
    
    //标题
    cell.loanTitleLabel.text = loanDict[@"loantitle"];
    
    //担保人数
    cell.guaranteeCountLable.text = [NSString stringWithFormat:@"%ld", [loanDict[@"warrantycount"] longValue]];
    //利率
    cell.rateLabel.text = [NSString stringWithFormat:@"%ld", [loanDict[@"loanrate"] longValue]];
    //天数
    cell.timeLabel.text = [NSString stringWithFormat:@"%ld", [loanDict[@"interestdaycount"] longValue]];
    //金额
    long loanedmainval = [loanDict[@"loanmainval"] longValue];
    double mainVal = loanedmainval / 1e4;
    cell.mainValLabel.text = [Util formatRMBWithoutUnit:@(mainVal)];
    
    return cell;
}

-(void)guaranteeButtonDidSelected:(UITableViewCell *)investmentListCell{
    NSUInteger selectedSection = investmentListCell.tag;
    NSDictionary *loanDict = self.dataArray[selectedSection];
    
    AllShouxinPeople * shouxin = ZSEC(@"AllShouxinPeople");
    NSInteger loanId =  [loanDict[@"loanid"] integerValue];
    [shouxin setLoanID:(int)loanId];
    [shouxin setLoanDict:loanDict];
    [self.navigationController pushViewController:shouxin animated:YES];
}

-(void)investButtonDidSelected:(UITableViewCell *)investmentListCell {
    NSUInteger selectedSection = investmentListCell.tag;
    NSDictionary *loanDict = self.dataArray[selectedSection];
    long loanstatus = [loanDict[@"loanstatus"] longValue];
    if (1 == loanstatus) {
        InvestmentAction *action = ZINVSTFP(@"InvestmentAction");
        action.loadDict = loanDict;
        [self.navigationController pushViewController:action animated:YES];
    }else{
        InvestmentFPDetailViewController *detail = ZINVSTFP(@"InvestmentFPDetailViewController");
        detail.loanid = [loanDict[@"loanid"] integerValue];
        detail.loanInfoDict = loanDict;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InvestmentFPDetailViewController *detail = ZINVSTFP(@"InvestmentFPDetailViewController");
    NSDictionary *loanDict = self.dataArray[indexPath.section];
    detail.loanid = [loanDict[@"loanid"] integerValue];
    detail.loanInfoDict = loanDict;
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
