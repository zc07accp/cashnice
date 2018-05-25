//
//  .m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BankChoose.h"
#import "BankCell.h"
#import "SeachHaoyouViewController.h"
#import "YaoqingHaoyou.h"
#import "PersonHomePage.h"
#import "LabelsView.h"
#import "GeRenTableViewCell.h"
#import "Chongzhi.h"

@interface BankChoose () {
	NSInteger   rowCnt;
	NSInteger   rowHeight;

	NSInteger opRow;
    
    BOOL willGoDetail;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *    dataArray;

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIView *textbgview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_textHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_tableHeight;

@end

@implementation BankChoose

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
	self.table.backgroundColor = [UIColor clearColor];
	[self.table setSeparatorInset:UIEdgeInsetsZero];


	rowCnt    = 0;
	rowHeight = 80;

    self.textbgview.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5];
    
    self.textview.text = @"重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明";
    self.textview.userInteractionEnabled = NO;
    
    self.textview.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.textview.font = [UtilFont systemLarge];
    
    CGSize textViewSize = [self.textview sizeThatFits:CGSizeMake(self.textview.frame.size.width, FLT_MAX)];
    self.con_textHeight.constant = [ZAPP.zdevice getDesignScale:textViewSize.height + 5];
    self.con_textHeight.constant = 0;
    
    self.textview.hidden = YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)rh {
	[self connectToServer];
}

- (NSMutableArray *)dataArray {
	if (_dataArray == nil) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

- (void)setData {
	[self.dataArray removeAllObjects];

	int cnt = [[ZAPP.myuser.bankcardListRespondDict objectForKey:NET_KEY_visacount] intValue];
	if (cnt > 0) {
		[self.dataArray addObjectsFromArray:[ZAPP.myuser.bankcardListRespondDict objectForKey:NET_KEY_visas]];
	}

	rowCnt = [self.dataArray count];
    
	[self ui];
}

- (void)loseData {
}

- (void)ui {
    self.con_tableHeight.constant = [ZAPP.zdevice getDesignScale:(rowCnt * rowHeight + 30 * 2 + 44 + (rowCnt == 0 ? 0 : 30))];
    self.table.footer.hidden = YES;
	[self.table reloadData];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
    progress_show
    
    __weak __typeof__(self) weakSelf = self;

    self.op = [ZAPP.netEngine api2_getBankcardListWithComplete:^{[weakSelf setData];progress_hide} error:^{[weakSelf loseData];progress_hide}];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"选择银行卡"];
	[self ui];
	[self uiNav];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

    if (willGoDetail) {
        willGoDetail = NO;
        //return;
    }
	if ([ZAPP.zlogin isLogined]) {
		[self rh];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"选择银行卡"];

	[self.op cancel];
	self.op = nil;
}

BLOCK_NAV_BACK_BUTTON

- (void)uiNav {
	[self setTitle:@"选择银行卡"];
    [self setNavButton];
}
- (BOOL)lastRow:(NSInteger)row {
	return row == rowCnt - 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowCnt;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale : 30];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return [ZAPP.zdevice getDesignScale:30];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [ZAPP.zdevice getDesignScale:rowHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor        = [UIColor clearColor];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       	BankCell *    cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.bankLabel.text = [dict objectForKey:NET_KEY_bankname];
        cell.numberLabel.text =[dict objectForKey:NET_KEY_visacode];
        //int isdefault = [[dict objectForKey:NET_KEY_isdefault] intValue];
//        int isverified = [[dict objectForKey:NET_KEY_isverifyed] intValue];
        //cell.backupLabel.text = (isdefault == 1 ? @"充值提现卡": @"备用卡");
    cell.backupLabel.hidden = YES;
        //cell.delegate = self;
        cell.button2.hidden = YES;
        
        cell.sepLine.hidden = [self lastRow:indexPath.row];
        
        return cell;


}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    ZAPP.myuser.gerenBankDict = [self.dataArray objectAtIndex:indexPath.row];
    Chongzhi *c = ZSEC(@"Chongzhi");
    c.level = 2;
    [self.navigationController pushViewController:c animated:YES];
}

@end
