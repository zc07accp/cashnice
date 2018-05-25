//
//  SearchCNFriendViewController.m
//  Cashnice
//
//  Created by apple on 2016/10/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SearchCNFriendViewController.h"
#import "HeaderNamePersonCell.h"
#import "ShouxinEngine.h"
#import "WriteIOUNetEngine.h"
#import "PersonObject.h"

@interface SearchCNFriendViewController ()
@property (nonatomic,strong) NSArray *searchResultArr; //搜索结果
@property (strong,nonatomic) ShouxinEngine *engine;
@end

@implementation SearchCNFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    

    self.searchDisplayController.searchResultsTableView.rowHeight = 52;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.backgroundColor = HexRGB(0Xe7e7e7);
    self.searchDisplayController.searchResultsTableView.tableFooterView = [UIView new];
    [self.searchDisplayController setActive:YES];
    
    
    [self.searchBar becomeFirstResponder];
    [self.view bringSubviewToFront:self.coverView];
    
//    self.searchDisplayController.searchResultsTableView.top -= 1;
    
    self.searchDisplayController.searchBar.layer.borderWidth = 1;
    self.searchDisplayController.searchBar.layer.borderColor = [[self.searchDisplayController.searchBar barTintColor] CGColor];
    
//    CGRect rect = self.searchBar.frame;
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-2,rect.size.width, 2)];
//    lineView.backgroundColor = CN_COLOR_DD_GRAY;
//    [self.searchBar addSubview:lineView];
    
    [self withoutSearchingState];
    
    self.fd_interactivePopDisabled = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
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



#pragma mark - Getter

-(ShouxinEngine *)engine{
    
    if(!_engine){
        _engine = [[ShouxinEngine alloc]init];
    }
    
    return _engine;
}

- (NSString *)searchString {
    
    return [[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
}

-(void)requestCNContactsData{
    
    progress_show

    NSDictionary *dic = @{@"searchkey":[self searchString],
                          @"pagenum":@(0),
                          @"pagesize":@(DEFAULT_PAGE_SIZE*3)
                          };
    
    __weak __typeof__(self) weakSelf = self;
    
    [self.engine getSearchCNContacts:dic success:^(NSArray *arr) {
        [weakSelf updateUI:arr];
        progress_hide

    } failure:^(NSString *error) {
        progress_hide

    }];
}




-(void)updateUI:(NSArray *)arr{
    
    if (arr.count) {
        self.coverView.hidden = YES;
        
        self.searchResultArr = arr;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }else{
        [self searchingResultEmptyState];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString * regex        = @"^[0-9]+$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    if ( [text isEqualToString:@"\n"]) {
        return YES;
    }
    
    if (([text length]==0 || [pred evaluateWithObject:text]) && range.location < 11) {
        return YES;
    }
    


    return NO;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        [self withoutSearchingState];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([searchBar.text length] == 11) {
        [self requestCNContactsData];
    }else{
        [Util toast:@"请输入11位手机号码"];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.searchResultArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HeaderNamePersonCell *cell = [HeaderNamePersonCell cellWithNib:tableView];
    HeaderNamePersonViewModel *model = [self.searchResultArr objectAtIndex:indexPath.row];
    
    [cell.headImgView setHeadImgeUrlStr:model.headerUrl];
    cell.nameLabel.text=model.name;
    cell.bottomLineHidden =  indexPath.row == self.searchResultArr.count-1?YES:NO;
    cell.leftSpace = YES;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row>= self.searchResultArr.count){return;}
    
    HeaderNamePersonViewModel *model = [self.searchResultArr objectAtIndex:indexPath.row];
    if([model.moreInfoDic[@"userid"] integerValue] == [ZAPP.myuser.getUserID integerValue]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您不能给自己的账户转账" message:nil
                                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    

    
    NSLog(@"didSelectRowAtIndexPath");
    
    UIViewController* vc = ZPERSON(@"TransferConfirmViewController");
 

        [vc setValue:model.moreInfoDic forKey:@"targetUserDict"];
        
 
    [self.navigationController pushViewController:vc animated:YES];
    
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
