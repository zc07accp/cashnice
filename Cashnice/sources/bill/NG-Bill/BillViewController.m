
//  BillViewController.m
//  YQS
//
//  Created by a on 16/1/31.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillViewController.h"
#import "BillNTableViewCell.h"
#import "BillDetailViewController.h"
#import "BLSelView.h"
#import "FilterBillViewController.h"
#import "CustomViewController+PickDate.h"
#import "BillHeaderCell.h"
#import "MoneyFormatViewModel.h"
#import "BillNetEngine.h"


@interface BillViewController ()<UITableViewDataSource, UITableViewDelegate,BLSelViewDelegate,FilterBillViewControllerDelegate,UITextFieldDelegate,BillHeaderCellDelegate>
{
    NSInteger rowCnt;
    int     curPage;
    int     pageCount;
    int     totalCount;
 
    NSInteger bill_type; //|bill_type|int|账单类型0：全部；1：充值；2：提现；3：收益；4：还款；5：收回；6：投资|
    
    BOOL selStartDateField;    
}

//@property (strong, nonatomic)UIDatePicker *datePicker;
@property (strong, nonatomic) MKNetworkOperation * op;
@property (strong, nonatomic) NSMutableArray *     dataArray;

@property (strong, nonatomic)NSDateFormatter *dateFormatter;
@property (strong, nonatomic)NSCalendar  *calendar;

@property (strong, nonatomic)UIControl  *overlayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
//@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) NSAttributedString *balanceAttStr;

//@property (weak, nonatomic) IBOutlet UILabel *accumulatedLabel;
//@property (weak, nonatomic) IBOutlet UILabel *balancePromptLabel;
//@property (weak, nonatomic) IBOutlet UILabel *accumPromptLabel;
@property (strong, nonatomic) NSAttributedString *accumPromptAttStr;

//@property (weak, nonatomic) IBOutlet UITextField *startTextField;
//@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@property (strong,nonatomic) NSString *startText;
@property (strong,nonatomic) NSString *endText;


@property (weak, nonatomic) IBOutlet UILabel *unitLabel1;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *startPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPromptLabel;

@property (strong, nonatomic) UILabel *vLable;

@property (strong, nonatomic) UIView *containView;
@property (strong, nonatomic) BLSelView *blSelView;
@property (strong, nonatomic) FilterBillViewController  *filervc;
@property (strong,nonatomic) BillNetEngine *engine;


@end

@implementation BillViewController

static const float kTableHeaderHight = 179;

BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的账单";
    [self setNavButton];
    
    [self setupUI];
    curPage                       = 0;
    pageCount                     = 1;
    totalCount                    = 0;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rhManual) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
    
    //设置TableView
    [self setupTableView];
    
    [self rhManual];
 }
 
// FIXME:

- (void)viewWillAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleKeyboardDidShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleKeyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    [super viewWillAppear:animated];
    
    [self setTitleSelView];

}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
    
    [self.blSelView removeFromSuperview];
    self.blSelView = nil;
}

-(UIView *)containView{
    
    if (!_containView) {
        _containView = [UIView new];
        _containView.backgroundColor = [UIColor clearColor];
    }
    
    return _containView;
}



-(BillNetEngine *)engine{
    
    if(!_engine){
        _engine = [[BillNetEngine alloc]init];
    }
    
    return _engine;
}


-(BLSelView *)blSelView{
    
    if (!_blSelView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BLSelView" owner:self options:nil];
        _blSelView  = nib[0];
        _blSelView.delegate = self;

        _blSelView.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
        _blSelView.left= ( MainScreenWidth - _blSelView.width)/2;
    }
    
    return _blSelView;
}


-(FilterBillViewController *)filervc{
    
    if (!_filervc) {
        _filervc = [[FilterBillViewController alloc]init];
        
        _filervc = MBDSTORY(@"FilterBillViewController");
//        [self addChildViewController:_filervc];
        [self.containView addSubview:_filervc.view];
        _filervc.view.frame = self.containView.bounds;
        _filervc.delegate = self;
//        [_filervc didMoveToParentViewController:self];
        
    }
    
    return _filervc;
}


