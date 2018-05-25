//
//  SearchAddFriendNewControllerViewController.m
//  Cashnice
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SearchAddFriendNewControllerViewController.h"
#import "SAFCell.h"
#import "SAFEngine.h"
#import "PersonHomePage.h"
#import "ListCountTip.h"
#import "InviteWebViewController.h"

@interface SearchAddFriendNewControllerViewController (){
    NSInteger curPage;
}
@property (strong,nonatomic) SAFEngine *engine;
@property (nonatomic,strong) NSMutableArray *searchResultArr; //搜索结果
@property (strong,nonatomic) ListCountTip *listTip;

@end

@implementation SearchAddFriendNewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self withoutSearchingState];
    
    self.tableView.rowHeight = IPHONE6_ORI_VALUE(90);
    [Util setScrollFooter:self.tableView target:self footer:@selector(getMoreData)];
    [self.searchBar becomeFirstResponder];

    self.fd_prefersNavigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

//    [self.navigationController setNavigationBarHidden:YES];

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

//    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.listTip adjustFrame];
}

#pragma mark - Getter

-(SAFEngine *)engine{
    
    if(!_engine){
        _engine = [[SAFEngine alloc]init];
    }
    
    return _engine;
}


- (NSMutableArray *)searchResultArr {
    if (!_searchResultArr) {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.searchResultArr.count) {
        SAFCell *cell = [SAFCell cellWithNib:tableView];
        
        NSDictionary *dict = [self.searchResultArr objectAtIndex:indexPath.row];
        cell.dic = dict;
        cell.bottomLineHidden =  indexPath.row == self.searchResultArr.count-1?YES:NO;
        
        
        return cell;
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%d", indexPath.row);
    
    if(indexPath.row <self.searchResultArr.count){
        
        PersonHomePage *person = DQC(@"PersonHomePage");
        [person setTheDataDict:[self.searchResultArr objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:person animated:YES];
    }
    
}

#pragma mark - UISearchBarDelegate delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:NO];

    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelAction:(id)sender {
    [self.view endEditing:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        [self withoutSearchingState];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([searchBar.text length]) {
        
        [self.view endEditing:YES];
        
        [self getData];
    }else{
        [Util toastStringOfLocalizedKey:@"tip.inputtingSearchContent"];
    }
    
}

//没有正式进行搜索
-(void)withoutSearchingState{
    self.searchResultArr = nil;
    
    self.noSearchResultStateView.hidden = YES;
    self.noSearchStateView.hidden = NO;
    
    self.coverView.hidden = NO;
}

//搜索结果为空
-(void)searchingResultEmptyState{
    
    self.noSearchResultStateView.hidden = NO;
    self.noSearchStateView.hidden = YES;
    
    self.coverView.hidden = NO;
}

- (NSString *)searchString {
    
    return [[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
}

-(void)getData{
    curPage = 0;
    [self requestData];
}

-(void)getMoreData{
    curPage++;
    [self requestData];
    
}

-(void)requestData{
    
    if (curPage==0) {
        progress_show
    }
    
    __weak __typeof__(self) weakSelf = self;
    
    [self.engine getSearchPhonePersons:[self searchString]
                               pageNum: curPage
                               success:^(NSInteger totalCount,NSInteger pageCount, NSArray *arr) {
                                   [weakSelf updateUI:arr totoalCount:totalCount pageCount:pageCount];
                                   progress_hide
                                   
                               } failure:^(NSString *error) {
                                   progress_hide
                                   
                               }];
}

-(void)updateUI:(NSArray *)arr totoalCount:(NSInteger)tcount pageCount:(NSInteger)pageCount{
    
    if (arr.count) {
        self.coverView.hidden = YES;
        
        if (curPage == 0) {
            [self.searchResultArr removeAllObjects];
        }
        
        [self.searchResultArr insertPage:curPage objects:arr];
        
        self.listTip.tip = [NSString stringWithFormat:@"Cashnice为您找到%ld个结果",(long)tcount];
        
        [self.tableView reloadData];
    }else{
        [self searchingResultEmptyState];
    }

    
    [self.tableView.footer endRefreshing];
    
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);
    
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

- (IBAction)inviteFriendAc:(id)sender {
    
    InviteWebViewController *haoyou = [[InviteWebViewController alloc]init];
    haoyou.urlStr = [NSString stringWithFormat:@"%@%@%@", WEB_DOC_URL_ROOT, NET_PAGE_INVITE_INDEX, [ZAPP.myuser getUserID]];
    [self.navigationController pushViewController:haoyou animated:YES];
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
