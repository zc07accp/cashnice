//
//  JieKuanViewController.m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

//我的借款

#import "Jiekuan3.h"
#import "Jiekuan2Cell.h"
#import "JiekuanDetailViewController.h"
#import "QuerenHuanxi.h"
#import "LabelsView.h"
#import "JiekuanTableViewCell.h"
#import "QuerenHuanxi.h"
#import "NewBorrowViewController.h"
#import "NoLevel.h"
#import "YaoqingHaoyou.h"
#import "ShouxinList.h"
#import "SendLoanViewController.h"

typedef enum Jiekuan2_CellType {
	Jiekuan2_cell1,
	Jiekuan2_cell2
}Jiekuan2_CellType;

@interface Jiekuan3 () {
	NSInteger rowCnt;
	int       curPage;
	int       pageCount;
	int       totalCount;
	NSDate *  lastDate;

	BOOL goDetail;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *    dataArray;

@property (strong, nonatomic) UILabel *vLable;
@property (strong, nonatomic) UILabel *promptView;
@end

@implementation Jiekuan3

BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setTitle:@"我的借款"];
    [self setNavButton];

	self.view.backgroundColor =ZCOLOR(COLOR_BG_WHITE);
	rowCnt                    = 0;
	curPage                   = 0;
	pageCount                 = 0;
	totalCount                = 0;

    [Util setScrollHeader:self.table target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
	[Util setScrollFooter:self.table target:self footer:@selector(rf)];
}
- (void)setNavButton {
    
    UIView *containerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 90)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(customNavBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, -7, 40, 40);
 
    [containerView2 addSubview:backBtn];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width=-20.0f;
    [self.navigationItem setLeftBarButtonItems:@[space, [[UIBarButtonItem alloc] initWithCustomView:containerView2]]];
}


- (void)viewDidLayoutSubviews{
    CGFloat promptViewSpacing = [ZAPP.zdevice getDesignScale:6];
    self.promptView.top = self.view.height - self.promptView.height - promptViewSpacing;
    self.promptView.left = (self.view.width - self.promptView.width)/2;
}


- (void)nameButtonPressedWithIndex:(int)rowIndexHere {
	//
}

- (void)huanKuanPressed:(int)rowIndexHere {
    goDetail = YES;
	QuerenHuanxi *h = ZSEC(@"QuerenHuanxi");
    h.delegate = self;
    h.opRowHere = rowIndexHere;
	h.dataDict = [self.dataArray objectAtIndex:rowIndexHere];
	[self.navigationController pushViewController:h animated:YES];
}

- (void)huankuanOkDonePressed:(int)opRow {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:opRow]];
    [dict setObject:@"0" forKey:NET_KEY_debtstartrepay];
    [dict setObject:@"0" forKey:NET_KEY_failuredrepaymentid];
    [self.dataArray replaceObjectAtIndex:opRow withObject:dict];
    [self.table reloadData];
}

- (Jiekuan2_CellType)getCellType:(NSIndexPath *)index {
	if (index.section % 2 == 0) {
		return Jiekuan2_cell1;
	}
	else {
		return Jiekuan2_cell2;
	}
}

- (void)changeTabToGeren {
    
}


