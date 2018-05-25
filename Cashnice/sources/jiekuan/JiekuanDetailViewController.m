//
//  JiekuanDetailViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "JiekuanDetailViewController.h"
#import "GongtongHaoyouTableViewCell.h"
#import "JiekuanInfoViewController.h"
#import "Querentouzi.h"
#import "PersonHomePage.h"
#import "FujianViewController.h"
#import "AllShouxinPeople.h"
#import "NextButton2.h"
#import "QuerenHuanxi.h"
#import "NoLevel.h"
#import "NewBorrowViewController.h"
#import "YaoqingHaoyou.h"
#import "ShouxinList.h"
#import "NewNewShenFen.h"
#import "SendLoanViewController.h"
#import "JieKuanViewController.h"
#import "Jiekuan3.h"
#import "Jiekuan1.h"
#import "Jiekuan2.h"
#import "WoDingdanDetail.h"

/* Values for LoanType */
typedef NS_ENUM(NSInteger, LoanDetailType) {
    LoanTypeOfMyFromInvetmentsList          = 0,    //
    LoanTypeOfOtherFromInvetmentsList       = 1,    //
    LoanTypeOfMyFromMyLoansList             = 2,    //
    //LoanTypeOfOther                         = 3,    //

};

@interface JiekuanDetailViewController () {
	NSInteger rowCnt;
	NSInteger rowHeight;
	
	LoanState _jiekuan_state;
	BOOL _blackList;
	
	NSDate *lastDate;
	
