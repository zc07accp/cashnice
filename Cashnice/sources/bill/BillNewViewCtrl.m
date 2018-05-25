//
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BillNewViewCtrl.h"
#import "BillTableViewCell.h"
#import "BillDetail.h"

#define BILL_SHOUYI_PERCENT_FORMAT @"  (占%d%%)"

@interface BillNewViewCtrl ()
{
	NSInteger rowCnt;
	NSInteger rowHeight;

	int     curPage;
	int     pageCount;
	int     totalCount;
	NSDate *lastDate;

	CGFloat v0, v1;
	CGFloat v2;
	int   v3;
	CGFloat v4;
	int   v5;

	BOOL goDetail;
}

@property (weak, nonatomic) IBOutlet UIView *            detailViewNowHide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_tableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_content_w;
@property (weak, nonatomic) IBOutlet UITableView *       table;
@property (strong, nonatomic)IBOutletCollection(NSLayoutConstraint) NSArray *con_onePixel;
@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *graylabels;
@property (weak, nonatomic) IBOutlet UIView *      headerBgView;
@property (weak, nonatomic) IBOutlet UIView *      middlebar;
@property (weak, nonatomic) IBOutlet UILabel *     zichan;
@property (weak, nonatomic) IBOutlet UILabel *     shouyi;
@property (weak, nonatomic) IBOutlet UILabel *     touzishouyiPercent;
@property (weak, nonatomic) IBOutlet UILabel *     fenghongshouyiPercent;
@property (weak, nonatomic) IBOutlet UILabel *     touzishouyiMoney;
@property (weak, nonatomic) IBOutlet UILabel *     fenghongshouyiMoney;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) MKNetworkOperation * op;
@property (strong, nonatomic) NSMutableArray *     dataArray;

@end

@implementation BillNewViewCtrl

- (void)awakeFromNib {
    [super awakeFromNib];

	self.title = @"我的账单";
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.con_content_w.constant = [ZAPP.zdevice getDesignScale:414];
	// Do any additional setup after loading the view.
	self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
	self.table.backgroundColor = [UIColor clearColor];

	self.detailViewNowHide.hidden = YES;
	rowCnt                        = 0;
	rowHeight                     = 60;
	curPage                       = 0;
	pageCount                     = 0;
	totalCount                    = 0;

	v0 = v1 = v2 = v3 = v4 = v5 = 0;


    [Util setScrollHeader:self.scroll target:self header:@selector(rhManual) dateKey:[Util getDateKey:self]];
	[Util setScrollFooter:self.scroll target:self footer:@selector(rf)];


	for (NSLayoutConstraint *x in self.con_onePixel) {
		[x setToOnePixel];
	}

	for (UILabel *l in self.labels) {
		l.textColor = [UIColor whiteColor];
		l.font      = [UtilFont systemLargeBold];
	}

	for (UILabel *l in self.graylabels) {
		l.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
		l.font      = [UtilFont systemLarge];
	}



	self.headerBgView.backgroundColor = ZCOLOR(COLOR_BILL_BG_YELLOW);
	self.middlebar.backgroundColor    = [UIColor lightTextColor];
}

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

- (void)rhManual {
	curPage = 0;
	[self connectToServer];
}

- (void)rh {
	curPage = 0;
	//[self connectToServer];
	[self.scroll.header beginRefreshing];
}

- (void)rhAppear {
	[self rh];
//    if (lastDate == nil) {
//        [self rh];
//    }
//    else {
//        NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:lastDate];
//        if (t > UPDATE_TIME_INTERVAL) {
//            [self rh];
//        }
//    }
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
	curPage    = [Util curPage:ZAPP.myuser.billDict];
	pageCount  = [Util pageCount:ZAPP.myuser.billDict];
	totalCount = [Util totalCount:ZAPP.myuser.billDict];

	NSDictionary *dict = ZAPP.myuser.billDict;
	v0 = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];//zhanghu yu e
	v1 = [[dict objectForKey:NET_key_profitval] doubleValue];//lei ji shou yi
	v2 = 0;
	v3 = 0;
	v4 = 0;
	v5 = 0;
	//v2 = [[[dict objectForKey:NET_key_profitbet] objectForKey:NET_KEY_VAL] doubleValue];//touzi shouyi
	//v3 = [[[dict objectForKey:NET_key_profitbet] objectForKey:NET_key_ratio] intValue];//touzi zhan bi
	//v4 = [[[dict objectForKey:NET_key_dividendsprofit] objectForKey:NET_KEY_VAL] doubleValue];//fen hong shouyi
	//v5 = [[[dict objectForKey:NET_key_dividendsprofit] objectForKey:NET_key_ratio] intValue];//fen hong zhanbi

	if (curPage == 0) {
		[self.dataArray removeAllObjects];
	}

	int cnt = [[dict objectForKey:NET_KEY_billcount] intValue];
	if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[dict objectForKey:NET_KEY_bills]];

	}

	rowCnt = [self.dataArray count];
	[self.scroll.header endRefreshing];
	[self.scroll.footer endRefreshing];

	[self ui];
}

