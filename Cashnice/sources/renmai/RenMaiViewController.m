//
//  .m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "RenMaiViewController.h"
#import "MightKnownTableViewCell.h"
#import "RenmaiHeadTableViewController.h"
#import "SeachHaoyouViewController.h"
#import "InviteWebViewController.h"
#import "PersonHomePage.h"
#import "ShouxinList.h"
#import "MutualFriendViewController.h"
#import "ContactMgr.h"
#import "UpdateManager.h"
#import "UIScrollView+UIScrollVIew_BannerTipWithMJFresh.h"
#import "SearchAddFriendViewController.h"
#import "ShouxinEngine.h"
#import "PersonInfoAPIEngine.h"
#import "NoticeManager.h"


@interface RenMaiViewController () <UIScrollViewDelegate, MightKnownTableViewCellDelegate>{
    NSInteger rowCnt;
    NSInteger rowHeight;
    
    int curPage;
    int pageCount;
    int totalCount;
    NSDate *lastDate;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_tableHeight;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *mightKnownNumber;
//@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) RenmaiHeadTableViewController *renhead;
@property (strong, nonatomic) UILabel *vLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;


@property (nonatomic) NSInteger mightKnownCount;
@property (strong, nonatomic) UILabel *promptView;
@property (strong,nonatomic) ContactMgr *contactMgr;
@property (strong,nonatomic) ShouxinEngine *engine;

@end

@implementation RenMaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZCOLOR(@"#FFFFFF");
    
    self.mightKnownNumber.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.mightKnownNumber.font = [UtilFont systemLarge];
    
    rowCnt = 0;
    rowHeight = 110;
    curPage = 0;
    pageCount = 0;
    totalCount = 0;

    [Util setScrollHeader:self.scroll target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.scroll target:self footer:@selector(rf)];
    [self connectToServer];
    
    

  
    if([ZAPP.myuser gerenInfoDict]){
        [self.renhead setTheDataDict:[ZAPP.myuser gerenInfoDict]];
    }
}

- (void)popWaringView {
    [self.scroll adjustState:YES parent:self];
}

- (void)dismissWaringView {
    [self.scroll adjustState:NO parent:self];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
//    NSArray *vcs = self.navigationController.viewControllers;
    if(![self.title isEqualToString:@"好友"]){
        NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:self.table
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.topLayoutGuide
                                                              attribute:NSLayoutAttributeBaseline
                                                             multiplier:1.0
                                                               constant:0.0];
        [self.view addConstraints:@[top]];
        
        self.tableBottomConstraint.constant = 0.0f;
        
        [self setNavButton];
    }
    
    CGFloat promptViewSpacing = [ZAPP.zdevice getDesignScale:6];
    self.promptView.top = self.view.height - self.tableBottomConstraint.constant-self.promptView.height - promptViewSpacing;
    self.promptView.left = (self.view.width - self.promptView.width)/2;
}



#pragma mark - Getter

-(ShouxinEngine *)engine{
    
    if(!_engine){
        _engine = [[ShouxinEngine alloc]init];
    }
    
    return _engine;
}

-(ContactMgr *)contactMgr{
    
    if(!_contactMgr){
        _contactMgr = [[ContactMgr alloc]init];
    }
    return _contactMgr;
}


- (void)rhManul {
    curPage = 0;
    [self connectToServer];
}

- (void)rh {
    curPage = 0;
    [self.scroll.header beginRefreshing];
}

- (void)rhAppear {
    if (lastDate == nil) {
        [self rh];
    }
    else {
        NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:lastDate];
        if (t > UPDATE_TIME_INTERVAL) {
            [self rh];
        }
    }
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

- (void)setData:(NSDictionary *)mightKnownDict{
    curPage = [Util curPage:mightKnownDict];
    pageCount = [Util pageCount:mightKnownDict];
    totalCount = [Util totalCount:mightKnownDict];
    self.mightKnownCount = totalCount;
    
    
    if (! totalCount) {
        self.vLable.hidden = NO;
        [self.vLable setText:@"暂无可能认识的人"];
        [self.vLable sizeToFit];
        
        [self.vLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.scroll);
            make.top.equalTo(self.table.mas_top).mas_offset(40);
        }];
    }else{
        self.vLable.hidden = YES;
    }
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    int cnt = [[mightKnownDict objectForKey:NET_KEY_creditusercount] intValue];
    if (cnt > 0) {
        NSArray *respData = [mightKnownDict objectForKey:NET_KEY_creditusers];
        [self.dataArray insertPage:curPage objects:respData];
    }
    