	int buttonFunc;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_tableH;
@property (strong,nonatomic) JiekuanInfoViewController*  jiekuanInfo;
@property (strong,nonatomic) FujianViewController*       fujian;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_info_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_close_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_touzi_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_shouxinren_height;
@property (weak, nonatomic) IBOutlet UIView *gontongTileView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_gongtong_height;
@property (weak, nonatomic) IBOutlet UILabel *           nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *           gongtongNumber;

@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *largeRed;
@property (weak, nonatomic) IBOutlet UIButton * shouxinbutton;
@property (weak, nonatomic) IBOutlet UILabel *  yongtuLabel;
@property (weak, nonatomic) IBOutlet UILabel *purposePromptLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITableView * table;

@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSDictionary *      commonDict;
@property (strong, nonatomic) NSMutableArray *    dataArray;
@property (assign, nonatomic) LoanDetailType   loanDetailType;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fujianH;
@property (strong, nonatomic) NextButtonViewController *   next;
@property (strong, nonatomic) NextButton2 *                next2;

@end

@implementation JiekuanDetailViewController

- (void)setJiekuanState:(LoanState)state {
	_jiekuan_state = state;
	[self performSelectorOnMainThread:@selector(ui) withObject:nil waitUntilDone:YES];;
}
- (IBAction)shouxinbuttonPressed:(UIButton *)sender {
	AllShouxinPeople *all    = ZSEC(@"AllShouxinPeople");
	int loanid = [[self.dataDict objectForKey:NET_KEY_LOANID] intValue];
	[all setLoanID:loanid];
    [all setLoanDict:self.dataDict];
	[self.navigationController pushViewController:all animated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
	
	rowCnt    = 0;
	rowHeight = 80;
	
	[Util setUILabelLargeGray:self.largeGray];
	[Util setUILabelLargeRed:self.largeRed];
	
	
	[self.shouxinbutton setTitleColor:ZCOLOR(COLOR_BUTTON_BLUE) forState:UIControlStateNormal];
	self.shouxinbutton.titleLabel.font = [UtilFont systemLarge];
	
	self.scroll.hidden = YES;
	[self performSelectorOnMainThread:@selector(ui) withObject:nil waitUntilDone:YES];;
	ZAPP.inFullImageView = NO;
}

#pragma mark - server

- (NSMutableArray *)dataArray {
	if (_dataArray == nil) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

- (void)rhManual {
	[self connectToServer];
}

- (void)rh {
	[self connectToServer];
	//[self.scroll.header beginRefreshing];
}

- (void)rhAppear {
    if ([[self.dataDict objectForKey:NET_KEY_USERID] isEqualToString:[ZAPP.myuser getUserID]]) {//我的借款详情
        //SharedTrigger
    }
	[self rh];
}

- (void)setData {
	self.dataDict   = ZAPP.myuser.loanDetailDict;
	self.commonDict = ZAPP.myuser.loanDetailCommonShouxinrenDict;
	[self.scroll.header endRefreshing];
	
	[self performSelectorOnMainThread:@selector(ui) withObject:nil waitUntilDone:YES];;
	self.scroll.hidden = NO;
}

- (void)loseData {
	[self.scroll.header endRefreshing];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
	NSString *loanid = [self.dataDict objectForKey:NET_KEY_LOANID];
	NSString *userid = [self.dataDict objectForKey:NET_KEY_USERID];
    if (!userid || ![loanid notEmpty] ){
        userid = [ZAPP.myuser getUserID];
    }
    lastDate = [NSDate date];
    
    
    WS(ws);

    
    switch (self.loanDetailType) {
        case LoanTypeOfOtherFromInvetmentsList:
        {
            progress_show
            self.op  = [ZAPP.netEngine getLoanDetailWithLoanID:loanid userid:userid page:0 pagesize:LARGEST_PAGE_SIZE complete:^{[ws setData]; progress_hide } error:^{[ws loseData]; progress_hide}];
            break;
        }
        case LoanTypeOfMyFromInvetmentsList:
        {
            progress_show
            self.op  = [ZAPP.netEngine getGerenMyLoanDetailWithLoanID:loanid fromtype:@(1) userid:userid page:0 pagesize:LARGEST_PAGE_SIZE complete:^{[ws setData]; progress_hide } error:^{[ws loseData]; progress_hide}];
            break;
        }
        case LoanTypeOfMyFromMyLoansList:
        {
            progress_show
            self.op  = [ZAPP.netEngine getGerenMyLoanDetailWithLoanID:loanid fromtype:@(0) userid:userid page:0 pagesize:LARGEST_PAGE_SIZE complete:^{[ws setData]; progress_hide } error:^{[ws loseData]; progress_hide}];
            break;
        }
        default:
            break;
    }
    
    
    
    
//    if ([userid notEmpty]) {
//        if ([userid isEqualToString:[ZAPP.myuser getUserID]]) {
//            // 我的借款
//            progress_show
//            self.op  = [ZAPP.netEngine getGerenMyLoanDetailWithLoanID:loanid userid:userid page:0 pagesize:LARGEST_PAGE_SIZE complete:^{[self setData]; progress_hide } error:^{[self loseData]; progress_hide}];
//        }else{
//            progress_show
//            self.op  = [ZAPP.netEngine getLoanDetailWithLoanID:loanid userid:userid page:0 pagesize:LARGEST_PAGE_SIZE complete:^{[self setData]; progress_hide } error:^{[self loseData]; progress_hide}];
//        }
//    }
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[MobClick beginLogPageView:@"借款详情"];
    self.title = @"借款详情";
	[self setNavButton];
	[self.next2 setTheGray];
	
	self.next.view.hidden = YES;
	[self.jiekuanInfo setTheDataDict:self.dataDict];
	self.jiekuanInfo.hideNameAlways = self.hideNameAlways;
	[self performSelectorOnMainThread:@selector(ui) withObject:nil waitUntilDone:YES];;
	
	if (ZAPP.inFullImageView) {
		return;
	}
	//self.scroll.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//[UtilLog rect:self.scroll.frame];
//	[UtilLog rect:self.scroll.bounds];
//	[UtilLog edgeInset:self.scroll.contentInset];
//	self.scroll.backgroundColor = [UIColor redColor];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
	
	if (ZAPP.inFullImageView) {
		ZAPP.inFullImageView = NO;
		return;
	}
	
	if ([ZAPP.zlogin isLogined]) {
		[self rhAppear];
	}
	
	[self performSelectorOnMainThread:@selector(ui) withObject:nil waitUntilDone:YES];;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[MobClick endLogPageView:@"借款详情"];
	[self.op cancel];
	self.op = nil;
	[self loseData];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - server end

- (void)ui {
	self.nameLabel.text = @"借款人";
	[self.jiekuanInfo setTheDataDict:self.dataDict];
	
	int blocktype = [[self.dataDict objectForKey:NET_KEY_BLOCKTYPE] intValue];
	_blackList                    = [Util isBlocked:blocktype];
	self.con_info_height.constant = [ZAPP.zdevice getDesignScale:(_blackList ? 320 : 250)];
	
	if (self.commonDict != nil) {
		rowCnt = [[self.commonDict objectForKey:NET_KEY_creditusercount] integerValue];
		[self.dataArray removeAllObjects];
		if(rowCnt > 0) {
			[self.dataArray addObjectsFromArray:[self.commonDict objectForKey:NET_KEY_creditusers]];
		}
	}
	
	
	int warrantyCount = 0;
	if (self.dataDict != nil) {
	
		warrantyCount=    [[self.dataDict objectForKey:NET_KEY_WARRANTYCOUNT ] intValue];
	}
	NSString *btnTtl = [NSString stringWithFormat:@"查看所有%d位授信人", warrantyCount];
	[self.shouxinbutton setTitle:btnTtl forState:UIControlStateNormal];
	
	self.gongtongNumber.text = [NSString stringWithFormat:@"%d", (int)rowCnt];
	
	NSString *str = [self.dataDict objectForKey:NET_KEY_PURPUSE];
	if (str.length > 0) {
        self.yongtuLabel.text = str;
        self.purposePromptLabel.hidden = NO;
	}
	else {
		self.yongtuLabel.text = @" ";
        self.purposePromptLabel.hidden = YES;
	}
	
	int fujiancnt = [[[ZAPP.myuser loanDetailAttachmentList] objectForKey:NET_KEY_attachmentcount] intValue];
	self.fujianH.constant = (fujiancnt == 0 ? 0 : 100);
	self.fujian.view.hidden = (fujiancnt == 0 ? YES : NO);
	
	[self.fujian setFujianDict:[ZAPP.myuser loanDetailAttachmentList]];
    
    self.next2.view.hidden = YES;
    
    switch (self.loanDetailType) {
        case LoanTypeOfOtherFromInvetmentsList:
        {
            [self setupViewForShowGuaranteen];
            [self setupViewForShowInvestAction];
            break;
        }
        case LoanTypeOfMyFromInvetmentsList:
        {
            [self setupViewForHideGuaranteen];
            [self setupViewForShowInvestAction];
            break;
        }
        case LoanTypeOfMyFromMyLoansList:
        {
            [self setupViewForShowMyLoanListDetail];
            break;
        }
        default:
            break;
    }
    
    
    
    
    
//    NSString *userid     = [self.dataDict objectForKey:NET_KEY_USERID];
//    int loanstatus = [[self.dataDict objectForKey:NET_KEY_LOANSTATUS] intValue];
//	if ([userid notEmpty] && [userid isEqualToString:[ZAPP.myuser getUserID]]) {//is me //我的借款详情
//		self.con_shouxinren_height.constant = 0;
//		self.con_gongtong_height.constant   = 0;
//		self.gontongTileView.hidden = YES;
//		rowCnt                              = 0;
//		if (loanstatus == 1) {
//			self.con_close_height.constant = [ZAPP.zdevice getDesignScale:60];
//			self.next2.view.hidden = NO;
//		}
//		else {
//			self.con_close_height.constant = [ZAPP.zdevice getDesignScale:60];
//			self.next2.view.hidden = YES;
//		}
//		if (loanstatus == 1) {//jie kuan zhong
//			[self.next setTheTitleString:@"我要投资"];
//			buttonFunc            = 0;
//			self.next.view.hidden = NO;
//			[self.next setTheRed];
//		}
//		else if (loanstatus == 2) {
//			BOOL hasFail = [Util hasFailDebt:self.dataDict];
//			if (hasFail) {//还款失败
//				[self.next setTheTitleString:@"追补还款"];
//				buttonFunc            = 1;
//				self.next.view.hidden = NO;
//				[self.next setTheRed];
//			}
//			else {
//				[self.next setTheTitleString:@"立即还款"];
//				buttonFunc            = 1;
//				self.next.view.hidden = NO;
//				[self.next setTheRed];
//				BOOL canReapy = [Util canRepay:self.dataDict];
//				[self.next setTheEnabled:canReapy];
//				
//			}
//		}
////        
////        //重新编辑按钮 不显示了
////        LoanState loanst = [UtilString cvtIntToJiekuanState:loanstatus];
////		else if (loanst == JieKuan_FailNow) {//shen he shi bai
////			[self.next setTheTitleString:@"重新编辑"];
////			buttonFunc = 2;//chong xin bian ji
////			self.next.view.hidden = NO;
////			[self.next setTheBlue];
////		}
////		else if (loanst == JieKuan_SelfClosed || loanst == JieKuan_UnfinishedClosed) {
////			[self.next setTheTitleString:@"复制并发布"];
////			buttonFunc = 3;//fu zhi bing fa bu
////			self.next.view.hidden = NO;
////			[self.next setTheBlue];
////		}
//		else {
//			self.next.view.hidden = YES;
//		}
//	}
//	else {
//	}
	
	self.con_touzi_height.constant = [ZAPP.zdevice getDesignScale:self.next.view.hidden ? 0 : 60];
	self.con_tableH.constant       = [ZAPP.zdevice getDesignScale: rowHeight * rowCnt + 2];
	
	[self.view needsUpdateConstraints];
	
	[self.table reloadData];
}

- (void)setupViewForShowGuaranteen{
    self.con_shouxinren_height.constant = [ZAPP.zdevice getDesignScale:30];
    
    self.con_gongtong_height.constant   = [ZAPP.zdevice getDesignScale:30];
    self.gontongTileView.hidden = NO;
    
    self.con_close_height.constant      = [ZAPP.zdevice getDesignScale:60];
}
- (void)setupViewForHideGuaranteen{
    self.con_shouxinren_height.constant = 0;
    self.con_gongtong_height.constant   = 0;
    self.gontongTileView.hidden = YES;
    rowCnt                              = 0;
}
- (void)setupViewForShowInvestAction{
    //self.next2.view.hidden = YES;
    int loanstatus = [[self.dataDict objectForKey:NET_KEY_LOANSTATUS] intValue];
#ifdef TEST_TOUZI_PAGE
    loanstatus = 1;
#endif
    if (loanstatus == 1) {//jie kuan zhong
        [self.next setTheTitleString:@"我要投资"];
        buttonFunc            = 0;
        self.next.view.hidden = NO;
    }
    else {
        self.next.view.hidden = YES;
    }
}
- (void)setupViewForShowMyLoanListDetail{
    int loanstatus = [[self.dataDict objectForKey:NET_KEY_LOANSTATUS] intValue];
    {//is me //我的借款详情
        [self setupViewForHideGuaranteen];
        if (loanstatus == 1) {
            self.con_close_height.constant = [ZAPP.zdevice getDesignScale:60];
            //self.next2.view.hidden = NO;
        }
        else {
            self.con_close_height.constant = [ZAPP.zdevice getDesignScale:60];
            //self.next2.view.hidden = YES;
        }
        if (loanstatus == 1) {
            [self.next setTheTitleString:@"关闭借款"];
            buttonFunc            = 1001;
            self.next.view.hidden = NO;
            [self.next setTheRed];
        }
        else if (loanstatus == 2) {
            BOOL hasFail = [Util hasFailDebt:self.dataDict];
            if (hasFail) {//还款失败
                [self.next setTheTitleString:@"追补还款"];
                buttonFunc            = 1;
                self.next.view.hidden = NO;
                [self.next setTheRed];
            }
            else {
                [self.next setTheTitleString:@"立即还款"];
                buttonFunc            = 1;
                self.next.view.hidden = NO;
                [self.next setTheRed];
                BOOL canReapy = [Util canRepay:self.dataDict];
                [self.next setTheEnabled:canReapy];
                
            }
        }
        /*
         //重新编辑按钮 不显示了
         LoanState loanst = [UtilString cvtIntToJiekuanState:loanstatus];
         else if (loanst == JieKuan_FailNow) {//shen he shi bai
         [self.next setTheTitleString:@"重新编辑"];
         buttonFunc = 2;//chong xin bian ji
         self.next.view.hidden = NO;
         [self.next setTheBlue];
         }
         else if (loanst == JieKuan_SelfClosed || loanst == JieKuan_UnfinishedClosed) {
         [self.next setTheTitleString:@"复制并发布"];
         buttonFunc = 3;//fu zhi bing fa bu
         self.next.view.hidden = NO;
         [self.next setTheBlue];
         }
         */
        else {
            self.next.view.hidden = YES;
        }
    }
}

- (void)customNavBackPressed {
    if (self.enterFromPreview) {
		[self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
	[self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)nextButtonPressed {
#ifdef TEST_TOUZI_PAGE
	QuerenTouzi *t = ZJKDetail(@"QuerenTouzi");
	[t setTheDataDict:self.dataDict];
	[self.navigationController pushViewController:t animated:YES];
	return;
#endif

	if (![ZAPP.myuser hasMoneyInAccount]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Util getStringInvestWithNoMoney] message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"充值", nil];
		alert.tag = 10;
		////[alert customLayout];
		[alert show];
		return;
	}
	
	if (buttonFunc == 0) {
        
        BOOL inBlackList = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_BLOCKTYPE] intValue] == 3);
        if (inBlackList) {
            [Util toast:@"您已进入Cashnice黑名单，无法投资。"];
            return;
        }
        
		QuerenTouzi *t = ZJKDetail(@"QuerenTouzi");
        if ([self.delegate isKindOfClass:[Jiekuan2 class]]) {
            t.fromTouzi = YES;
        }
		[t setTheDataDict:self.dataDict];
		[self.navigationController pushViewController:t animated:YES];
		
	}
	else if (buttonFunc == 1) {
		QuerenHuanxi *h = ZSEC(@"QuerenHuanxi");
		h.dataDict = self.dataDict;
		h.delegate = self;
		h.opRowHere = self.opRowHuankuan;
		[self.navigationController pushViewController:h animated:YES];
    }else if (buttonFunc == 1001) {
        [self nextButton2Pressed];
    }
	else  {
		[self refabuPressed];
	}
	
	
}

- (void)huankuanOkDonePressed:(int)opRow {
    if ([self.delegate respondsToSelector:@selector(huanRowDone:)]) {
        [self.delegate huanRowDone:opRow];
    }
}

- (void)refabuPressed {
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
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[ZAPP.myuser infoNotFriendNum] message:@"请邀请好友或索要授信!" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"邀请好友", @"索要授信", nil];
//		alert.tag = 100;
//		[alert show];
        
        [Util toast:[NSString stringWithFormat:@"%@",[ZAPP.myuser infoNotFriendNum]]];
		return;
	}
	if (noRemain) {
		[Util toast:@"借款额度为0，无法发布借款。"];
		return;
	}
    
