//
//  JieKuanViewController.m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "Jiekuan1.h"
#import "Jiekuan1Cell.h"
#import "JiekuanDetailViewController.h"
#import "LabelsView.h"
#import "JiekuanTableViewCell.h"
#import "PersonHomePage.h"
#import "QuerenHuanxi.h"

//我授信的借款

typedef enum Jiekuan1_CellType {
	Jiekuan1_cell1,
	Jiekuan1_cell2,
	Jiekuan1_cell3
}Jiekuan1_CellType;

@interface Jiekuan1 () {
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

@implementation Jiekuan1

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:@"我的担保"];
    [self setNavButton];
	
	self.view.backgroundColor =ZCOLOR(COLOR_BG_WHITE);
	
	curPage    = 0;
	pageCount  = 0;
	totalCount = 0;
	
	[Util setScrollFooter:self.table target:self footer:@selector(rf)];
	rowCnt = 0;
}

- (Jiekuan1_CellType)getCellType:(NSIndexPath *)index {
	if (index.section % 3 == 0) {
		return Jiekuan1_cell1;
	}
	else if (index.section % 3 == 1) {
		return Jiekuan1_cell2;
	}
	else {
		return Jiekuan1_cell3;
	}
}

- (CGFloat)getHeightWithtype:(NSIndexPath *)index {
	Jiekuan1_CellType ty = [self getCellType:index];
	if (ty == Jiekuan1_cell1) {
		return 300;
	}
	else if (ty == Jiekuan1_cell2) {
		return 190;
	}
	else {
		return 160;
	}
}

- (NSString *)getIdenWithType:(NSIndexPath *)index {
	Jiekuan1_CellType ty = [self getCellType:index];
	if (ty == Jiekuan1_cell1) {
		return @"cell1";
	}
	else if (ty == Jiekuan1_cell2) {
		return @"cell2";
	}
	else {
		return @"cell3";
	}
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[MobClick beginLogPageView:@"我的担保"];
	[self ui];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self.table reloadData];
    
    CGFloat promptViewSpacing = [ZAPP.zdevice getDesignScale:6];
    self.promptView.top = self.view.height - self.promptView.height - promptViewSpacing;
    self.promptView.left = (self.view.width - self.promptView.width)/2;
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
	curPage    = [Util curPage:ZAPP.myuser.gerenMyShouxinLoanList];
	pageCount  = [Util pageCount:ZAPP.myuser.gerenMyShouxinLoanList];
	totalCount = [Util totalCount:ZAPP.myuser.gerenMyShouxinLoanList];
	
	if (curPage == 0) {
		[self.dataArray removeAllObjects];
	}
	
	int cnt = (int)[[ZAPP.myuser.gerenMyShouxinLoanList objectForKey:NET_KEY_LOANCOUNT] intValue];
	if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.gerenMyShouxinLoanList objectForKey:NET_KEY_LOANS]];
	}
	
	rowCnt = [self.dataArray count];
	
	[self.table.header endRefreshing];
	[self.table.footer endRefreshing];
    
    if (! totalCount) {
        self.vLable.hidden = NO;
        [self.vLable setText:@"暂无担保"];
    }else{
        self.vLable.hidden = YES;
    }
    
	[self ui];
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
    self.promptView.text = [NSString stringWithFormat:@"共%@个担保", x];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
	
	progress_show
    
    __weak __typeof__(self) weakSelf = self;
    
    self.op = [ZAPP.netEngine getGerenMyShouxinLoanListWithPageIndex:curPage pagesize:DEFAULT_PAGE_SIZE complete:^{
        [weakSelf setData];
        progress_hide
    } error:^{
        [weakSelf loseData];
        progress_hide
    }
               
        withStage:0 withOrder:0 historic:nil];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.table reloadData];
	if (goDetail) {
		goDetail = NO;
		return;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
	if ([ZAPP.zlogin isLogined]) {
		[self rhAppear];
	}
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[MobClick endLogPageView:@"我的担保"];
	
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
	NSDictionary *dict       = [self.dataArray objectAtIndex:indexPath.section];
	int           loanstatus = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
	int           offset     = (loanstatus != 1 ? 22 : 0);
	LoanState     loanstate  = [UtilString cvtIntToJiekuanState:loanstatus];
	int           of1        = 0;
	int           of2        = 0;
	if (loanstate == JieKuan_WaitingNow) {
		of1 = -30;
	}
	else if (loanstate == JieKuan_GoingNow || loanstate == JieKuan_FinishedNow || loanstate == JieKuan_Refund) {
		of1 = 0;
	}
	else if (loanstate == JieKuan_FinishedAndPayed) {
		of1 = -30;
	}
	
	BOOL shouldRepayForLoan = [self getRepayShould:(int)indexPath.section];
	of2 = shouldRepayForLoan ? 0 : -60;
	
	return [ZAPP.zdevice getDesignScale:320 - offset + of1 + of2];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == -1) {
		LabelsView *v     =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
		CGFloat      limit = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_CREDITLIMIT] doubleValue];
		[v setTexts:@[@"已授信总额度: ", [Util formatRMB:@(limit)]]];
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
	JiekuanTableViewCell *cell;
	static NSString *     CellIdentifier = @"cell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
	
	[cell setJiekuanState:[UtilString cvtIntToJiekuanState:([[dict objectForKey:NET_KEY_LOANSTATUS] intValue])]];
	
	int       loanstatus = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
	LoanState loanstate  = [UtilString cvtIntToJiekuanState:loanstatus];
	
	[cell setChoukuanQi:loanstate != JieKuan_GoingNow];//jie kuan zhong
	
	
	int loanty = [[dict objectForKey:NET_KEY_LOANTYPE] intValue];
	cell.biaoti.text = [NSString stringWithFormat:@"%@%@", [Util getLoantype:loanty], [dict objectForKey:NET_KEY_LOANTITLE]];
