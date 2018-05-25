//
//  JiekuanInfoViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "JiekuanInfoViewController.h"
#import "SliderPercentViewController.h"
#import "PersonHomePage.h"

@interface JiekuanInfoViewController () {
    LoanState _state;
    BOOL _blackList;
}
@property (weak, nonatomic) IBOutlet UILabel *biaoti;

@property (weak, nonatomic) IBOutlet UIView *statebgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ligthGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeRed;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *gray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *red;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *deadline;
@property (weak, nonatomic) IBOutlet UILabel *t1;
@property (weak, nonatomic) IBOutlet UILabel *t2;
@property (weak, nonatomic) IBOutlet UILabel *t3;
@property (weak, nonatomic) IBOutlet UILabel *remainDays;
@property (weak, nonatomic) IBOutlet UILabel *lixi;
@property (weak, nonatomic) IBOutlet UILabel *totalamount;
@property (weak, nonatomic) IBOutlet UILabel *authpeople;
@property (weak, nonatomic) IBOutlet UILabel *returnday;
@property (strong,  nonatomic) SliderPercentViewController *slider;
@property (weak, nonatomic) IBOutlet UIView *blackListBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_blackListHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_progressHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_content_width;
@property (weak, nonatomic) IBOutlet UILabel *blackListLabel;
@property (weak, nonatomic) IBOutlet UILabel *yijie;
@property (weak, nonatomic) IBOutlet UILabel *jikuanzonge;
@property (weak, nonatomic) IBOutlet UILabel *jikuanzonge2;
@property (weak, nonatomic) IBOutlet UIView *stat1;
@property (weak, nonatomic) IBOutlet UIView *stat2;
@property (weak, nonatomic) IBOutlet UILabel *danhao;
@property (weak, nonatomic) IBOutlet UILabel *betcount;
@property (weak, nonatomic) IBOutlet UILabel *jiekuanren;
@property (weak, nonatomic) IBOutlet UIButton *personButton;

@property (strong, nonatomic) NSDictionary *dataDict;
@property (strong, nonatomic) MKNetworkOperation *op;
@end

@implementation JiekuanInfoViewController
- (IBAction)personPressed:(id)sender {
    [self connectToServer];
}

- (void)setTheNameButtonDisabled:(BOOL)dis {
    dis = NO;
    self.personButton.enabled = !dis;
}

- (void)setData {
    PersonHomePage *person = DQC(@"PersonHomePage");
    [person setTheDataDict:ZAPP.myuser.personInfoDict];
    [self.navigationController pushViewController:person animated:YES];
}

- (void)loseData {
//    [Util toast:@"服务器暂时不可用"];
    [Util toastStringOfLocalizedKey:@""];
}

