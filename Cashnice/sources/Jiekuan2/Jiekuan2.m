//
//  JieKuanViewController.m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

//我的投资

#import "Jiekuan2.h"
#import "Jiekuan2Cell.h"
#import "JiekuanDetailViewController.h"
#import "LabelsView.h"
#import "JiekuanDetailViewController.h"
#import "PersonHomePage.h"
#import "WoDingdanDetail.h"
#import "QuerenTouzi.h"


typedef enum Jiekuan2_CellType {
	Jiekuan2_cell1,
	Jiekuan2_cell2
}Jiekuan2_CellType;

@interface Jiekuan2 () <JiekuanDetailViewControllerDelegate>{
	NSInteger rowCnt;

	int     curPage;
	int     pageCount;
	int     totalCount;
	NSDate *lastDate;

	BOOL goDetail;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *    dataArray;

@property (strong, nonatomic) UILabel *vLable;
@property (strong, nonatomic) UILabel *promptView;
@end

@implementation Jiekuan2

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"我的投资";
    [self setNavButton];

	self.view.backgroundColor =ZCOLOR(COLOR_BG_WHITE);
	rowCnt                    = 0;

	curPage    = 0;
	pageCount  = 0;
	totalCount = 0;

    [Util setScrollHeader:self.table target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
	[Util setScrollFooter:self.table target:self footer:@selector(rf)];
}

- (void)viewDidLayoutSubviews{
    CGFloat promptViewSpacing = [ZAPP.zdevice getDesignScale:6];
    self.promptView.top = self.view.height - self.promptView.height - promptViewSpacing;
    self.promptView.left = (self.view.width - self.promptView.width)/2;
    [self.view layoutIfNeeded];
}

- (Jiekuan2_CellType)getCellType:(NSIndexPath *)index {
	if (index.section % 2 == 0) {
		return Jiekuan2_cell1;
	}
	else {
		return Jiekuan2_cell1;
	}
}

- (CGFloat)getHeightWithtype:(NSIndexPath *)index {
	Jiekuan2_CellType ty = [self getCellType:index];
	if (ty == Jiekuan2_cell1) {
		return 320;
	}
	else {
		return 220;
	}
}

- (NSString *)getIdenWithType:(NSIndexPath *)index {
	Jiekuan2_CellType ty = [self getCellType:index];
	if (ty == Jiekuan2_cell1) {
		return @"cell1";
	}
	else {
		return @"cell2";
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)rhManul {
	curPage = 0;
	[self connectToServer];
}

- (void)rh {
	curPage = 0;
	[self connectToServer];
	//[self.table.header beginRefreshing];
}

- (void)rhAppear {
	[self rh];
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
	curPage    = [Util curPage:ZAPP.myuser.gerenMyBetList];
	pageCount  = [Util pageCount:ZAPP.myuser.gerenMyBetList];
	totalCount = [Util totalCount:ZAPP.myuser.gerenMyBetList];

	if (curPage == 0) {
		[self.dataArray removeAllObjects];
	}

	int cnt = (int)[[ZAPP.myuser.gerenMyBetList objectForKey:NET_KEY_BETScount] intValue];
	if (cnt > 0) {
         [self.dataArray insertPage:curPage objects:[ZAPP.myuser.gerenMyBetList objectForKey:NET_KEY_BETS]];
	}

	rowCnt = [self.dataArray count];
	[self.table.header endRefreshing];
	[self.table.footer endRefreshing];

    if (! totalCount) {
        self.vLable.hidden = NO;
        [self.vLable setText:@"暂无投资"];
    }else{
        self.vLable.hidden = YES;
    }
    
	[self performSelectorOnMainThread:@selector(ui) withObject:nil waitUntilDone:YES];
}

- (void)loseData {
	[self.table.header endRefreshing];
	[self.table.footer endRefreshing];
}

- (void)ui {
	self.table.footer.hidden = ((curPage + 1) >= pageCount);
	[self.table reloadData];
	if (curPage == 0) {
		//self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	}
    NSString *  x = [Util intWithUnit:(int)totalCount unit:@""];
    self.promptView.text = [NSString stringWithFormat:@"共%@个投资", x];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
	progress_show
	self.op = [ZAPP.netEngine getGerenMyBetListWithPageIndex:curPage pagesize:DEFAULT_PAGE_SIZE complete:^{
        [self setData]; progress_hide
    } error:^{
        [self loseData]; progress_hide
    } withStage:0 withOrder:0];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的投资"];
	[self ui];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if (goDetail) {
		goDetail = NO;
		return;
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
	if ([ZAPP.zlogin isLogined]) {
		[self rhAppear];
	}

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"我的投资"];

	[self.op cancel];
	self.op = nil;
	[self loseData];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return rowCnt;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return [ZAPP.zdevice getDesignScale:(section == 0) ? 0 : 20];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return [ZAPP.zdevice getDesignScale:(section == rowCnt - 1) ? 20 : 0];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *betDict    = [self.dataArray objectAtIndex:indexPath.section];
	NSDictionary *dict       = [betDict objectForKey:NET_KEY_LOAN];
	int           loanstatus = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
	int           offset     = (loanstatus != 1 ? 22 : 0);
	return [ZAPP.zdevice getDesignScale:320 - offset];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		LabelsView *v =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
		NSString *  x = [Util intWithUnit:(int)totalCount unit:@""];
		[v setTexts:@[@"共", x, @"个投资"]];
        v.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
		return v;
	}
	else {
		UIView *v = [UIView new];
		v.userInteractionEnabled = NO;
		v.backgroundColor        = [UIColor clearColor];
		return v;
	}
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Jiekuan2Cell *cell;
	cell = [tableView dequeueReusableCellWithIdentifier:[self getIdenWithType:indexPath]];

	NSDictionary *betDict = [self.dataArray objectAtIndex:indexPath.section];

	BetType       betstatus = [UtilString cvtIntToBetState:[[betDict objectForKey:NET_KEY_BETSTATUS] intValue]];
	NSDictionary *dict      = [betDict objectForKey:NET_KEY_LOAN];

	int state = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
	[cell setJiekuanState:(LoanState)state];

	int loanstatus = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
	[cell setChoukuanQi:loanstatus !=1];

	int loanty = [[dict objectForKey:NET_KEY_LOANTYPE] intValue];
	cell.biaoti.text = [NSString stringWithFormat:@"%@%@", [Util getLoantype:loanty], [dict objectForKey:NET_KEY_TITLE]];
	//cell.biaoti.text = [NSString stringWithFormat:@"%@%@[betid: %@]", [Util getLoantype:loanty], [dict objectForKey:NET_KEY_TITLE], [betDict objectForKey:NET_KEY_BETID]];

	BOOL shouldHideName = [Util loanShouldHideNameWithDict:dict];
    
	cell.name.hidden       = shouldHideName;
	cell.jiekuanren.hidden = shouldHideName;
	cell.nameButton.hidden = shouldHideName;

	cell.name.text     = [Util getUserRealNameOrNickName:dict];
	cell.deadline.text =  [Util shortDateFromFullFormat:[dict objectForKey:NET_KEY_LOANENDTIME]];//@"2015-03-15";
//    cell.remainDays.text = [Util intWithUnit:[[dict objectForKey:NET_KEY_LOANREMAINDAYCOUNT] intValue] unit:@""];//@"18";
	cell.remainDays.attributedText = [Util getRemainDaysString:dict];

	cell.lixi.text        = [Util percentProgress:[[dict objectForKey:NET_KEY_LOANRATE] doubleValue]];//@"10.00%";
	cell.totalamount.text = [Util formatRMB:@([[dict objectForKey:NET_key_planmainval] doubleValue])];//:@(50*1e3)];
	cell.percent.text     = [Util percentProgress:[[dict objectForKey:NET_key_progress] doubleValue]];// @"25%";
	cell.authpeople.text  = [Util intWithUnit:[[dict objectForKey:NET_KEY_WARRANTYCOUNT ] intValue] unit:@"人"];//@"20人";

	int loaddaycnt = [[dict objectForKey:NET_KEY_interestdaycount] intValue];
	cell.returnday.text = [Util intWithUnit:loaddaycnt unit:@"天"];//@"2015-12-31";

	NSString *touzishijian = [betDict objectForKey:NET_KEY_BETTIME];
	CGFloat    touzijine    = [[betDict objectForKey:NET_KEY_BETVAL] doubleValue];
//    CGFloatyujishouyi = [[dict objectForKey:NET_KEY_repayableinterestval] doubleValue];
	CGFloat yujishouyi = [[betDict objectForKey:@"receivableinterestval"] doubleValue];

//    cell.touzizhuangtai.text = [Util shortDateFromFullFormat:touzishijian];
	cell.touzizhuangtai.text = touzishijian;

	cell.shifubenjin.text = [Util formatRMB:@(touzijine)];
	cell.yujishouyi.text  = [Util formatRMB:@(yujishouyi)];
	cell.dingdanhao.text  = [betDict objectForKey:NET_KEY_ORDERNO];

	cell.rowIndex = (int)indexPath.section;
	cell.delegate = self;

	NSString *userid = [dict objectForKey:NET_KEY_USERID];
	[cell setNameButtonDisabled:[Util isMyUserID:userid]];

	[cell.kefuButton setTitle:[UtilString getBetStateString:betstatus] forState:UIControlStateNormal];
	cell.kefuButton.hidden = (betstatus == Bet_BetFinished);
	[cell.kefuButton setTitleColor:ZCOLOR((betstatus == Bet_BetFailed) ? COLOR_BUTTON_RED : COLOR_BUTTON_BLUE) forState:UIControlStateDisabled];

	if (betstatus == Bet_Processing) {
		[cell.dingdanButton setTitle:@"查看订单详情" forState:UIControlStateNormal];
		[cell setDingdanButtonDisabled:YES];
	}
	else if (betstatus == Bet_BetFinished) {
		[cell.dingdanButton setTitle:@"查看订单详情" forState:UIControlStateNormal];
		[cell setDingdanButtonDisabled:NO];
	}
	else if (betstatus == Bet_BetFailed && loanstatus == JieKuan_GoingNow) {
		[cell.dingdanButton setTitle:@"继续投资" forState:UIControlStateNormal];
		[cell setDingdanButtonDisabled:NO];//追补投资
		[cell.dingdanButton setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
	}
	else if (betstatus == Bet_LoanClosedAndRefunded) {
		[cell.dingdanButton setTitle:@"查看订单详情" forState:UIControlStateNormal];
		[cell setDingdanButtonDisabled:NO];
	}
	else if (betstatus == Bet_RefundFail) {
		[cell.dingdanButton setTitle:@"查看订单详情" forState:UIControlStateNormal];
		[cell setDingdanButtonDisabled:YES];
	}
	else if (betstatus == Bet_Refunding) {
		[cell.dingdanButton setTitle:@"查看订单详情" forState:UIControlStateNormal];
		[cell setDingdanButtonDisabled:NO];
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	goDetail = YES;
	JiekuanDetailViewController * detail  = ZJKDetail(@"JiekuanDetailViewController");
	NSDictionary *                betDict = [self.dataArray objectAtIndex:indexPath.section];
	detail.dataDict = [betDict objectForKey:NET_KEY_LOAN];
    detail.delegate = self;
	[self.navigationController pushViewController:detail animated:YES];
}

- (void)namePressed:(int)rowIndex {
	goDetail = YES;
	NSDictionary *  betDict = [self.dataArray objectAtIndex:rowIndex];
	NSDictionary *  dict    = [betDict objectForKey:NET_KEY_LOAN];
	PersonHomePage *p       = DQC(@"PersonHomePage");
	[p setTheDataDict:dict];
	[self.navigationController pushViewController:p animated:YES];
}

- (void)detailPressed:(int)rowIndex {
	NSDictionary *betDict  = [self.dataArray objectAtIndex:rowIndex];
	int           bettype  = [[betDict objectForKey:NET_KEY_BETSTATUS] intValue];
	BetType       betstate = [UtilString cvtIntToBetState:bettype];
	if (betstate == Bet_BetFailed) {
		QuerenTouzi *q = ZJKDetail(@"QuerenTouzi");
		[q setTheDataDict:[betDict objectForKey:NET_KEY_LOAN]];
		q.betid = [betDict objectForKey:NET_KEY_BETID];
        q.fromTouzi = YES;
        q.delegate  = self;
		[self.navigationController pushViewController:q animated:YES];
	}
	else {
		goDetail = YES;
		WoDingdanDetail *e = ZBill(@"WoDingdanDetail");
		e.betDict = [self.dataArray objectAtIndex:rowIndex];
		[self.navigationController pushViewController:e animated:YES];
	}
}

- (void)touziOkDone {
    //[self rh];
}

- (void)changeTabToGeren {
    
}

- (NSMutableAttributedString *)getAttr:(NSString *)name money:(NSNumber *)money date:(NSDate *)date {
	return [Util getAttributedString:@"违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息" font:[UtilFont systemSmall] color:ZCOLOR(COLOR_TEXT_GRAY)];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
        _promptView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [ZAPP.zdevice getDesignScale:100], [ZAPP.zdevice getDesignScale:24])];
        _promptView.backgroundColor = ZCOLOR(COLOR_SEPERATOR_COLOR);
        _promptView.textAlignment = NSTextAlignmentCenter;
        
        CGFloat cornerRadius = [ZAPP.zdevice getDesignScale:3];
        _promptView.layer.cornerRadius = cornerRadius;
        _promptView.layer.masksToBounds = YES;
        _promptView.hidden = YES;
        [self.view addSubview:_promptView];
        
        _promptView.font = [UtilFont systemLargeNormal];
        _promptView.textColor = [UIColor whiteColor];
    }
    return _promptView;
}

- (UILabel *)vLable{
    if (! _vLable) {
        _vLable = [[UILabel alloc] initWithFrame:self.view.bounds];
        _vLable.height = self.view.height/2;
        _vLable.textAlignment = NSTextAlignmentCenter;
        _vLable.font = [UIFont systemFontOfSize:20.0f];
        _vLable.textColor = ZCOLOR(@"#555555");
        _vLable.hidden = YES;
        [self.table addSubview:_vLable];
    }
    return  _vLable;
}

@end
