//
//  SupportedBankListViewController.m
//  YQS
//
//  Created by a on 16/4/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SupportedBankListViewController.h"
#import "SupportedBankListCell.h"

@interface SupportedBankListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *bankListData;
@property (weak, nonatomic) IBOutlet UILabel *headlabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SupportedBankListViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self connectToServer];
}


- (void)connectToServer {
    progress_show
    [ZAPP.netEngine api2_getBankcardListWithComplete:^{
        [self.tableView reloadData];
        //[weakSelf setData];
        progress_hide
    } error:^{
        //[weakSelf loseData];
        progress_hide
    }];
}

- (void)setupView{
    self.title = @"支持的银行卡和充值限额";
    [self setNavButton];
    self.headlabel.font = [UtilFont systemLarge];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZAPP.zdevice getDesignScale:65];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SupportedBankListCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SupportedBankListCell"];
    
    NSDictionary *bankInfo = self.bankListData[indexPath.row];
    
    
    [cell.logoImage setImageFromURL:[NSURL URLWithString:bankInfo[@"bankimg"]]];
    
    cell.nameLabel.text = bankInfo[@"bankname"];
    
    NSInteger limit1 = [bankInfo[@"qpaylimitvaleverytrans"] integerValue];
    NSInteger limit2 = [bankInfo[@"qpaylimitvaleveryday"] integerValue];
    NSString *limit1Str = [Util formatRMB:@(limit1)];
    NSString *limit2Str = [Util formatRMB:@(limit2)];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"单笔上限%@  每日上限%@", limit1Str, limit2Str];
    
    return cell;
}

- (NSArray *)bankListData {
    NSDictionary *banks = ZAPP.myuser.bankcardPayListRespondDict[@"banks"];
    if ([banks isKindOfClass:[NSArray class]]) {
        _bankListData = [banks copy];
    }else{
        _bankListData = nil;
    }
    return _bankListData;
}

@end
