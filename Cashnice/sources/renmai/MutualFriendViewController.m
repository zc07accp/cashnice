//
//  MutualFriendViewController.m
//  Cashnice
//
//  Created by a on 16/3/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MutualFriendViewController.h"
#import "MightKnownTableViewCell.h"
#import "PersonHomePage.h"
#import "LabelsView.h"

@interface MutualFriendViewController () <UITableViewDataSource, UITableViewDelegate>{
    
    NSInteger rowCnt;
    NSInteger rowHeight;
    
    int curPage;
    int pageCount;
    int totalCount;
    NSDate *lastDate;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UILabel *vLable;
@property (strong, nonatomic) UILabel *promptView;

@end

@implementation MutualFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = ZCOLOR(@"#FFFFFF");
    
    rowCnt = 0;
    rowHeight = 110;
    curPage = 0;
    pageCount = 0;
    totalCount = 0;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
    self.tableView.footer.hidden = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self connectToServer];
    
    [self setNavButton];
    
    self.title = @"共同朋友";
}

- (void)viewDidLayoutSubviews{
    CGFloat promptViewSpacing = [ZAPP.zdevice getDesignScale:6];
    self.promptView.top = self.view.height - self.promptView.height - promptViewSpacing;;
    self.promptView.left = (self.view.width - self.promptView.width)/2;
    [self.view layoutIfNeeded];
}

- (void)rhManul {
    curPage = 0;
    [self connectToServer];
}

- (void)rh {
    curPage = 0;
    [self.tableView.header beginRefreshing];
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

- (void)setData {
    curPage = [ZAPP.myuser.mutualFriendDict[@"curpage"] intValue];
    pageCount = [ZAPP.myuser.mutualFriendDict[@"pagecount"] intValue];
    totalCount = [ZAPP.myuser.mutualFriendDict[@"totalcount"] intValue];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
//    int cnt = [[ZAPP.myuser.mutualFriendDict objectForKey:@"data"] intValue];
//    if (cnt > 0) {
        NSArray *respData = [ZAPP.myuser.mutualFriendDict objectForKey:@"data"];
        [self.dataArray insertPage:curPage objects:respData];
//    }
    
    
    if (! totalCount) {
        self.vLable.hidden = NO;
        NSString *fridenName = self.dataDict[@"userrealname"];
        [self.vLable setText:[NSString stringWithFormat:@"你和%@目前没有共同好友", fridenName]];
    }else{
        self.vLable.hidden = YES;
    }
    
    rowCnt = [self.dataArray count];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    [self ui];
}

- (void)loseData {
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)ui {
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
    
    self.promptView.text = [NSString stringWithFormat:@"共%d人", totalCount];
    [self.promptView sizeToFit];
    self.promptView.width += ([ZAPP.zdevice getDesignScale:30]);
    self.promptView.height = [ZAPP.zdevice getDesignScale:30];
    
    [self.tableView reloadData];
}

- (void)connectToServer {
    bugeili_net
    lastDate = [NSDate date];
    
    NSString *fridenUserId = self.dataDict[NET_KEY_USERID];
    
    [ZAPP.netEngine getMutualFriendWithComplete:^{
        [self setData];
        
        SharedTrigger
    } error:^{
        [self loseData];
    } friendUserid:fridenUserId page:curPage pagesize:DEFAULT_PAGE_SIZE];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [MobClick beginLogPageView:@"好友"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    curPage = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    if ([ZAPP.zlogin isLogined]) {
        [self rhAppear];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"好友"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowCnt;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSInteger mutualFridens = [self.dataDict[@"MutualFriend"] integerValue];
    return [ZAPP.zdevice getDesignScale:(mutualFridens ? 0 : 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:rowHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LabelsView *v     =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
    NSString *fridenName = self.dataDict[@"userrealname"];
    [v setTexts:@[@"你和",fridenName, @" 目前没有共同好友"]];
    v.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
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
    
    [cell.img setHeadImgeUrlStr:[dict objectForKey:NET_KEY_HEADIMG]];
    //    cell.img.layer.cornerRadius = cell.img.bounds.size.width/2;
    //    cell.img.layer.masksToBounds = YES;
    
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
        _vLable.height = self.view.height/2;
        _vLable.textAlignment = NSTextAlignmentCenter;
        _vLable.font = [UIFont systemFontOfSize:20.0f];
        _vLable.textColor = ZCOLOR(@"#555555");
        _vLable.hidden = YES;
        [self.tableView addSubview:_vLable];
    }
    return  _vLable;
}

@end
