//
//  MoreFriendViewController.m
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MoreFriendViewController.h"
#import "SFCashFriendCell.h"
#import "WriteIOUNetEngine.h"
#import "SelFriendViewController.h"
#import "ContactMgr.h"
#import "ListCountTip.h"

@interface MoreFriendViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger curPage;
    NSInteger pageCount;
    NSIndexPath *selIndexPath;
}

@property(nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic)WriteIOUNetEngine *engine;
@property (strong,nonatomic) ListCountTip *listTip;
@property (nonatomic,strong)IBOutlet UITableView *tableView;

@end

@implementation MoreFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavButton];
    [self setNavRightBtn];
 
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pageCount=10;
    
    //通讯录不分页
    if (! [self.atitle hasPrefix:@"通讯录"]) {
        [Util setScrollHeader:self.tableView target:self header:@selector(getData) dateKey:[Util getDateKey:self]];
        [Util setScrollFooter:self.tableView target:self footer:@selector(getMoreData)];;
    }

    _tableView.tableFooterView = [UIView new];
//    _tableView.delegate = self;

    bugeili_net_new
    progress_show
    
    [self getData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.atitle;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.listTip adjustFrame];
}

-(void)setNavRightBtn{
    [super setNavRightBtn];
    [self.rightNavBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self setNavRightBtnHidden:YES];
}

- (void)setNavRightBtnHidden : (BOOL) hidden {
    
    self.rightNavBtn.hidden = hidden;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _dataArray;
}

-(WriteIOUNetEngine *)engine{
    
    if(!_engine){
        _engine = [[WriteIOUNetEngine alloc]init];
    }
    
    return _engine;
}

-(ListCountTip *)listTip{
    
    if(!_listTip){
        _listTip = [ListCountTip tipSuperView:self.view bottomLayout:self.view.mas_bottom];
    }
    
    return _listTip;
}

-(void)rightNavItemAction{
    
    if (!selIndexPath) {
        [Util toast:@"没有选中的人"];
        return;
    }
    
    PersonObject *po = nil;
    po = self.dataArray[selIndexPath.row];
 
    NSString *msg = [NSString stringWithFormat:@"确定选择%@？", [po nameShowed]];
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alertview show];
    alertview.tag=300;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 300 && buttonIndex==0) {

        PersonObject *po = nil;
        po = self.dataArray[selIndexPath.row];
        
     
        if (self.navigationController.viewControllers.count>3) {
            SelFriendViewController *sfvc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
            [sfvc.delegate didSelFriend:po];
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
            
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
    (NSIndexPath *)indexPath {
    
    return [ZAPP.zdevice getDesignScale:SF_ROW_HEIGHT];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell_id = @"SFCashFriendCell_id";
    SFCashFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (indexPath.row<self.dataArray.count) {
        cell.people = self.dataArray[indexPath.row];
         cell.sel = (selIndexPath && selIndexPath.section== indexPath.section && indexPath.row == selIndexPath.row);
    }
    cell.leftSpace = YES;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (self.dataArray.count>0) {
        selIndexPath = indexPath;
        [self setNavRightBtnHidden:NO];
        [self.tableView reloadData];
    }
}

-(void)getData{
    
    if ([self.atitle hasPrefix:@"通讯录"]) {
        progress_hide
        ContactMgr *contactMgr = [[ContactMgr alloc]init];
        NSArray *contacts = [contactMgr contactsContainingString:self.keyText];
        _dataArray = [[NSMutableArray alloc] initWithArray:contacts];
        
        self.listTip.tip = [NSString stringWithFormat:@"共%zd人", _dataArray.count];
        
        [self.tableView reloadData];
        return;
    }
    
    curPage = 0;
    bugeili_net_new
    
    if (!self.searchPhoneContacts) {
        [self requestCNContactsData];
    }else{
        
    }
    
}

-(void)getMoreData{
    
    curPage ++;
    bugeili_net_new
    
    if (!self.searchPhoneContacts) {
        [self requestCNContactsData];
    }else{
        
    }
    
}

-(void)requestCNContactsData{
    
    NSDictionary *dic = @{@"searchkey":self.keyText,
                          @"pagenum":@(curPage),
                          @"pagesize":@(pageCount)
                          };
    
    __weak __typeof__(self) weakSelf = self;
    
    [self.engine getSearchContacts:dic success:^(NSArray *arr, NSInteger totalCount) {
        
        self.listTip.tip = [NSString stringWithFormat:@"共%zd人", totalCount];
        
        [weakSelf updateUI:arr];
        [weakSelf endRefresh];
        progress_hide
        
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        progress_hide
        
    }];
}

- (void)endRefresh{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

-(void)updateUI:(NSArray *)arr{
    if (arr && arr.count) {
        [self.dataArray insertPage:curPage pageSize:pageCount objects:arr];

        [self.tableView reloadData];
        
        
    }
    
    self.tableView.footer.hidden = (arr.count == 0);
 }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY =  scrollView.contentOffset.y;
    //
    if (  (offsetY > 20 || offsetY < - 20) && scrollView.isDragging && scrollView.tracking) {
        [self.listTip showPromptView];
    }
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



@end
