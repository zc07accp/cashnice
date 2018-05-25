//
//  TransferHistoryViewController.m
//  Cashnice
//
//  Created by a on 16/10/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TransferHistoryViewController.h"
#import "BillDetailViewController.h"
#import "TransferHistoryCell.h"
#import "TransferEngine.h"
#import "ListCountTip.h"

@interface TransferHistoryViewController () {
    NSInteger _curPage;
    NSInteger _totalPage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *historyDataList;

@property (strong, nonatomic) TransferEngine *engine;
@property (strong,nonatomic) ListCountTip *listTip;

@end

@implementation TransferHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _curPage = 1;
    
    if (self.userName.length > 1) {
        self.title = [NSString stringWithFormat:@"与%@的转账记录", self.userName];
    }else{
        self.title = @"转账记录";
    }
    
    self.tableView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(refresh) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(loadMore)];
    self.tableView.footer.hidden = YES; //默认先隐藏
    
    [self setNavButton];
    
    [self connectToServer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"转账记录"];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"转账记录"];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.listTip adjustFrame];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyDataList.count;
}

- (BOOL)lastRow:(NSIndexPath *)indexPath {
    return indexPath.row == self.historyDataList.count-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice scaledValue: 60];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *   CellIdentifier = @"TransferHistoryCell";
    TransferHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell configurateWithHistoryItem:self.historyDataList[indexPath.row]];
    cell.sepLine.hidden = [self lastRow:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = self.historyDataList[indexPath.row];
    NSString *orderString = EMPTYOBJ_HANDLE(item[@"orderno"]);
    //NSString *orderNo = [orderString substringFromIndex:2];
    NSString *orderType = [orderString substringToIndex:2];
    NSString *accrual = EMPTYOBJ_HANDLE(item[@"accrual"]);
    
    
    [self.navigationController pushViewController:[MeRouter commonPushedBillViewController: @{@"orderno":orderString,@"order_flag":orderType,@"accrual":accrual}] animated:YES];
//    BillDetailViewController *bdvc = MBDSTORY(@"BillDetailViewController");
  //  bdvc.dic = @{@"orderno":orderString,@"order_flag":orderType,@"accrual":accrual};
    //[self.navigationController pushViewController:bdvc animated:YES];
}

- (void)loadMore{
    _curPage ++;
    [self connectToServer];
}

- (void)refresh{
    _curPage = 1;
    [self connectToServer];
}

- (void)endRefreshing{
    [self.tableView.footer endRefreshing];
    [self.tableView.header endRefreshing];
}

- (void)loadTable:(NSArray *)historyItems isLastPage:(BOOL)isLastPage{
    
    if ([historyItems isKindOfClass:[NSArray class]] && historyItems.count > 0) {
        
        self.tableView.footer.hidden = isLastPage;
        
        if (_curPage <= 1) {
            [self.historyDataList removeAllObjects];
        }
        [self.historyDataList addObjectsFromArray:historyItems];
        
        [self.tableView reloadData];
    }else{
        //暂无记录
        [self showNoData];
    }
}

- (void)connectToServer {
    progress_show
    WS(ws)
    
    [self.engine getTransferHistoryListWithUserId:self.targetUserId page:_curPage pageSize:DEFAULT_PAGE_SIZE success:^(NSArray *historyItems, BOOL isLastPage,NSInteger totalcount) {
        
        progress_hide
        [ws endRefreshing];
        
        if(totalcount>0){
            self.listTip.tip = [NSString stringWithFormat:@"共%@笔", @(totalcount)];
        }
        
        [ws loadTable:historyItems isLastPage:isLastPage];
        
    } failure:^(NSString *error) {
        progress_hide
        [self endRefreshing];
    }];
}

- (void)showNoData{
    UIImageView *noDataImageView = [[UIImageView alloc] init];
    noDataImageView.image = [UIImage imageNamed:@"record_none.png"];
    
    UILabel *noDataLabel = [[UILabel alloc] init];
    noDataLabel.text = @"暂无记录";
    noDataLabel.textColor = CN_TEXT_GRAY;
    noDataLabel.font = CNFontNormal;
    
    [self.tableView addSubview:noDataLabel];
    [self.tableView addSubview:noDataImageView];

    [noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.top.equalTo(self.tableView).mas_offset([ZAPP.zdevice scaledValue:99]);
    }];
    
    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.top.equalTo(noDataImageView.mas_bottom).mas_offset(10);
    }];
    
//    [noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(noDataLabel);
//        make.bottom.equalTo(noDataLabel.mas_top).mas_offset(-10);
//    }];
//    
//    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.tableView);
//    }];
}

- (NSString *)targetUserId{
    if (! _targetUserId) {
        return @"";
    }
    return _targetUserId;
}

- (NSMutableArray *)historyDataList{
    if (! _historyDataList) {
        _historyDataList = [NSMutableArray new];
    }
    return _historyDataList;
}

- (TransferEngine *)engine{
    if (! _engine) {
        _engine = [[TransferEngine alloc] init];
    }
    return _engine;
}

-(ListCountTip *)listTip{
    
    if(!_listTip){
        _listTip = [ListCountTip tipSuperView:self.view bottomLayout:self.mas_bottomLayoutGuideTop];
    }
    
    return _listTip;
}

static CGFloat savedInvestOffsetY = 0.0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY =  scrollView.contentOffset.y;
    //
    if (  (offsetY > 200 || offsetY < - 200) && scrollView.isDragging && scrollView.tracking) {
        [self.listTip showPromptView];
    }

    savedInvestOffsetY = offsetY;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate){
        [self.listTip hidePromptView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.listTip hidePromptView];
}

@end
