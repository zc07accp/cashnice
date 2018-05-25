//
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "AllShouxinPeople.h"
#import "ShouxinCell.h"
#import "ShouXinRenCell.h"
#import "SeachHaoyouViewController.h"
#import "YaoqingHaoyou.h"
#import "PersonHomePage.h"
#import "LabelsView.h"
#import "QuerenTouzi.h"
#import "CNActionButton.h"
#import "InvestmentAction.h"
#import "GuarantorCell.h"
#import "GuarantorSectionCell.h"

@interface AllShouxinPeople () {
	NSInteger   rowCnt;
	NSInteger   rowHeight;
	ShouXinType _type;

	int curPage;
	int pageCount;
	int totalCount;

	NSInteger opRow;
    
    BOOL willGoDetail;
    
    int mLoanID;
    NSInteger surplusValue;
    NSDictionary *loanDict;
    
    CGFloat investViewHeightOffset;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *    dataArray;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *investmentButton;

@property (strong, nonatomic) UILabel *promptView;
@property (weak, nonatomic) IBOutlet UIView *investView;
@property (weak, nonatomic) IBOutlet UILabel *investLabel;
@property (weak, nonatomic) IBOutlet CNActionButton *investButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investViewHeight;

@end

@implementation AllShouxinPeople

- (void)setShowXintype:(ShouXinType)ty {
	_type = ty;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor  = ZCOLOR(COLOR_DD_GRAY);
	self.table.backgroundColor = [UIColor clearColor];
	[self.table setSeparatorInset:UIEdgeInsetsZero];

	rowCnt    = 0;
	rowHeight = 90;

	curPage    = 0;
	pageCount  = 0;
	totalCount = 0;

	[Util setScrollHeader:self.table target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
	[Util setScrollFooter:self.table target:self footer:@selector(rf)];

    [self setupUI];
    
    //hidden
    self.investViewHeight.constant = 0;
    self.investView.hidden = YES;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self layoutPromptView];
    [self setupUI];
}

- (void)setupUI{
    
    surplusValue = [[loanDict objectForKey:NET_KEY_LOANMAINVAL] integerValue] - [[loanDict objectForKey:NET_KEY_LOANEDMAINVAL] integerValue];
    NSInteger loanSatus = [loanDict[NET_KEY_LOANSTATUS] integerValue];
    
    self.promptViewHeightConstraint.constant = [ZAPP.zdevice getDesignScale:(surplusValue>0 && loanSatus==1)?60:0];
    
    self.promptLabel.font =
    self.investmentValueLabel.font = [UtilFont systemLarge];
    self.investmentButton.titleLabel.font = [UtilFont system:18];
    
    self.investmentValueLabel.text = [Util formatRMB:@(surplusValue)];
    
    self.investmentButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5];
    self.investmentButton.layer.masksToBounds = YES;
}

