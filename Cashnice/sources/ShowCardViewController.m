//
//  ShowCardViewController.m
//  YQS
//
//  Created by a on 16/4/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ShowCardViewController.h"
#import "CustomIOSAlertView.h"
#import "TiXian.h"
#import "BindBank3.h"
#import "BindBank2.h"
#import "CustomTitledAlertView.h"

@interface ShowCardViewController () <CustomIOSAlertViewDelegate, BindBank3Delegate>
{
    CustomIOSAlertView *autoCloseAlertView ;
    NSTimer            *autoCloseAlertTimer;
    NSUInteger         autoCloseAlertInterval;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scollView;
@property (weak, nonatomic) IBOutlet UIControl *backView;

@property (weak, nonatomic) IBOutlet UITextField *cardInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeProcessLabel;

@property (weak, nonatomic) IBOutlet UILabel *onceLimitPrompt;
@property (weak, nonatomic) IBOutlet UILabel *dailyLimitPrompt;
@property (weak, nonatomic) IBOutlet UILabel *onceLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyLimitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *toAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *continueBindButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toAddViewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UITextField *toAddPrompt;
@property (weak, nonatomic) IBOutlet UIButton *toAddButton;
@property (weak, nonatomic) IBOutlet UIButton *unbindButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong, nonnull) UIBarButtonItem *rightNavBarButtonItem;

@property (nonatomic, strong) NSDictionary *cardInfo;

@end

@implementation ShowCardViewController

//BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    self.backView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"银行卡"];
    
    [self showView];
    [self connectToServer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"银行卡"];
}

- (void)connectToServer {
    bugeili_net
    progress_show
    [ZAPP.netEngine api2_getBankcardListWithComplete:^{
        progress_hide
        
        [self.scollView.header endRefreshing];
        [self showView];
        
    } error:^{
        
        [self.scollView.header endRefreshing];
        [self showView];
        progress_hide
    }];
}

- (void)showView{
    
    [self setupNavBar];
    
    if (self.cardInfo) {
        [self showCardView];
        
        NSString *bankname = self.cardInfo[@"bankname"];
        NSString *visacode = self.cardInfo[@"visacode"];
        NSString *bankLogoUrl = self.cardInfo[@"bankimg"];
        
        NSInteger onceLimit = [self.cardInfo[@"qpaylimitvaleverytrans"] integerValue];
        NSInteger dailyLimit = [self.cardInfo[@"qpaylimitvaleveryday"] integerValue];
        [self.bankLogoImageView setImageFromURL:[NSURL URLWithString:bankLogoUrl]];
        self.cardInfoLabel.text =[NSString stringWithFormat:@"%@  %@", bankname, visacode];
        
        self.onceLimitLabel.text = [Util formatRMB:@(onceLimit)];
        self.dailyLimitLabel.text = [Util formatRMB:@(dailyLimit)];
        
        NSInteger visastatus = [self.cardInfo[@"visastatus"] integerValue];
        
        self.continueBindButton.hidden = (visastatus >= 2);
        self.activeProcessLabel.hidden = (visastatus != 3);
    }else{
        [self showAddView];
    }
}
//银行账号加空格
- (NSString *) formatVisaCode:(NSString *)visacode {
    
    NSMutableString *formatedCode = [NSMutableString new];
    for (int i = 0; i<visacode.length; i++) {
        char c = [visacode characterAtIndex:i];
        if ((i+1) % 4 == 0) {
            [formatedCode appendFormat:@"%c ", c];
        }else{
            [formatedCode appendFormat:@"%c", c];
        }
    }
    return formatedCode;
}

- (IBAction)unbind:(id)sender {
    [self unbindBankcard];
}

/////  重新  发送激活验证码   /////
- (void)resendValidationCode {
    bugeili_net
    progress_show
    [ZAPP.netEngine requestVisaActiveValidateCodeComplete:^{
        [ZAPP.zvalidation sucSend];
        [ZAPP.zvalidation startTimer];
        progress_hide
    } error:^{
        progress_hide
    }];
}