//	cell.biaoti.text = [NSString stringWithFormat:@"%@%@[id: %@]", [Util getLoantype:loanty], [dict objectForKey:NET_KEY_LOANTITLE], [dict objectForKey:NET_KEY_LOANID]];

	/**
	 *  我授信的借款，隐藏借款人名称
	 */
	cell.name.text         = [Util getUserRealNameOrNickName:dict];
    
    BOOL shouldHideName = [Util loanShouldHideNameWithDict:dict];
	cell.jiekuanren.hidden = shouldHideName;
	cell.nameButton.hidden = shouldHideName;
	cell.name.hidden       = shouldHideName;
	
	
	cell.deadline.text =  [Util shortDateFromFullFormat:[dict objectForKey:NET_KEY_LOANENDTIME]];//@"2015-03-15";
//    cell.remainDays.text = [Util intWithUnit:[[dict objectForKey:NET_KEY_LOANREMAINDAYCOUNT] intValue] unit:@""];//@"18";
	cell.remainDays.attributedText = [Util getRemainDaysString:dict];
	
	cell.lixi.text        = [Util percentProgress:[[dict objectForKey:NET_KEY_LOANRATE] doubleValue]];//@"10.00%";
	cell.totalamount.text = [Util formatRMB:@([[dict objectForKey:NET_KEY_LOANMAINVAL] doubleValue])];//:@(50*1e3)];
	cell.percent.text     = [Util percentProgress:[[dict objectForKey:NET_KEY_LOANPROGRESS] doubleValue]];// @"25%";
	cell.authpeople.text  = [Util intWithUnit:[[dict objectForKey:NET_KEY_WARRANTYCOUNT ] intValue] unit:@"人"];//@"20人";Ø
	
	int loaddaycnt = [[dict objectForKey:NET_KEY_interestdaycount] intValue];
	cell.returnday.text = [Util intWithUnit:loaddaycnt unit:@"天"];//@"2015-12-31";
	
	cell.nameButton.tag = indexPath.section;
	cell.delegate       = self;
	
	//NSString *userid = [dict objectForKey:NET_KEY_USERID];
	//[cell setNameButtonDisabled:[Util isMyUserID:userid]];
	
	cell.desc1.hidden = NO;
	cell.desc2.hidden = NO;
	
	CGFloat shouxine = [[dict objectForKey:NET_KEY_WARRANTYVAL] doubleValue];
	if (loanstate == JieKuan_WaitingNow) {
		cell.desc1.attributedText = nil;
		cell.desc1.text           = [NSString stringWithFormat:@"在%@还款之前 无法取消对其的授信", @"借款人"];
		[cell setDesc2Disabled:YES];
	}
	else if (loanstate == JieKuan_GoingNow || loanstate == JieKuan_FinishedNow || loanstate == JieKuan_Refund) {
		cell.desc1.text           = @"";
		cell.desc1.attributedText = [self getAttrForShouxin:@(shouxine)];
		cell.desc2.text           = [NSString stringWithFormat:@"在%@还款之前 无法取消对其的授信", @"借款人"];
		[cell setDesc2Disabled:NO];
	}
	else if (loanstate == JieKuan_FinishedAndPayed) {
		cell.desc1.attributedText = nil;
		cell.desc1.text           = [NSString stringWithFormat:@"%@已完成还款，您在此项目中的授信已解冻", @"借款人"];
		[cell setDesc2Disabled:YES];
	}
	
	BOOL shouldRepayForLoan = [self getRepayShould:(int)indexPath.section];
	cell.repayButton.tag = indexPath.section;
	cell.delegate        = self;
	
	[cell setRepaybuttonDisabled:!shouldRepayForLoan];
	
	[cell setNeedsUpdateConstraints];
	[cell setNeedsDisplay];
	[cell setNeedsLayout];
	
	return cell;
}

