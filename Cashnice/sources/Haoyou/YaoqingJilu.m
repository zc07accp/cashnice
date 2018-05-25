//
//  SeachHaoyouViewController.m
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "YaoqingJilu.h"
#import "HaoyouRecordHeaderTableViewCell.h"
#import "HaoyouRecordTableViewCell.h"

@interface YaoqingJilu () {
    int rowHeight;
    int rowCnt;
    
    int curPage;
    int pageCount;
    int totalCount;
    NSDate *lastDate;
    
    int opRow;
}

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeRed;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation YaoqingJilu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.table.layer.cornerRadius = [Util getCornerRadiusLarge];
    
    [Util setUILabelLargeGray:self.largeGray];
    [Util setUILabelLargeRed:self.largeRed];
    
    rowHeight = 30;
    rowCnt = 0;
    
    curPage = 0;
    pageCount = 0;
    totalCount = 0;
    
    [Util setScrollFooter:self.table target:self footer:@selector(rf)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"邀请好友记录"];
    [self setTitle:@"邀请好友记录"];
    
    [self ui];
}

- (void)ui {
    self.numberLabel.text = [NSString stringWithFormat:@"%d", totalCount];
    self.table.footer.hidden = ((curPage + 1) >= pageCount);
    [self.table reloadData];
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
    curPage = [Util curPage:ZAPP.myuser.inviteListDict];
    pageCount = [Util pageCount:ZAPP.myuser.inviteListDict];
    totalCount = [Util totalCount:ZAPP.myuser.inviteListDict];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    int cnt = (int)[[ZAPP.myuser.inviteListDict objectForKey:@"invitescount"] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.inviteListDict objectForKey:@"invites"]];
    }
    
    rowCnt = (int)[self.dataArray count];
    [self.table.header endRefreshing];
    [self.table.footer endRefreshing];
    
    [self ui];
}

- (void)loseData {
    [self.table.header endRefreshing];
    [self.table.footer endRefreshing];
}

- (void)connectToServer {
    [self.op cancel];
    bugeili_net
    
    progress_show
    WS(ws);

    self.op = [ZAPP.netEngine getInviteWithComplete:^{[ws setData];progress_hide} error:^{[ws loseData];progress_hide} page:curPage pagesize:DEFAULT_PAGE_SIZE];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    if ([ZAPP.zlogin isLogined]) {
        [self rhAppear];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"邀请好友记录"];
    
    [self.op cancel];
    self.op = nil;
    [self loseData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return [ZAPP.zdevice getDesignScale:30];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:rowHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HaoyouRecordHeaderTableViewCell *cell;
    static NSString *CellIdentifier = @"header";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HaoyouRecordTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [Util getUserRealNameOrNickName:dict];
 //   cell.timeLabel.text = [Util shortDateFromFullFormat:[dict objectForKey:@"regtime"]];
    cell.timeLabel.text = [dict objectForKey:@"regtime"];
    
    BOOL hasShouxin = ([[dict objectForKey:NET_KEY_CREDITSTATUS] intValue] == 1);
    cell.shouxinLabel.text = hasShouxin ? @"已授信" : @"未授信";
    cell.shouxinLabel.textColor = hasShouxin ? ZCOLOR(COLOR_BUTTON_BLUE) : ZCOLOR(COLOR_BUTTON_RED);
    
    BOOL canSouyao = ([[dict objectForKey:NET_KEY_acquirecreditinlastdays] intValue] == 0);
    
    
    cell.suoyaoButton.hidden = hasShouxin;
    cell.suoyaoButton.enabled = canSouyao;
    [cell.suoyaoButton setBackgroundColor:ZCOLOR(canSouyao ? COLOR_BUTTON_BLUE : COLOR_TEXT_LIGHT_GRAY)];
    cell.suoyaoButton.tag = indexPath.row;
    
    cell.delegate = self;
    cell.sepLine.hidden = [self lastRow:indexPath.row];
    
    return cell;
}

- (void)souyaopressed:(int)rowindex {
    NSDictionary *dict = [self.dataArray objectAtIndex:rowindex];
    NSString *str =[NSString localizedStringWithFormat:CNLocalizedString(@"alert.title.yaoQingJiLu", nil), [Util getUserRealNameOrNickName:dict] ];
   
//    NSString *   str   = [NSString stringWithFormat:@"要对%@索要授信吗？", [Util getUserRealNameOrNickName:dict]];
//    NSString * msg = @"索要授信3天后才能再次索要。";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:CNLocalizedString(@"alert.message.yaoQingJiLu", nil) delegate:self cancelButtonTitle:@"不索要" otherButtonTitles:@"索要", nil];
    //[alert customLayout];
    alert.tag = rowindex;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        int rowHere = (int)alertView.tag;
        NSDictionary *dict = [self.dataArray objectAtIndex:rowHere];
        NSString *uid = [dict objectForKey:NET_KEY_USERID];
        opRow = rowHere;
        [self commandCreditUserid:uid];
    }
}

- (void)commandCreditSuc {
    //[ZAPP showAutoAlertWithTitle:@"索要授信成功！" msg:@"3秒钟关闭此窗口" cancelTitle:@"关闭" dissapearSeconds:3];
//    [Util toast:@"索要授信成功"];
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
    WS(ws);

    self.op = [ZAPP.netEngine requestCreditWithComplete:^{[ws commandCreditSuc];progress_hide} error:^{progress_hide} userid:userid];
}


@end
