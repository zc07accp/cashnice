//
//  .m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BillDetail.h"
#import "ShouxinCell.h"
#import "GeRenTableViewCell.h"

@interface BillDetail () {
	NSInteger   rowCnt;
	NSInteger   rowHeight;

    int mLoanID;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSArray *nameArr;
@property (strong, nonatomic) NSMutableArray *valueArr;
@end

@implementation BillDetail
- (NSMutableArray *)valueArr {
    if (_valueArr == nil) {
        _valueArr =  [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @""]];
    }
    return _valueArr;
}
- (NSArray *)nameArr {
    if (_nameArr == nil) {
        _nameArr = @[@"金额",@"备注", @"交易时间", @"交易单号"];
    }
    return _nameArr;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
	self.table.backgroundColor = [UIColor clearColor];
	[self.table setSeparatorInset:UIEdgeInsetsZero];


	rowCnt    = 8;
	rowHeight = 80;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (void)setData {
    NSDictionary *dict = ZAPP.myuser.billDetailDict;
    [self.valueArr replaceObjectAtIndex:0 withObject:[dict objectForKey:NET_KEY_VAL]];//
    [self.valueArr replaceObjectAtIndex:1 withObject:[dict objectForKey:NET_KEY_TEXT]];
//    [self.valueArr replaceObjectAtIndex:2 withObject:[dict objectForKey:NET_KEY_VAL]];
//    [self.valueArr replaceObjectAtIndex:3 withObject:[dict objectForKey:NET_KEY_]];
//    [self.valueArr replaceObjectAtIndex:4 withObject:[dict objectForKey:NET_KEY_]];
    [self.valueArr replaceObjectAtIndex:2 withObject:[dict objectForKey:NET_KEY_NOTICETIME]];
    [self.valueArr replaceObjectAtIndex:3 withObject:[dict objectForKey:NET_KEY_ORDERNO]];
    //int status = [[dict objectForKey:NET_KEY_status] intValue];
    //[self.valueArr replaceObjectAtIndex:4 withObject:(status == 1 ? @"交易成功" : @"交易失败")];
    
    NSString *namestr = [dict objectForKey:NET_KEY_FROMUSERREALNAME];
    if (!ISNSNULL(namestr) && [namestr notEmpty]) {
    }
    else {
        namestr = [dict objectForKey:NET_KEY_FROMUSERNICKNAME];
        if (!ISNSNULL(namestr) && [namestr notEmpty]) {
            
        }
        else {
            namestr = @"";
        }
    }
    [self.valueArr replaceObjectAtIndex:4 withObject:namestr];//actually name
    //头像
    [self.valueArr replaceObjectAtIndex:5 withObject:[dict objectForKey:@"fromuserheadimg"]];
    
    [self.table reloadData];
}

- (void)loseData {

    [Util toastStringOfLocalizedKey:@"tip.loadFail"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ui {
	[self.table reloadData];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
    progress_show
    
    __weak __typeof__(self) weakSelf = self;

    self.op = [ZAPP.netEngine getBillDetailWithComplete:^{[weakSelf setData];
        SharedTrigger;
        progress_hide
    } error:^{[weakSelf loseData];progress_hide} noticeID:self.billID];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单详情"];
	[self ui];
	[self uiNav];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

    [self connectToServer];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"订单详情"];

	[self.op cancel];
	self.op = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

BLOCK_NAV_BACK_BUTTON
- (void)uiNav {
	NSString *str = @"订单详情";
	[self setTitle:str];
[self setNavButton];
}

- (BOOL)lastRow:(NSInteger)row {
	return row == rowCnt - 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (section == 0 ?[ZAPP.zdevice getDesignScale : 30] : 0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [ZAPP.zdevice getDesignScale:rowHeight];
    }
    else {
        if (indexPath.row == 1) {
            int w = 350;
           NSString *str= [self.valueArr objectAtIndex:indexPath.row];
            CGRect therc = [str boundingRectWithSize:CGSizeMake([ZAPP.zdevice getDesignScale:w], 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UtilFont systemLarge]} context:nil];
            CGSize labelSize = therc.size;
            return labelSize.height + [ZAPP.zdevice getDesignScale:30];
        }
        else {
            return [ZAPP.zdevice getDesignScale:44];
        }
    }
    return 0;
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
    if (indexPath.section == 0) {
       	ShouxinCell *    cell;
        static NSString *CellIdentifier = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSString *imgurl = [self.valueArr objectAtIndex:5];//self.headImg;
        
        NSString *namestr = [self.valueArr objectAtIndex:4];
        if ([imgurl notEmpty]) {
            [cell.img setHeadImgeUrlStr:imgurl];
        }
        else {
            [cell.img setImage:[UIImage imageNamed:@"portrait_place.png"]];
        }
        
        cell.nameLabel.text = namestr;
        for (UILabel *l in cell.labelArray) {
            l.hidden = YES;
        }
        
        cell.sepLine.hidden = NO;
        
        
        cell.editButton.hidden = YES;
        cell.button1.hidden = YES;
        cell.button2.hidden = YES;
        
        return cell;
    }
    else {
        GeRenTableViewCell *cell;
        static NSString *   CellIdentifier2 = @"cell2";
        cell                = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.sepLine.hidden = [self lastRow:indexPath.row];
        
        cell.biaoti.text = [self.nameArr objectAtIndex:indexPath.row];// objectAtIndex:indexPath.row];
        
        cell.detail.hidden = NO;
        
        if (indexPath.row == 0) {
            cell.detail.textColor = [UIColor redColor];
            cell.detail.text = [Util formatRMB:@([[self.valueArr objectAtIndex:indexPath.row] doubleValue])];
        }
        else {
            cell.detail.textColor = ZCOLOR(COLOR_TEXT_BLACK);
            cell.detail.text = [self.valueArr objectAtIndex:indexPath.row];
        }
        
        
        return cell;
    }

    

}

@end
