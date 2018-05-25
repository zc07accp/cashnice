//
//  RenmaiHeadTableViewController.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NewInstruction.h"
#import "GeRenTableViewCell.h"
#import "WebDetail.h"
#import "NewInstructionDetail.h"

@interface NewInstruction ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *rowNameArray;
@property (strong, nonatomic) NSArray *rowPathArray;
@end

@implementation NewInstruction

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.table.backgroundColor = ZCOLOR(COLOR_BG_WHITE);
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

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"用户指南"];
    
    [self setTitle:@"用户指南"];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"用户指南"];
}

- (NSArray *)rowPathArray {
    if (! _rowPathArray) {
        _rowPathArray = @[@"certification.html", @"certification_vip.html", @"link_card.html", @"limit.html", @"invite_friends.html", @"add_limit.html", @"borrowing.html", @"invest.html", @"repayment.html", @"recharge.html", @"withdrawal.html"];
    }
    return _rowPathArray;
}

- (NSArray *)rowNameArray {
    if (_rowNameArray == nil) {
        _rowNameArray = @[@"如何成为认证用户？",@"如何成为认证VIP用户？", @"如何绑定银行卡？", @"如何授信？", @"如何邀请好友？", @"如何增加借款额度？", @"如何发布借款？", @"如何投资？", @"如何还款？", @"如何充值？", @"如何提现？"];
    }
    return _rowNameArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowNameArray.count;
}

- (BOOL)lastRow:(NSIndexPath *)indexPath {
    return indexPath.row == self.rowNameArray.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:TABLE_TEXT_ROW_HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeRenTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //cell.sepLine.hidden = [self lastRow:indexPath];
    
    cell.biaoti.text = [self.rowNameArray objectAtIndex:indexPath.row];
    

    cell.detail.text = @"";

    
    cell.arrow.hidden = NO;
    
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
//    NewInstructionDetail *x = ZSTORY(@"NewInstructionDetail");
//    x.rowIndex = (int)indexPath.row;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSInteger row = indexPath.row;
    WebDetail *x = ZSTORY(@"WebDetail");
    x.userAssistantPath = @{@"name" : self.rowNameArray[row],
                            @"path" :
                                [NSString stringWithFormat:@"%@?t=%@",self.rowPathArray[row], strDate] };
    
    [self.navigationController pushViewController:x animated:YES];
}



@end
