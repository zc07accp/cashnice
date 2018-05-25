//
//  AddingCardViewController.m
//  YQS
//
//  Created by a on 16/4/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "AddingCardViewController.h"
#import "FillingBankInfoViewController.h"
#import "GYBankCardFormatTextFieldDelate.h"
#import "CustomTitledAlertView.h"

@interface AddingCardViewController () {
    
    GYBankCardFormatTextFieldDelate *bankCardFieldDelegate;
}
@property (weak, nonatomic) IBOutlet UILabel *promptLable;
@property (weak, nonatomic) IBOutlet UILabel *holderPrompt;
@property (weak, nonatomic) IBOutlet UILabel *cardNoPrompt;

@property (weak, nonatomic) IBOutlet UITextField *holderTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *cardNoTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *supportedButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holderViewHeight;

@end

@implementation AddingCardViewController

BLOCK_NAV_BACK_BUTTON

static NSString *addingCardViewCardNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupLayout];
    [self setupData];
    
    if (addingCardViewCardNumber.length > 0) {
        self.cardNoTextFiled.text = addingCardViewCardNumber;
    }
    addingCardViewCardNumber = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"添加银行卡"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"添加银行卡"];
}

- (void)setupData{
    NSDictionary *userInfo = ZAPP.myuser.gerenInfoDict;
    NSString *idnumber = userInfo[@"idnumber"];
    if (idnumber.length > 1) {
        NSString *userrealname = userInfo[@"userrealname"];
        self.holderTextFiled.text = userrealname;
    }
}

- (BOOL)validateCardNo {
    return ([self getInputedCardNo].length > 0) ;
}

- (IBAction)cardholderHint:(id)sender {
    [self.view endEditing:YES];
    CustomTitledAlertView *alertView = [[CustomTitledAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.bank.holderIntro", nil) andInfo:CNLocalizedString(@"alert.info.bank.holderIntro", nil)];
    [alertView show];
}

- (void)setupView {
    self.title = @"添加银行卡";
    [self setNavButton];
    
    bankCardFieldDelegate = [[GYBankCardFormatTextFieldDelate alloc] initWithTextField:self.cardNoTextFiled];
    self.cardNoTextFiled.delegate = bankCardFieldDelegate;
    
    self.nextButton.enabled = NO;
    [self.nextButton setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
}

- (void)setupLayout {
    
    self.promptLable.font =
    self.holderPrompt.font =
    self.cardNoPrompt.font =
    self.holderTextFiled.font =
    self.cardNoTextFiled.font =
    [UtilFont systemLarge];
    
    self.nextButton.titleLabel.font = [UtilFont systemButtonTitle];
    self.supportedButton.titleLabel.font = [UtilFont systemSmall];
    [self.supportedButton sizeToFit];
    
    NSDictionary *userInfo = ZAPP.myuser.gerenInfoDict;
    NSString *idnumber = userInfo[@"idnumber"];
    if (idnumber.length <= 1) {
        self.holderViewHeight.constant = 0;
    }else{
        self.holderViewHeight.constant = [ZAPP.zdevice getDesignScale:61.0];
    }
}

- (NSString *)getInputedCardNo{
    return [self deleteWhitespaceOfString:self.cardNoTextFiled.text];
}

- (NSString *)deleteWhitespaceOfString : (NSString*)source{
    return [source stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (IBAction)showSupportedBank:(id)sender {
    UIViewController *vc = ZBANK(@"SupportedBankListViewController");
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nextAction:(id)sender {
    if (! [self validateCardNo]) {
        [Util toastStringOfLocalizedKey:@"tip.inputtingBankNumber"];
        return;
    }
    [self.cardNoTextFiled resignFirstResponder];
    
    FillingBankInfoViewController *fillVC = ZBANK(@"FillingBankInfoViewController");
    fillVC.inputedCardNo = [self getInputedCardNo];
    [self.navigationController pushViewController:fillVC animated:YES];
}

- (IBAction)inputChanged:(id)sender {
    
    BOOL fillingCompleted = NO;
    
    if ([self.holderTextFiled.text notEmpty] && [self.cardNoTextFiled.text notEmpty]) {
        fillingCompleted = YES;
    }
    
    self.nextButton.enabled = fillingCompleted;
    [self.nextButton setBackgroundColor:fillingCompleted?ZCOLOR(COLOR_NAV_BG_RED):ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
}

- (IBAction)backgroundToched:(id)sender {
    [self.cardNoTextFiled resignFirstResponder];
}

@end
