//
//  ServiceMessageViewController.m
//  YQS
//
//  Created by a on 16/1/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ServiceMessageViewController.h"
#import "LabelsView.h"
#import "GeRenTableViewCell.h"
#import "ServiceMessageTableViewCell.h"
#import "EditingTableViewCell.h"
#import "NoticeManager.h"
#import "PersonHomePage.h"
#import "ShouxinList.h"

#import "BillDetail.h"
#import "MessageLaunchingUtil.h"
#import "NewSysMsgCell.h"
#import "ServiceMsgEngine.h"

@interface ServiceMessageViewController () <EditingTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate> {
    int rowHeight;
    
    BOOL goDetail;
    int curPage;
    int pageCount;
    int totalCount;
    
//    BOOL edited;
    
    NSMutableSet *set;
    
}

@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *deleteContentArray;
//@property (nonatomic) BOOL isEditing;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UILabel *deleteViewCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteViewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (strong, nonatomic) UIBarButtonItem *cancelNavigationBarItem;

@property (strong, nonatomic) ServiceMsgEngine *engine;

@end

@implementation ServiceMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
//    self.view.backgroundColor = ZCOLOR(COLOR_TAB_REFRESH_HEAD);

    self.table.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:CN_COLOR_DD_GRAY];

    rowHeight = TABLE_TEXT_ROW_HEIGHT;
    curPage = 0;
    pageCount = 0;
    totalCount = 0;
    
//    edited = YES;
    
    set = [NSMutableSet set];
    
    [Util setScrollHeader:self.table target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.table target:self footer:@selector(rf)];
    
    self.table.header.backgroundColor = CN_COLOR_DD_GRAY;

    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.table.estimatedRowHeight = 120;
    self.table.rowHeight = UITableViewAutomaticDimension;
    
    
    self.deleteViewBottom.constant = -100; //默认隐藏
    self.tableViewBottom.constant = 0;
}

BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    [MobClick beginLogPageView:@"提醒"];
    [self setNavButton];
    [self setupNavBar];

    [self setTitle:@"提醒"];
    [self ui];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick endLogPageView:@"提醒"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    if (goDetail) {
        goDetail = NO;
        return;
    }
    if ([ZAPP.zlogin isLogined]) {
        [self rhAppear];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"提醒"];
    
    [self.op cancel];
    self.op = nil;
    [self loseData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(ServiceMsgEngine *)engine{
    
    if (!_engine) {
        _engine = [[ServiceMsgEngine alloc]init];
    }
    
    return _engine;
}

- (void)rhManul {
    curPage = 0;
    [self connectToServer];
}

- (void)rh {
    curPage = 0;
    // [self connectToServer];
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

- (void)setupNavBar{
    //Right
    
    [super setNavRightBtn];
    [self.rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
}
- (void)rightNavItemAction{
    [self editAction];
}

- (UIBarButtonItem *)cancelNavigationBarItem{
    if (! _cancelNavigationBarItem) {
        //Right
        UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 9, 45, 22)];
        editBtn.titleLabel.font = [UtilFont system:12.0f];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editingStopedAction) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setTitle:@"取消" forState:UIControlStateNormal];
        editBtn.backgroundColor = [UIColor clearColor];
        editBtn.layer.borderWidth = 1;
        editBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        editBtn.layer.cornerRadius = 5;
        editBtn.layer.masksToBounds = YES;
        
        UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, KNAV_SUBVIEW_MAXHEIGHT)];
        [containerView1 addSubview:editBtn];
        _cancelNavigationBarItem = [[UIBarButtonItem alloc]initWithCustomView:containerView1];
//        _cancelNavigationBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(editingStopedAction)];
    }
    return _cancelNavigationBarItem;
}

- (void)editAction {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 1;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, self.cancelNavigationBarItem]];
    
    self.pseudoEdit = YES;
    
    [self.table setEditing:YES animated:YES];
    [self animationDeleteViewSetEditing:YES];
    
    [self.table removeHeader];
    
    [self.deleteContentArray removeAllObjects];
    self.deleteViewCountLabel.text = @"0";
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)editingStopedAction{
    [self.table setEditing:NO animated:YES];
    [self animationDeleteViewSetEditing:NO];
    
    [Util setScrollHeader:self.table target:self header:@selector(rhManul) dateKey:[Util getDateKey:self]];
    
    [self.deleteContentArray removeAllObjects];
    
    [self setNavButton];
    [self setupNavBar];
}