#ifdef DEBUG_DUPLICATION
    NSMutableArray* useridarr = [[NSMutableArray alloc] init];
    NSMutableDictionary* userdict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict  in self.dataArray) {
        NSString *userid = dict[@"userid"];
        [useridarr addObject:userid];
        
        NSInteger passedidVal = [userdict[userid] integ erValue];
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
    [self.scroll.header endRefreshing];
    [self.scroll.footer endRefreshing];
    
    [self ui];
}

- (void)loseData {
    [self.scroll.header endRefreshing];
    [self.scroll.footer endRefreshing];
}

- (void)ui {
    self.con_tableHeight.constant = [ZAPP.zdevice getDesignScale: rowHeight * rowCnt];
    self.scroll.footer.hidden = ((curPage + 1) >= pageCount);
    
    self.mightKnownNumber.text = [NSString stringWithFormat:@"可能认识%d人", totalCount];
    self.promptView.text = [NSString stringWithFormat:@"可能认识%d人", totalCount];
    [self.promptView sizeToFit];
    self.promptView.width += ([ZAPP.zdevice getDesignScale:30]);
    self.promptView.height = [ZAPP.zdevice getDesignScale:30];
    
    [self.table reloadData];
    
    
}

- (void)connectToServer {
//    [self.op cancel];
    bugeili_net
    lastDate = [NSDate date];
    WS(ws);

    if (self.dataArray.count == 0) {
        progress_show
    }
    
    /*
    self.op = [ZAPP.netEngine getMightKnownWithComplete:^{
        [ws setData];
        progress_hide
        UpdateAndSharedTrigger
    } error:^{
        progress_hide
        [ws loseData];
    } userid:[ZAPP.myuser getUserID] page:curPage pagesize:DEFAULT_PAGE_SIZE];
     */
    
    [self.engine getMightKnown:curPage pageSize:DEFAULT_PAGE_SIZE userID:[ZAPP.myuser getUserID] success:^(NSDictionary *mightKnownDict) {
        progress_hide
        UpdateAndSharedTrigger
        [ws setData:mightKnownDict];

    } failure:^(NSString *error) {
        progress_hide
        [ws loseData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popWaringView) name:MSG_system_service_updating object:nil];
    
    
    [MobClick beginLogPageView:@"好友"];
    
//    [self setNavRightWarnBadge:[ZAPP.znotice getNtfNum]];
    NSArray *vcs = self.navigationController.viewControllers;
    if(vcs.count > 1){
        self.title = @"可能认识的人";
    }else{
        self.title = @"好友";
        [self setLeftNavLogo];
        [self setNavRightWarnBadge:[ZAPP.znotice getNtfNum]];
        
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    curPage = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popWaringView) name:MSG_system_service_updating object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWaringView) name:MSG_system_service_recovery object:nil];
    
    if ([ZAPP.zlogin isLogined]) {
        [self rhAppear];
        
        
        WS(weakSelf)

        //刷新个人数据
        [[PersonInfoAPIEngine sharedInstance] setUserInfoFreshBlock:^{
            [weakSelf.renhead setTheDataDict:[ZAPP.myuser gerenInfoDict]];
        }];
        
        POST_USERINFOFRESH_NOTI

        
        //上传通讯录
        [self.contactMgr uploadContacts:nil];
        
    }
    
    [ZAPP.znotice load];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"好友"];
//    [self.op cancel];
//    self.op = nil;
    
    [self.engine cancleAllHttpRequest];
    self.engine = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.scroll.header endRefreshing];
    [self.scroll.footer endRefreshing];
    
    [[PersonInfoAPIEngine sharedInstance] setUserInfoFreshBlock:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[RenmaiHeadTableViewController class]]) {
        ((RenmaiHeadTableViewController *)[segue destinationViewController]).delegate  = self;
        self.renhead = (RenmaiHeadTableViewController *)[segue destinationViewController];
    }
}

