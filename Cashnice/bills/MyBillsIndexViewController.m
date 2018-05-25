//
//  MyBillsIndexViewController.m
//  YQS
//
//  Created by a on 15/9/14.
//  Copyright (c) 2015年 l. All rights reserved.
//

#import "MyBillsIndexViewController.h"
#import "MyBillsIndexTableViewCell.h"
#import "RepaymentBillListViewController.h"
#import "RepaymentBillDetailViewController.h"

@interface MyBillsIndexViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *                  rowNameArray;
@end

@implementation MyBillsIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSArray *)rowNameArray{
    if (! _rowNameArray) {
        _rowNameArray = @[@"还款账单", @"投资收益账单", @"邀请人分层"];
    }
    return _rowNameArray;
}

- (BOOL)lastRow:(NSIndexPath *)indexPath {
    return indexPath.row == 2;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:TABLE_TEXT_ROW_HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:10];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *   CellIdentifier = @"MyBillsIndexCell";
    MyBillsIndexTableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.sepLIne.hidden = [self lastRow:indexPath];
    
    cell.title.text = self.rowNameArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0) {
        RepaymentBillListViewController *list = CcStory(@"RepaymentBillListViewController");
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
