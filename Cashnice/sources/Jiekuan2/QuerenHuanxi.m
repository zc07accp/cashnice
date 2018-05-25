//
//  JieKuanViewController.m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "QuerenHuanxi.h"
#import "LabelsView.h"
#import "HuanxiCell2.h"
#import "ButtonCell.h"
#import "JiekuanTableViewCell.h"

@interface QuerenHuanxi () {
    NSInteger rowCnt;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MKNetworkOperation *op;
@end

@implementation QuerenHuanxi

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =ZCOLOR(COLOR_BG_GRAY);
    rowCnt = 3;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
[self setNavButton];
    //[@"jie kuan" toast];
    [MobClick beginLogPageView:@"确认还款"];
    [self setTitle:@"确认还款"];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"确认还款"];
}

- (void)setDataLoadDetail {
}

- (void)loseDataLoadDetail {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connectToLoadDebtDetail {
    [self.op cancel];
    bugeili_net
    return;
    progress_show
    if ([Util hasFailDebt:self.dataDict]) {
        progress_hide
        [self setDataLoadDetail];
    }
    else {
        progress_hide
        [self setDataLoadDetail];
    }
//    self.op = [ZAPP.netEngine
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 2) ? rowCnt : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:(section == 0) ? 20 : 30];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:(section == 0) ? 10 : 30];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger x = 200;
    if (indexPath.section == 1) {
        x = 60;
    }
    else if (indexPath.section == 2) {
        x = 44;
    }
    return [ZAPP.zdevice getDesignScale:x];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
    LabelsView *v =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
        CGFloat f6 = [[self.dataDict objectForKey:@"nextdebtrepayval"] doubleValue];
        [v setTexts:@[@"应还金额:", [Util formatRMB:@(f6)]]];
        [v setColor:ZCOLOR(COLOR_BUTTON_RED) atIndex:1];
    return v;
        
    }
    else if (section == 2) {
        LabelsView *v =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
        [v setTexts:@[@"往期还息记录  共", @"2", @"条"]];
        return v;
        
    }
    else {
        UIView *v = [UIView new];
        v.userInteractionEnabled = NO;
        v.backgroundColor = [UIColor clearColor];
        return v;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        HuanxiCell2 *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.nameLabel.text = [Util formatRMB:@(2000)];
        cell.lixiLabel.text = @"成功还息";
        cell.timeLabel.text = @"2015-03-03";
        cell.sepLine.hidden = (indexPath.row == rowCnt - 1);
        
        return cell;
    }
    else if (indexPath.section == 0){
        JiekuanTableViewCell *cell;
        static NSString *CellIdentifier = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSDictionary *dict = self.dataDict;
        
        [cell setJiekuanState:[UtilString cvtIntToJiekuanState:([[dict objectForKey:NET_KEY_LOANSTATUS] intValue])]];
        
        int loanstatus = [[dict objectForKey:NET_KEY_LOANSTATUS] intValue];
        [cell setChoukuanQi:loanstatus !=1];
        
        int loanty = [[dict objectForKey:NET_KEY_LOANTYPE] intValue];
        cell.biaoti.text = [NSString stringWithFormat:@"%@%@", [Util getLoantype:loanty], [dict objectForKey:NET_KEY_LOANTITLE]];
        
        cell.name.text = [Util getUserRealNameOrNickName:dict];
        cell.deadline.text =  [Util shortDateFromFullFormat:[dict objectForKey:NET_KEY_LOANENDTIME]];//@"2015-03-15";
//        cell.remainDays.text = [Util intWithUnit:[[dict objectForKey:NET_KEY_LOANREMAINDAYCOUNT] intValue] unit:@""];//@"18";
    cell.remainDays.attributedText = [Util getRemainDaysString:dict];
        
        cell.lixi.text = [Util percentProgress:[[dict objectForKey:NET_KEY_LOANRATE] doubleValue]];//@"10.00%";
        cell.totalamount.text = [Util formatRMB:@([[dict objectForKey:NET_KEY_LOANMAINVAL] doubleValue])];//:@(50*1e3)];
        cell.percent.text = [Util percentProgress:[[dict objectForKey:NET_KEY_LOANPROGRESS] doubleValue]];// @"25%";
        cell.authpeople.text = [Util intWithUnit:[[dict objectForKey:NET_KEY_WARRANTYCOUNT ] intValue] unit:@"人"];//@"20人";Ø
        
        int loaddaycnt = [[dict objectForKey:NET_KEY_interestdaycount] intValue];
        cell.returnday.text = [Util intWithUnit:loaddaycnt unit:@"天"];//@"2015-12-31";
        
        cell.nameButton.tag = indexPath.section;
        
//        NSString *userid = [dict objectForKey:NET_KEY_USERID];
//        [cell setNameButtonDisabled:[Util isMyUserID:userid]];
//        [cell setNameButtonDisabled:YES];
        
        cell.desc1.hidden = NO;
        cell.desc2.hidden = NO;
        
        int toucnt = [[dict objectForKey:NET_KEY_BETCOUNT] intValue];
        CGFloat touzie = [[dict objectForKey:NET_KEY_LOANMAINVAL] doubleValue];
        CGFloat f6 = [[dict objectForKey:@"nextdebtrepayval"] doubleValue];
        cell.desc1.text = [NSString stringWithFormat:@"%d位投资人，共投本金%@",toucnt, [Util formatRMB:@(touzie)]];
        cell.desc2.text = [NSString stringWithFormat:@"应还金额:%@", [Util formatRMB:@(f6)]];
        cell.desc2.hidden = YES;
        
        return cell;
    }

    else {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.delegate = self;
        return cell;
    }
}
- (void)buttonPressedFromCell {
   CGFloat f6 = [[self.dataDict  objectForKey:@"nextdebtrepayval"] doubleValue];
    
    int failid = [[self.dataDict objectForKey:NET_KEY_failuredrepaymentid] intValue];
    failid = 0;
    if (failid > 0) {
        [self connectToRepayFail:f6 intv:failid];
    }
    else {
    int v = [[self.dataDict objectForKey:NET_KEY_NEXT_DEBT_ID] intValue];
    [self connectTo:f6 intv:v];
        
    }
    
    
}

- (void)setData {

    [Util toastStringOfLocalizedKey:@"tip.repaymentProcessing"];
    [self.delegate huankuanOkDonePressed:self.opRowHere];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loseData {
//    [Util toast:@"正在处理中，返回结果稍后请查看消息提醒。"];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)connectTo:(CGFloat)f intv:(int)v {
    [self.op cancel];
    bugeili_net
    progress_show
    //[self setData];
   self.op = [ZAPP.netEngine huankuanWithComplete:^{[self setData];progress_hide} error:^{[self loseData];progress_hide} value:[NSString stringWithFormat:@"%.2lf", f] debtid:[NSString stringWithFormat:@"%d", v]];
               }

- (void)connectToRepayFail:(CGFloat)f intv:(int)v {
    [self.op cancel];
    bugeili_net
    progress_show
    [self setData]; progress_hide
    //self.op = [ZAPP.netEngine huankuanWithComplete:^{[self setData];progress_hide} error:^{[self loseData];progress_hide} value:[Util formatFloat:@(f)] debtid:[NSString stringWithFormat:@"%d", v]];
}

@end
