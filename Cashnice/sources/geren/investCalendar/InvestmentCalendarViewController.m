//
//  InvestmentCalendarViewController.m
//  Cashnice
//
//  Created by a on 2017/3/10.
//  Copyright © 2017年 l. All rights reserved.
//

#import "InvestmentCalendarViewController.h"
#import "GFCalendarView.h"
#import "MyLoansListCell.h"
#import "CalendarNetEngine.h"
#import "BillInfoViewController.h"

@interface InvestmentCalendarViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSUInteger curPage;
    NSUInteger tolPage;
    
    BOOL selectedDay;
    NSInteger _year;
    NSInteger _month;
    NSInteger _day;
    
    BOOL loaded;
    
}
@property (weak, nonatomic) IBOutlet UIView *calendarContainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarViewHeight;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@property (strong, nonatomic) CalendarNetEngine *netEngine;
@property (strong, nonatomic) GFCalendarView *calendarView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSArray *contentDayList;

@end

@implementation InvestmentCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"待收回款日历";
    
    [self setNavButton];
    
    [self setupView];
    
    self.scrollView.delegate = self;
    
    curPage = 0;
    
    //self.tableView.bounces = NO;
    
    loaded = YES;
    
}

-(void)setupView{
    CGFloat width = self.view.width-[ZAPP.zdevice getDesignScale:20];
    CGPoint origin = CGPointMake([ZAPP.zdevice getDesignScale:10], 0.0);
    
    _calendarView = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    self.calendarViewHeight.constant = _calendarView.calendarHeight;
    
    WS(weakSelf);
    
    // 点击某一天的回调
    _calendarView.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        
        selectedDay = YES;
        _year = year;
        _month = month;
        _day = day;
        curPage = 0;
        [weakSelf getBetList];
    };
    
    _calendarView.didDisSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        
        selectedDay = NO;
        _year = year;
        _month = month;
        _day = day;
        curPage = 0;
        
        [weakSelf refreshListMonth:[NSString stringWithFormat:@"%zd-%zd-%zd", year, month, day]];
        [weakSelf getBetList];
    };
    
    _calendarView.didSelectMonthHandler = ^(NSInteger year, NSInteger month) {
        
        
        //NSLog(@" %@", [NSString stringWithFormat:@"%zd-%zd", year, month]);
        
        selectedDay = NO;
        _year = year;
        _month = month;
        //_day = day;
        curPage = 0;
        
        [weakSelf refreshListMonth:[NSString stringWithFormat:@"%zd-%zd-01", year, month]];
        [weakSelf getBetList];
    };
    
    [self.calendarContainView addSubview:_calendarView];
    
    
    
    [Util setScrollHeader:self.scrollView target:self header:@selector(refreshBets) dateKey:[Util getDateKey:self]];
    
    [Util setScrollFooter:self.scrollView target:self footer:@selector(loadMoreBets)];
    
    self.promptLabel.font = CNFont_24px;
    self.noDataLabel.font = CNFont_24px;
    
    self.noDataView.hidden = YES;
    
    self.noDataLabel.textColor = CN_TEXT_GRAY_9;
}

-(void)loadMoreBets{
    curPage++;
    [self getBetList];
}

- (void)refreshBets{
    curPage = 0;
    [self getBetList];
    
    if (_day < 1) {
        _day = 1;
    }
    
    [self refreshListMonth:[NSString stringWithFormat:@"%zd-%zd-%zd", _year, _month, _day]];
}

- (void)refreshListMonth:(NSString *)month {
    WS(weakSelf);
    
    
    [self.netEngine betDateList:month success:^(NSArray *contentArray) {
        
        weakSelf.contentDayList = contentArray;
        
        [weakSelf.calendarView setMonthHightPoint:contentArray];
    } failure:^(NSString *e) {
        ;
    }];
    /* */
}