    NSMutableDictionary *dictCopied       = [self.dataDict mutableCopy];
    SendLoanViewController *borrow = SENDLOANSTORY(@"SendLoanViewController");
	if (buttonFunc == 2) {
        //重新编辑
		//[self setDataToTempisnew:NO];
        borrow.loanDictRedistributed = dictCopied;
	}
	else if (buttonFunc == 3) {
        //复制并发布
        //[self setDataToTempisnew:YES];[dictCopied setObject:@"" forKey:NET_KEY_LOANID];
        borrow.loanDictRedistributed = dictCopied;
    }
    [self.navigationController pushViewController:borrow animated:YES];
}

- (void)setDataToTempisnew:(BOOL)isNew {
	[ZAPP.myuser fabuClear];
	NSDictionary *dict = self.dataDict;
	
	if (!isNew) {
		[ZAPP.myuser fabuSetLoanId:[dict objectForKey:NET_KEY_LOANID]];
	}
	//[ZAPP.myuser fabuSetTitle:[dict objectForKey:NET_KEY_LOANTITLE] val:[[dict objectForKey:NET_KEY_LOANMAINVAL] doubleValue] day:[[dict objectForKey:NET_KEY_LOANDAYCOUNT] intValue]];
	int ty = 0;
	if ([[dict objectForKey:NET_KEY_LOANTYPE] intValue] == 0) {//gong kai
		ty = 1;
	}
	//[ZAPP.myuser fabuSetType:ty lixi:[[dict objectForKey:NET_KEY_LOANRATE] doubleValue] day:[[dict objectForKey:NET_KEY_interestdaycount] intValue]];
	//[ZAPP.myuser fabuSetYongtu:[dict objectForKey:NET_KEY_PURPUSE]];
	
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
	
	NewBorrowViewController *borrow = ZBorrow(@"NewBorrowViewController");
	[self.navigationController pushViewController:borrow animated:YES];
}

