//
//  GuaDetailListViewController.m
//  Cashnice
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuaDetailListViewController.h"
#import "GuaDetailConfig.h"
#import "ListDetailDataReformer.h"
#import "NewLoanProtocolViewController.h"

@interface GuaDetailListViewController ()
@end

@implementation GuaDetailListViewController
@synthesize typeNameArr = _typeNameArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDetail];
}



#pragma mark - 关于详情的各种网络请求

-(void)getDetail{

    progress_show

    WS(ws);
    [self.engine getListDetail:self.loanId typeid:@"W" betid:-1 success:^(NSDictionary *detail) {
        progress_hide
        
        [ws updateUI:detail];

        
    } failure:^(NSString *error) {
        progress_hide

    }];
}


-(void)updateUI:(NSDictionary *)dic{
    self.detailDic = dic;

    self.title = [self.detailDic objectForKey:@"loantitle"];
    self.typeNameArr = [GuaDetailConfig listTypes:self.detailDic];
    [self.tableView reloadData];
    
    WS(ws);

    [self.engine getWaterFlowDetail:self.loanId typeid:@"W" betid:-1 
                            success:^(NSArray *list) {
                                
//                                if(list.count){
                                    [ws updateWaterFlow:list];
  //                              }
                                
                            } failure:^(NSString *error) {
                                
                            }];

    
}

-(void)updateWaterFlow:(NSArray *)list{
    
    if ([ListDetailDataReformer showWaterFlowTip:self.detailDic type:@"W" list:list]) {
        [self.typeNameArr addObject:@{@"交易明细":list?list:@[]}];
        [self.tableView reloadData];
    }

}

-(void)openWebProtocol{
    NewLoanProtocolViewController *vc = [[NewLoanProtocolViewController alloc]init];
    vc.type = 5;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)cellDetail:(NSIndexPath *)indexPath title:(NSString *)title{
    return [ListDetailDataReformer valueForList:self.detailDic title:title type:@"W"];
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