- (CGFloat)getHeightWithtype:(NSIndexPath *)index {
	Jiekuan2_CellType ty = [self getCellType:index];
	if (ty == Jiekuan2_cell1) {
		return 355;
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//[@"jie kuan" toast];
    [MobClick beginLogPageView:@"我的借款"];
	[self ui];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
	curPage    = [Util curPage:ZAPP.myuser.gerenMyLoanList];
	pageCount  = [Util pageCount:ZAPP.myuser.gerenMyLoanList];
	totalCount = [Util totalCount:ZAPP.myuser.gerenMyLoanList];

	if (curPage == 0) {
		[self.dataArray removeAllObjects];
	}

	int cnt = (int)[[ZAPP.myuser.gerenMyLoanList objectForKey:NET_KEY_LOANCOUNT] intValue];
	if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.gerenMyLoanList objectForKey:NET_KEY_LOANS]];
	}

	rowCnt = [self.dataArray count];
	[self.table.header endRefreshing];
	[self.table.footer endRefreshing];
    
    if (! totalCount) {
        self.vLable.hidden = NO;
        [self.vLable setText:@"暂无借款"];
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
    self.promptView.text = [NSString stringWithFormat:@"共%@个借款", x];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
    progress_show
	self.op = [ZAPP.netEngine getGerenMyLoanListWithPageIndex:curPage pagesize:DEFAULT_PAGE_SIZE complete:^{[self setData];progress_hide } error:^{[self loseData]; progress_hide}];
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

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"我的借款"];

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
	return [ZAPP.zdevice getDesignScale:(section == rowCnt - 1) ? 20: 0];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *dict       = [self.dataArray objectAtIndex:indexPath.section];
	int           loanstatus = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
	int           offset     = (loanstatus != 1 ? 22 : 0);
	int           offset2    = (loanstatus == 2 ? 200 : 0);
    int of = (loanstatus == 3 ? 150 : 0);
    //重新编辑按钮 不显示了
    int           offset3    = 0;//(loanstatus == -1 || loanstatus == 4 || loanstatus == 5) ? 30 : 0;
	return [ZAPP.zdevice getDesignScale:200 + offset2- offset + offset3 + of];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	if (section == 0) {
//		LabelsView *v =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
//		NSString *  x = [Util intWithUnit:(int)totalCount unit:@""];
//		[v setTexts:@[@"共", x, @"个借款"]];
//        
//    v.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
//		return v;
//	}
//	else {
		UIView *v = [UIView new];
		v.userInteractionEnabled = NO;
		v.backgroundColor        = [UIColor clearColor];
		return v;
//	}
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

	int loanty = [[dict objectForKey:NET_KEY_LOANTYPE] intValue];
	cell.biaoti.text = [NSString stringWithFormat:@"%@%@", [Util getLoantype:loanty], [dict objectForKey:NET_KEY_LOANTITLE]];

	int loanstatus = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
	[cell setChoukuanQi:loanstatus !=1];

	cell.name.text     = [Util getUserRealNameOrNickName:dict];
	cell.deadline.text =  [Util shortDateFromFullFormat:[dict objectForKey:NET_KEY_LOANENDTIME]];//@"2015-03-15";
//    cell.remainDays.text = [Util intWithUnit:[[dict objectForKey:NET_KEY_LOANREMAINDAYCOUNT] intValue] unit:@""];//@"18";
	cell.remainDays.attributedText = [Util getRemainDaysString:dict];

	cell.lixi.text        = [Util percentProgress:[[dict objectForKey:NET_KEY_LOANRATE] doubleValue]];//@"10.00%";
	cell.totalamount.text = [Util formatRMB:@([[dict objectForKey:NET_KEY_LOANMAINVAL] doubleValue])];//:@(50*1e3)];
	cell.percent.text     = [Util percentProgress:[[dict objectForKey:NET_KEY_LOANPROGRESS] doubleValue]];// @"25%";
	cell.authpeople.text  = [Util intWithUnit:[[dict objectForKey:NET_KEY_WARRANTYCOUNT ] intValue] unit:@"人"];//@"20人";Ø

	int loaddaycnt = [[dict objectForKey:NET_KEY_interestdaycount] intValue];
	cell.returnday.text = [Util intWithUnit:loaddaycnt unit:@"天"];//@"2015-12-31";

	cell.nameButton.tag     = indexPath.section;
	cell.huanKuanButton.tag = indexPath.section;
	cell.reFabuButton.tag   = indexPath.section;
	cell.delegate           = self;

	CGFloat   f1 = [[dict objectForKey:NET_KEY_LOANMAINVAL] doubleValue];
	CGFloat   f2 = [[dict objectForKey:NET_KEY_repayableinterestval] doubleValue];
	CGFloat   f3 = [[dict objectForKey:NET_KEY_FEEval] doubleValue];
	CGFloat   f4 = [[dict objectForKey:NET_KEY_ALLOWANCEval] doubleValue];
	CGFloat   f5 = [[dict objectForKey:NET_KEY_repayableval] doubleValue];
	CGFloat   f6 = [[dict objectForKey:@"nextdebtrepayval"] doubleValue];
	NSString *f7 = [dict objectForKey:@"nextdebtrepaystarttime"];
	f7 = [Util shortDateFromFullFormat:f7];

	cell.lll1.text = [Util formatRMB:@(f1)];
	cell.lll2.text = [Util formatRMB:@(f2)];
	cell.lll3.text = [Util formatRMB:@(f3)];
	cell.lll4.text = [Util formatRMB:@(f4)];
	cell.lll5.text = [Util formatRMB:@(f5)];
	cell.lll6.text = [Util formatRMB:@(f6)];
	cell.lll7.text = [NSString stringWithFormat:@"%@还款:", f7];
	BOOL jieman = loanstatus == 2;
	cell.lll1.hidden           = !jieman;
	cell.lll2.hidden           = !jieman;
	cell.lll3.hidden           = !jieman;
	cell.lll4.hidden           = !jieman;
	cell.lll5.hidden           = !jieman;
	cell.lll6.hidden           = !jieman;
	cell.lll7.hidden           = !jieman;
	cell.huanKuanButton.hidden = !jieman;
    cell.lefttitlelabelsview.hidden = !jieman;
    
    if (loanstatus == 3) {
        cell.lefttitlelabelsview.hidden = NO;
        cell.lll1.hidden           = NO;
        cell.lll2.hidden           = NO;
        cell.lll3.hidden           = NO;
        cell.lll4.hidden           = NO;
        cell.lll5.hidden           = NO;
    }
    
    
    BOOL canReapy = [Util canRepay:dict];

    cell.huanKuanButton.enabled = canReapy;
	[cell.huanKuanButton setBackgroundColor:ZCOLOR(canReapy ? COLOR_BUTTON_RED : COLOR_TEXT_LIGHT_GRAY)];
    
    BOOL hasFail = [Util hasFailDebt:dict];
    if (hasFail) {//还款失败
        cell.desc_my_loan.text = @"还款失败";
        cell.desc_my_loan.textColor = ZCOLOR(COLOR_BUTTON_RED);
        cell.desc_my_loan.hidden = NO;
        cell.lll7.text = [NSString stringWithFormat:@"%@追补还款:", f7];
        cell.huanKuanButton.enabled = YES;
    }
    else {
        cell.desc_my_loan.hidden = YES;
    }

    //重新编辑按钮 不显示了
    cell.reFabu.hidden = YES;
    /*
    LoanState lsate = [UtilString cvtIntToJiekuanState:loanstatus];
	if (lsate == JieKuan_FailNow) {//审核失败
		cell.reFabu.hidden = NO;
		[cell.reFabuButton setTitle:@"重新编辑" forState:UIControlStateNormal];
	}
	else if (loanstatus == 4 || loanstatus == 5) {//借款人关闭，未筹满关闭
		cell.reFabu.hidden = NO;
		[cell.reFabuButton setTitle:@"复制并发布" forState:UIControlStateNormal];
	}
	else {
		cell.reFabu.hidden = YES;
	}
    */
//	NSString *userid = [dict objectForKey:NET_KEY_USERID];
//	[cell setNameButtonDisabled:[Util isMyUserID:userid]];

	return cell;

}