- (IBAction)deleteAction:(id)sender {
    if (self.deleteContentArray.count > 0) {
        NSMutableArray *deleteIdArray = [[NSMutableArray alloc] init];
        NSMutableArray *deleteIndexPath = [[NSMutableArray alloc] init];
        
        for (NSNumber *idx in self.deleteContentArray) {
            NSInteger i = [idx integerValue];
            if (i < self.dataArray.count) {
                NSString *noticeid = self.dataArray[i][@"noticeid"];
                [deleteIdArray addObject:noticeid];
                [deleteIndexPath addObject: [NSIndexPath indexPathForRow:i inSection:0]];
                [_dataArray removeObjectAtIndex:i];
            }
        }

        [self.table beginUpdates];
        [self.table deleteRowsAtIndexPaths:deleteIndexPath withRowAnimation:UITableViewRowAnimationNone];
        [self.table endUpdates];
        
        [self.deleteContentArray removeAllObjects];
        [self updateDeleteView];
        
        [ZAPP.netEngine deleteRemindListWithComplete:^{
            //[self rh];
            //Refresh
            [ZAPP.netEngine getRemindListWithComplete:^{
                ;
            } error:^{
                ;
            } page:0 pagesize:DEFAULT_PAGE_SIZE];
        } error:^{
            ;
        } notices:deleteIdArray];
    }else{

        [Util toastStringOfLocalizedKey:@"tip.deleteAlert"];
    }
    
    //[self editingStopedAction];
}

- (void)updateDeleteView{
    NSInteger deleteCount = self.deleteContentArray.count;
    self.deleteViewCountLabel.text = [NSString stringWithFormat:@"%ld", deleteCount];
    if (! deleteCount) {
        self.deleteViewButton.titleLabel.text = @"完成";
    }else{
        self.deleteViewButton.titleLabel.text = @"删除";
    }
}

- (void)animationDeleteViewSetEditing : (BOOL)editing {
    self.deleteViewBottom.constant = editing?50:0;
    self.tableViewBottom.constant = editing?50:0;
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        nil;
    }];
}

- (void)setData {
    curPage = [Util curPage:ZAPP.znotice.noticeListDict];
    pageCount = [Util pageCount:ZAPP.znotice.noticeListDict];
    totalCount = [Util totalCount:ZAPP.znotice.noticeListDict];
    
    if (curPage == 0) {
        /**
         *  如果获取的是第一页通知，代表所有不再有新的通知
         */
        [ZAPP.znotice clearNtfNum];
        
        [self.dataArray removeAllObjects];
    }
    
    int cnt = [[ZAPP.znotice.noticeListDict objectForKey:NET_KEY_NOTICECOUNT] intValue];
    if (cnt > 0) {
        
        NSMutableArray *reformArr = [NSMutableArray array];
        
        //优化nsdate操作
        [[ZAPP.znotice.noticeListDict objectForKey:NET_KEY_NOTICES] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
            [dic setObject:[Util dateToMinute:obj[@"noticedate"]] forKey:@"time"];
            
            [reformArr addObject:dic];
        }];
        
           [self.dataArray insertPage:curPage objects:reformArr];
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
    
    [self.deleteContentArray removeAllObjects];
}

