//
//  .m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//


#import "ShouxinList.h"
#import "ShouxinCell.h"
#import "SeachHaoyouViewController.h"
#import "YaoqingHaoyou.h"
#import "PersonHomePage.h"
#import "LabelsView.h"
#import "NewNewShenFen.h"

@interface ShouxinList () {
	NSInteger   rowCnt;
	NSInteger   rowHeight;
	ShouXinType _type;

	int curPage;
	int pageCount;
	int totalCount;

	NSInteger opRow;
    
    BOOL willGoDetail;
    
    int opNum;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *    dataArray;
@property (strong, nonatomic) UILabel *vLable;
@end

@implementation ShouxinList

- (void)setShowXintype:(ShouXinType)ty {
	_type = ty;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor  = ZCOLOR(COLOR_BG_WHITE);
	self.table.backgroundColor = [UIColor clearColor];
	[self.table setSeparatorInset:UIEdgeInsetsZero];


	rowCnt    = 0;
	rowHeight = 80;

	curPage    = 0;
	pageCount  = 0;
	totalCount = 0;

    [Util setScrollHeader:self.table target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
	[Util setScrollFooter:self.table target:self footer:@selector(rf)];

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
	//[self connectToServer];
	[self.table.header beginRefreshing];
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
    
	curPage    = [Util curPage:ZAPP.myuser.shouxinListDict];
	pageCount  = [Util pageCount:ZAPP.myuser.shouxinListDict];
	totalCount = [Util totalCount:ZAPP.myuser.shouxinListDict];

	if (curPage == 0) {
		[self.dataArray removeAllObjects];
	}

	int cnt = [[ZAPP.myuser.shouxinListDict objectForKey:NET_KEY_creditusercount] intValue];
	if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.shouxinListDict objectForKey:NET_KEY_creditusers]];
	}

//#define DEBUG_DUPLICATION
#ifdef DEBUG_DUPLICATION
    NSMutableArray* useridarr = [[NSMutableArray alloc] init];
    NSMutableDictionary* userdict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict  in self.dataArray) {
        NSString *userid = dict[@"userid"];
        [useridarr addObject:userid];
        
        NSInteger passedidVal = [userdict[userid] integerValue];
        if (passedidVal  > 0) {
            passedidVal ++;
            [userdict setObject:[NSString stringWithFormat:@"%ld", passedidVal] forKey:userid];
        }else{
            [userdict setObject:[NSString stringWithFormat:@"%d", 1] forKey:userid];
        }
    }
    for (NSString *key in userdict.allKeys) {
        NSString *val = userdict[key];
        NSInteger num = [val integerValue];
        if (num > 1) {
            NSLog(@"Catched  it ！！！%@", val);
        }
    }
#endif
	rowCnt = [self.dataArray count];
    
    if (! totalCount) {
        self.vLable.hidden = NO;
    }else{
        self.vLable.hidden = YES;
    }
    
    
	[self.table.header endRefreshing];
	[self.table.footer endRefreshing];

	[self ui];
}

- (void)loseData {
	[self.table.header endRefreshing];
	[self.table.footer endRefreshing];
}

- (void)ui {
	self.table.footer.hidden = ((curPage + 1) >= pageCount);
	[self.table reloadData];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
    
    WS(ws);

    self.op = [ZAPP.netEngine getShouxinWithComplete:^{[ws setData]; }
                                               error:^{[ws loseData];}
                                              userid:[ZAPP.myuser getUserID]
                                                page:curPage pagesize:DEFAULT_PAGE_SIZE
                                         shouxintype:(int)_type];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [MobClick beginLogPageView:[self curTit]];
	[self ui];
	[self uiNav];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

    if (willGoDetail) {
        willGoDetail = NO;
        return;
    }
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
	if ([ZAPP.zlogin isLogined]) {
		[self rhAppear];
	}

}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

    [MobClick endLogPageView:[self curTit]];
	[self.op cancel];
	self.op = nil;
    [self loseData];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)curTit {
   	NSString *str1 = @"我单向授信";
    NSString *str2 = @"单向授信我";
    NSString *str3 = @"相互授信";
    NSString *str  = @"";
    if (_type == ShouXin_MeiYou) {
        str = str1;
    }
    if (_type == ShouXin_YiJing) {
        str = str2;
    }
    if (_type == ShouXin_XiangHu) {
        str = str3;
    }
    return str;
}
BLOCK_NAV_BACK_BUTTON

