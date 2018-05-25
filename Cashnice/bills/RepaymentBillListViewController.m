//
//  RepaymentBillListViewController.m
//  YQS
//
//  Created by a on 15/9/14.
//  Copyright (c) 2015年 l. All rights reserved.
//

#import "RepaymentBillListViewController.h"
#import "RepaymentBillListCell.h"

@interface RepaymentBillListViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger rowCnt;
    NSInteger rowHeight;

    int curPage;
    int pageCount;
    int totalCount;

    NSDate *lastDate;
}

@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RepaymentBillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rowCnt = 0;
    curPage = 0;
    pageCount = 0;
    rowHeight = 200;
    
    [Util setScrollHeader:self.scrollView target:self header:@selector(rhManual) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
}


#pragma mark - server

- (void)rhManual {
    curPage = 0;
    [self connectToServer];
}

- (void)rh {
    curPage = 0;
    [self.scrollView.header beginRefreshing];
    
    [self performSelector:@selector(loseData) withObject:self afterDelay:1.0f];
}

- (void)rhAppear {
    if (lastDate == nil) {
        [self rh];
    }
    else {
        NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:lastDate];
        if (t > UPDATE_TIME_INTERVAL) {
            [self rh];
        }
    }
}

- (void)rf {
    curPage++;
    [self connectToServer];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setData {
    curPage = [Util curPage:ZAPP.myuser.repaymentBillsListRespondDict];
    pageCount = [Util pageCount:ZAPP.myuser.repaymentBillsListRespondDict];
    totalCount = [Util totalCount:ZAPP.myuser.repaymentBillsListRespondDict];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
//    NSDictionary *dic = [AppDelegate zapp].myuser.repaymentBillsListRespondDict ;
    int cnt = [[ZAPP.myuser.repaymentBillsListRespondDict objectForKey:NET_KEY_billcount] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.repaymentBillsListRespondDict objectForKey:NET_KEY_bills]];
    }
    
    rowCnt = [self.dataArray count];
    [self.scrollView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    [self ui];
}

- (void)loseData {
    [self.scrollView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)ui {
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
    [self.tableView reloadData];
}

- (void)connectToServer {
    [self.op cancel];
    bugeili_net
    lastDate = [NSDate date];
    WS(ws);

    self.op = [ZAPP.netEngine getRepaymentListWithPageIndex:curPage pagesize:DEFAULT_PAGE_SIZE complete:^{[ws setData]; } error:^{[ws loseData];}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    [MobClick beginLogPageView:@"还款账单"];
    self.title = @"还款账单";
    [self ui];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    if ([ZAPP.zlogin isLogined]) {
        [self rhAppear];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"还款账单"];
    
    [self.op cancel];
    self.op = nil;
    [self loseData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [self.scrollView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

#pragma mark - server end


#pragma mark - UITableViewDelegate Method


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:(section == 0) ? 10 : 10];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:(section == rowCnt - 1) ? 20 : 0];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
    int loanstatus = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
    int offset = (loanstatus != 1 ? 22 : 0);
    return [ZAPP.zdevice getDesignScale:rowHeight-offset];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *   CellIdentifier = @"RepaymentBillListCell";
    RepaymentBillListCell *cell    = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
    
    cell.title.text = [NSString stringWithFormat:@"公开理财第%@号", dict[@"noticeid"]];
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"借款总额¥500,000 未还款金额¥27,944\n借满日期2015－07-23\n2015-8-21应还 ¥430.21"];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(4, 8)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(4, 8)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString : @"借款总额 "];

    NSDictionary *firstNumAtt = @{NSFontAttributeName           : [UIFont systemFontOfSize:16],
                                  NSForegroundColorAttributeName: [UIColor blackColor]};
    NSMutableAttributedString *firstNum = [[NSMutableAttributedString alloc] initWithString:@"¥500,000" attributes:firstNumAtt];
    [str appendAttributedString:firstNum];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString : @",未还款金额 "]];
    
    NSDictionary *secNumAtt = @{NSFontAttributeName           : [UIFont systemFontOfSize:16],
                                NSForegroundColorAttributeName: [UIColor cyanColor]};
    NSMutableAttributedString *secNum = [[NSMutableAttributedString alloc] initWithString:@"¥27,944" attributes:secNumAtt];
    [str appendAttributedString:secNum];
    NSAttributedString *sepTmp = [[NSMutableAttributedString alloc] initWithString:@"\n借满日期 " attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [str appendAttributedString:sepTmp];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString :@"2015－07-23 \n"]];
    
    // 添加行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.string.length)];
    //int tmpLength = str.string.length;
    
    [str appendAttributedString:[[NSAttributedString alloc]initWithString:@"2015-8-21应还 " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} ]];
    [str appendAttributedString:[[NSAttributedString alloc]initWithString:@"¥430.21" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]} ]];
    [str appendAttributedString:[[NSAttributedString alloc]initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} ]];
//    // 添加行间距
//    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle2 setLineSpacing:8];
//    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(tmpLength, str.string.length - tmpLength)];
    
    cell.detail.attributedText = str;

    
    return cell;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
