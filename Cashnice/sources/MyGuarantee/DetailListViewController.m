//
//  DetailListViewController.m
//  Cashnice
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "DetailListViewController.h"
#import "LDThreeLabelCell.h"
#import "GuaDetailListViewController.h"
#import "LoanDetailListViewController.h"
#import "InvesDetailListViewController.h"
#import "WebDetail.h"
#import "AllShouxinPeople.h"
#import "BILLWebViewUtil.h"
#import "JieKuanUtil.h"
#import "InvestHistoryViewController.h"

@interface DetailListViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation DetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    
    [self setNavButton];
    
    [self.view addSubview:self.tableView];
    UIView *superView = self.view;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        
    }];

    
}


-(LoanDetailEngine *)engine{
    
    if(!_engine){
        _engine = [[LoanDetailEngine alloc]init];
    }
    
    return _engine;
}


-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

//子类重写
-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        _typeNameArr = @[
                        @{@"aaa":
                              @[@"111",@"222"]
                          }
                        ,
                        
                        @{@"bbb":
                              @[@"555",@"222"]
                          }
                        ,
                        
                        @{@"ccc":
                              @[@"666",@"222"]
                          }
                        ].mutableCopy;
    }
    
    return _typeNameArr;
}


-(BOOL)showBlankWithSection{
//    return NO;
    return YES;
}



//固定头部视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = LISTDETAIL_ROW_HEIGHT_HEADER;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.typeNameArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section < self.typeNameArr.count) {
        NSDictionary *dic = self.typeNameArr[section];
        NSArray *arr = [[dic allValues] firstObject];
        return  [arr count]+(self.showBlankWithSection? 1 : 0);
    }
    
    return 0;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return LISTDETAIL_ROW_HEIGHT_HEADER;
 }

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, LISTDETAIL_ROW_HEIGHT_HEADER)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *_headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainScreenWidth, LISTDETAIL_ROW_HEIGHT_HEADER)];
    _headerLabel.font = [UIFont systemFontOfSize:15];
    _headerLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY) ;
    
    [_headerView addSubview:_headerLabel];
    

    NSDictionary *dic = self.typeNameArr[section];
    NSArray *arr = [[dic allValues] firstObject];
    _headerLabel.text = [[dic allKeys] firstObject];

    if (arr.count) {
        UIView*lineview = [[UIView alloc]initWithFrame:CGRectMake(SEPERATOR_LINELEFT_OFFSET, _headerView.frame.size.height-1, _headerLabel.frame.size.width, 1)];
        [lineview setBackgroundColor:CN_COLOR_DD_GRAY];
        [_headerView addSubview:lineview];
    }
    
    return _headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
//    if(indexPath.section < 2){
    
    if(indexPath.section <self.typeNameArr.count){

        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSArray *arr = [[dic allValues] firstObject];
        
        if (indexPath.row < arr.count) {
            return  indexPath.section < 2? LISTDETAIL_ROW_HEIGHT:IPHONE6_ORI_VALUE(40);
        }else{
            return LISTDETAIL_SECTION_BLANK;
        }
    }
//    }else{
//        return IPHONE6_ORI_VALUE(40);
//    }
//    

    return 0;
}

//子类根据情况重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section <self.typeNameArr.count){
        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSString *key = [dic allKeys][0];
        
        if ([key isEqualToString:@"交易明细"]) {
            return [self cellForThreeLabel:tableView indexPath:indexPath];
        }else{
            return [self cellForDetail:tableView indexPath:indexPath];
        }
    }

    return [UITableViewCell new];
}

 

- (UITableViewCell *)cellForBlank:(UITableView *)tableView {
    
    NSString *const cellForBlank_ID= @"cellForBlank";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellForBlank_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellForBlank_ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
    
}

-(NSString *)bottomBtnName{
    return @"";
}

-(UITableViewCell *)cellForThreeLabel:(UITableView *)tw indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section<self.typeNameArr.count) {
     
        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSArray *arr = [[dic allValues] firstObject];
        
        if (indexPath.row < arr.count) {
            LDThreeLabelCell *cell = [LDThreeLabelCell cellWithTableView:tw];
            cell.textLabel.textColor = CN_TEXT_BLACK;
            WaterFlowDetail *detail = arr[indexPath.row];
            [cell configureTitle:detail.t_time detail:detail.format_t_money centralTitle: detail.t_type];
            return cell;
        }else{
            return [self cellForBlank:tw];
        }
    }
    
    return nil;
    
}