- (void)loseDataAttach {
	[Util toast:@""];
}

- (void)connectToLoadAttach:(NSString *)loanid {
	[self.op cancel];
	bugeili_net
	progress_show
    
    __weak __typeof__(self) weakSelf = self;
    
	self.op = [ZAPP.netEngine getLoanDetailAttachmentsWithLoanID:loanid complete:^{[weakSelf setDataAttach]; progress_hide} error:^{[weakSelf loseDataAttach]; progress_hide}];
}

- (void)nextButton2Pressed {
//	CGFloat loaned = [[self.dataDict objectForKey:NET_KEY_LOANEDMAINVAL] doubleValue];
//	int betcount = [[self.dataDict objectForKey:NET_KEY_BETCOUNT] intValue];
//	
//	if (loaned > 0 && betcount > 0) {
//		str = [NSString stringWithFormat:@"确定要关闭此次借款？系统将退还投资%@给%d位投资人(不计利息)", [Util formatRMB:@(loaned)], betcount];
//	}
    NSString *str = @"是否关闭此借款？";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//	//[alert customLayout];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [alertView cancelButtonIndex]) {
		if (alertView.tag == 10) {
			if (buttonIndex == 1) {
				[self.navigationController popViewControllerAnimated:YES];
				[self.delegate changeTabToGeren];
			}
		}
		else if (alertView.tag == 100) {
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
		else {
			[self connectToClose];
			
		}
	}
}

