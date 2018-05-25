//
//  JiekuanDetailViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "JiekuanPreview.h"
#import "GongtongHaoyouTableViewCell.h"
 
#import "JiekuanInfoViewController.h"
#import "Querentouzi.h"
#import "PersonHomePage.h"
#import "FujianViewController.h"
#import "JiekuanDetailViewController.h"

@interface JiekuanPreview () {
    LoanState _jiekuan_state;
    BOOL _blackList;
}

@property (strong,nonatomic) JiekuanInfoViewController*         jiekuanInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_info_height;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeRed;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGreen;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeBlack;
@property (strong,nonatomic) FujianViewController*       fujian;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fujianH;
@property (weak, nonatomic) IBOutlet UILabel *yongtuLabel;
@property (weak, nonatomic) IBOutlet UILabel *number1;
@property (weak, nonatomic) IBOutlet UILabel *number2;
@property (weak, nonatomic) IBOutlet UILabel *number3;
@property (weak, nonatomic) IBOutlet UILabel *number4;
@property (weak, nonatomic) IBOutlet UILabel *number5;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSDictionary *dataDict;
@end

@implementation JiekuanPreview

- (void)setJiekuanState:(LoanState)state {
    _jiekuan_state = state;
    [self ui];
}
- (IBAction)shouxinbuttonPressed:(UIButton *)sender {
    [Util toast:sender.titleLabel.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    
    [Util setUILabelLargeGray:self.largeGray];
    [Util setUILabelLargeRed:self.largeRed];
    [Util setUILabelLargeGreen:self.largeGreen];
    [Util setUILabelLargeBlack:self.largeBlack];
    
    [self ui];
}

- (NSDictionary *)cvtDictTo:(NSDictionary *)dict {
    [UtilLog dict:dict];
    return @{
             NET_KEY_LOANSTATUS:@(0),
             NET_KEY_LOANTITLE:[dict objectForKey:def_key_fabu_name],
             NET_KEY_USERREALNAME: [ZAPP.myuser getUserRealName],
             NET_KEY_LOANTYPE : [dict objectForKey:def_key_fabu_friend_type],
             NET_KEY_LOANENDTIME: [UtilTimeStamp timestampAfterDays:[[dict objectForKey:def_key_fabu_borrow_day] intValue] ],
             NET_KEY_LOANREMAINDAYCOUNT :[dict objectForKey:def_key_fabu_borrow_day],
             NET_KEY_LOANRATE :[dict objectForKey:def_key_fabu_lixi],
             NET_KEY_LOANMAINVAL: [dict objectForKey:def_key_fabu_money],
             NET_KEY_WARRANTYCOUNT:@([ZAPP.myuser getWarrantyCount]),
             NET_KEY_interestdaycount:@([[dict objectForKey:def_key_fabu_huankuan_day] intValue ]),
             NET_KEY_LOANPROGRESS: @(0),
             def_key_fabu_is_preview: @(1),
             NET_KEY_BLOCKTYPE:@(0)
             };
}

- (void)ui {
    _blackList = NO;
    _jiekuan_state = JieKuan_WaitingNow;
    self.con_info_height.constant = [ZAPP.zdevice getDesignScale:195];
    
    NSDictionary *dict = [ZAPP.myuser fabuGetDataDict];
    [self.jiekuanInfo setTheDataDict:[self cvtDictTo:dict]];
    
   //[self.jiekuanInfo setJiekuanState:_jiekuan_state blacklist:_blackList];
    
    
    self.yongtuLabel.text = [dict objectForKey:def_key_fabu_yongtu];
    
    CGFloat v1 = [[self.dataDict objectForKey:NET_KEY_MAINVAL] doubleValue];
    CGFloat v2 = [[self.dataDict objectForKey:NET_KEY_interestval] doubleValue];
    CGFloat v3 = [[self.dataDict objectForKey:NET_KEY_FEEval] doubleValue];
    CGFloat v4 = [[self.dataDict objectForKey:NET_KEY_ALLOWANCEval] doubleValue];
    self.number1.text = [Util formatRMB:@(v1)];
    self.number2.text = [Util formatRMB:@(v2)];
    self.number3.text = [Util formatRMB:@(v3)];
    self.number4.text = [Util formatRMB:@(v4)];
    self.number5.text = [Util formatRMB:@(v1+v2+v3-v4)];
    
    int fujiancnt = (int)[[ZAPP.myuser fabuFujianArray] count];
    NSDictionary *theee = @{
                            NET_KEY_attachmentcount:@(fujiancnt),
                            NET_KEY_ATTACHMENTS:[ZAPP.myuser fabuFujianArray]
                            };
    self.fujianH.constant = (fujiancnt == 0 ? 0 : 100);
    self.fujian.view.hidden = (fujiancnt == 0) ? YES : NO;
    
    [self.fujian setFujianDict:theee];
    
    [self.view needsUpdateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"预览"];
    [self setTitle:@"预览"];
[self setNavButton];
    
    ZAPP.myuser.fabuCalDict = nil;
    self.dataDict = nil;
    //[self.jiekuanInfo setJiekuanState:_jiekuan_state blacklist:_blackList];
    [self ui];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self ui];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ZAPP.myuser.fabuCalDict = nil;
    self.dataDict = nil;
    
    [self ui];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    if ([ZAPP.zlogin isLogined]) {
        [self rhAppear];
    }
}