- (IBAction)toAddAction:(id)sender {
    
//#ifdef TEST_BIND_BANK_STEPS
//    BindBank2 *bindBank2          = ZSTORY(@"BindBank2");
//    bindBank2.hasId = NO;
//    bindBank2.orderno  = @"222";
//        bindBank2.delegate = self;
//        bindBank2.phone = [self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//        bindBank2.card = self.inputedCardNo;
//    [self.navigationController pushViewController:bindBank2 animated:YES];
//    return;
//#endif
    
//#ifdef TEST_BIND_BANK_STEPS
//    BindBank3 *cz = ZSTORY(@"BindBank3");
//    cz.hasId = YES;
//    cz.phone = @"18264153825";
//    cz.card = @"333333";
//    cz.delegate = self;
//    [self.navigationController pushViewController:cz animated:YES];
//    return;
//#endif
    
    
    extern  NSString *fillingBankInfoPhoneNumber;
    fillingBankInfoPhoneNumber = nil;
    
    [self.navigationController pushViewController:[MeRouter UserBindBankViewController] animated:YES];
}


- (IBAction)continuousBindingAction:(id)sender {
    NSInteger visastatus = [self.cardInfo[@"visastatus"] integerValue];
    if (visastatus == 3) {
        return;
    }
    
    _isNavigationBack = NO;
    bugeili_net
    progress_show

    WS(ws);

    [ZAPP.netEngine requestVisaActiveValidateCodeComplete:^{
        
        [ZAPP.zvalidation startTimer];
        [ZAPP.zvalidation sucSend];
        
        BindBank3 *cz = ZSTORY(@"BindBank3");
        cz.hasId = [ZAPP.myuser hasIdCardInUserInfo];
        cz.delegate = self;
//        cz.phone = self.phone;
//        cz.card = self.card;
        [ws.navigationController pushViewController:cz animated:YES];
        
        progress_hide
    } error:^{
        progress_hide
        ;
    }];
}

- (void)unbindBankcard{
    
    bugeili_net
    progress_show
    [ZAPP.netEngine unbindBankcardWithComplete:^{
//        [self setDataUnbind]
        progress_hide
        [self unBindRefreshUI];
    } error:^{
        //[self loseData];
        progress_hide
    } cardid:self.cardInfo[NET_KEY_visaid]];
}


- (void)unBindRefreshUI {
//    NSString *msg = @"解绑成功！";;
    //[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"3秒后自动关闭" otherButtonTitles:nil, nil];
    ZAPP.myuser.bankcardListRespondDict = nil;
    self.cardInfo = nil;
    [self showView];
    
    autoCloseAlertView = [[CustomIOSAlertView alloc] init];
    [autoCloseAlertView setContainerView:[self createTiXianAlertViewWithMessage:CNLocalizedString(@"alert.message.showCardVC", nil)]];
    [autoCloseAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"3秒后自动关闭", nil]];
    [autoCloseAlertView setDelegate:self];
    
    autoCloseAlertView.tag = 1000;
    [autoCloseAlertView show];
    [autoCloseAlertView formatAlertButton];
    
    autoCloseAlertTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alertViewTimerAction) userInfo:nil repeats:YES];
    autoCloseAlertInterval = 3;
    
}

- (void)alertViewTimerAction {
    NSUInteger interval = --autoCloseAlertInterval;
    if (interval > 0) {
        for (UIView *view in autoCloseAlertView.dialogView. subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag == 0) {
                    [button setTitle:[NSString stringWithFormat:@"%ld秒后自动关闭", (long)interval] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"%ld秒后自动关闭", (long)interval] forState:UIControlStateHighlighted];
                }
            }
        }
    }else{
        [autoCloseAlertView close];
        [autoCloseAlertTimer invalidate];
        autoCloseAlertTimer = nil;
        autoCloseAlertInterval = 0;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    if (alertView.tag == 1000) {
        [super customNavBackPressed];
    }
    if (alertView.tag == 1001 && buttonIndex == 0 ) {    //解绑
        [self unbindBankcard];
//        [self unBindRefreshUI];
    }
    if (alertView.tag == 1002 && buttonIndex == 0 ) {   //提现
        TiXian *chong = ZSEC(@"TiXian");
        [self.navigationController pushViewController:chong animated:YES];
    }
    [alertView close];
}

