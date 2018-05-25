//
//  IOUWaitSureViewController.m
//  Cashnice
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUWaitSureDetailViewController.h"

@interface IOUWaitSureDetailViewController ()

@end

@implementation IOUWaitSureDetailViewController
@synthesize typeNameArr = _typeNameArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getDetail];
    
}

//子类重写
-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        _typeNameArr = [NSArray arrayWithObjects:
                        
                        @{@"hh":
                              @[@"hh"]
                          }
                        ,
                        
                        @{@"基本信息":
                              @[@"借款金额",@"借款日期", @"还款日期", @"年化利率"]
                          }
                        ,
                        
                        nil];
    }
    
    return _typeNameArr;
}

-(BOOL)showBlankWithSection{
    return NO;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return ROW_HEIGHT_0;
    }
    
    return ROW_HEIGHT_1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//子类根据情况重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [self cellForTopRelation:tableView indexPath:indexPath];
    }
    return [self cellForDetail:tableView indexPath:indexPath];
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
