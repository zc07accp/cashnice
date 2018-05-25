//
//  TransferIndexViewController.m
//  Cashnice
//
//  Created by a on 16/10/13.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TransferIndexViewController.h"
#import "TransferIndexCell.h"
#import "TransferConfirmViewController.h"
#import "TransferHistoryViewController.h"
#import "ShouxinEngine.h"
#import "HeaderNamePersonCell.h"
#import "TransferEngine.h"


@interface TransferIndexViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSUInteger _curPage;
    NSUInteger _sectionHeaderHight;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *transferDataList;

@property (strong, nonatomic) TransferEngine *engine;

@end

@implementation TransferIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"转账";
    _curPage = 1;
    _sectionHeaderHight = [ZAPP.zdevice scaledValue:33];
    
    self.tableView.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(refresh) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(loadMore)];
    self.tableView.footer.hidden = YES; //默认先隐藏
    
    [self setNavButton];
    [self setNavRightBtn];
    
    [self refresh];
    self.needRefresh = NO;
    
    [ShouxinEngine requestStoreShouxinToMe];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"转账"];
    
    //刷新转账列表
    if (self.needRefresh) {
        [self refresh];
    }
  
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"转账"];
}

-(void)setNavRightBtn{
    
    self.isRightNavBtnBorderHidden = YES;
    
    [super setNavRightBtn];
    
    [self.rightNavBtn.titleLabel setFont:CNFontNormal];
    [self.rightNavBtn setTitle:@"转账记录" forState:UIControlStateNormal];
    [self.rightNavBtn sizeToFit];
    self.rightNavBtn.left -= 5;
//    self.rightNavBtn.right = 3;
//    [self.rightNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(3);
////        make.top.equalTo(self.rightNavBtn.superview).mas_offset(-1);
//    }];
    
//    [self.rightNavBtn addTarget:self action:@selector(showHistory) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightNavItemAction {
    TransferHistoryViewController *history = ZPERSON(@"TransferHistoryViewController");
    [self.navigationController pushViewController:history animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : self.transferDataList.count;
}
- (BOOL)lastRow:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row ==  1;
    }else{
        return indexPath.row == self.transferDataList.count-1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [ZAPP.zdevice scaledValue: 52];
    return [self lastRow:indexPath] ? height-1 : height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==1?_sectionHeaderHight : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self sectionHeaderView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *   CellIdentifier = @"TransferIndexCell";
        TransferIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell configurateWithIndexPath:indexPath];
        cell.sepLine.hidden = [self lastRow:indexPath];
        return cell;
    }else{
//        static NSString *   CellIdentifier = @"TransferRecentCell";
        
        HeaderNamePersonCell *cell = [HeaderNamePersonCell cellWithNib:tableView];
        
        NSDictionary *dictData = self.transferDataList[indexPath.row];
        [cell.headImgView setHeadImgeUrlStr:dictData[@"headimg"]];
        cell.nameLabel.text=dictData[@"userrealname"];

        NSLog(@"head=%@", dictData[@"headimg"]);
        
        cell.bottomLineHidden =  indexPath.row == self.transferDataList.count-1?YES:NO;
        cell.leftSpace = YES;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    if (indexPath.section == 1) {
        TransferConfirmViewController *tvc = ZPERSON(@"TransferConfirmViewController");
        tvc.targetUserDict = self.transferDataList[indexPath.row];
        vc = tvc;
    }else{
        switch (indexPath.row) {
            case 0:
                vc = SEARCHSTORY(@"SearchPersonViewController");
                break;
            case 1:
                vc = SEARCHSTORY(@"SearchCNFriendViewController");
                break;
                
            default:
                break;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadMore{
    _curPage ++;
    [self connectToServer];
}

- (void)refresh{
    _curPage = 1;
    [self connectToServer];
}

- (void)endRefreshing{
    [self.tableView.footer endRefreshing];
    [self.tableView.header endRefreshing];
}

- (void)loadTable:(NSArray *)historyItems isLastPage:(BOOL)isLastPage{
    
    if ([historyItems isKindOfClass:[NSArray class]] && historyItems.count > 0) {
        
        self.tableView.footer.hidden = isLastPage;
        
        if (_curPage <= 1) {
            [self.transferDataList removeAllObjects];
            [self.tableView reloadData];
        }
        [self.transferDataList addObjectsFromArray:historyItems];
        
        [self.tableView reloadData];
    }else{
        //暂无记录
    }
}
- (void)connectToServer {
    progress_show
    
    WS(ws)
    [self.engine getTransferDataWithpage:_curPage pageSize:10 success:^(NSArray *dataItems, BOOL isLastPage) {
        progress_hide
        [ws endRefreshing];
        
        [ws loadTable:dataItems isLastPage:isLastPage];
        
    } failure:^(NSString *error) {
        progress_hide
        [ws endRefreshing];
    }];
}

//- (void)connectToServer {
//    progress_show
//    [ZAPP.netEngine getTransferDataComplete:^{
//        progress_hide
//        if (ZAPP.myuser.transferDataList && [ZAPP.myuser.transferDataList isKindOfClass:[NSArray class]]) {
//            _transferDataList = ZAPP.myuser.transferDataList;
//            [self.tableView reloadData];
//        }
//    } error:^{
//        progress_hide;
//    }];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = _sectionHeaderHight;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (UIView *)sectionHeaderView{
    UIView *v = [UIView new];
    
    v.userInteractionEnabled = NO;
    
    UILabel *l = [UILabel new];
    l.font = CNFont_26px;
    l.textColor = CN_TEXT_GRAY;
    l.text = self.transferDataList.count>0? @"最近" : nil;
    [v addSubview: l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v).mas_offset([ZAPP.zdevice scaledValue:10]);
        make.centerY.equalTo(v);
    }];
    
    return v;
}

- (TransferEngine *)engine{
    if (! _engine) {
        _engine = [[TransferEngine alloc] init];
    }
    return _engine;
}


- (NSMutableArray *)transferDataList{
    if (! _transferDataList) {
        _transferDataList = [NSMutableArray new];
    }
    return _transferDataList;
}

/*
- (UILabel *)noDataLabel{
    if (! _noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.font = [UIFont systemFontOfSize:20.0f];
        _noDataLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        _noDataLabel.hidden = YES;
        _noDataLabel.text = @"暂无数据";
        [self.tableView addSubview:_noDataLabel];
        
        [_noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat offset = [ZAPP.zdevice scaledValue:33+100];
            make.centerX.equalTo(self.tableView);
            make.top.mas_equalTo(offset);
            make.height.equalTo(self.tableView).mas_offset(-offset*1.5);
        }];
    }
    return  _noDataLabel;
}
 */

@end
