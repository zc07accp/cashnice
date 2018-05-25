//
//  SelFriendViewController.m
//  Cashnice
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SelFriendViewController.h"
#import "CNTableViewCell.h"
#import "SFCashFriendCell.h"
#import "SFMoreCell.h"
#import "WriteIOUNetEngine.h"
#import "MoreFriendViewController.h"
#import "IOU.h"
#import "ContactMgr.h"

@interface SelFriendViewController ()<UITextFieldDelegate>
{
    NSInteger curPage;
    NSInteger pageCount;
    NSInteger totalCount;
    
    NSIndexPath *selIndexPath;
    
    ContactMgr *contactMgr;
}

@property (nonatomic,strong)IBOutlet UITextField *searchBar;
@property (nonatomic,strong)IBOutlet UIButton *cancleBtn;
@property(nonatomic) NSMutableArray *cnFriendsArr;
@property(nonatomic) NSMutableArray *phoneFriendsArr;
@property (nonatomic,strong)IBOutlet UITableView *tableView;
@property (nonatomic,strong) UILabel *noContactPromptLabel;

@property (weak, nonatomic) IBOutlet UIView *initialTipView;
@property (strong,nonatomic)WriteIOUNetEngine *engine;

@end

@implementation SelFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
    [self setNavButton];
    [self setNavRightBtn];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"选择联系人";
}


-(void)setup{
    
    self.tableView.estimatedRowHeight = 70;
    _tableView.tableFooterView = [UIView new];

    self.searchBar.delegate = self;
 
    [self noSearchState];
}

-(void)setNavRightBtn{
    [super setNavRightBtn];
    [self.rightNavBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self setNavRightBtnHidden:YES];
}

- (void)setNavRightBtnHidden : (BOOL) hidden {
    
    self.rightNavBtn.hidden = hidden;
}

-(void)rightNavItemAction{
    
    if (!selIndexPath) {
        [Util toast:@"没有选中的人"];
        return;
    }
    
    [self.view endEditing:YES];
    
    PersonObject *po = nil;
    if (selIndexPath.section == 0) {
        po = self.cnFriendsArr[selIndexPath.row];
    }else{
        po = self.phoneFriendsArr[selIndexPath.row];
    }
    
    NSString *msg = [NSString stringWithFormat:@"确定选择%@？", [po nameShowed]];
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alertview show];
    alertview.tag=300;

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 300 && buttonIndex==0) {
        
        PersonObject *po = nil;
        if (selIndexPath.section == 0) {
            po = self.cnFriendsArr[selIndexPath.row];
        }else{
            po = self.phoneFriendsArr[selIndexPath.row];
        }

        if ([self.delegate respondsToSelector:@selector(didSelFriend:)]) {
            [self.delegate didSelFriend:po];
            [self.view endEditing:YES];
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}

-(NSMutableArray *)cnFriendsArr{
    
    if (!_cnFriendsArr) {
        _cnFriendsArr = [NSMutableArray array];
    }
    return _cnFriendsArr;
}

-(NSMutableArray *)phoneFriendsArr{
    
    if (!_phoneFriendsArr) {
        _phoneFriendsArr = [NSMutableArray array];
    }
    return _phoneFriendsArr;
}

-(WriteIOUNetEngine *)engine{
    
    if(!_engine){
        _engine = [[WriteIOUNetEngine alloc]init];
    }
    
    return _engine;
}

-(void)getC{
    contactMgr = [[ContactMgr alloc]init];
    NSArray *contacts = [contactMgr contactsContainingString:[self searchString]];
    _phoneFriendsArr = [[NSMutableArray alloc] initWithArray:contacts];
    //TODO 重写
    while (_phoneFriendsArr.count > 3) {
        [_phoneFriendsArr removeLastObject];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {

        return _cnFriendsArr.count>=3?(_cnFriendsArr.count+1):_cnFriendsArr.count;

    }else{

        return _phoneFriendsArr.count>=3?(_phoneFriendsArr.count+1):_phoneFriendsArr.count;

    }
 }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section ==0 && _cnFriendsArr.count > 0) {
        return 38;
    }
    
    if (section ==1 && _phoneFriendsArr.count > 0) {
        return 38;
    }
 
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [ZAPP.zdevice getDesignScale:40])];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *_headerLabel = [[UILabel alloc]initWithFrame:CGRectMake([ZAPP.zdevice getDesignScale:20], 0, MainScreenWidth, 38)];
    _headerLabel.font = [UtilFont systemLarge];

    _headerLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY) ;
    
    [_headerView addSubview:_headerLabel];
    _headerLabel.text = section==0?@"Cashnice联系人":@"手机通讯录";
    
    HorizonLine *line = [[HorizonLine alloc]init];
    [_headerView addSubview:line];
    [line setLineColor:ZCOLOR(COLOR_SEPERATOR_COLOR)];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerView.mas_left).mas_offset(SEPERATOR_LINELEFT_OFFSET);
        make.right.equalTo(_headerView.mas_right);
        make.bottom.equalTo(_headerView.mas_bottom).mas_offset(-0.5);
        make.height.mas_equalTo(0.5);
        
    }];

    
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row >= _cnFriendsArr.count) {
            return 47;
        }
    }else if(indexPath.section==1){
        
        if (indexPath.row >= _phoneFriendsArr.count) {
            return 47;
        }
    }
    
    return [ZAPP.zdevice getDesignScale:SF_ROW_HEIGHT];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section == 0) {
        if (indexPath.row >= _cnFriendsArr.count) {
           
            static NSString *cell_id = @"SFMoreCell_id";
            SFMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
            cell.tipLabel.text = @"查看更多Cashnice联系人";
            cell.leftSpace = NO;
            cell.lineView.backgroundColor = _phoneFriendsArr.count>0? CN_COLOR_DD_GRAY:[UIColor whiteColor];
            return cell;
            

        }
        static NSString *cell_id = @"SFCashFriendCell_id";
        SFCashFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (indexPath.row<_cnFriendsArr.count) {
            cell.people = _cnFriendsArr[indexPath.row];
            cell.sel = (selIndexPath && selIndexPath.section== indexPath.section && indexPath.row == selIndexPath.row);
        }
        cell.leftSpace = YES;

        return cell;
    }else{
        
        if (indexPath.row >= _phoneFriendsArr.count) {
            
            static NSString *cell_id = @"SFMoreCell_id";
            SFMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
            cell.tipLabel.text = @"查看更多联系人";
            cell.leftSpace = NO;
            cell.lineView.backgroundColor =  [UIColor whiteColor];

            return cell;
            
        }
        
        static NSString *cell_id = @"SFCashFriendCell_id";
        SFCashFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (indexPath.row<_phoneFriendsArr.count) {
            cell.people = _phoneFriendsArr[indexPath.row];
            cell.sel = (selIndexPath && selIndexPath.section== indexPath.section && indexPath.row == selIndexPath.row);
            
        }
        cell.leftSpace = YES;

        return cell;
    }
    

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section == 1) {
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell isKindOfClass:[SFCashFriendCell class]]) {
            selIndexPath = indexPath;
            [self setNavRightBtnHidden:NO];
            [self.tableView reloadData];
        }else{
            
            //点击查看更多

            MoreFriendViewController *mfvc = ZWIOU(@"MoreFriendViewController");
            mfvc.atitle = indexPath.section == 1?@"通讯录":@"Cashnice联系人";
            mfvc.keyText= [self searchString];//self.searchBar.text;
            mfvc.searchPhoneContacts = indexPath.section == 1?YES:NO;
            [self.navigationController pushViewController:mfvc animated:YES];
            
        }
        
}


