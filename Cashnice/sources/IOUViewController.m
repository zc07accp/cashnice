//
//  IOUViewController.m
//  Cashnice
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUViewController.h"
#import "TopTapView.h"
#import "IOUCell.h"
#import "IOUDetailViewController.h"
#import "IOUWaitSureDetailViewController.h"
#import "UIScrollView+UIScrollVIew_BannerTipWithMJFresh.h"
#import "WriteIOUViewController.h"
#import "IOUShowRepaymentViewController.h"
#import "IOUListNetEngine.h"
#import "MoneyFormatViewModel.h"
#import "IOUDetail2ViewController.h"
#import "ListCountTip.h"
#import "MyIouTableViewController.h"
#import "IOUDetailEngine.h"
#import "ShowCardViewController.h"
#import "UpdateManager.h"
#import "UIScrollView+UIScrollVIew_BannerTipWithMJFresh.h"

static CGFloat const IOULIST_ROW_HEIGHT = 93.f;

static CGFloat const TOPVIEW_HEIGHT = 92.f;

@interface IOUViewController ()<UITableViewDelegate, UITableViewDataSource,TopTapDelegate>
{
    BOOL isHeaderHide;
    NSInteger curPage;
    NSInteger pageCount;

    
    NSInteger count_receive;//待收借条数量
    CGFloat total_receive ;//待收总金额
    
    NSInteger count_payment ;//待还借条数量
    CGFloat total_payment; //待换总金额
}
@property (strong,nonatomic) TopTapView *topView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *headerView;
@property (strong,nonatomic) UILabel *emptyDataLabel;
@property (strong,nonatomic) NSMutableArray *dataArr;

@property (strong,nonatomic) IOUListNetEngine *engine;
@property (strong,nonatomic) WriteIOUNetEngine *w_engine;

@property (strong,nonatomic) ListCountTip *listTip;


@end

@implementation IOUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CN_COLOR_DD_GRAY;

    UIView *superView = self.view;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);

    }];
    
    [self.tableView addSubview:self.emptyDataLabel];
    [self.emptyDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.center.equalTo(self.tableView);
        
    }];
    self.emptyDataLabel.hidden = YES;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(getData) dateKey:[Util getDateKey:self]];

    [self updateUI:nil];
    
    bugeili_net_new

    progress_show

    [self getData];
    
    self.title = @"借条";
    [self setNavRightBtn];
    [self setLeftNavLogo];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:KIOUHOME_FRESH_NOTIFY object:nil];
    
    [ZAPP.netEngine getUserInfoWithComplete:^{
    } error:^{
    }];
    
    
    [self.w_engine getAverageSuccess:^(CGFloat rate) {
    } failure:^(NSString *error) {
    }];

    UpdateAndSharedTrigger
    
//    [self performSelector:@selector(goNe) withObject:nil afterDelay:3];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

//    [ZAPP updateNavLeftLogo];
    
    [MobClick beginLogPageView:@"借条"];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popWaringView) name:MSG_system_service_updating object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWaringView) name:MSG_system_service_recovery object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"借条"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MSG_system_service_updating object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MSG_system_service_recovery object:nil];

    //注意： 不能直接调用removeObserver:self
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.listTip adjustFrame];
}

- (void)popWaringView {
    [self.tableView adjustState:YES parent:self];
}

- (void)dismissWaringView {
    [self.tableView adjustState:NO parent:self];
}

#pragma mark - getter


-(WriteIOUNetEngine *)w_engine{
    
    if(!_w_engine){
        _w_engine = [[WriteIOUNetEngine alloc]init];
    }
    return _w_engine;
}


-(TopTapView *)topView{
    if (!_topView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TopTapView" owner:self options:nil];
        _topView = nib[0];
        _topView.delegate = self;
    }
    
    return _topView;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [ZAPP.zdevice getDesignScale:40])];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:_headerView.bounds];
        [_headerView addSubview:label];
        label.tag = 100;
        label.font= [UtilFont systemLarge];
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.text = @"与我相关的待确认借入、借出、还款、驳回";
        
        UIView*lineview = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height-1, _headerView.frame.size.width, 1)];
        [lineview setBackgroundColor:CN_COLOR_DD_GRAY];
        [_headerView addSubview:lineview];
    }
    
    return _headerView;
}


