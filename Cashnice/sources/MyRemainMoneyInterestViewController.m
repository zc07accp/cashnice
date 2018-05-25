//
//  MyRemainMoneyInterestViewController.m
//  Cashnice
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyRemainMoneyInterestViewController.h"
#import "MRMC1Cell.h"
#import "MRMC2Cell.h"
#import "MRMC3Cell.h"
#import "RMFundEngine.h"
#import "WebViewController.h"
#import "FSLineChart.h"
#import "SinaWithdrawViewController.h"
#import "SinaRechargeViewController.h"
#import "CustomIOSAlertView.h"
#import "SystemOptionsEngine.h"

@interface MyRemainMoneyInterestViewController ()<CustomIOSAlertViewDelegate>{
    NSDictionary *detailDic;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) RMFundEngine *engine;
@property (nonatomic, strong) FSLineChart *chartWithDates;
@property (strong, nonatomic) SystemOptionsEngine *s_engine;


@end

@implementation MyRemainMoneyInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    progress_show
    
    [Util setScrollHeader:self.tableView target:self header:@selector(fresh) dateKey:[Util getDateKey:self]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    [self fresh];
    
    WS(weakSelf)

    [weakSelf.s_engine getVISASuccess:^{
        
    } failure:^(NSString *error) {
        
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO];
    
    
}


-(RMFundEngine *)engine{
    
    if(!_engine){
        _engine = [[RMFundEngine alloc]init];
    }
    
    return _engine;
}

-(SystemOptionsEngine *)s_engine{
    
    if (!_s_engine) {
        _s_engine = [[SystemOptionsEngine alloc]init];
    }
    return _s_engine;
}


-(void)fresh{
    
    WS(weakSelf)

    bugeili_net_new
    
    [self.engine getDetailSuccess:^(NSDictionary *detail) {
        progress_hide

        [weakSelf updateUI:detail];
    } failure:^(NSString *error) {
        progress_hide
        [self.tableView.header endRefreshing];

    }];
}



- (IBAction)popAc:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)seeHelp:(id)sender {
    
    NSString *httpPrefix = @"";
    if (USESSL) {
        httpPrefix = @"https://";
    }else{
        httpPrefix = @"http://";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", [YQS_SERVER_URL rangeOfString:httpPrefix].location == NSNotFound?httpPrefix:@"", YQS_SERVER_URL, @"balance"];

    
    WebViewController *wvc = [[WebViewController alloc]init];

    wvc.urlStr = url;
    wvc.atitle = @"余额有息说明";
    [ZAPP.tabViewCtrl.selectedViewController pushViewController:wvc animated:YES];
}

-(void)updateUI:(NSDictionary *)detail{

    [self.tableView.header endRefreshing];

    if(self.chartWithDates){
        [self.chartWithDates removeFromSuperview];
        self.chartWithDates = nil;
        
    }
    
    detailDic = detail;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return IPHONE6_ORI_VALUE(286);
    }else if (indexPath.row == 1) {
        return 116;
    }else{
        return 270;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        
        MRMC1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"MRMC1Cell_ID"];
        cell.label2.text = [Util formatRMBWithoutUnit:@([detailDic[@"yesterdayVal"] doubleValue])];
        cell.label3.text = [NSString stringWithFormat:@"累计收益%@", [Util formatRMB:@([detailDic[@"totalVal"]doubleValue])]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else  if(indexPath.row == 1){
        MRMC2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"MRMC2Cell_ID"];
        cell.label1.text = detailDic[@"fund_extreme_income"];
        cell.label2.text =  [Util formatRMBWithoutUnit:@([detailDic[@"accountVal"]doubleValue])];
//        detailDic[@"accountVal"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
        WS(weakSelf)
        cell.TAP = ^(NSInteger index){
            if(index == 0){
                [weakSelf chongzhi];
            }else{
                [weakSelf tixian];
            }
            
        };
 
        
        return cell;
    }else {
        MRMC3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"MRMC3Cell_ID"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (![_chartWithDates superview] && detailDic) {

            [self initFSChart:cell.contentView];
            [cell.contentView bringSubviewToFront:cell.label1];
        }
        
        
        return cell;
    }
}