- (void)setDataClose {
	[Util toast:@"借款已关闭"];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)connectToClose {
	NSString *loanid = [self.dataDict objectForKey:NET_KEY_LOANID];
	if ([loanid notEmpty]) {
		[self.op cancel];
		bugeili_net
		
		progress_show
        
        __weak __typeof__(self) weakSelf = self;

		self.op = [ZAPP.netEngine closeTheLoanWithComplete:^{[weakSelf setDataClose]; progress_hide} error:^{[weakSelf loseData]; progress_hide} loanid:loanid];
	}
	
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ([[segue destinationViewController] isKindOfClass:[NextButton2 class]]) {
		((NextButton2*)[segue destinationViewController]).delegate    = self;
		((NextButton2*)[segue destinationViewController]).titleString = @"关闭借款";
		self.next2                                                    = ((NextButton2*)[segue destinationViewController]);
	}
	else if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate    = self;
		((NextButtonViewController *)[segue destinationViewController]).titleString = [segue identifier];
		self.next                                                                   = (NextButtonViewController *)[segue destinationViewController];
	}
	else if ([[segue destinationViewController] isKindOfClass:[JiekuanInfoViewController class]]) {
		self.jiekuanInfo = ((JiekuanInfoViewController*)[segue destinationViewController]);
	}
	else if ([[segue destinationViewController] isKindOfClass:[FujianViewController class]]) {
		self.fujian = ((FujianViewController*)[segue destinationViewController]);
	}
}
- (BOOL)lastRow:(NSInteger)row {
	return NO;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ZAPP.zdevice getDesignScale:rowHeight];
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
	GongtongHaoyouTableViewCell *cell;
	static NSString *            CellIdentifier = @"cell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
	
	NSString *thename = [Util getUserRealNameOrNickName:dict];
	if (thename == nil) {
		thename = @"";
	}
	NSString *duty = [dict objectForKey:NET_KEY_JOB];
	if (duty == nil) {
		duty = @"";
	}
    [cell.img setHeadImgeUrlStr:[dict objectForKey:NET_KEY_HEADIMG]];
    cell.img.layer.cornerRadius = cell.img.bounds.size.width/2;
    cell.img.layer.masksToBounds = YES;

	cell.nameLabel.text                                 = [NSString stringWithFormat:@"%@ - %@", thename, duty];
	((UILabel *)[cell.labelArray objectAtIndex:0]).text = [dict objectForKey:NET_KEY_ORGANIZATION];//@"山东恒生有限公司";
	((UILabel *)[cell.labelArray objectAtIndex:1]).text = @"";
	((UILabel *)[cell.labelArray objectAtIndex:2]).text = @"为此借款授信";
	id obj = [dict objectForKey:NET_KEY_loanwarrantyval];
	if (ISNSNULL(obj)) {
		((UILabel *)[cell.labelArray objectAtIndex:3]).text = [Util formatRMB:@(0)];
	}
	else {
        CGFloat value =  [[dict objectForKey:NET_KEY_loanwarrantyval]doubleValue];
		((UILabel *)[cell.labelArray objectAtIndex:3]).text = [Util formatRMB:@(value)];
	}
	((UILabel *)[cell.labelArray objectAtIndex:4]).text = @"";
	
	return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	PersonHomePage *person = DQC(@"PersonHomePage");
	[person setTheDataDict:[self.dataArray objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:person animated:YES];
}