- (void)getBetList{
    WS(weakSelf);
    
    NSString *begin;
    NSString *end;
    
    if (selectedDay) {
        begin = [self formatedYear:_year month:_month day:_day]; //[NSString stringWithFormat:@"%zd-%zd-%zd", _year, _month, _day];
        end = begin;
    }else{
        begin = [NSString stringWithFormat:@"%zd-%zd-01", _year, _month];
        
        NSInteger day = [self howManyDaysInThisYear:_year withMonth:_month];
        
        end = [NSString stringWithFormat:@"%zd-%zd-%zd", _year, _month, day];
    }
    
    if (selectedDay) {
        if(! [self.contentDayList containsObject:begin]){
            //没有数据
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            
            self.noDataView.hidden = NO;
            self.noDataLabel.text = [NSString stringWithFormat:@"当日无待回款"];
            
            self.promptLabel.text = [NSString stringWithFormat:@"当日待收回款：%@",[Util formatRMB:(@(0))]];
            
            [self.scrollView.header endRefreshing];
            [self.scrollView.footer endRefreshing];
            return;
        }
    }
    
    
    if (loaded) {
        progress_show
        loaded = NO;
    }
    [self.netEngine calendarBetListWithBegin:begin end:end page:curPage success:^(NSDictionary *content) {
        [weakSelf refrshTable:content];
        progress_hide
    } failure:^(NSString *e) {
        progress_hide
    }];
    /* */
}

- (NSString *)formatedYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    
    NSString *mStr;
    NSString *mDay;
    
    if (month<10) {
        mStr = [NSString stringWithFormat:@"0%zd", month];
    }else{
        mStr = [NSString stringWithFormat:@"%zd", month];
    }
    if (day<10) {
        mDay = [NSString stringWithFormat:@"0%zd", day];
    }else{
        mDay = [NSString stringWithFormat:@"%zd", day];
    }
    
    return [NSString stringWithFormat:@"%zd-%@-%@", _year, mStr, mDay];
}

- (void)refrshTable:(NSDictionary *)content {
    NSArray *bets = content[@"bets"];
    if (! [bets isKindOfClass:[NSArray class]]) {
        bets = @[];
    }
    tolPage = [content[@"pagecount"] integerValue];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    NSInteger cnt = bets.count;
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:bets];
    }
    
    [self.tableView reloadData];
    
    NSInteger rowCount = [self.dataArray count];
    self.tableViewHeight.constant = rowCount * ceil([ZAPP.zdevice getDesignScale:150.0])+1;
    
    
    [self.scrollView.header endRefreshing];
    [self.scrollView.footer endRefreshing];
    
    if (curPage + 1 >= tolPage) {
        self.scrollView.footer.hidden = YES;
    }else{
        self.scrollView.footer.hidden = NO;
    }
    
    double last_val = [content[@"last_val"] doubleValue];
    NSString *valStr = [Util formatRMB:@(last_val)];
    if (selectedDay) {
        self.promptLabel.text = [NSString stringWithFormat:@"当日待收回款：%@", valStr];
    }else{
        self.promptLabel.text = [NSString stringWithFormat:@"当月待收回款：%@", valStr];
    }
    
    if(bets.count == 0){
        self.noDataView.hidden = NO;
        if (selectedDay) {
            self.noDataLabel.text = [NSString stringWithFormat:@"当日无待回款"];
        }else{
            self.noDataLabel.text = [NSString stringWithFormat:@"当月无待回款"];
        }
    }else{
        self.noDataView.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"投资日历"];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"投资日历"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZAPP.zdevice getDesignScale:150.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *      CellIdentifier = @"MyInvestmentsListCell";
    MyLoansListCell * cell       = (MyLoansListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *betDict = [self.dataArray objectAtIndex:indexPath.item];
    
    [cell updateForInvestment:betDict];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = [_dataArray objectAtIndex:indexPath.item];
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


- (CalendarNetEngine *)netEngine{
    if (! _netEngine) {
        _netEngine = [[CalendarNetEngine alloc] init];
    }
    return _netEngine;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - 获取某年某月的天数
- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

@end