- (void)renmaiheaderpressed:(int)idx {
    if (idx == 4) {
//        SeachHaoyouViewController *haoyou = ZSTORY(@"SeachHaoyouViewController");
//        [self.navigationController pushViewController:haoyou animated:YES];
        
        UIViewController *savc = SEARCHSTORY(@"SearchAddFriendNewControllerViewController");
        savc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:savc animated:YES];
        
    }
    else if (idx == 5) {
        //YaoqingHaoyou *haoyou = ZSTORY(@"YaoqingHaoyou");
        
        InviteWebViewController *haoyou = [[InviteWebViewController alloc]init];
        haoyou.urlStr = [NSString stringWithFormat:@"%@%@%@", WEB_DOC_URL_ROOT, NET_PAGE_INVITE_INDEX, [ZAPP.myuser getUserID]];
        //haoyou.atitle = @"Title";
        //haoyou.desc = @"showUnit.desc";
        [self.navigationController pushViewController:haoyou animated:YES];
    }
    else if (idx == 2){
        ShouxinList *list = ZSEC(@"ShouxinList");
        [list setShowXintype:ShouXin_MeiYou];
        [self.navigationController pushViewController:list animated:YES];
    }
    else if (idx == 3){
        ShouxinList *list = ZSEC(@"ShouxinList");
        [list setShowXintype:ShouXin_YiJing];
        [self.navigationController pushViewController:list animated:YES];
    }
    else if (idx == 1){
        ShouxinList *list = ZSEC(@"ShouxinList");
        [list setShowXintype:ShouXin_XiangHu];
        [self.navigationController pushViewController:list animated:YES];
    }
    else if (idx == 6) {
        RenMaiViewController *list = ZRENMAI(@"RenMaiViewController");
        [self.navigationController pushViewController:list animated:YES];
    }
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
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MightKnownTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *dict = [[self dataArray] objectAtIndex:indexPath.row];
    
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    [cell.img setHeadImgeUrlStr:[dict objectForKey:NET_KEY_HEADIMG]];
    
    cell.nameLabel.text = [Util getUserRealNameOrNickName:dict];
    
    cell.friNumLabel.text = [NSString stringWithFormat:@"%ld", [dict[@"MutualFriend"] integerValue]];
    
    cell.titleLabel.text = [dict objectForKey:@"organizationduty"];
    
    cell.orgLabel.text = [dict objectForKey:NET_KEY_ORGANIZATION];
    
    
    //cell.sepLine.hidden = [self lastRow:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    PersonHomePage *person = DQC(@"PersonHomePage");
    NSMutableDictionary *d = [self.dataArray objectAtIndex:indexPath.row];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:d];
    [dict setObject:[d objectForKey:NET_KEY_ORGANIZATION] forKey:NET_KEY_ORGANIZATIONNAME];
    [dict setObject:[d objectForKey:NET_KEY_JOB] forKey:NET_KEY_ORGANIZATIONDUTY];
    [person setTheDataDict:[self.dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:person animated:YES];
}

- (void)mutualFriendListAction:(NSInteger)indexRow{
    NSDictionary *dict = [[self dataArray] objectAtIndex:indexRow];
    MutualFriendViewController *vc = ZRENMAI(@"MutualFriendViewController");
    vc.dataDict = dict;
    [self.navigationController pushViewController:vc animated:YES];
//    NSInteger mutualFridens = [dict[@"MutualFriend"] integerValue];
//    if (mutualFridens > 0) {
//    }else{
//        [Util toast:@"您和Ta暂时没有共同朋友"];
//    }
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
        _promptView = [[UILabel alloc] init];
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

- (UILabel *)vLable{
    if (! _vLable) {
        _vLable = [[UILabel alloc] initWithFrame:self.view.bounds];
        _vLable.textAlignment = NSTextAlignmentCenter;
        _vLable.font = [UIFont systemFontOfSize:20.0f];
        _vLable.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        _vLable.height = self.view.height/2;
        _vLable.hidden = YES;
        [self.scroll addSubview:_vLable];
    }
    return  _vLable;
}


@end