-(UITableView *)tableView{
   
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

-(UILabel *)emptyDataLabel{
    
    if (!_emptyDataLabel) {
        _emptyDataLabel = [[UILabel alloc]init];
        _emptyDataLabel.text = @"暂无数据";
        _emptyDataLabel.textAlignment = NSTextAlignmentCenter;
        _emptyDataLabel.textColor = CN_TEXT_GRAY;
        _emptyDataLabel.font = [UIFont systemFontOfSize:20.0f];
    }
    
    return _emptyDataLabel;
}

-(IOUListNetEngine *)engine{
    
    if(!_engine){
        _engine = [[IOUListNetEngine alloc]init];
    }
    
    return _engine;
}

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(ListCountTip *)listTip{

    if(!_listTip){
        _listTip = [ListCountTip tipSuperView:self.view bottomLayout:self.mas_bottomLayoutGuideTop];
    }
    
    return _listTip;
}

-(void)getData{
    
    DLog();

    curPage = 1;
    pageCount=DEFAULT_PAGE_SIZE;
    
    bugeili_net_new_block(^{
        [self endFreshState];
    });
    [self requestListData];

}


-(void)getMoreCNData{
    
    curPage ++;
    pageCount=DEFAULT_PAGE_SIZE;
    
    bugeili_net_new_block(^{
        [self endFreshState];
    });
    [self requestListData];
    
}

-(void)requestListData{
    
    __weak __typeof__(self) weakSelf = self;

    [self.engine getPendingList:@{@"userid":[ZAPP.myuser getUserID],
                                  @"pagenum":@(curPage),
                                  @"pagesize":@(pageCount)}
                        success:^(NSDictionary *dic) {
                            [weakSelf updateUI:dic];
                            progress_hide

                        } failure:^(NSString *error) {
                            progress_hide
                            [weakSelf endFreshState];
                        }];
}

-(void)updateUI:(NSDictionary *)dic{
    [self endFreshState];
 
    //下面的应该再放在一个viewmodel里面
    
    count_receive = [dic[@"count_receive"] integerValue];
    total_receive = [dic[@"total_receive"] floatValue];
    
    count_payment = [dic[@"count_payment"] integerValue];
    total_payment = [dic[@"total_payment"] floatValue];

    //self.topView.topLabel1.text = [NSString stringWithFormat:@"%ld张待收", (long)count_receive];
    //self.topView.topLabel2.text = [NSString stringWithFormat:@"%ld张待还", (long)count_payment];

    
    MoneyFormatViewModel *m = [MoneyFormatViewModel viewModelFrom:2];
    m.originalMoneyNum = @(total_receive);
    //NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:m.reformedMoneyStr];
    //NSMutableAttributedString *forstr = [Util getAttributedString:@"待收款" font:[UtilFont systemNormal:18] color:CN_TEXT_GRAY];
    //[str insertAttributedString:forstr atIndex:0];
    //self.topView.detailLabel1.attributedText = str;
    
    self.topView.detailLabel1.text = [Util formatRMBWithoutUnit:@(total_receive)];
    
    NSInteger count_today_receive=[dic[@"count_today_receive"] integerValue];
    NSInteger count_today_payment=[dic[@"count_today_payment"] integerValue];
    [self.topView setRed1Count:count_today_receive];
    [self.topView setRed2Count:count_today_payment];
    
    
    //m.originalMoneyNum = @(total_payment);
    //str = [[NSMutableAttributedString alloc]initWithAttributedString:m.reformedMoneyStr];
    
    //forstr = [Util getAttributedString:@"待还款" font:[UtilFont systemNormal:18] color:CN_TEXT_GRAY];
    
    //[str insertAttributedString:forstr atIndex:0];
    //self.topView.detailLabel2.attributedText = str;
    self.topView.detailLabel2.text = [Util formatRMBWithoutUnit:@(total_payment)];
    
    //列表数据
    if (dic) {
        NSArray *list = EMPTYOBJ_HANDLE(dic[@"list"]);
        
        //第一页先把以前的数据清空(不管是否拿到了新的数据)
        if (curPage == 1) {
            [self.dataArr removeAllObjects];
        }
        
        //加载新数据
        if (list.count > 0) {
            self.listTip.tip = [NSString stringWithFormat:@"共%@条", dic[@"totalcount"]];
            
            [self.dataArr insertPage:curPage pageSize:pageCount objects:list];
        }
        
        [self.tableView reloadData];

        
        //第一页没有数据，显示没有数据提醒
        if (curPage == 1) {
            [self.emptyDataLabel setHidden:self.dataArr.count == 0 ? NO:YES];
        }
        
    }

    
    
}

-(void)endFreshState{
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

-(void)setNavRightBtn{
    
    [super setNavRightBtn];
    [self.rightNavBtn setTitle:@"写借条" forState:UIControlStateNormal];
}

-(void)rightNavItemAction{
    DLog();
    
#ifdef TEST_TEST_SERVER
//    UIViewController *vc = SISTORY(@"EditEmailViewController");
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
#endif
    
    if ([IOUConfigure inBlackIOULimited]) {
        return ;
    }
    
    //实名认证
    if ([[ZAPP.myuser getUserRealNamepExplictly] length]) {
        WriteIOUViewController *wvc = ZWIOU(@"WriteIOUViewController");
        [self.navigationController pushViewController:wvc animated:YES];
    }else{
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"请去绑定银行卡认证实名" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"去绑定",@"取消", nil];
        [alertview show];
        alertview.tag=500;
        
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500 && buttonIndex==0) {
        //绑定银行卡
        [self.navigationController pushViewController:[MeRouter UserBindBankViewController] animated:YES];
    }
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return  [ZAPP.zdevice getDesignScale:40];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return TOPVIEW_HEIGHT;
    }
    return [ZAPP.zdevice getDesignScale:IOULIST_ROW_HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    return self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *const cell_id = @"ioutopcell_id";
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            
            [cell.contentView addSubview:self.topView];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];

            
           [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.top.equalTo(cell);
            make.height.equalTo(@(TOPVIEW_HEIGHT));
        }];


        }

        return cell;
    }else{
        IOUCell *cell = (IOUCell *)[IOUCell cellWithNib:tableView];
        if(indexPath.row<self.dataArr.count){
            cell.dic = self.dataArr[indexPath.row];
        }
        return cell;
    }
    

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 &&  indexPath.row < self.dataArr.count) {
        [self dispathDetail:indexPath];
    }
 
}