- (void)rh {
    [self connectToServer];
}

- (void)rhAppear {
    [self rh];
}

- (void)setData {
    self.dataDict = ZAPP.myuser.fabuCalDict;
    [self ui];
}

- (void)connectToServer {
    [self.op cancel];
    bugeili_net
    progress_show
    self.op = [ZAPP.netEngine loanCalWithComplete:^{[self setData]; progress_hide} error:^{[self setData];progress_hide} ];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"预览"];
    
    [self.op cancel];
    self.op = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)fabuData {

    [Util toast:@"借款已提交审核，我们将会在3个工作日内通知您结果。"];
    JiekuanDetailViewController *detail = ZJKDetail(@"JiekuanDetailViewController");
    [detail setDataDict:ZAPP.myuser.loanFabuSucDetailDict];
    detail.enterFromPreview = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)losefabuData {
}

- (void)loseData {
}

- (void)connectToFabu {
    [self.op cancel];
    bugeili_net
    progress_show
    self.op = [ZAPP.netEngine fabuWithComplete:^{[self fabuData]; progress_hide} error:^{[self losefabuData];progress_hide}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self connectToFabu];
    }
}

- (void)nextButtonPressed {
    //NSString *bi = [ZAPP.myuser fabuGetTitle];
    //NSString *tt = [NSString stringWithFormat:@"确定发布借款项目标题是%@吗？", bi];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tt message:@"一旦发布不可更改" delegate:self cancelButtonTitle:@"返回修改" otherButtonTitles:@"确定", nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.jiekuanPreview", nil) message:@"" delegate:self cancelButtonTitle:@"返回修改" otherButtonTitles:@"确定", nil];
   // //[alert customLayout];
    [alert show];
}

- (void)strokeButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
        ((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = @"确认发布";
    }
    else if ([[segue destinationViewController] isKindOfClass:[StrokeButtonViewController class]]) {
        ((StrokeButtonViewController *)[segue destinationViewController]).delegate = self;
        ((StrokeButtonViewController *)[segue destinationViewController]).titleString = @"返回修改";
    }
    else if ([[segue destinationViewController] isKindOfClass:[JiekuanInfoViewController class]]) {
         self.jiekuanInfo = ((JiekuanInfoViewController*)[segue destinationViewController]);
    }
    else if ([[segue destinationViewController] isKindOfClass:[FujianViewController class]]) {
        self.fujian = ((FujianViewController*)[segue destinationViewController]);
    }
}

@end