- (void)setDataToTemp:(int)rowIndexHere isnew:(BOOL)isNew {
	[ZAPP.myuser fabuClear];
	NSDictionary *dict = [self.dataArray objectAtIndex:rowIndexHere];

	if (!isNew) {
		[ZAPP.myuser fabuSetLoanId:[dict objectForKey:NET_KEY_LOANID]];
	}
	int ty = 0;
	if ([[dict objectForKey:NET_KEY_LOANTYPE] intValue] == 0) {//gong kai
		ty = 1;
	}
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:NET_KEY_PURPUSE] forKey:def_key_fabu_yongtu];
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:NET_KEY_LOANTITLE] forKey:def_key_fabu_name];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", (int)([[dict objectForKey:NET_KEY_LOANMAINVAL] intValue]/1e4) ] forKey:def_key_fabu_money];
    
    int borrDay = [[dict objectForKey:NET_KEY_LOANDAYCOUNT] intValue];
    int se = 0;
    if (borrDay == 5) {
        se = 1;
    }
    else if (borrDay == 7) {
        se = 2;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(se) forKey:def_key_fabu_borrow_day];
    [[NSUserDefaults standardUserDefaults] setObject:[Util cutMoney:[NSString stringWithFormat:@"%f", [[dict objectForKey:NET_KEY_LOANRATE] doubleValue]]] forKey:def_key_fabu_lixi];
    [[NSUserDefaults standardUserDefaults] setObject:@(ty) forKey:def_key_fabu_friend_type];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", [[dict objectForKey:NET_KEY_interestdaycount] intValue]] forKey:def_key_fabu_huankuan_day];

    [self connectToLoadAttach:[dict objectForKey:NET_KEY_LOANID]];
}