-(void)tixian{
    
    if ([ZAPP.myuser hasBankCardNumber]) {
        if (![ZAPP.myuser hasMoneyInAccount]) {
            
            [Util toastStringOfLocalizedKey:@"tip.hasMoneyInAccountEmpty"];
            return;
        }
        SinaWithdrawViewController *withdraw = ZSEC(@"SinaWithdrawViewController");
        [self.navigationController pushViewController:withdraw animated:YES];
        //TiXian *chong = ZSEC(@"TiXian");
        //[self.navigationController pushViewController:chong animated:YES];
    }
    else {
        [self showTixianAlertView];
        return;
    }
}

-(void)chongzhi{
    
#ifdef TEST_CHONGZHI_PAGE
    Chongzhi *c = ZSEC(@"Chongzhi");
    c.delegate = self.delegate;
    c.level = 1;
    [self.navigationController pushViewController:c animated:YES];
    return;
#endif
    
    
    if ([ZAPP.myuser hasBankBinded]) {                   //if ([ZAPP.myuser hasDefaultBank]) {
        // 选择银行卡
        //BankChoose *e = ZSEC(@"BankChoose");
        //[self.navigationController pushViewController:e animated:YES];
        SinaRechargeViewController *recharge = ZSEC(@"SinaRechargeViewController");
        [self.navigationController pushViewController:recharge animated:YES];
    }
    else {
        [self showChongzhiAlertView];
        return;
    }
}


//体现的提示
- (void)showTixianAlertView{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithMessage:CNLocalizedString(@"alert.message.tixianViewController", nil) closeDelegate:self buttonTitles:@[@"去绑定", @"取消"]];
    alertView.tag = 0;
    [alertView show];
    [alertView formatAlertButton];
    
}

//充值的提示
- (void)showChongzhiAlertView{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithMessage:CNLocalizedString(@"alert.message.chongzhiViewController", nil) closeDelegate:self buttonTitles:@[@"去绑定", @"取消"]];
    alertView.tag = 0;
    [alertView show];
    [alertView formatAlertButton];
    
}

- (void)customIOS7dialogButtonTouchUpInside:(CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 1) {
        if (alertView.tag == 0) {
            //绑定银行卡
            [self.navigationController pushViewController:[MeRouter UserBindBankViewController] animated:YES];
        }
    }
    [alertView close];
}

-(void)initFSChart:(UIView *)superView{

    //折线图。
    _chartWithDates = [[FSLineChart alloc]initWithFrame:CGRectMake(35, 50, MainScreenWidth-70, 160)];
    [superView addSubview:_chartWithDates];
    
    
    NSMutableArray* chartData = [NSMutableArray array];
    NSMutableArray* months = [NSMutableArray array];

    for (NSDictionary *dic in detailDic[@"fund_list"]) {
        [chartData addObject:@([dic[@"fund_average_rate"] doubleValue])];
        [months addObject:dic[@"fund_date_time"]];
    }
    
    UIColor *lastGradientColor = HexRGB(0xf74a28);
    
    // Setting up the line chart
    _chartWithDates.verticalGridStep = 5;
    _chartWithDates.horizontalGridStep = 6;
    _chartWithDates.fillColor = nil;
    _chartWithDates.valueLabelTextColor = CN_TEXT_GRAY_9;
    _chartWithDates.displayDataPoint = YES;
    _chartWithDates.dataPointColor = lastGradientColor;
    _chartWithDates.dataPointBackgroundColor = lastGradientColor;
    _chartWithDates.axisColor = HexRGB(0xcccccc);
    _chartWithDates.dataPointRadius = 5;
    _chartWithDates.color = [UIColor redColor]; //just test
    
    //设置渐变色，如果没有设置的话，就没有渐变效果
    _chartWithDates.gradientColors = @[HexRGB(0xffa902),lastGradientColor];

    _chartWithDates.valueLabelPosition = ValueLabelLeft;
    
    _chartWithDates.labelForIndex = ^(NSUInteger item) {
        return months[item];
    };
    
    
    _chartWithDates.DataPointShow = ^(NSInteger index){
        
        if (index == chartData.count-1) {
            return YES;
        }
        return NO;
    };
    
    _chartWithDates.bezierSmoothing = NO;
    
    _chartWithDates.labelForValue = ^(CGFloat value, NSUInteger index) {
        
//        NSLog(@"labelForValue = %.2f index=%lu", value, (unsigned long)index);
        return [NSString stringWithFormat:@"%.3f", value];
//        return @"test";
    };
    
    [_chartWithDates setChartData:chartData];
    
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