-(void)dispathDetail:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArr[indexPath.row];

    NSInteger uid = [dic[@"ui_id"] integerValue];
    NSInteger ui_status = [dic[@"ui_status"] integerValue];

    //未发送
    if ([dic[@"ui_status"] integerValue] == 0) {
        
        WriteIOUViewController *wivc = ZWIOU(@"WriteIOUViewController");
        wivc.iouid = uid;
        [self.navigationController pushViewController:wivc animated:YES];
        return;

    }
    //线下还款
    else if ([dic[@"ui_status"] integerValue] == 4 || [dic[@"ui_status"] integerValue] == 5 || [dic[@"ui_status"] integerValue] == 6) {
        IOUShowRepaymentViewController *irvc =ZIOU(@"IOURepaymentViewController");
        irvc.iou_title = dic[@"ui_orderno"];
        irvc.dic =dic;
        [self.navigationController pushViewController:irvc animated:YES];
        return;
    }
    
    //我创建的
    if([dic[@"create_user"] integerValue] == [[ZAPP.myuser getUserID] integerValue]){
        
        IOUDetail1ViewController * iwvc = [[IOUDetail1ViewController alloc]init];
        iwvc.iouid = uid;
        iwvc.listPassedStatus = @(ui_status);

        iwvc.type = [IOUConfigure detail1Type:dic];
        [self.navigationController pushViewController:iwvc animated:YES];
        
    }else{
        //别人创建的
        IOUDetail2ViewController * iwvc = [[IOUDetail2ViewController alloc]init];
        iwvc.iouid = uid;
        iwvc.listPassedStatus = @(ui_status);

        iwvc.type = [IOUConfigure detail2Type:dic];
        [self.navigationController pushViewController:iwvc animated:YES];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TopTapDelegate

-(void)topTap:(NSInteger)index{
    MyIouTableViewController *list = ZMYIOU(@"MyIouTableViewController");
    
    list.iouListPageType = index == 0 ? IouListPageTypeCreditor : IouListPageTypeDebter;
    list.prespecifiedCount = index == 0 ? count_receive : count_payment;
    
    [self.navigationController pushViewController:list animated:YES];
}

static CGFloat savedInvestOffsetY = 0.0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY =  scrollView.contentOffset.y;
//
    if (  (offsetY > 200 || offsetY < - 200) && scrollView.isDragging && scrollView.tracking) {
        [self.listTip showPromptView];
    }
//    
//    if (offsetY - savedInvestOffsetY > 4 && offsetY>0 &&
//        CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
//        ![self.tableView.header isRefreshing] &&
//        ![self.tableView.footer isRefreshing]) {
//        
//        [self hideTopView];
//
//    }
//    
//    
//    if ((self.tableView.contentSize.height < self.tableView.height && offsetY < -4)||
//        (offsetY - savedInvestOffsetY < -4    &&
//         CGRectGetHeight(self.tableView.bounds)+offsetY < self.tableView.contentSize.height &&
//         ![self.tableView.header isRefreshing] &&
//         ![self.tableView.footer isRefreshing])) {
//        
//        [self showTopView];
//
//    }
    savedInvestOffsetY = offsetY;
}

-(void)showTopView{
    

    if (!isHeaderHide) {
        return;
    }
    
    DLog();
    
    isHeaderHide = NO;
    
    
    [self.topView setNeedsUpdateConstraints];
    
    UIView *superView = self.view;
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(superView);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.height.equalTo(@(TOPVIEW_HEIGHT));
    }];
    [self.topView updateConstraintsIfNeeded];
    
    
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
    }];
    

}

-(void)hideTopView{
    
    
    if (isHeaderHide) {
        return;
    }
    
    DLog();
    
    isHeaderHide = YES;
    
    
    [self.topView setNeedsUpdateConstraints];

    UIView *superView = self.view;
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(superView);
        make.bottom.equalTo(self.mas_topLayoutGuideBottom);
        make.height.equalTo(@(TOPVIEW_HEIGHT));
    }];
    [self.topView updateConstraintsIfNeeded];

    
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
    }];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate){
        [self.listTip hidePromptView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.listTip hidePromptView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