-(void)requestList{
    
    progress_show
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [para setObject:@(curPage) forKey:NET_KEY_PAGENUM];
    [para setObject:@(DEFAULT_PAGE_SIZE) forKey:NET_KEY_PAGESIZE];
    [para setObject:[self transformDateToServiceFormat:self.startText] forKey:@"begindate"];
    [para setObject:[self transformDateToServiceFormat:self.endText] forKey:@"enddate"];
    [para setObject:@(bill_type) forKey:@"bill_type"];
    
    
    WS(ws);
    
    [self.engine getBillList:para success:^(NSDictionary *dic) {
        
        progress_hide
        
        if (dic) {
            [ws updateUI:dic];
        }else{
            //resp为空，走list
            DDLogError(@"detail nil");
        }
        
        
        
    } failure:^(NSString *error) {
        progress_hide
        
    }];
}


-(void)updateUI:(NSDictionary *)dic{
    
    pageCount  = [Util pageCount:dic];
    totalCount = [Util totalCount:dic];
    
    self.tableView.footer.hidden     = ((curPage + 1) >= pageCount);
    //

    NSArray *billArray = dic[@"data"];
 
    MoneyFormatViewModel *m = [MoneyFormatViewModel viewModelFrom:3];
    m.originalMoneyNum = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL];
    _balanceAttStr = m.reformedMoneyStr;
    
    m.originalMoneyNum = @([dic[@"accumulated"] doubleValue]);
    _accumPromptAttStr = m.reformedMoneyStr;
    
    if (curPage <= 1) {
        [self.dataArray removeAllObjects];
    }
    
    NSInteger cnt = billArray.count;//[[dict objectForKey:NET_KEY_billcount] intValue];
    if (cnt > 0) {
        //[self.dataArray insertPage:curPage objects:billArray];
        [self.dataArray addObjectsFromArray:billArray];
    }
    
    rowCnt = [self.dataArray count];
    
    if (! totalCount) {
        self.vLable.hidden = NO;
    }else{
        self.vLable.hidden = YES;
    }
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    [self.tableView reloadData];

    
}

#pragma mark - BillHeaderCellDelegate

-(void)didSelTextField:(BOOL)aselStartDateField date:(NSDate *)date{

    selStartDateField = aselStartDateField;
    [self openDatePicker:date];

}

-(void)didBeginSearch{
    
    [self hideKeyboard];

    
    /*
    //检查3个月跨度
    NSDate *start = [self.dateFormatter dateFromString:self.startText];
    NSDate *end   = [self.dateFormatter dateFromString:self.endText];

    NSTimeInterval interval = 93 * 24 * 3600; //93天
    if ([end timeIntervalSinceDate:start] > interval) {
        
        [Util toastStringOfLocalizedKey:@"tip.queryDateTime"];
        return;
    }
     */
    
    [self rhManual];
    
}


-(void)setTitleSelView{
    [self.navigationController.navigationBar addSubview:self.blSelView];
}


#pragma mark - BLSelViewDelegate
-(void)arrawStateDidChanged:(BLSelView *)view{
    
//    return;
    
    if (!_containView) {
       
   
        self.blSelView.opened = YES;

        [self.view addSubview:self.containView];
        
        UIView *superView = self.view;
        [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.top.equalTo(self.mas_topLayoutGuideBottom);
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        }];

         [self filervc];
         
    }else{
        
        if (self.containView.hidden) {
            self.containView.hidden = NO;
            self.blSelView.opened = YES;
        }else{
            self.blSelView.opened = NO;
            self.containView.hidden = YES;
        }
        
    }
 
}

-(void)filterBillDidSelected:(NSString *)fiterTitle tag:(NSInteger)tag{
    DDLogDebug(@"fiterTitle = %@", fiterTitle);
    
    bill_type = tag;


    self.blSelView.opened = NO;
    self.containView.hidden = YES;

    [self rhManual];
}

-(void)filterBillDidTapClose{
    
    
    self.blSelView.opened = NO;
    self.containView.hidden = YES;
    
}


- (void)setupUI{
    
    self.tableView.backgroundColor = ZCOLOR(COLOR_BG_WHITE);
    
    NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    [components setMonth:[components month] -1];
    
    NSDate *startDate = [self.calendar dateFromComponents:components];
//    self.startTextField.text = [self.dateFormatter stringFromDate:startDate];
    self.startText =  [self.dateFormatter stringFromDate:startDate];
    
    
    NSDate *endDate = [NSDate date];
//    self.endTextField.text = [self.dateFormatter stringFromDate:endDate];
    self.endText =  [self.dateFormatter stringFromDate:endDate];

    
//    self.balanceLabel.font = self.accumulatedLabel.font = [UtilFont systemNormal:20];
//    self.unitLabel1.font = self.unitLabel2.font = [UtilFont system:18];
//    self.balancePromptLabel.font =
//    self.accumPromptLabel.font = [UtilFont systemSmall];
    
    self.headerHeightConstraint.constant = [ZAPP.zdevice getDesignScale:80];
    
    _startPromptLabel.font = [UtilFont systemLarge];
    _endPromptLabel.font = [UtilFont systemLarge];
}