- (void)setupNavBar{
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width=-10.0f;
    if ([ZAPP.myuser hasBankBinded]) {
        self.navigationItem.rightBarButtonItems = @[space, self.rightNavBarButtonItem];
    }
    else {
        self.navigationItem.rightBarButtonItems = @[space];
    }
}

- (UIBarButtonItem *)rightNavBarButtonItem{
    if (! _rightNavBarButtonItem) {
        UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        [editBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        
        [editBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        
        editBtn.contentMode = UIViewContentModeCenter;
        UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, KNAV_SUBVIEW_MAXHEIGHT)];
        
        [containerView1 addSubview:editBtn];
        
        _rightNavBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:containerView1];
    }
    return _rightNavBarButtonItem;
}

- (IBAction)showMenu:(id)sender {
    
    if (self.menuViewBottom.constant == 0) {
        self.menuViewBottom.constant = -[ZAPP.zdevice getDesignScale:115];
        self.backView.hidden = YES;
    }else{
        self.menuViewBottom.constant = 0;
        self.backView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        nil;
    }];
}

- (void)setupView {
    self.title = @"银行卡";
    [self setNavButton];
    
//    self.continueBindButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.viewWidth.constant = [UIScreen mainScreen].bounds.size.width;
    self.onceLimitLabel.text =
    self.dailyLimitLabel.text =
    self.cardInfoLabel.text = @"";
    
    self.unbindButton.titleLabel.font =
    self.cancelButton.titleLabel.font =
    self.activeProcessLabel.font =
    self.toAddButton.titleLabel.font =
    self.toAddPrompt.font =
    self.continueBindButton.titleLabel.font =
    self.onceLimitPrompt.font =
    self.dailyLimitPrompt.font =
    self.onceLimitLabel.font =
    self.dailyLimitLabel.font =
    self.cardInfoLabel.font = [UtilFont systemLarge];
    
    self.toAddViewTop.constant = 0;
    
    self.onceLimitPrompt.hidden =
    self.dailyLimitPrompt.hidden = YES;
    
    [Util setScrollHeader:self.scollView target:self header:@selector(connectToServer) dateKey:[Util getDateKey:self]];
}


- (UIView *)createTiXianAlertViewWithMessage : (NSString *)message  {
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 230, 110)];
    label.numberOfLines = 0;
    label.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    label.font = [UIFont systemFontOfSize:15.0f];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [message length])];
    [label setAttributedText:attributedString1];
    
    label.textAlignment = NSTextAlignmentCenter;
    [demoView addSubview:label];
    
    return demoView;
}

- (NSDictionary *)cardInfo{
    NSArray *visas = ZAPP.myuser.bankcardListRespondDict[@"visas"];
    if (![visas isKindOfClass:[NSNull class]] && visas.count > 0) {
        _cardInfo = visas[0];
    }else{
        _cardInfo = nil;
    }
    return _cardInfo;
}

-(void)showCardView{
    self.cardView.hidden =
    self.onceLimitPrompt.hidden =
    self.dailyLimitPrompt.hidden =
    self.onceLimitLabel.hidden =
    self.dailyLimitLabel.hidden = NO;
    
    self.toAddView.hidden = YES;
}

- (void)showAddView{
    self.cardView.hidden =
    self.onceLimitPrompt.hidden =
    self.dailyLimitPrompt.hidden =
    self.onceLimitLabel.hidden =
    self.dailyLimitLabel.hidden = YES;
    
    self.toAddView.hidden = NO;
}

@end
