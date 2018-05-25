//
//  InvestHistoryViewController.m
//  Cashnice
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestHistoryViewController.h"
#import "LoanEngine.h"
#import "InvesHisCell.h"
#import "ListCountTip.h"
#import "MoneyFormatViewModel.h"

@interface InvestHistoryViewController (){
    NSInteger curPage;
    NSInteger pageCount;
    NSInteger totalCount;

}
@property (strong, nonatomic) LoanEngine *loan_engine;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) ListCountTip *listTip;

@end

@implementation InvestHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    self.title = @"投资记录";
    [self setNavButton];
    
    
    [Util setScrollHeader:self.tableView target:self header:@selector(getData) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(getMoreData)];
    
    
    [self getData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.listTip adjustFrame];
}

-(ListCountTip *)listTip{
    
    if(!_listTip){
        _listTip = [ListCountTip tipSuperView:self.view bottomLayout:self.view.mas_bottom];
    }
    
    return _listTip;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(LoanEngine *)loan_engine{
    
    if (!_loan_engine) {
        _loan_engine = [[LoanEngine alloc]init];
    }
    return _loan_engine;
}

-(void)getData{
    
    curPage = 0;
    [self connectToServer];
}

-(void)getMoreData{
    curPage++;
    [self connectToServer];
}

-(NSArray *)reformArr:(NSArray *)oriArr{
    
    if(!oriArr){
        return nil;
    }
    
    NSMutableArray *reArr = [NSMutableArray array];

    for(NSDictionary *oriDic in oriArr){
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oriDic];
        MoneyFormatViewModel *vm = [MoneyFormatViewModel viewModelFrom:4];
        vm.originalMoneyNum = @([EMPTYOBJ_HANDLE(dic[@"betVal"]) doubleValue]);
        [dic setObject:vm forKey:@"reformed"];
        [reArr addObject:dic];
    }
    
    return reArr;
}

-(void)updateUI:(NSDictionary *)dic{
    
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    pageCount = [Util pageCount:dic];
    totalCount = [Util totalCount:dic];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }

    [self.dataArray insertPage:curPage
                       objects:[self reformArr: [dic objectForKey:NET_KEY_BETUSERS]]];
    
    if([[dic objectForKey:NET_KEY_BETUSERS] count]){
        [self.tableView reloadData];
    }


    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
 
    //暂无记录
    if(self.dataArray.count == 0){
        [self showNoData];
    }else{
        [self removeNoData];
        self.listTip.tip = [NSString stringWithFormat:@"共%ld人",(long)totalCount];
    }
    
}

- (void)connectToServer {
    
    if (_dataArray.count==0) {
        progress_show
    }
    
    __weak __typeof__(self) weakSelf = self;

    [self.loan_engine getLoanInvesHistoryList:self.loanId pageSize:DEFAULT_PAGE_SIZE pagenum:curPage success:^(NSDictionary *dic) {
        progress_hide
        [weakSelf updateUI:dic];
    } failure:^(NSString *error) {
        progress_hide
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return IPHONE6_ORI_VALUE(70);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"InvesHisCell_id";
    InvesHisCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row < self.dataArray.count) {
        NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
        cell.dic = dict;
    }
    
    cell.leftSpace = YES;
    cell.bottomLineHidden =  (indexPath.row == self.dataArray.count - 1);
    return cell;
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

-(void)removeNoData{
    
    UIImageView*view = [self.tableView viewWithTag:1200];
    if (view) {
        [view removeFromSuperview];
        view = nil;
    }
    
    UILabel*label = [self.tableView viewWithTag:1300];
    if (label) {
        [label removeFromSuperview];
        label = nil;
    }
    
}

- (void)showNoData{
    [self removeNoData];
    
    UIImageView *noDataImageView = [[UIImageView alloc] init];
    noDataImageView.image = [UIImage imageNamed:@"record_none.png"];
    
    UILabel *noDataLabel = [[UILabel alloc] init];
    noDataLabel.text = @"暂无记录";
    noDataLabel.textColor = CN_TEXT_GRAY;
    noDataLabel.font = CNFontNormal;
    
    [self.tableView addSubview:noDataLabel];
    noDataLabel.tag = 1300;
    
    [self.tableView addSubview:noDataImageView];
    noDataImageView.tag = 1200;
    
    [noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.top.equalTo(self.tableView).mas_offset([ZAPP.zdevice scaledValue:99]);
    }];
    
    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.top.equalTo(noDataImageView.mas_bottom).mas_offset(10);
    }];
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
