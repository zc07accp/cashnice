//
//  SearchAddFriendViewController.m
//  Cashnice
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SearchAddFriendViewController.h"
#import "SAFCell.h"
#import "SAFEngine.h"
#import "PersonHomePage.h"
#import "ListCountTip.h"

@interface SearchAddFriendViewController (){
    NSInteger curPage;
    
}
@property (nonatomic,strong) NSMutableArray *searchResultArr; //搜索结果
@property (strong,nonatomic) SAFEngine *engine;
@property (strong,nonatomic) ListCountTip *listTip;

@end

@implementation SearchAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;  //可以让视图扩展到全部
    self.definesPresentationContext = YES;

    
//    UIView *superView = self.view;

//    [self.searchDisplayController.searchResultsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView);
//        make.right.equalTo(superView);
//        make.top.equalTo(self.searchBar.mas_bottom);
//        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
//        
//    }];
//    self.searchDisplayController.searchResultsTableView.height = MainScreenHeight - self.searchBar.bounds.size.height - 64;
    
//    self.searchDisplayController.searchResultsTableView.rowHeight = 52;
//    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.searchDisplayController.searchResultsTableView.backgroundColor = HexRGB(0Xe7e7e7);
//    self.searchDisplayController.searchResultsTableView.tableFooterView = [UIView new];
//    [self.searchDisplayController setActive:YES];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.barTintColor =HexRGB(0xDDDDDD);
    self.searchController.searchBar.backgroundColor =HexRGB(0xDDDDDD);

    self.searchController.searchBar.placeholder = @"姓名/昵称/手机号";

    self.tableView.tableHeaderView = self.searchController.searchBar;

    [self.view bringSubviewToFront:self.coverView];
    
    [self withoutSearchingState];

    self.tableView.rowHeight = IPHONE6_ORI_VALUE(90);
    [Util setScrollFooter:self.tableView target:self footer:@selector(getMoreData)];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
    [self.searchController setActive:YES];
    [self.searchController.searchBar becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
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
    
    return [[self.searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
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
                               success:^(NSInteger totalCount,
                                         NSInteger pageCount, NSArray *arr) {
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
        
        [self.searchDisplayController.searchResultsTableView reloadData];
    }else{
        [self searchingResultEmptyState];
    }
    
    UITableView *tableView = self.searchDisplayController.searchResultsTableView;

    NSLog(@"%d, %d", tableView.contentInset.top, tableView.contentInset.bottom);
    
//    [tableView setContentInset:UIEdgeInsetsZero];
//    [tableView setContentInset:UIEdgeInsetsMake(-100, 0, 0, 0)];

//    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
    [self.searchDisplayController.searchResultsTableView.footer endRefreshing];

    self.searchDisplayController.searchResultsTableView.footer.hidden = ((curPage + 1) >= pageCount);

}

#pragma UISearchDisplayDelegate

//- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    
//}
//


//- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
//    
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
//    
//    [tableView setContentInset:UIEdgeInsetsMake(-100, 0, 0, 0)];
//    
//    [tableView setContentInset:UIEdgeInsetsMake(-100, 0, 0, 0)];
//
//    
//}



- (void) keyboardWillHide {
    
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    
    [tableView setContentInset:UIEdgeInsetsMake(100, 0, 0, 0)];

    [tableView setContentInset:UIEdgeInsetsZero];
    
//    [tableView setScrollIndicatorInsets:UIEdgeInsetsMake(100, 0, 0, 0)];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    if(iPhone6Plus){
        [tableView setContentInset:UIEdgeInsetsZero];
        [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    }

}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
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
        [self getData];
    }else{
        [Util toastStringOfLocalizedKey:@"tip.inputtingSearchContent"];
    }
    
}


- (IBAction)inviteFriendAc:(id)sender {
    
    UIViewController *haoyou = ZSTORY(@"YaoqingHaoyou");
    [self.navigationController pushViewController:haoyou animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
