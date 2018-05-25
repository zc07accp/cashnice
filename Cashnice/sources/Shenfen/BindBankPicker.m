//
//  BindBankPicker.m
//  YQS
//
//  Created by a on 15/11/16.
//  Copyright © 2015年 l. All rights reserved.
//

#import "BindBankPicker.h"
#import "NextButtonViewController.h"
#import "CustomIOSAlertView.h"
#import "ProgressIndicator.h"
#import "RTLabel.h"
#import "BankPicker.h"
#import "BindBank2.h"
#import "BindBank1.h"

@interface BindBankPicker () <NextButtonDelegate, BindBank2Delegate, CustomIOSAlertViewDelegate>
{
    BindBank2 *bindBank2;
}

@property (strong, nonatomic) NSArray *           nameArray;
@property (strong, nonatomic) NSArray *           imageArray;
@property (strong, nonatomic) IBOutlet UIView* progressHolder;
@property (strong, nonatomic)  ProgressIndicator* progressIndicator;
@property (weak, nonatomic) IBOutlet BankPicker *bankPIcker;

@property (strong, nonatomic) NSString *selectedBankCode;

@end

@implementation BindBankPicker

BLOCK_NAV_BACK_BUTTON
CODE_BLOCK_PROGRESS_INDICATOR_ADD_AND_ALLOC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];
    [self.navigationItem setTitle:@"绑定银行卡"];
    
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    [self addProgressBar];
    
    if (self.hasId) {
        [self.progressIndicator setCurrentPage:0 strings:BIND_BANK_TITLES_3_STEP];
    }
    else {
        [self.progressIndicator setCurrentPage:1 strings:BIND_BANK_TITLES_4_STEP];
    }
    [self connectToServer];
}

- (void)BankPicker:(__unused BankPicker *)picker didSelectBankWithName:(NSString *)name code:(NSString *)code
{
    _selectedBankCode = code;
    //NSLog(@"name : %@, code : %@", name, code);
}

- (void)setData {
    NSString *orderno = [ZAPP.myuser.bindBankcardRespondDict objectForKey:NET_KEY_ORDERNO];
    if ([orderno notEmpty]) {
        bindBank2          = ZSTORY(@"BindBank2");
        bindBank2.hasId = self.hasId;
        bindBank2.orderno  = orderno;
        bindBank2.delegate = self;
        bindBank2.phone = self.PhoneNum;
        bindBank2.card = self.cardCode;
        [self.navigationController pushViewController:bindBank2 animated:YES];
    }
}

- (void)nextButtonPressed {
//    [ZAPP.zvalidation sendBindBankcardWithComplete:^{[self setData]; } error:^{[self loseData]; }  cardnumber:self.cardCode phonenumber:self.PhoneNum bankCode:_selectedBankCode province:@"" city:@""];
}

- (void)setData2 {
#ifdef TEST_BIND_BANK_STEPS
    [self showBindAlertView];
#endif
    NSString *orderno = [ZAPP.myuser.bindBankcardRespondDict objectForKey:NET_KEY_ORDERNO];
    if ([orderno notEmpty]) {
        bindBank2.orderno = orderno;
    }
}

- (void)loseData {
    [self showBindAlertView];
}

- (void)showBindAlertView{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerView:[self createAlertView]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"返回修改", @"取消绑卡", nil]];
    [alertView setDelegate:self];
    alertView.tag = 1001;
    [alertView show];
    
    [alertView formatAlertButton];
}

- (void)customIOS7dialogButtonTouchUpInside:(CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *back;
    UIViewController *cancel;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[BindBank1 class]]) {
            back = vc;
        }
//        if ([vc isKindOfClass:[BankList class]]) {
//            cancel = vc;
//        }
    }
    if (buttonIndex == 0) {
        //返回修改
        [self.navigationController popToViewController:back animated:YES];
    }else if (buttonIndex == 1){
        //取消绑卡
        [self.navigationController popToViewController:cancel animated:YES];
    }
    [alertView close];
}

- (void)resendValidationCode {
//    [ZAPP.zvalidation sendBindBankcardWithComplete:^{[self setData2]; } error:^{[self loseData]; }  cardnumber:self.cardCode phonenumber:self.PhoneNum bankCode:_selectedBankCode province:@"" city:@""];
}

- (void)setPicker {
    NSDictionary *guestBank = ZAPP.myuser.visaGuestBank;
    _selectedBankCode = guestBank[@"bankcode"];
    [_bankPIcker setSelectedBankCode:_selectedBankCode animated:YES];
}

- (void)connectToServer {
    bugeili_net
    progress_show
    [ZAPP.netEngine guestBankWithComplete:^{
        [self setPicker];
        progress_hide
    } error:^{
        //[self loseData];
        progress_hide
    } bankCard:self.cardCode];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
        ((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        //self.next  = ((NextButtonViewController *)[segue destinationViewController]);
    }
}

- (UIView *)createAlertView {
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    
//    NSString *message = @"亲，绑卡失败啦，可能是 \n1.您的借记卡号码填错了。\n2.银行预留手机号码填错了。\n3.我们还不支持您的银行卡。";
    
    RTLabel *contentLabel = [[RTLabel alloc] init];
    //contentLabel.numberOfLines = 0;
    contentLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    contentLabel.font = [UIFont systemFontOfSize:12.0f];
//    contentLabel.backgroundColor = [UIColor greenColor];
    contentLabel.lineSpacing = 8;
    contentLabel.text =CNLocalizedString(@"alert.message.bindBankPicker", nil);// message;
    CGSize size = contentLabel.optimumSize;
    CGRect frame = CGRectMake(10, 10, 230, size.height);
    contentLabel.frame = frame;
    
    frame = CGRectMake(0, 0, 250, size.height + 20);
    demoView.frame = frame;
    
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:message];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:8];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [message length])];
//    [contentLabel setAttributedText:attributedString1];
    
    //[demoView addSubview:label];
    [demoView addSubview:contentLabel];
    
    return demoView;
}

@end
