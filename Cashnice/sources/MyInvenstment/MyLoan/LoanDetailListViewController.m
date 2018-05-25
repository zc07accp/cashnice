//
//  LoanDetailListViewController.m
//  Cashnice
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanDetailListViewController.h"
#import "LoanDetailConfig.h"
#import "ListDetailDataReformer.h"
#import "LoanDetailEngine.h"
#import "JieKuanUtil.h"
#import "NewLoanProtocolViewController.h"

@interface LoanDetailListViewController ()
@end

@implementation LoanDetailListViewController
@synthesize typeNameArr = _typeNameArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDetail];

}


-(void)getDetail{
    
    progress_show
    
    WS(ws);
    [self.engine getListDetail:self.loanId typeid:@"L" betid:-1 success:^(NSDictionary *detail) {
        progress_hide
        
        [ws updateUI:detail];
        
        
    } failure:^(NSString *error) {
        progress_hide
        
    }];
        
}


-(void)updateUI:(NSDictionary *)dic{
    self.detailDic = dic;
    
    self.title = [self.detailDic objectForKey:@"loantitle"];
    
    [self.typeNameArr removeAllObjects];
    [self.typeNameArr addObjectsFromArray: [LoanDetailConfig listTypes:self.detailDic]];
    [self.tableView reloadData];
    
    WS(ws);
    
    [self.engine getWaterFlowDetail:self.loanId typeid:@"L" betid:-1 
                            success:^(NSArray *list) {
                                
//                                if(list.count){
                                    [ws updateWaterFlow:list];
  //                              }
                                
                            } failure:^(NSString *error) {
                                
                            }];
}

-(void)updateWaterFlow:(NSArray *)list{
    
    if ([ListDetailDataReformer showWaterFlowTip:self.detailDic type:@"L" list:list]) {

        [self.typeNameArr addObject:@{@"交易明细":list?list:@[]}];
        [self.tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//子类重写
-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        _typeNameArr = @[].mutableCopy;
//         [_typeNameArr addObjectsFromArray:[LoanDetailConfig listTypes:self.detailDic]];
    }
    
    return _typeNameArr;
}

-(NSString *)cellDetail:(NSIndexPath *)indexPath title:(NSString *)title{
    return [ListDetailDataReformer valueForList:self.detailDic title:title type:@"L"];
}

-(void)openWebProtocol{
    NewLoanProtocolViewController *vc = [[NewLoanProtocolViewController alloc]init];
    vc.type = 4;
    vc.loanId = self.loanId;

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