- (void)uiNav {
[self setNavButton];
    [self setTitle:[self curTit]];
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
    //return (rowCnt == 0 ?[ZAPP.zdevice getDesignScale : 60] : 0);
    //return (rowCnt == 0 ? self.view.height/2 : 0);
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ZAPP.zdevice getDesignScale:rowHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *v = [[UILabel alloc] init];    
	return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ShouxinCell *    cell;
	static NSString *CellIdentifier = @"cell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    [cell.img setHeadImgeUrlStr:[dict objectForKey:NET_KEY_HEADIMG]];
//    cell.img.layer.cornerRadius = cell.img.bounds.size.width/2;
//    cell.img.layer.masksToBounds = YES;

    cell.nameLabel.text                                 = [Util getUserRealNameOrNickName:dict];
	((UILabel *)[cell.labelArray objectAtIndex:0]).text = [dict objectForKey:NET_KEY_ORGANIZATION];
	NSString *job = [dict objectForKey:NET_KEY_JOB];
	((UILabel *)[cell.labelArray objectAtIndex:1]).text = [Util spaceWithString:job];

	int       num1   = [[dict objectForKey:NET_KEY_CREDITOTHERVAL] intValue];
	int       num2i  = [[dict objectForKey:NET_KEY_becreditmeval] intValue];
	NSString *numStr = [Util intWithUnit:(int)(num1/1e4) unit:@"万元"];
	NSString *num2   = [Util intWithUnit:(int)(num2i/1e4) unit:@"万元"];
	NSString *theStr = [NSString stringWithFormat:@"我给Ta授信%@  ", numStr];
	NSString *the2   = [NSString stringWithFormat:@"Ta给我授信%@  ", num2];

	NSMutableAttributedString *attr1 = [Util getAttributedString:theStr font:[UtilFont systemSmall] color:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
	[Util setAttributedString:attr1 font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:[theStr rangeOfString:numStr]];
	NSMutableAttributedString *attr2 = [Util getAttributedString:the2 font:[UtilFont systemSmall] color:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
	[Util setAttributedString:attr2 font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:[the2 rangeOfString:num2]];

	((UILabel *)[cell.labelArray objectAtIndex:2]).attributedText = attr2;
	((UILabel *)[cell.labelArray objectAtIndex:3]).attributedText = attr1;
	if (_type == ShouXin_MeiYou) {
		((UILabel *)[cell.labelArray objectAtIndex:2]).attributedText = nil;
		((UILabel *)[cell.labelArray objectAtIndex:2]).text           = @"";
	}
	else if (_type == ShouXin_YiJing) {
		((UILabel *)[cell.labelArray objectAtIndex:3]).attributedText = nil;
		((UILabel *)[cell.labelArray objectAtIndex:3]).text           = @"";
	}
	cell.editButton.hidden                              = (_type == ShouXin_YiJing);
	((UILabel *)[cell.labelArray objectAtIndex:4]).text = @"";

	//cell.sepLine.hidden = [self lastRow:indexPath.row];

	if (_type == ShouXin_MeiYou) {
        BOOL yisuoyao = [[dict objectForKey:NET_KEY_acquirecreditinlastdays] intValue] == 1;
        [cell.button1 setBackgroundColor: yisuoyao ? ZCOLOR(COLOR_TEXT_LIGHT_GRAY) : ZCOLOR(COLOR_BUTTON_RED)];
		[cell.button2 setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
		[cell.button1 setTitle:@"  索要授信  " forState:UIControlStateNormal];
		[cell.button1 setTitle:@"  已经索要  " forState:UIControlStateDisabled];
        cell.button1.enabled = !yisuoyao;
        
		[cell.button2 setTitle:@"  取消授信  " forState:UIControlStateNormal];
		cell.button2.hidden = NO;
	}
	else if (_type == ShouXin_YiJing) {
		[cell.button1 setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
		[cell.button1 setTitle:@"  加好友，授信  " forState:UIControlStateNormal];
		cell.button2.hidden = YES;
	}
	else if (_type == ShouXin_XiangHu) {
		[cell.button1 setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
		[cell.button1 setTitle:@"  取消授信  " forState:UIControlStateNormal];
		cell.button2.hidden = YES;
	}
	cell.delegate       = self;
	cell.button1.tag    = indexPath.row;
	cell.button2.tag    = indexPath.row;
	cell.editButton.tag = indexPath.row;

	cell.targetNum = [self targetChangeNum:num1];
    bool isvip = [ZAPP.myuser getUserLevel]==UserLevel_VIP;
    if (cell.targetNum > 1 && !isvip) {
        cell.editButton.hidden = YES;
    }else{
        cell.editButton.hidden = NO;
        NSString *btnt = [NSString stringWithFormat:@"改为%d万元", cell.targetNum];
        [cell.editButton setTitle:btnt forState:UIControlStateNormal];
    }
    if (_type == ShouXin_YiJing) {
        cell.editButton.hidden = YES;
    }

	return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    willGoDetail = YES;
	PersonHomePage *person = DQC(@"PersonHomePage");
	[person setTheDataDict:[self.dataArray objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:person animated:YES];
}

- (int)targetChangeNum:(int)v {
	if (v == 50000) {
		return 1;
	}
	else {
		return 5;
	}
}

- (void)changeCreditSuc {

    [Util toastStringOfLocalizedKey:@"tip.changeCreditSuccess"];

	//modify the local data
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:opRow]];
	int                  num1 = [[dict objectForKey:NET_KEY_CREDITOTHERVAL] intValue];
	int                  num2 = [self targetChangeNum:num1];
	[dict setObject:[NSNumber numberWithInt:(int)(num2*1e4)] forKey:NET_KEY_CREDITOTHERVAL];
	[self.dataArray replaceObjectAtIndex:opRow withObject:dict];
	[self.table reloadData];
}

- (void)changeCredit:(int)v userid:(NSString *)userid {
	bugeili_net
	//[self changeCreditSuc];
    progress_show
    WS(weakSelf)
    
    self.op = [ZAPP.netEngine creditWithComplete:^{[weakSelf changeCreditSuc];progress_hide} error:^{progress_hide} userid:userid intv:v];
}

- (void)cancelCreditSuc {

    [Util toastStringOfLocalizedKey:@"tip.cancelCredit"];
    [self removeRowAndReloadTable];
}

- (void)removeRowAndReloadTable {
    [self.dataArray removeObjectAtIndex:opRow];
    rowCnt = [self.dataArray count];
    totalCount --;
    
    [self.table reloadData];
}

- (void)cancelCreditUserid:(NSString *)userid {
	bugeili_net
	//[self cancelCreditSuc];
    progress_show
    WS(weakSelf)
    
    self.op = [ZAPP.netEngine creditWithComplete:^{[weakSelf cancelCreditSuc];progress_hide} error:^{progress_hide} userid:userid intv:0];
}

- (void)addSuc {

    [Util toastStringOfLocalizedKey:@"tip.creditSuccess"];
    [self removeRowAndReloadTable];
}

- (void)addFriendAndCreditUserid:(NSString *)userid intv:(int)v {
	bugeili_net
	//[self addSuc];
    progress_show
    WS(ws)

    self.op = [ZAPP.netEngine creditWithComplete:^{[ws addSuc];progress_hide} error:^{progress_hide} userid:userid intv:v];
}

- (void)shouxinOkdone {
    [self addSuc];
}

- (void)commandCreditSuc {
    //[ZAPP showAutoAlertWithTitle:@"索要授信成功！" msg:@"3秒钟关闭此窗口" cancelTitle:@"关闭" dissapearSeconds:3];

    [Util toastStringOfLocalizedKey:@"tip.askForCreditSuccess"];
    
    //modify the local data
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:opRow]];
    [dict setObject:[NSNumber numberWithInt:(int)(1)] forKey:NET_KEY_acquirecreditinlastdays];
    [self.dataArray replaceObjectAtIndex:opRow withObject:dict];
    [self.table reloadData];
}

- (void)commandCreditUserid:(NSString *)userid {
	bugeili_net
	//[self commandCreditSuc];
    progress_show
    self.op = [ZAPP.netEngine requestCreditWithComplete:^{[self commandCreditSuc];progress_hide} error:^{progress_hide} userid:userid];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [alertView cancelButtonIndex]) {
            NSDictionary *dict = [self.dataArray objectAtIndex:opRow];
            NSString *userid = [dict objectForKey:NET_KEY_USERID];
		if (alertView.tag == 0) {//索要
            [self commandCreditUserid:userid];
		}
		else if (alertView.tag == 1) {//取消
            [self cancelCreditUserid:userid];

		}
        if (alertView.tag == 10) {
            NewNewShenFen *e = ZEdit(@"NewNewShenFen");
            [self.navigationController pushViewController:e animated:YES];
        }
        else if (alertView.tag == 99) {
		[self changeCredit:opNum* 1e4 userid:userid];
        }
        else if (alertView.tag == 2) {//shouxin
            int t = 0;//取消授信
            if (buttonIndex == 1) {
                //1万
                t = 1e4;
            }
            else {
                //5万
                t = 5 * 1e4;
            }
            [self addFriendAndCreditUserid:userid intv:t];
        }
	}
}

- (void)cancelWithName:(NSString *)name {
     NSString *s =[NSString localizedStringWithFormat:CNLocalizedString(@"alert.title.shouxinList", nil), name];
//	NSString *   str   = [NSString stringWithFormat:@"确实要取消对%@的授信吗？", name];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s message:nil delegate:self cancelButtonTitle:@"保留授信" otherButtonTitles:@"取消授信", nil];
    //[alert customLayout];
	alert.tag = 1;
	[alert show];
}

- (void)buttonClicked:(NSInteger)buttonIndex row:(NSInteger)rowIndex targetNum:(int)num {
	NSDictionary *dict = [self.dataArray objectAtIndex:rowIndex];
	opRow = rowIndex;
    NSString *name   = [Util getUserRealNameOrNickName:dict];
	if (buttonIndex == 0) {
        NSString *s =[NSString localizedStringWithFormat:CNLocalizedString(@"alert.title.shouxinList2", nil), name, num];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s message:nil delegate:self cancelButtonTitle:@"不更改" otherButtonTitles:@"更改", nil];
        //[alert customLayout];
        alert.tag = 99;
        opNum = num;
        [alert show];
	}
	else if (buttonIndex == 1) {
		if (_type == ShouXin_MeiYou) {
            NSString *s =[NSString localizedStringWithFormat:CNLocalizedString(@"alert.title.shouxinList3", nil), name];
//			NSString *   str   = [NSString stringWithFormat:@"要对%@索要授信吗？", name];
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s message:CNLocalizedString(@"alert.message.shouxinList3", nil) delegate:self cancelButtonTitle:@"不索要" otherButtonTitles:@"索要", nil];
            //[alert customLayout];
			alert.tag = 0;
			[alert show];
		}
		else if (_type == ShouXin_YiJing) {
            int thetype = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_USERLEVEL] intValue];
            if (thetype == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.shouxinList4", nil) message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"去验证",nil];
                //[alert customLayout];
                alert.tag = 10;
                [alert show];
                return;
            }
            
            int mylimit = [ZAPP.myuser getRemainCreditLimit];
            if (mylimit < 1e4) {
                NSString *s = [NSString localizedStringWithFormat:CNLocalizedString(@"tip.creditBalanceNotEnough", nil), mylimit];
                [Util toast : s];
                return;
            }
            else  {
                QuerenShouxin *q = ZSEC(@"QuerenShouxin");
//                NSString *str = [NSString stringWithFormat:@"确定要加 %@ 为好友并为他授信吗？", name];
 
                //UIAlertView *alert;
                if (mylimit < 5*1e4 || thetype == 1) {
//                    NSString *msg = [NSString stringWithFormat:@"授信额度1万元（您当前还有%d万元可授信）", (int)(mylimit/10000)];
//                    alert = [[UIAlertView alloc] initWithTitle:str message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    //[alert customLayout];
                    q.allowFive = NO;
                }
                else {
//                    NSString *msg = [NSString stringWithFormat:@"请选择授信额度（您当前还有%d万元可授信）", (int)(mylimit/10000)];
//                    alert = [[UIAlertView alloc] initWithTitle:str message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"授信1万", @"授信5万", nil];
//                    //[alert customLayout];
                    q.allowFive = YES;
                }
//                alert.tag = 2;
//                [alert show];
//                
//                q.allowFive = allowfive;
                q.uid = [dict objectForKey:NET_KEY_USERID];
                q.delegate = self;
                [self.navigationController pushViewController:q animated:YES];
            }
		}
		else if (_type == ShouXin_XiangHu) {
			[self cancelWithName:name];
		}
	}
	else {
		[self cancelWithName:name];
	}
}

- (UILabel *)vLable{
    if (! _vLable) {
        _vLable = [[UILabel alloc] initWithFrame:self.view.bounds];
        _vLable.height = self.view.height/2;
        _vLable.textAlignment = NSTextAlignmentCenter;
        _vLable.font = [UIFont systemFontOfSize:20.0f];
        _vLable.textColor = ZCOLOR(@"#555555");
        _vLable.text = @"暂无授信";
        _vLable.hidden = YES;
        [self.table addSubview:_vLable];
    }
    return  _vLable;
}

@end