- (void)setInvestViewLayout{
    
    NSString *leavedString = ZAPP.myuser.allShouxinPeopleListDict[@"remind_val"];
    
    double remindVal = [leavedString doubleValue];
    NSString *remindStr = [Util formatRMB:@(remindVal)];
    
    //NSUInteger loanStatus = [loanDict[@"loanstatus"] integerValue];
    
    
    if (1 < remindVal) {
        investViewHeightOffset = [ZAPP.zdevice getDesignScale:68];
        self.investView.hidden = NO;
        
        NSString *str = [NSString stringWithFormat:@"剩余投资金额：%@", remindStr];
        NSMutableAttributedString *attStr = [Util getAttributedString:str font:CNLightFont(28) color:HexRGB(0x000000)];
        
        [Util setAttributedString:attStr font:CNFont_28px color:HexRGB(0x000000) substr:remindStr allstr:str];
        self.investLabel.attributedText = attStr;
        
        [self.investButton addTarget:self action:@selector(touziPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        investViewHeightOffset = 0;
        self.investView.hidden = YES;
    }
    
    self.investViewHeight.constant = investViewHeightOffset;
    
    self.investButton.enabled = YES;
    //剩余投资金额
    //double leaved = [self LeftedAmount];
    //[Util formatRMBWithoutUnit:@(leaved)];
    //self.investLabel.text = [Util formatRMBWithoutUnit:@(leaved)];
    
}

- (void)setLoanID:(int)loadid {
    mLoanID = loadid;
}

- (void)setLoanDict:(NSDictionary *)aLoanDict {
    loanDict = aLoanDict;
}

- (void)rhManul {
	curPage = 1;
	[self connectToServer];
}

//- (void)rh {
//	curPage = 1;
//	//[self connectToServer];
//	[self.table.header beginRefreshing];
//}

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

- (IBAction)inventmentAction:(id)sender {
//    BOOL inBlackList = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_BLOCKTYPE] intValue] == 3);
//    if (inBlackList) {
//        [Util toast:@"您已进入Cashnice黑名单，无法投资。"];
//        return;
//    }
    /*
    if (![ZAPP.myuser hasMoneyInAccount]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"tip.balanceNotEnough", nil) message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles: @"充值", nil];
        [alert show];
        return;
    }
     */
    QuerenTouzi *t = ZJKDetail(@"QuerenTouzi");
    [t setTheDataDict:loanDict];
    [self.navigationController pushViewController:t animated:YES];
}

NSArray *lastDataArray = nil;
- (void)setData {
    
    NSDictionary *responseDict = ZAPP.myuser.allShouxinPeopleListDict;
	curPage    = [Util curPage:responseDict];
	pageCount  = [Util pageCount:responseDict];
	totalCount = [Util totalCount:responseDict];

    NSInteger pagecount = [responseDict[@"pagecount"] integerValue];
    
    self.table.footer.hidden = (curPage >= pagecount);
    
	if (curPage <= 1) {
		[self.dataArray removeAllObjects];
	}
    
    NSInteger offset = 0;
    for (NSDictionary *dict in self.dataArray) {
        if ([self isTyteItem:dict]) {
            ++offset;
        }
    }
    NSArray *thisDataArray = [ZAPP.myuser.allShouxinPeopleListDict objectForKey:NET_KEY_WARRANTYs];
	int cnt = [[ZAPP.myuser.allShouxinPeopleListDict objectForKey:NET_KEY_WARRANTYCOUNT] intValue];
	if (cnt > 0) {
        
        [self.dataArray addObjectsFromArray:thisDataArray];
        
        //[self.dataArray insertPage:curPage-1 offset:offset objects:thisDataArray];
	}

	rowCnt = [self.dataArray count];

	[self performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:YES];;
    
    NSDictionary *listDcit = ZAPP.myuser.allShouxinPeopleListDict ;
    NSInteger comm = [listDcit[@"commounusercount"] integerValue];
    self.promptView.text = [NSString stringWithFormat:@"共%ld位担保人，其中有%ld位您的好友担保", (long)totalCount, (long)comm];
    [self.promptView sizeToFit];
    self.promptView.width += [ZAPP.zdevice getDesignScale:30];
    self.promptView.height = [ZAPP.zdevice getDesignScale:30];
    [self layoutPromptView];
    
    [self setInvestViewLayout];
}

- (void)loseData {
	[self.table.header endRefreshing];
	[self.table.footer endRefreshing];
}

- (void)refreshUI {
    
    [self.table.header endRefreshing];
    [self.table.footer endRefreshing];
	[self.table reloadData];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
    NSString *lo = [NSString stringWithFormat:@"%d", mLoanID];
    progress_show
    
    __weak __typeof__(self) weakSelf = self;
    
    self.op = [ZAPP.netEngine getAllShouxinPeopleWithComplete:^{[weakSelf setData]; progress_hide} error:^{[weakSelf loseData];progress_hide} loadid:lo page:curPage pagesize:DEFAULT_PAGE_SIZE];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"所有授信人"];
	//[self performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:YES];;
	[self uiNav];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

    if (willGoDetail) {
        willGoDetail = NO;
        return;
    }
	//curPage = 0;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rhManul) name:MSG_login_to_server_suc object:nil];
	if ([ZAPP.zlogin isLogined]) {
		[self rhManul];
	}

}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"所有授信人"];

	[self.op cancel];
	self.op = nil;
    [self loseData];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