- (void)loseData {
	[self.scroll.header endRefreshing];
	[self.scroll.footer endRefreshing];
}

- (void)ui {
    CGFloat sum = 0;
    for (int i = 0; i < rowCnt; i++) {
        sum += [self tableView:nil heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
	self.con_tableHeight.constant = sum;
    
	self.scroll.footer.hidden     = ((curPage + 1) >= pageCount);

	self.touzishouyiPercent.text    = [NSString stringWithFormat:BILL_SHOUYI_PERCENT_FORMAT, v3];
	self.fenghongshouyiPercent.text = [NSString stringWithFormat:BILL_SHOUYI_PERCENT_FORMAT, v5];
	self.touzishouyiMoney.text      = [Util formatRMB:@(v2)];
	self.fenghongshouyiMoney.text   = [Util formatRMB:@(v4)];

	self.zichan.text = [Util formatRMB:@(v0)];
	self.shouyi.text = [Util formatRMB:@(v1)];

	[self.table reloadData];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
	        lastDate = [NSDate date];
    
    __weak __typeof__(self) weakSelf = self;

	self.op = [ZAPP.netEngine getBillWithComplete:^{[weakSelf setData]; } error:^{[weakSelf loseData]; } userid:[ZAPP.myuser getUserID] page:curPage pagesize:DEFAULT_PAGE_SIZE];
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的账单"];
[self setNavButton];
	[self ui];
	[self setTitle:@"我的账单"];
	
	
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
	if ([ZAPP.zlogin isLogined]) {
		if (goDetail) {
			goDetail = NO;
		}
		else {
			[self rhAppear];
		}
	}
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"我的账单"];

	[self.op cancel];
	self.op = nil;
	[self loseData];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return rowCnt;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0;
}
- (BOOL)lastRow:(NSInteger)row {
	return row == rowCnt - 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    NSString *s = [dict objectForKey:NET_KEY_TEXT];
    CGRect thefr = [s boundingRectWithSize:CGSizeMake([ZAPP.zdevice getDesignScale:340], 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UtilFont systemLarge]} context:nil];
//    CGSize si = [s sizeWithFont:[UtilFont systemLarge] constrainedToSize:CGSizeMake([ZAPP.zdevice getDesignScale:340], 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize si = thefr.size;
    CGFloat ff = [ZAPP.zdevice getDesignScale:rowHeight + si.height * 1.2];
	return ff;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BillTableViewCell *cell;
	static NSString *  CellIdentifier = @"cell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];

	NSString *imgaddr = [dict objectForKey:NET_KEY_FROMUSERHEADIMG];
    [cell.img setHeadImgeUrlStr:imgaddr];
	int       state    = [[dict objectForKey:NET_KEY_ACTIONstatus] intValue];
	NSString *datetime = [dict objectForKey:NET_KEY_accounttime];

	//CGFloat money = [[dict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];
	//NSString *moneystr = [Util formatRMB:@(money)];
	NSString *strstr = [dict objectForKey:NET_KEY_TEXT];

	cell.nameLabel.text = strstr;//[NSString stringWithFormat:@"%@  %@", strstr, moneystr];
	cell.dateLabel.text = [Util shortDateFromFullFormat:datetime];
	//cell.moneyLabel.text = [Util formatPositiveMoney:@(5*1e3) positive:(indexPath.row % 2 == 0)];
	cell.moneyLabel.hidden = YES;
	cell.tradeState.text   = (state == 1 ? @"交易成功" : @"交易失败");
	cell.tradeState.hidden = YES;

	cell.sepLine.hidden = [self lastRow:indexPath.row];

	return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	BillDetail *e = ZBill(@"BillDetail");
	goDetail = YES;
	NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
	e.billID  = [dict objectForKey:NET_KEY_NOTCEID];
	e.headImg = [dict objectForKey:NET_KEY_FROMUSERHEADIMG];
	[self.navigationController pushViewController:e animated:YES];
}
@end