/*
- (void)setData{
    //curPage    = [Util curPage:ZAPP.myuser.billDict];
    pageCount  = [Util pageCount:ZAPP.myuser.billDict];
    totalCount = [Util totalCount:ZAPP.myuser.billDict];
    
    self.tableView.footer.hidden     = ((curPage + 1) >= pageCount);
//    
    NSDictionary *dict = ZAPP.myuser.billDict;
    NSArray *billArray = dict[@"data"];
//
//    CGFloat balance = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];
//    self.balanceLabel.text = [Util formatRMBWithoutUnit:[NSNumber numberWithDouble:balance]]; //dict[@"balance"];
//    self.accumulatedLabel.text = [NSString stringWithFormat:@"%@", dict[@"accumulated"]]; //@"unkonw";//
    
    MoneyFormatViewModel *m = [MoneyFormatViewModel viewModelFrom:3];
    m.originalMoneyNum = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL];
    _balanceAttStr = m.reformedMoneyStr;
    
    m.originalMoneyNum = @([dict[@"accumulated"] doubleValue]);
    _accumPromptAttStr = m.reformedMoneyStr;
    
    if (curPage <= 1) {
        [self.dataArray removeAllObjects];
    }
    
    NSInteger cnt = billArray.count;//[[dict objectForKey:NET_KEY_billcount] intValue];
    if (cnt > 0) {
        //[self.dataArray insertPage:curPage objects:billArray];
        [self.dataArray addObjectsFromArray:billArray];
    }
    
    rowCnt = [self.dataArray count];
    
    if (! totalCount) {
        self.vLable.hidden = NO;
    }else{
        self.vLable.hidden = YES;
    }
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    [self.tableView reloadData];
}

- (void)loseData{
    
}
*/

#pragma mark - Event Action Method

//- (IBAction)searchAction:(id)sender {
//    
//    [self hideKeyboard];
//    
//    //检查3个月跨度
//    NSDate *start = [self.dateFormatter dateFromString:self.startTextField.text];
//    NSDate *end   = [self.dateFormatter dateFromString:self.endTextField.text];
//    /*
//    NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:start];
//    [components setMonth:[components month] + 3];
//    NSDate *threeMonthAfterOfStart = [self.calendar dateFromComponents:components];
//    if ([threeMonthAfterOfStart compare:end]) {
//        //超过3个月
//    }
//    */
//    NSTimeInterval interval = 93 * 24 * 3600; //93天
//    if ([end timeIntervalSinceDate:start] > interval) {
//
//        [Util toastStringOfLocalizedKey:@"tip.queryDateTime"];
//        return;
//    }
//    
//    [self rhManual];
//}


//
//- (void)datePicked:(id)sender {
//    if ([self.startTextField isFirstResponder]) {
//        self.startTextField.text = [self.dateFormatter stringFromDate:[self.datePicker date]];
//    }
//    if ([self.endTextField isFirstResponder]) {
//        self.endTextField.text = [self.dateFormatter stringFromDate:[self.datePicker date]];
//    }
//}

