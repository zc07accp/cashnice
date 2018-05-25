//
//  SearchPersonViewController.m
//  Cashnice
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SearchPersonViewController.h"
#import "HeaderNamePersonCell.h"
#import "ShouxinEngine.h"
#import "ShouxinFilter.h"

@interface SearchPersonViewController ()<UISearchBarDelegate>
{
    NSInteger curPage;
    NSInteger pageCount;
    NSInteger totalCount;
    
    
}
@property IBOutlet UITableView *allDataTableView;
@property (nonatomic,strong) NSArray *searchResultArr; //搜索结果
@property (nonatomic,strong) NSMutableArray *shouxinList; //授信给我的好友列表

@property (nonatomic,strong) NSMutableArray  *sectionArray;       //section数目
@property (nonatomic,strong) NSMutableArray  *sectionDataArray;   //分组的联系人数据

@property (strong,nonatomic) ShouxinEngine *engine;

@end

@implementation SearchPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor =  HexRGB(0Xe7e7e7);
    [self setNavButton];
    
    pageCount = DEFAULT_PAGE_SIZE *3;
    
    self.title = @"好友";
    self.allDataTableView.tableFooterView = [UIView new];
    self.allDataTableView.rowHeight = 52;
    self.allDataTableView.sectionIndexColor = CN_TEXT_GRAY;
    self.allDataTableView.sectionIndexBackgroundColor = [UIColor clearColor];

    self.searchDisplayController.searchResultsTableView.rowHeight = 52;
    self.searchDisplayController.searchResultsTableView.backgroundColor = HexRGB(0Xe7e7e7);
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.searchDisplayController.searchBar.layer.borderWidth = 1;
    self.searchDisplayController.searchBar.layer.borderColor = [[self.searchDisplayController.searchBar barTintColor] CGColor];
    
    [self.shouxinList addObjectsFromArray: [self.engine readLocalShouxinList:[ZAPP.myuser getUserID] type:6]];
    if (self.shouxinList.count == 0) {
        
//        [self getShouxinDataFromBegin];
        
        self.noShowpersonsLabel.hidden = NO;
        
    }else{
        
        self.noShowpersonsLabel.hidden = YES;
        [self sortSectionReloadTable];
    }
    
    [self.view bringSubviewToFront:self.coverView];
    self.coverView.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.searchDisplayController.active? UIStatusBarStyleDefault:UIStatusBarStyleLightContent];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}



#pragma mark - Getter

-(ShouxinEngine *)engine{
    
    if(!_engine){
        _engine = [[ShouxinEngine alloc]init];
    }
    
    return _engine;
}


-(NSMutableArray *)shouxinList{
    
    if(!_shouxinList){
        _shouxinList = [[NSMutableArray alloc]init];
    }
    
    return _shouxinList;
}
-(void)updateUI:(NSArray *)list{

    [self.shouxinList insertPage:curPage pageSize:pageCount objects:list ];
    
    [self sortSectionReloadTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)sortSectionReloadTable
{
    
    self.sectionArray=nil;
    self.sectionDataArray=nil;
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"firstLetter" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    
    
    NSMutableArray *tmpSectionArray = [[NSMutableArray alloc] initWithArray:[[self.engine sectionSet] sortedArrayUsingDescriptors:sortDescriptors]];
    
    //第一个是#
    if ([tmpSectionArray count] > 0 && [[[tmpSectionArray objectAtIndex:0] valueForKey:@"firstLetter"] isEqualToString:@"#"])
    {
        [tmpSectionArray removeObjectAtIndex:0];
        [tmpSectionArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"#",@"firstLetter", nil]];
    }
    
    NSMutableArray *tmpSectionDataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *firstDic in tmpSectionArray)
    {
        NSString *firstL = [firstDic valueForKey:@"firstLetter"];
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:10];
        for (HeaderNamePersonViewModel *model in self.shouxinList)
        {
            if ([model.firstLetter isEqualToString:firstL])
            {
                [tmpArray addObject:model];
                
            }
        }
        [tmpSectionDataArray addObject:tmpArray];
    }
    
    self.sectionArray = tmpSectionArray;
    self.sectionDataArray = tmpSectionDataArray;
    [self.allDataTableView reloadData];
    
}