-(UITableViewCell *)cellForDetail:(UITableView *)tw indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section<self.typeNameArr.count) {
        
        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSArray *arr = [[dic allValues] firstObject];
        
        if (indexPath.row < arr.count) {
            NSString*title =arr[indexPath.row];
            
            CNTitleDetailArrowCell *cell = nil;
 
            cell = [CNTitleDetailArrowCell cellWithTableView:tw];

        
            [cell configureTitle:title detail:[self cellDetail:indexPath title:title]
                  rightLabelType:[self cellRightType:indexPath title:title]];


            cell.leftSpace = YES;
            
            if(indexPath.row == arr.count -1 ){
                cell.bottomLineHidden = YES;
            }else{
                cell.bottomLineHidden = NO;
            }
        
             return cell;
            
        }else{
            return [self cellForBlank:tw];
        }
        
    }
    
    return nil;
    
}


///**
// 是否是抵押用户
//
// @return
// */
-(BOOL)isPrivilegedWithLoan{
    BOOL pledge = [JieKuanUtil isPrivilegedWithLoan:self.detailDic];
    return pledge;
}

-(NSString *)cellDetail:(NSIndexPath *)indexPath title:(NSString *)title{
    
    return  @"zzz";
}

-(DETAILCELL_RIGHTLABEL_TYPE)cellRightType:(NSIndexPath *)indexPath title:(NSString *)title{

    
    if ([title isEqualToString:@"担保人"]|| [title isEqualToString:@"投资人"]) {
        return RIGHTLABEL_RIGHTSPACE_SHOWACC;
    }
    
    else if ([title isEqualToString:@"借款协议"]) {
        return RIGHTLABEL_RIGHTSPACE_SHOWACC;
    }
    
//    else if ([title isEqualToString:@"投资人"]) {
//        return RIGHTLABEL_RIGHTSPACE_HIDEACC;
//    }
    else if ([title isEqualToString:@"抵押用户"]) {
        return RIGHTLABEL_RIGHTSPACE_SHOWACC;
    }


    return RIGHTLABEL_ALIGNRIGHT;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section < self.typeNameArr.count)
    {
        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSArray *arr = [[dic allValues] firstObject];
        
        if (indexPath.row < arr.count) {
            NSString*title =arr[indexPath.row];
            
            if(![title isKindOfClass:[NSString class]]){
                return;
            }
            
            if ([title isEqualToString:@"借款协议"]) {
                [self openWebProtocol];
            }else  if ([title isEqualToString:@"担保人"]){
                AllShouxinPeople *guaranteen = ZSEC(@"AllShouxinPeople");
//                if (self.detailDic) {
//                    [guaranteen setLoanDict:self.detailDic];
//                }
                [guaranteen setLoanID:_loanId];
                guaranteen.title = @"担保人";
                [self.navigationController pushViewController:guaranteen animated:YES];

                
            }else  if ([title isEqualToString:@"投资人"]){
//                AllShouxinPeople *guaranteen = ZSEC(@"AllShouxinPeople");
//                [guaranteen setLoanID:_loanId];
//                guaranteen.title = @"担保人";
//                [self.navigationController pushViewController:guaranteen animated:YES];

                InvestHistoryViewController *ihvc = ZINVST(@"InvestHistoryViewController");
                ihvc.loanId = self.loanId;
                [self.navigationController pushViewController:ihvc animated:YES];
                
                
            }else  if ([title isEqualToString:@"抵押用户"]){
                [BILLWebViewUtil presentPrivilegedUserWithViewController:self];
            }
        }
    }

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(instancetype)listDetailWith:(NSString *)type loanid:(NSInteger)loanid{
    
    DetailListViewController *vc = nil;
    
    if ([type isEqualToString:@"W"]) {
        vc = [[GuaDetailListViewController alloc]init];
    }else if ([type isEqualToString:@"L"]) {
        vc = [[LoanDetailListViewController alloc]init];
    }else if ([type isEqualToString:@"B"]) {
        vc = [[InvesDetailListViewController alloc]init];
    }
    vc.loanId = loanid;
    return vc;
}

-(void)openWebProtocol{
    
    WebDetail *w = ZSTORY(@"WebDetail");
    w.webType = WebDetail_borrow_xuzhi;
    [self.navigationController pushViewController:w animated:YES];
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
