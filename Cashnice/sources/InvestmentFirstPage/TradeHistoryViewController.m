//
//  TradeHistoryViewController.m
//  Cashnice
//
//  Created by a on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import "TradeHistoryViewController.h"
#import "TradeHistoryTableViewCell.h"
#import "TradeHistroyNetEngine.h"
#import "InvestmentFPDetailViewController.h"

@interface TradeHistoryViewController () <UITableViewDelegate, UITableViewDataSource>{
    int       curPage;
    int       pageCount;
    int       totalCount;
}

@property (strong, nonatomic) TradeHistroyNetEngine *netEngine;
@property (strong, nonatomic) IBOutlet UIView *noDataView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation TradeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"成交记录";
    
    [Util setScrollHeader:self.tableView target:self header:@selector(refreshData) dateKey:[Util getDateKey:self]];
    
    [Util setScrollFooter:self.tableView target:self footer:@selector(loadMoreData)];
    
    curPage = 0;
    [self connectToServer];
   
}

- (void)setData:(NSDictionary *)data{
    
    curPage = [Util curPage:data];
    pageCount = [Util pageCount:data];
    totalCount = [Util totalCount:data];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    NSInteger cnt = [[data objectForKey:NET_KEY_BETS] count];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[data objectForKey:NET_KEY_BETS]];
    }
    
    //rowCnt = [self.dataArray count];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
    [self.tableView reloadData];
    
    
    self.noDataView.hidden = self.dataArray.count > 0;
}

- (void)loseData {
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    self.noDataView.hidden = NO;
}

- (void)refreshData{
    curPage = 0;
    [self connectToServer];
}

- (void)loadMoreData{
    ++curPage;
    [self connectToServer];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZAPP.zdevice scaledValue:51];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [ZAPP.zdevice scaledValue:40];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self headerView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TradeHistoryTableViewCell";
    TradeHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell updateWithData:self.dataArray[indexPath.row]];
    
    if (indexPath.row % 2) {
        cell.backgroundColor = CN_COLOR_BG_GRAY;
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDict = self.dataArray[indexPath.row];
    NSString *loanid = EMPTYSTRING_HANDLE(dataDict[@"ul_id"]);
    
    if (loanid) {
        
        InvestmentFPDetailViewController *detail = ZINVSTFP(@"InvestmentFPDetailViewController");
        detail.loanid = [loanid  integerValue];
        UINavigationController *nav = ( UINavigationController *)self.parentViewController.parentViewController.navigationController;
        if ([nav isKindOfClass:[UINavigationController class]]) {
            [nav pushViewController:detail animated:YES];
        }
        
    }
}

- (void)connectToServer {
    WS(weakSelf);
    
    [self.netEngine historyList:self.tradeHistoryType pageNum:curPage pageSize:DEFAULT_PAGE_SIZE success:^(NSDictionary *contentArray) {
        [weakSelf setData:contentArray];
    } failure:^(NSString *error) {
        [weakSelf loseData];
    }];
}

- (TradeHistroyNetEngine *)netEngine{
    if (! _netEngine) {
        _netEngine = [[TradeHistroyNetEngine alloc] init];
    }
    return _netEngine;
}


- (UIView *)headerView {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = CN_COLOR_BG_GRAY;
    
    UILabel *bidder = [[UILabel alloc] init];
    bidder.text = @"投标人";
    
    UILabel *time = [[UILabel alloc] init];
    time.text = @"时间";
    
    UILabel *money = [[UILabel alloc] init];
    money.text = @"金额";
    
    NSArray *labs = @[bidder, time, money];
    for (UILabel *l in labs) {
        [header addSubview:l];
        l.textColor = HexRGB(0x888888);
        l.font = CNFont_18px;
    }
    
    [bidder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left).mas_equalTo(16);
        make.centerY.equalTo(header.mas_centerY);
    }];
    
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header.mas_centerX);
        make.centerY.equalTo(header.mas_centerY);
    }];
    
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header.mas_right).mas_offset(-16);
        make.centerY.equalTo(header.mas_centerY);
    }];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = CN_COLOR_DD_GRAY;
    [header addSubview:sepLine];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left);
        make.right.equalTo(header.mas_right);
        make.bottom.equalTo(header.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    return header;
}

- (UIView *)noDataView{
    if (! _noDataView) {
        _noDataView = [[UIView alloc] init];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wushuju.png"]];
        [_noDataView addSubview:img];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.font = CNFont_30px;
        lab.textColor = HexRGB(0x666666);
        lab.text = @"暂无数据";
        [_noDataView addSubview:lab];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.top.equalTo(_noDataView.mas_top).mas_offset([ZAPP.zdevice scaledValue:45]);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView).mas_offset(3);
            
            make.top.equalTo(img.mas_bottom).mas_offset([ZAPP.zdevice scaledValue:35]);
        }];
        
        [self.tableView addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top).mas_offset([ZAPP.zdevice scaledValue:42]);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _noDataView.hidden = YES;
    }
    
    return _noDataView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