#pragma mark  - UITextFieldDelegate

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    
//    if([self.searchBar.text length] ==0){
//        
//        _cnFriendsArr = nil;
//        _phoneFriendsArr =nil;
//        
//        [self noSearchState];
//    }
//}

- (IBAction)search:(id)sender {
    DLog(@"%@", _searchBar.text);
    
    NSString *searchString = [self searchString];;
    
    if (searchString.length > 0) {
        selIndexPath = nil;
        [self getCNData];
    }else{
        [_searchBar becomeFirstResponder];
    }
}

- (NSString *)searchString {
    return [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self searchState];
    return YES;
}
-(void)noSearchState{
  
    self.cancleBtn.hidden = YES;
    self.searchBar.text = @"";
    [self.view endEditing:YES];
    
    self.initialTipView.hidden = YES;
    
    [self.tableView reloadData];
}
-(void)searchState{
  
    self.cancleBtn.hidden = NO;

//    [self.searchBar setShowsCancelButton:YES animated:YES];
//    self.initialTipView.hidden = YES;
    
    
}

- (IBAction)searchBarCancelButtonClicked:(id)sender{
    
    _cnFriendsArr = nil;
    _phoneFriendsArr =nil;
    
    [self noSearchState];
    [self setNavRightBtnHidden:YES];
    [self customNavBackPressed];
}

-(void)getCNData{
    curPage = 0;
    pageCount=3;
    bugeili_net_new
    [self requestCNContactsData];
    
}

-(void)getMoreCNData{
    
    curPage ++;
    pageCount=3;

    bugeili_net_new
    [self requestCNContactsData];

}

-(void)requestCNContactsData{

    NSDictionary *dic = @{@"searchkey":[self searchString],
                          @"pagenum":@(curPage),
                          @"pagesize":@(pageCount)
                          };
    
    __weak __typeof__(self) weakSelf = self;

    [self.engine getSearchContacts:dic success:^(NSArray *arr, NSInteger totalCount) {
        
        
        [weakSelf updateUI:arr];
        
    } failure:^(NSString *error) {
        
    }];
}

-(void)updateUI:(NSArray *)arr{
    
    [self getC];
    
    if ( self.phoneFriendsArr.count || (arr && arr.count)) {
        
        self.noContactPromptLabel.hidden = YES;
        
        [self.cnFriendsArr insertPage:curPage pageSize:pageCount objects:arr];

        self.initialTipView.hidden = YES;
        
    }else{
        //无结果
        [self.cnFriendsArr removeAllObjects];
        [self.phoneFriendsArr removeAllObjects];
        self.noContactPromptLabel.hidden = NO;
    }
    
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self noSearchState];
    [self.view endEditing:YES];
}

- (UILabel *)noContactPromptLabel{
    if (! _noContactPromptLabel) {
        _noContactPromptLabel = [[UILabel alloc] init];
        _noContactPromptLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        _noContactPromptLabel.font = [UtilFont systemLargeNormal];
        _noContactPromptLabel.text = @"无结果";
        [_noContactPromptLabel sizeToFit];
        _noContactPromptLabel.hidden = YES;
        [self.view addSubview:_noContactPromptLabel];
        [_noContactPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.searchBar.mas_bottom).mas_offset(30);
        }];
    }
    return _noContactPromptLabel;
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