- (void)setDataAttach {
  	int fujiancnt = [[[ZAPP.myuser loanDetailAttachmentList] objectForKey:NET_KEY_attachmentcount] intValue];
    if (fujiancnt > 0) {
    NSArray *arr = [ZAPP.myuser.loanDetailAttachmentList objectForKey:NET_KEY_ATTACHMENTS];
        if ([arr count] == fujiancnt) {
            for (NSDictionary *dict in arr) {
                [ZAPP.myuser fabuAddFujian:dict];
            }
        }
        
    }
    
    
    [self borrowPressed];
}

- (void)loseDataAttach {
	[Util toast:@""];
}

- (void)connectToLoadAttach:(NSString *)loanid {
	[self.op cancel];
	bugeili_net
    progress_show
	self.op = [ZAPP.netEngine getLoanDetailAttachmentsWithLoanID:loanid complete:^{[self setDataAttach]; progress_hide} error:^{[self loseDataAttach]; progress_hide}];
}

- (void)borrowPressed {
    goDetail = YES;
    UIViewController *borrow = SENDLOANSTORY(@"SendLoanViewController");
    [self.navigationController pushViewController:borrow animated:YES];
}


- (void)refabuPressed:(int)rowIndexHere {
    BOOL noUserLevel = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_USERLEVEL] intValue] == 0);
    BOOL noRemain    = ([ZAPP.myuser getRemainLoanLimit] == 0);
    BOOL inBlackList = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_BLOCKTYPE] intValue] == 3);
    if (noUserLevel) {
        NoLevel *borrow = ZSTORY(@"NoLevel");
        [self.navigationController pushViewController:borrow animated:YES];
        return;
    }
    if (inBlackList) {
        [Util toast:@"您已进入Cashnice黑名单，无法发布借款。"];
        return;
    }
    if (![ZAPP.myuser satisfyFriendNum]) {
        [Util toast:[NSString stringWithFormat:@"%@",[ZAPP.myuser infoNotFriendNum]]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[ZAPP.myuser infoNotFriendNum] message:@"请邀请好友或索要授信!" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"邀请好友", @"索要授信", nil];
//        [alert show];
        return;
    }
    if (noRemain) {
        [Util toast:@"借款额度为0，无法发布借款。"];
        return;
    }
    
	NSMutableDictionary *dictCopied       = [[self.dataArray objectAtIndex:rowIndexHere] mutableCopy];
    goDetail = YES;
    SendLoanViewController *borrow = SENDLOANSTORY(@"SendLoanViewController");
    
    int loanstatus = [[dictCopied objectForKey:NET_KEY_LOANSTATUS] intValue];
	if (loanstatus == -1) {
        //重新编辑
		//[self setDataToTemp:rowIndexHere isnew:NO];
        borrow.loanDictRedistributed = dictCopied;
	}
	else if (loanstatus == 4 || loanstatus == 5) {
        //复制并发布
		//[self setDataToTemp:rowIndexHere isnew:YES];
        [dictCopied setObject:@"" forKey:NET_KEY_LOANID];
        borrow.loanDictRedistributed = dictCopied;
	}
    [self.navigationController pushViewController:borrow animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (buttonIndex == 1) {
            YaoqingHaoyou *y = ZSTORY(@"YaoqingHaoyou");
            [self.navigationController pushViewController:y animated:YES];
        }
        else if (buttonIndex == 2) {
            ShouxinList *s = ZSEC(@"ShouxinList");
            [s setShowXintype:ShouXin_MeiYou];
            [self.navigationController pushViewController:s animated:YES];
        }
    }
}

- (void)huanRowDone:(int)rowHere {
    [self huankuanOkDonePressed:rowHere];
 
}

- (NSMutableAttributedString *)getAttr:(NSString *)name money:(NSNumber *)money date:(NSDate *)date {
	return [Util getAttributedString:@"违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息违约信息" font:[UtilFont systemSmall] color:ZCOLOR(COLOR_TEXT_GRAY)];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	goDetail = YES;
	JiekuanDetailViewController * detail  = ZJKDetail(@"JiekuanDetailViewController");
    detail.delegate = self;
	NSDictionary *                betDict = [self.dataArray objectAtIndex:indexPath.section];
	detail.dataDict = betDict;
    detail.opRowHuankuan = (int)indexPath.section;
	[self.navigationController pushViewController:detail animated:YES];
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