- (NSAttributedString *)getAttrForShouxin:(NSNumber *)mone {
	NSString *                 monstr = [Util formatRMB:mone];
	NSString *                 allstr =  [NSString stringWithFormat:@"我在此借款中的授信额:%@",monstr];
	NSMutableAttributedString *a      = [Util getAttributedString:allstr font:[UtilFont systemLarge] color:ZCOLOR(COLOR_TEXT_BLACK)];
	[Util setAttributedString:a font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:[allstr rangeOfString:monstr]];
	return a;
}

- (BOOL)getRepayShould:(int)rowhere {
	NSDictionary *dict = [self.dataArray objectAtIndex:rowhere];
	if ([[dict objectForKey:NET_KEY_NEXT_DEBT_ID] intValue] > 0) {
		return YES;
	}
	else {
		return NO;
	}
}

- (void)repayPressed:(int)rowIndexHere {
	goDetail = YES;
	QuerenHuanxi *h = ZSEC(@"QuerenHuanxi");
	h.dataDict  = [self.dataArray objectAtIndex:rowIndexHere];
	h.delegate  = self;
	h.opRowHere = rowIndexHere;
	[self.navigationController pushViewController:h animated:YES];
}

- (void)huankuanOkDonePressed:(int)opRow {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:opRow]];
	[dict setObject:@"0" forKey:NET_KEY_NEXT_DEBT_ID];
	[self.dataArray replaceObjectAtIndex:opRow withObject:dict];
	[self.table reloadData];
}

- (void)nameButtonPressedWithIndex:(int)rowIndexHere {
	goDetail = YES;
	NSDictionary *  betDict = [self.dataArray objectAtIndex:rowIndexHere];
	PersonHomePage *p       = DQC(@"PersonHomePage");
	[p setTheDataDict:betDict];
	[self.navigationController pushViewController:p animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	goDetail = YES;
	JiekuanDetailViewController * detail = ZJKDetail(@"JiekuanDetailViewController");
	//detail.hideNameAlways = YES;//deprecated
	NSDictionary * betDict = [self.dataArray objectAtIndex:indexPath.section];
	detail.dataDict = betDict;
    detail.delegate = self;
	[self.navigationController pushViewController:detail animated:YES];
}

- (NSMutableAttributedString *)getAttr:(NSString *)name money:(NSNumber *)money date:(NSDate *)date {
	return [Util getAttributedString:@"违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息" font:[UtilFont systemSmall] color:ZCOLOR(COLOR_TEXT_GRAY)];
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