- (LoanDetailType)loanDetailType{
    NSString *userid = [ZAPP.myuser getUserID];
    NSString *useridOfLoan = [self.dataDict objectForKey:NET_KEY_USERID];
    if (!useridOfLoan || ![useridOfLoan notEmpty]) {
        useridOfLoan = userid;
    }
    if ([self.delegate isKindOfClass:[JieKuanViewController class]] ||
        [self.delegate isKindOfClass:[Jiekuan1 class]]              ||
        [self.delegate isKindOfClass:[Jiekuan2 class]]              ||
        [self.delegate isKindOfClass:[WoDingdanDetail class]]) {
        if ([userid isEqualToString:useridOfLoan]) {
            _loanDetailType = LoanTypeOfMyFromInvetmentsList;
        }else{
            _loanDetailType = LoanTypeOfOtherFromInvetmentsList;
        }
    }else{
        if ([userid isEqualToString:useridOfLoan]) {
            _loanDetailType = LoanTypeOfMyFromMyLoansList;
        }else{
            _loanDetailType = LoanTypeOfOtherFromInvetmentsList;
        }
    }
    
//    // 对我的投资，我的担保页面的处理
//    if ([self.delegate isKindOfClass:[Jiekuan1 class]] ||
//        [self.delegate isKindOfClass:[Jiekuan2 class]]) {
//        _loanDetailType = LoanTypeOfOtherFromInvetmentsList;
//    }
    return _loanDetailType;
}

@end