- (void)connectToServer {
    [self.op cancel];
    bugeili_net
    NSString *userid = [self.dataDict objectForKey:NET_KEY_USERID];
    if ([userid notEmpty]) {
        progress_show
        __weak __typeof__(self) weakSelf = self;

        self.op = [ZAPP.netEngine getUserInfoWithComplete:^{[weakSelf setData]; progress_hide } error:^{[weakSelf loseData];progress_hide} userid:userid];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.op cancel];
    self.op = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.con_content_width.constant = [ZAPP.zdevice getDesignScale:390];
    
    self.biaoti.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.biaoti.font = [UtilFont systemLargeBold];
    
    self.statebgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:2];
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.font = [UtilFont systemLarge];
    
    self.blackListBgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5];
    self.blackListBgView.backgroundColor = [DefColor colorWithRed:252 green:253 blue:195];
    
    for (UILabel *l in self.ligthGray) {
        l.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
        l.font = [UtilFont systemLarge];
//        l.font = [UtilFont systemSmall];
    }
    
    for (UILabel *l in self.gray) {
        l.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        l.font = [UtilFont systemLarge];
    }
    
    for (UILabel *l in self.red) {
        l.textColor = ZCOLOR(COLOR_BUTTON_RED);
        l.font = [UtilFont systemLarge];
    }
    for (UILabel *l in self.largeRed) {
        l.textColor = ZCOLOR(COLOR_BUTTON_RED);
        l.font = [UtilFont systemLarge];
    }
    for (UILabel *l in self.largeGray) {
        l.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        l.font = [UtilFont systemLarge];
    }
    
    for (UILabel *l in self.choukuanqi) {
        l.font = [UtilFont systemSmall];
    }
    
    self.personButton.titleLabel.font = [UtilFont systemLarge];
    [self.personButton setTitleColor:ZCOLOR(COLOR_BUTTON_BLUE) forState:UIControlStateNormal];
    [self.personButton setTitleColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY) forState:UIControlStateDisabled];
    [self updateJiekuanState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateJiekuanState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateJiekuanState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTheDataDict:(NSDictionary *)dict {
    self.dataDict = dict;
    [self updateJiekuanState];
}

- (void)setChoukuanQi:(BOOL)dis {
    for (UILabel *l in self.choukuanqi) {
        l.hidden = dis;
    }
}

- (void)updateJiekuanState {
    if (self.dataDict != nil) {
        BOOL isPreview = [[self.dataDict objectForKey:def_key_fabu_is_preview] intValue] == 1;
        self.con_progressHeight.constant = [ZAPP.zdevice getDesignScale:isPreview ? 50 : 105];
        self.stat1.hidden = isPreview;
        self.stat2.hidden = !isPreview;
        _state = [UtilString cvtIntToJiekuanState:[[self.dataDict objectForKey:NET_KEY_LOANSTATUS] intValue]];
        
        self.statebgView.backgroundColor = [UtilString bgColorJiekuanState:_state];
        self.stateLabel.text = [UtilString getJiekuanState:_state];
        
        BOOL hideInfo = _state != JieKuan_GoingNow;
        self.t1.hidden = hideInfo;
        self.t2.hidden = hideInfo;
        self.t3.hidden = hideInfo;
        self.deadline.hidden = hideInfo;
        self.remainDays.hidden = hideInfo;
        
        int loanstatus = [[self.dataDict objectForKey:NET_KEY_LOANSTATUS] intValue];
        [self setChoukuanQi:loanstatus!=1];
        //self.biaoti.text = [self.dataDict objectForKey:NET_KEY_LOANTITLE];
        int loanty = [[self.dataDict objectForKey:NET_KEY_LOANTYPE] intValue];
        self.biaoti.text = [NSString stringWithFormat:@"%@%@", [Util getLoantype:loanty], [self.dataDict objectForKey:NET_KEY_LOANTITLE]];
        
        BOOL shouldHideName = [Util loanShouldHideNameWithDict:self.dataDict];
        if (isPreview) {
            self.name.alpha = 1;
            self.personButton.hidden = YES;
        }
        else {
        self.name.hidden = shouldHideName;
        self.personButton.hidden = shouldHideName;
        self.jiekuanren.hidden = shouldHideName;
            
        }
        
//        /**
//         *  我授信的借款，进入后隐藏借款人名称
//         *  This is deprecated2
//         */
//        if (self.hideNameAlways) {
//            self.name.hidden = YES;
//            self.personButton.hidden = YES;
//            self.jiekuanren.hidden = YES;
//            
//            if ([Util loanIsWeiYue:self.dataDict]) {
//                self.name.hidden = NO;
//                self.personButton.hidden = NO;
//                self.jiekuanren.hidden = NO;
//            }
//
//        }
        
#ifdef TEST_SHOW_ALL_NAME
        self.name.hidden = NO;
        self.personButton.hidden = NO;
        self.jiekuanren.hidden = NO;
#endif
        
        self.name.text = [Util getUserRealNameOrNickName:self.dataDict];
        if (self.name.text == nil) {
            self.name.text = @"";
        }
        

        [self.personButton setTitle:self.name.text forState:UIControlStateNormal];
        
        
        self.deadline.text =  [Util shortDateFromFullFormat:[self.dataDict objectForKey:NET_KEY_LOANENDTIME]];///@"2015-03-15";
//        self.remainDays.text = [Util intWithUnit:[[self.dataDict objectForKey:NET_KEY_LOANREMAINDAYCOUNT] intValue] unit:@""];//@"18";
    self.remainDays.attributedText = [Util getDetailRemainDaysString:self.dataDict];
        
        self.lixi.text = [Util percentProgress:[[self.dataDict objectForKey:NET_KEY_LOANRATE] doubleValue]];//@"10.00%";
        self.totalamount.text = [Util formatRMB:@([[self.dataDict objectForKey:NET_KEY_LOANMAINVAL] doubleValue])];//:@(50*1e3)];
        self.authpeople.text = [Util intWithUnit:[[self.dataDict objectForKey:NET_KEY_WARRANTYCOUNT ] intValue] unit:@"人"];//@"20人";Ø
        int loaddaycnt = [[self.dataDict objectForKey:NET_KEY_interestdaycount] intValue];
        self.returnday.text = [Util intWithUnit:loaddaycnt unit:@"天"];//@"2015-12-31";
        
        [self.slider setPercentFloat:[[self.dataDict objectForKey:NET_KEY_LOANPROGRESS] doubleValue]];
        
        self.yijie.text = [Util formatRMB:@([[self.dataDict objectForKey:NET_KEY_LOANEDMAINVAL] doubleValue])];
        self.jikuanzonge.text = [Util formatRMB:@([[self.dataDict objectForKey:NET_KEY_LOANMAINVAL] doubleValue])];
        self.jikuanzonge2.text = [Util formatRMB:@([[self.dataDict objectForKey:NET_KEY_LOANMAINVAL] doubleValue])];
        self.danhao.text = [self.dataDict objectForKey:NET_KEY_LOANORDERNO];
        self.betcount.text = [Util intWithUnit:[[self.dataDict objectForKey:NET_KEY_BETCOUNT] intValue] unit:@""];
        
       int blocktype = [[self.dataDict objectForKey:NET_KEY_BLOCKTYPE] intValue];
        _blackList = [Util isBlocked:blocktype];
        if (_blackList) {
            NSString *thename = self.name.text;
            NSString *thestr = [NSString stringWithFormat:@"借款人：%@，因拖欠还款被系统加入黑名单，正", thename];
            NSMutableAttributedString *attr = [Util getAttributedString:thestr font:[UtilFont systemLarge] color:ZCOLOR(COLOR_TEXT_GRAY)];
            [Util setAttributedString:attr font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:[thestr rangeOfString:thename]];
            
            if (shouldHideName) {
                thestr = @"借款人因拖欠还款被系统加入黑名单，正";
                attr = [Util getAttributedString:thestr font:[UtilFont systemLarge] color:ZCOLOR(COLOR_TEXT_GRAY)];
            }
            self.blackListLabel.attributedText = attr;
        }
        
        self.con_blackListHeight.constant = _blackList ?  [ZAPP.zdevice getDesignScale: 70] : 0;
        
        [self setTheNameButtonDisabled:[Util isMyUserID:[self.dataDict objectForKey:NET_KEY_USERID]]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[SliderPercentViewController class]]) {
        self.slider = ((SliderPercentViewController *)[segue destinationViewController]);
    }
}

- (void)setJiekuanState:(LoanState)state blacklist:(BOOL)hasBlackList {
    [UtilLog string:@"set jiekuan state, this is a placeholder"];
}
@end