- (void)connectToServer {
    [self.op cancel];
    bugeili_net
    WS(ws);

    self.op = [ZAPP.netEngine getRemindListWithComplete:^{[ws setData]; } error:^{[ws loseData];} page:curPage pagesize:DEFAULT_PAGE_SIZE];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (BOOL)lastRow:(NSIndexPath *)indexPath {
    //[UtilLog intValue:rowCnt];
    //[UtilLog intValue:indexPath.row];
    return (indexPath.row == ([self.dataArray count] - 1));
}

- (void)selectCell:(EditingTableViewCell *)cell {
    NSIndexPath *indexPath =  [self.table indexPathForCell:cell];
    UITableView *tableView = self.table;
    
    if (cell.selected) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        // Above method will not call the below delegate methods
        if ([tableView.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
        }
        if ([tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        }
    } else {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        // Above method will not call the below delegate methods
        if ([tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
        }
        if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

- (BOOL)canJump:(int)ty behave:(int)be{
    if (ty == 1 && be == 2) {           //转账通知
        return YES;
    }
    if (ty == 16) {
        //借条
        return YES;
    }
    
    if (ty == 2 && (be == 6 || be == 9)) {           //审核失败不带详情
        return NO;
    }
    if (ty == 1 && be == 7) {           //带有详情的系统消息
        return YES;
    }
    if (ty == 2 || ty == 3 || ty == 4 || ty == 6 || ty == 7 || ty == 8 || ty == 9) {
        if (ty == 3 && be == 6) {
            return YES;
        }
        return YES;
    }
    else {
        return NO;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return [ZAPP.zdevice getDesignScale:0];
    return 10;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return [ZAPP.zdevice getDesignScale:20];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
    //    LabelsView *v =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
    //    NSString *str = [Util intWithUnit:totalCount unit:@""];
    //    [v setTexts:@[str,@"条未读"]];
    //    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (void)loadPersonHome:(NSDictionary *)dict {
    NSString *userid = [dict objectForKey:NET_KEY_FROMUSERID];
    NSString *realname = [dict objectForKey:NET_KEY_FROMUSERREALNAME];
    if ([userid notEmpty] && ![userid isEqualToString:@"0"] && [realname notEmpty]) {
        PersonHomePage *per = DQC(@"PersonHomePage");
        [per setTheDataDict:@{NET_KEY_USERID:userid,
                              NET_KEY_USERREALNAME:realname}];
        goDetail = YES;
        [self.navigationController pushViewController:per animated:YES];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Move this asignment to the method/action that
    // handles table editing for bulk operation.
    self.pseudoEdit = YES;
    
    [super setEditing:editing animated:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServiceMessageTableViewCell *cell;
    static NSString *CellIdentifier = @"ServiceMessageTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setEditing:self.table.isEditing];
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    cell.rowRight.hidden = ![self canJump:ty behave:behave];
    
    if (dict[@"title"] != [NSNull null]) {
        cell.titleLabel.text = dict[@"title"];
    }else{
        cell.titleLabel.text = @"";
    }
    if (dict[@"time"] != [NSNull null]) {
//        cell.timeLabel.text = [Util dateToMinute:dict[@"noticedate"]];
        cell.timeLabel.text = dict[@"time"];
    }else{
        cell.timeLabel.text = @"";
    }
    if (dict[@"desc"] != [NSNull null]) {
        cell.contentLabel.text = dict[@"desc"];
    }else{
        cell.contentLabel.text = @"";
    }
    
    cell.titleIcon.image = [MessageLaunchingUtil iconImageOfNoticeDict:dict];
    
    //0 未读 1已读
    if ([[dict objectForKey:@"un_remind"] integerValue] == 0) {
        cell.coverView.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor blackColor];

    }else{
        cell.coverView.backgroundColor = HexRGB(0xf6f6f6);
        cell.titleLabel.textColor = HexRGB(0x999999);
    }

    cell.shouldShowGoDetailLabel = [MessageLaunchingUtil shouldReactForDetail:dict];
    
    return cell;
}



- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    NSInteger row = indexPath.row;

    if (! self.table.isEditing) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self detailPressedWithIndex: row];
        return;
    }
    
//    if ([self hasSelected:row]) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [self.deleteContentArray removeObject:@(row)];
//
//    }else{
//        [self.deleteContentArray addObject:@(row)];
//
//    }
  
    [self.deleteContentArray addObject:@(row)];
    [self updateDeleteView];
//    [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self updateDeleteView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    [self.deleteContentArray removeObject:@(row)];
    [self updateDeleteView];
}
- (void)detailPressedWithIndex:(NSInteger)rowIndex {
    goDetail = YES;

    //标记已读
    [self markRead:rowIndex];

    NSDictionary *dict = [self.dataArray objectAtIndex:rowIndex];
    
    if([MessageLaunchingUtil shouldReactForDetail:dict]){
        [MessageLaunchingUtil MesssageLaunchAction:dict viewController:self];
    }
        
}

-(void)markRead:(NSInteger)rowIndex{
    
    NSDictionary *dict = [self.dataArray objectAtIndex:rowIndex];
    
    if ([[dict objectForKey:@"un_remind"] integerValue] == 1) {
        return;
    }
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    mutDic[@"un_remind"] = @(1);
    [self.dataArray replaceObjectAtIndex:rowIndex withObject:mutDic];
  
    [self.table reloadData];
    
    [self.engine setNoticeRead:[dict[@"noticeid"] integerValue] success:^{
        NSLog(@"setNoticeRead ok ");
    } failure:^(NSString *error) {
        
    }];

    
}

- (ShouXinType)getTypeForShouxin:(int)ty {
    if (ty == 1) {
        return ShouXin_MeiYou;
    }
    else if (ty == 2) {
        return ShouXin_YiJing;
    }
    else if (ty == 3) {
        return ShouXin_XiangHu;
    }
    return ShouXin_MeiYou;
}

- (void)loadBill:(NSDictionary *)dict {
    BillDetail *e = ZBill(@"BillDetail");
    e.billID = [dict objectForKey:NET_KEY_NOTCEID];
    e.headImg = [dict objectForKey:NET_KEY_FROMUSERHEADIMG];
    [self.navigationController pushViewController:e animated:YES];
    
}

- (NSMutableArray *)deleteContentArray{
    if (! _deleteContentArray) {
        _deleteContentArray = [[NSMutableArray alloc]init];
    }
    return _deleteContentArray;
}

-(BOOL)hasSelected:(NSInteger)row{
    
    for (NSNumber *num in self.deleteContentArray) {
        if ([num integerValue] == row) {
            return YES;
        }
    }
    
    return NO;
}

@end