BLOCK_NAV_BACK_BUTTON
- (void)uiNav {
	NSString *str = @"担保人";
	[self setTitle:str];
    [self setNavButton];
}
- (BOOL)lastRow:(NSInteger)row {
	return row == rowCnt - 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return rowCnt;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	//return (section == 0 ?[ZAPP.zdevice getDesignScale : 30] : 0);
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return [ZAPP.zdevice getDesignScale:20];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([self isTyteItem:dict]) {
        return [ZAPP.zdevice getDesignScale:30];
    }else{
        return [ZAPP.zdevice getDesignScale:rowHeight];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	LabelsView *v      =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
	NSString *  cntstr = [Util intWithUnit:totalCount unit:@""];
		[v setTexts:@[@"共有",cntstr,@"位授信人"]];

	[v setIndexColor:ZCOLOR(COLOR_BUTTON_RED) index:@[@(1)]];
    v.backgroundColor = ZCOLOR(COLOR_BG_WHITE);
	return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    
    if ([self isTyteItem:dict]) {
        
        GuarantorSectionCell *    cell;
        static NSString *CellIdentifier = @"GuarantorSectionCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [cell updateCellData:dict];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        
        GuarantorCell *    cell;
        static NSString *CellIdentifier = @"GuarantorCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:dict];
        
        
        return cell;
        
    }
    
    
    
    
    /*
    ShouxinCell *    cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    [cell.img setHeadImgeUrlStr:[dict objectForKey:NET_KEY_HEADIMG]];
    
//    cell.img.layer.cornerRadius = cell.img.bounds.size.width/2;
//    cell.img.layer.masksToBounds = YES;
    
    cell.nameLabel.text                                 = [Util getUserRealNameOrNickName:dict];
    ((UILabel *)[cell.labelArray objectAtIndex:0]).text = [dict objectForKey:NET_KEY_ORGANIZATION];
    //NSString *job = [dict objectForKey:NET_KEY_JOB];
    //    NET_KEY_JOB_OLD
    NSString *job = [dict objectForKey:NET_KEY_ORGANIZATIONDUTY];
    NSString *com = [dict objectForKey:NET_KEY_ORGANIZATIONNAME];
    ((UILabel *)[cell.labelArray objectAtIndex:0]).text = com;
    ((UILabel *)[cell.labelArray objectAtIndex:1]).text = [NSString stringWithFormat:@"%@", job];
    
    double  num   = [[dict objectForKey:NET_KEY_WARRANTYVAL] doubleValue];
    //	NSString *numStr = [Util intWithUnit:(int)(num/1e4) unit:@"万元"];
    NSString *numStr = [Util formatRMB:@(num)];
    NSString *theStr = [NSString stringWithFormat:@"为此借款担保%@", numStr];
    
    NSMutableAttributedString *attr1 = [Util getAttributedString:theStr font:[UtilFont systemSmall] color:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
    [Util setAttributedString:attr1 font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:[theStr rangeOfString:numStr]];
    
    ((UILabel *)[cell.labelArray objectAtIndex:2]).attributedText =attr1;
    ((UILabel *)[cell.labelArray objectAtIndex:3]).text = @"";
    ((UILabel *)[cell.labelArray objectAtIndex:4]).text = @"";
    
    //cell.sepLine.hidden = [self lastRow:indexPath.row];
    
    
    cell.editButton.hidden = YES;
    cell.button1.hidden = YES;
    cell.button2.hidden = YES;
    
    
    2.0.0.0.0.0.0.0.0.0
     
	ShouXinRenCell *    cell;
	static NSString *CellIdentifier = @"shouXinRenCell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    [cell.headImgeView setHeadImgeUrlStr:[dict objectForKey:NET_KEY_HEADIMG]];
    
    cell.headImgeView.layer.cornerRadius = cell.headImgeView.bounds.size.width/2;
    cell.headImgeView.layer.masksToBounds = YES;
    
    cell.nameLabel.text                                 = [Util getUserRealNameOrNickName:dict];
    cell.orgLabel.text = [dict objectForKey:NET_KEY_ORGANIZATIONNAME];

	NSString *job = [dict objectForKey:NET_KEY_ORGANIZATIONDUTY];
    //NSString *com = [dict objectForKey:NET_KEY_ORGANIZATIONNAME];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",job];

	double  num   = [[dict objectForKey:NET_KEY_WARRANTYVAL] doubleValue];
	NSString *numStr = [Util formatRMB:@(num)];
    cell.guarValLabel.text = numStr;
    

	return cell;
    */
}

- (BOOL)isTyteItem:(NSDictionary *)dict{
    NSString *itemType = dict[@"type"];
    return ([itemType length] > 0);
}

- (void)touziPressed {
    /*
     BOOL inBlackList = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_BLOCKTYPE] intValue] == 3);
     if (inBlackList) {
     [Util toastStringOfLocalizedKey:@"tip.enterBlackList"];
     return;
     }
     
    if (![ZAPP.myuser hasMoneyInAccount]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Util getStringInvestWithNoMoney] message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles: @"充值", nil];
        [alert show];
        return;
    }
    */
    
    InvestmentAction *t = ZINVSTFP(@"InvestmentAction");
    
    
    if (loanDict) {
        [t setTheDataDict:loanDict];
    }else{
        [t setTheDataDict:@{@"loanid" : @(mLoanID)}];
    }
    
    [self.navigationController pushViewController:t animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (buttonIndex == 1) {
            [self changeTabToGeren];
        }
    }
}
- (void)changeTabToGeren {
    [self.navigationController popViewControllerAnimated:YES];
    [((UINavigationController *)self.parentViewController).viewControllers.firstObject setSelectedIndex:4];
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
    if (offsetY > rowHeight || offsetY < -rowHeight) {
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
        _promptView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
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

- (void)layoutPromptView{
    CGFloat promptViewSpacing = [ZAPP.zdevice getDesignScale:6];
    self.promptView.center = self.view.center;
    self.promptView.top = self.view.height - self.promptView.height - promptViewSpacing - investViewHeightOffset;
//    self.promptView.left = (self.view.width - self.promptView.width)/2;
}

@end