//确定操作，子类重写
-(void)datePickerDidSure{
    
    if (selStartDateField) {
        self.startText = [self.dateFormatter stringFromDate:self.showDate];
    }else{
        self.endText = [self.dateFormatter stringFromDate:self.showDate];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)setupTableView{
    //[_tableView setBounces:NO];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)rhManual {
    curPage = 1;
//    [self connectToServer];
    [self requestList];
}

- (void)rf {
    curPage++;
    [self requestList];
//    [self connectToServer];
}

//- (void)handleKeyboardDidShow:(NSNotification *)notification {
//    
//    self.overlayView.hidden = NO;
//    [UIView animateWithDuration:0.55 animations:^{
//        self.overlayView.alpha = .3f;
//    } completion:^(BOOL finished) {
//        ;
//    }];
//    
//    
//    if ([self.startTextField isFirstResponder]) {
//        self.datePicker.date = [self.dateFormatter dateFromString:_startTextField.text];
//    }
//    if ([self.endTextField isFirstResponder]) {
//        self.datePicker.date = [self.dateFormatter dateFromString:_endTextField.text];
//    }
//}
//
//- (void)handleKeyboardWillHide:(NSNotification *)notification {
//    [UIView animateWithDuration:0.55 animations:^{
//        self.overlayView.alpha = .0f;
//    } completion:^(BOOL finished) {
//        self.overlayView.hidden = YES;
//    }];
//}

- (NSString *)transformDateToServiceFormat:(NSString *)dateString {
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-dd"];
    return [f stringFromDate:date];
}

/*
- (void)connectToServer {
    [self.op cancel];
    
    bugeili_net_new
    progress_show
    
    __weak __typeof__(self) weakSelf = self;
    
    
    self.op = [ZAPP.netEngine getBillNGWithComplete:^{
        progress_hide
        [weakSelf setData];
    } error:^{
        progress_hide
        [weakSelf loseData];
    } page:curPage pagesize:DEFAULT_PAGE_SIZE begin:[self transformDateToServiceFormat:self.startText]
                            end:[self transformDateToServiceFormat:self.endText] bill_type:bill_type];

}
*/

#pragma mark - TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return rowCnt;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //2.0.0.0.0.0.0.0.0.0.0.0.0.0
    //return (section == 0 ?[ZAPP.zdevice getDesignScale : 15] : 0);
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (BOOL)lastRow:(NSInteger)row {
    return row == rowCnt - 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return kTableHeaderHight;
    }
    
    return 60.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor        = ZCOLOR(COLOR_BG_GRAY);
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
        static NSString *  CellIdentifier = @"BillHeaderCell";
        BillHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier
                               :CellIdentifier];

        cell.balanceLabel.attributedText = _balanceAttStr;
        cell.accumulatedLabel.attributedText = _accumPromptAttStr;

        cell.startTextField.text = self.startText;
        cell.endTextField.text = self.endText;
        cell.delegate = self;
        return cell;
    }
    
    BillNTableViewCell *cell;
    static NSString *  CellIdentifier = @"BillNTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
      /*|time|String|交易时间|
        |accrual|String|收支|
        |balance|String|余额|
        |type|String|交易类型|
      */
    cell.timeLabel.text = dict[@"time"];
    cell.accrualLabe.text = dict[@"accrual"];
    cell.balanceLabel.text = dict[@"balance"];
    cell.typeLabel.text = dict[@"type"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideKeyboard];
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[MeRouter commonPushedBillViewController:dict] animated:YES];

}

- (IBAction)backgroundTouched:(id)sender {
    [self hideKeyboard ];
}

- (void)hideKeyboard {
//    [self.startTextField resignFirstResponder];
//    [self.endTextField resignFirstResponder];
}
#pragma mark - Getter and Setter Method

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSDateFormatter *)dateFormatter{
    if (! _dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    return _dateFormatter;
}

- (NSCalendar *)calendar{
    if (! _calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}
//
//- (UIDatePicker *)datePicker{
//    if (! _datePicker) {
//        _datePicker = [[UIDatePicker alloc] init];
//        _datePicker.datePickerMode = UIDatePickerModeDate;
//        _datePicker.backgroundColor = [UIColor whiteColor];
//        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//        [_datePicker addTarget:self action:@selector(datePicked:) forControlEvents:UIControlEventValueChanged];
//    }
//    return _datePicker;
//}

- (UIControl *)overlayView{
    if (! _overlayView) {
        UIWindow *window = [ZAPP window];
        _overlayView = [[UIControl alloc] initWithFrame:window.bounds];
        _overlayView.backgroundColor = [UIColor blackColor];
        [_overlayView addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchDown];
        _overlayView.alpha = 0.0f;
        _overlayView.hidden = YES;
        [window addSubview:_overlayView];
    }
    return _overlayView;
}

- (UILabel *)vLable{
    if (! _vLable) {
        _vLable = [[UILabel alloc] initWithFrame:self.view.bounds];
        _vLable.top = kTableHeaderHight;
        _vLable.height = (self.view.height - kTableHeaderHight)/2;
        _vLable.textAlignment = NSTextAlignmentCenter;
        _vLable.font = [UIFont systemFontOfSize:20.0f];
        _vLable.textColor = ZCOLOR(@"#555555");
        _vLable.text = @"暂无数据";
        _vLable.hidden = YES;
        [self.tableView addSubview:_vLable];
    }
    return  _vLable;
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