#pragma mark - UISearchBarDelegate delegate


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.coverView.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchBar.text = %@", searchBar.text);
    
    if (searchText.length > 0) {
        //
       self.searchResultArr =  [ShouxinFilter filterShouxinList:self.shouxinList searchText:searchBar.text searchTextHighlighted:YES];
        
        if (self.searchResultArr.count > 0) {
            self.coverView.hidden = YES;
        }else{
            self.coverView.hidden = NO;
            [self.view bringSubviewToFront:self.coverView];

        }
        
    }else{
        self.coverView.hidden = YES;
    }
    
}

#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
    
}


- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
}


- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

//
//- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
//    NSLog(@"searchBar.text = %@", controller.searchBar.text);
//}

#pragma mark - UITableViewDataSource


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    }
    
    if([self.sectionArray count] > 0)
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        [tempArray addObject:@"{search}"];
        
        for (int i = 0; i < [self.sectionArray count]; i++) {
            if ([([self.sectionArray objectAtIndex:i]) objectForKey:@"firstLetter"])
            {
                [tempArray addObject:[([self.sectionArray objectAtIndex:i]) objectForKey:@"firstLetter"]];
                
            }
        }
        
        return tempArray;
        
    }
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return -1;
    }
    
    if (title == UITableViewIndexSearch)
    {
        return -1;
    }
    else if([title isEqualToString:@"#"])
    {
        return [self.sectionArray count];
        
    }
    else
    {
        
        for (int i = 0; i < [self.sectionArray count]; i ++)
        {
            if ([[[self.sectionArray objectAtIndex:i] objectForKey:@"firstLetter"]isEqualToString:title])
            {
                return i;
            }
        }
        
        
    }
    return -1;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }
 
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return self.searchResultArr.count;
    }
    return [[self.sectionDataArray objectAtIndex:section] count];

 }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(tableView == self.searchDisplayController.searchResultsTableView){
        return 0;
    }
    
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    }
    
    UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 28)];
    _headerView.backgroundColor = HexRGB(0Xe7e7e7);
    
    UILabel *_headerLabel = [[UILabel alloc]initWithFrame:CGRectInset(_headerView.bounds, 10, 0)];
    _headerLabel.font = CNFont_26px;
    _headerLabel.textColor = CN_TEXT_GRAY;
    
    [_headerView addSubview:_headerLabel];
    if([self.sectionArray count] > section ){
        if ([((NSDictionary *)[self.sectionArray objectAtIndex:section]) objectForKey:@"firstLetter"])
        {
            _headerLabel.text = [((NSDictionary *)[self.sectionArray objectAtIndex:section])
                          objectForKey:@"firstLetter"];
        }
        
    }

    return _headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HeaderNamePersonCell *cell = [HeaderNamePersonCell cellWithNib:tableView];

    if(tableView == self.searchDisplayController.searchResultsTableView){
        HeaderNamePersonViewModel *model = [self.searchResultArr objectAtIndex:indexPath.row];
        [cell.headImgView setHeadImgeUrlStr:model.headerUrl];
        cell.nameLabel.attributedText=model.attrName;
        cell.bottomLineHidden =  indexPath.row == self.searchResultArr.count-1?YES:NO;


    }else{

        NSArray *array = self.sectionDataArray[indexPath.section];
        HeaderNamePersonViewModel *model = [array objectAtIndex:indexPath.row];
        
        [cell.headImgView setHeadImgeUrlStr:model.headerUrl];
        cell.nameLabel.text=model.name;
        cell.bottomLineHidden = indexPath.row == array.count-1?YES:NO;
    }
    
    cell.leftSpace = YES;

    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSLog(@"didSelectRowAtIndexPath");
    
    UIViewController* vc = ZPERSON(@"TransferConfirmViewController");

    if(tableView == self.searchDisplayController.searchResultsTableView){
        if(indexPath.row>= self.searchResultArr.count){return;}
        
        HeaderNamePersonViewModel *model = [self.searchResultArr objectAtIndex:indexPath.row];
        [vc setValue:model.moreInfoDic forKey:@"targetUserDict"];

    }else{
        NSArray *array = self.sectionDataArray[indexPath.section];
        
        if(indexPath.row>= array.count){return;}
        
        HeaderNamePersonViewModel *model = [array objectAtIndex:indexPath.row];
        [vc setValue:model.moreInfoDic forKey:@"targetUserDict"];

    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

//
//-(BOOL)showLine{
//    
//    if (self.searchResultArr.count == 1) {
//        return YES;
//    }
//    
//    
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
