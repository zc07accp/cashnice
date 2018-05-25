//
//  FillingBankInfoViewController.m
//  YQS
//
//  Created by a on 16/4/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "FillingBankInfoViewController.h"
#import "GYBankCardFormatTextFieldDelate.h"
#import "ShowCardViewController.h"
#import "CustomIOSAlertView.h"
#import "CustomTitledAlertView.h"
#import "BankPicker.h"
#import "BindBank2.h"
#import "RTLabel.h"

@interface FillingBankInfoViewController () <BankPickerDelegate, BindBank2Delegate, CustomIOSAlertViewDelegate> {
    GYBankCardFormatTextFieldDelate *bankCardFieldDelegate;
    
    BindBank2 *bindBank2;
}
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *promptLabels;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UITextField *idNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextActionButton;

@property (weak, nonatomic) IBOutlet UITextField *holderNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTypeTextFileld;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

@property (strong, nonatomic) BankPicker *bankPicker;
@property (strong, nonatomic) NSString *selectedBankCode;
@property (nonatomic) BOOL isIdentified;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardInfoViewHeight;

@end

@implementation FillingBankInfoViewController

BLOCK_NAV_BACK_BUTTON

NSString *fillingBankInfoPhoneNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    if (fillingBankInfoPhoneNumber.length > 0) {
        self.phoneNumTextField.text = fillingBankInfoPhoneNumber;
    }
    
    
#ifndef TEST_BIND_BANK_STEPS
    self.nextActionButton.enabled = NO;
#endif
    [self.nextActionButton setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
    
    [self inputChanged:nil];
    
    self.nextActionButton.titleLabel.font = [UtilFont systemButtonTitle];
    
    [self connectToServer];
}

- (IBAction)toAddAction:(id)sender {
    
#ifdef TEST_BIND_BANK_STEPS
    BindBank2 *bindBank          = ZSTORY(@"BindBank2");
    bindBank.hasId = self.isIdentified;
    bindBank.orderno  = @"222";
    bindBank.delegate = self;
    bindBank.phone = [self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    bindBank.card = self.inputedCardNo;
    [self.navigationController pushViewController:bindBank animated:YES];
    return;
#endif
    
    [self.view endEditing:YES];
    if ([self verifyTheForm]) {
        
        progress_show
        if (self.isIdentified) {
            [self sendValidationCode];
        }else{
            [ZAPP.netEngine
             bindBankcardCommitNameAndIdNumberWithComplete:^{
                 [self sendValidationCode];
             }
             error:^{
                 progress_hide
                 [self showBindAlertView];
             } userrealname:self.holderNameTextField.text
             idcardnumber:self.idNumTextField.text];
        }
    }
}

- (void)showBindAlertView{
    
    /*
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerView:[self createAlertView]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"返回修改", @"取消绑卡", nil]];
    [alertView setDelegate:self];
    alertView.tag = 1001;
    [alertView show];
    [alertView formatAlertButton];
    */
    /*
    CustomTitledAlertView *alertView = [[CustomTitledAlertView alloc] initWithTitle:@"请确认您的银行卡信息是否正确" andInfo:@""];
    alertView.tag = 1001;
    [alertView show];
    */
}

- (void)customNavBackPressed{
    //保存填入的手机号
    fillingBankInfoPhoneNumber = self.phoneNumTextField.text;
    [super customNavBackPressed];
}

- (void)customIOS7dialogButtonTouchUpInside:(CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    /*
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *cancel;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[ShowCardViewController class]]) {
            cancel = vc;
        }
    }
    if (buttonIndex == 0) {
        //返回修改
        //保存填入的手机号
        fillingBankInfoPhoneNumber = self.phoneNumTextField.text;
        //留在当前页
        //[self.navigationController popToViewController:back animated:YES];
    }else if (buttonIndex == 1){
        //取消绑卡
        [self.navigationController popToViewController:cancel animated:YES];
    }
    */
    [alertView close];
}


- (void)sendValidationCode{
//    [ZAPP.zvalidation
//     sendBindBankcardWithComplete:^{
//         progress_hide
//         [self setData];
//     }error:^{
//         [self showBindAlertView];
//         progress_hide
//     }cardnumber:self.inputedCardNo
//     phonenumber:[self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]
//     bankCode:_selectedBankCode
//     province:@""
//     city:@""];
}

- (void)resendValidationCode {
    
//    progress_show
//    [ZAPP.zvalidation
//     sendBindBankcardWithComplete:^{
//         progress_hide
//         NSString *orderno = [ZAPP.myuser.bindBankcardRespondDict objectForKey:NET_KEY_ORDERNO];
//         bindBank2.orderno  = orderno;
//     }error:^{
//         progress_hide
//     }cardnumber:self.inputedCardNo
//     phonenumber:[self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]
//     bankCode:_selectedBankCode
//     province:@""
//     city:@""];
}

- (void)setData {
    NSString *orderno = [ZAPP.myuser.bindBankcardRespondDict objectForKey:NET_KEY_ORDERNO];
    if ([orderno notEmpty]) {
        bindBank2          = ZSTORY(@"BindBank2");
        bindBank2.hasId = self.isIdentified;
        bindBank2.orderno  = orderno;
        bindBank2.delegate = self;
        bindBank2.phone = [self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        bindBank2.card = self.inputedCardNo;
        [self.navigationController pushViewController:bindBank2 animated:YES];
    }
}

- (void)setPicker {
    NSDictionary *guestBank = ZAPP.myuser.visaGuestBank;
    _selectedBankCode = guestBank[@"bankcode"];
    self.cardTypeTextFileld.text = [NSString stringWithFormat:@"%@储蓄卡",guestBank[@"bankname"]];
    if (_selectedBankCode.length  < 1) {
        self.cardTypeTextFileld.text = nil;
    }
    [self.bankPicker setSelectedBankCode:_selectedBankCode animated:YES];
    [self inputChanged:nil];
}

- (IBAction)bankTypeTouched:(id)sender {
    if ([sender isFirstResponder]) {
        if (_selectedBankCode.length < 1) {
            [self.bankPicker pickerView:self.bankPicker didSelectRow:0 inComponent:0];
            [self inputChanged:nil];
        }
    }
}

- (IBAction)inputChanged:(id)sender {
    
    BOOL fillingCompleted = NO;
    
    if (! self.isIdentified) {
        if ([self.holderNameTextField.text notEmpty] && [self.idNumTextField.text notEmpty ]) {
            if ([_selectedBankCode notEmpty] && [self.phoneNumTextField.text notEmpty]) {
                fillingCompleted = YES;
            }
        }
    }else if ([_selectedBankCode notEmpty] && [self.phoneNumTextField.text notEmpty]) {
        fillingCompleted = YES;
    }
    
    self.nextActionButton.enabled = fillingCompleted;
#ifdef TEST_BIND_BANK_STEPS
    self.nextActionButton.enabled = YES;
#endif
    [self.nextActionButton setBackgroundColor:fillingCompleted?ZCOLOR(COLOR_NAV_BG_RED):ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];

}

- (BOOL)verifyTheForm {
    if (! [_selectedBankCode notEmpty]) {
        [Util toastStringOfLocalizedKey:@"tip.selectedBankCode"];
        return NO;
    }
    if (!self.isIdentified && ![self.holderNameTextField.text notEmpty]) {
        [Util toastStringOfLocalizedKey:@"tip.holderName"];
        return NO;
    }
    if (!self.isIdentified && ![self.idNumTextField.text notEmpty ]) {
        [Util toastStringOfLocalizedKey:@"tip.idNum"];
        return NO;
    }
    if (! [self.phoneNumTextField.text notEmpty]) {
        [Util toastStringOfLocalizedKey:@"tip.phoneNum"];
        return NO;
    }
    return YES;
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
    } bankCard:self.inputedCardNo];
}

- (void)BankPicker:(__unused BankPicker *)picker didSelectBankWithName:(NSString *)name code:(NSString *)code
{
    _selectedBankCode = code;
    self.cardTypeTextFileld.text = [NSString stringWithFormat:@"%@储蓄卡",name];
    [self inputChanged:nil];
}

- (IBAction)codeHint:(id)sender {
    [self.view endEditing:YES];
    CustomTitledAlertView *alertView = [[CustomTitledAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.fillingBankInfoViewContro", nil) andInfo:CNLocalizedString(@"alert.info.fillingBankInfoViewContro", nil)];
    alertView.tag = 1001;
    [alertView show];
}

- (void)setupView {
    self.title = @"填写银行卡信息";
    [self setNavButton];
    
    self.cardTypeTextFileld.inputView = self.bankPicker;
    
    for (UILabel *promptLabel in self.promptLabels) {
        promptLabel.font = [UtilFont systemLarge];
    }
    for (UITextField *textFiled in self.textFields) {
        textFiled.font = [UtilFont systemLarge];
    }
    
    if (!self.isIdentified) {
        self.cardInfoViewHeight.constant = [ZAPP.zdevice getDesignScale:150];
    }else{
        self.cardInfoViewHeight.constant = 0;
    }
    
    bankCardFieldDelegate = [[GYBankCardFormatTextFieldDelate alloc] initWithTextField:self.phoneNumTextField andTextFieldForametType:GYTextFieldForametTypePhoneNumber];
    self.phoneNumTextField.delegate = bankCardFieldDelegate;
}

- (BOOL)isIdentified{
    NSDictionary *userInfo = ZAPP.myuser.gerenInfoDict;
    NSString *idnumber = userInfo[@"idnumber"];
    return (idnumber.length > 1) ;
}

- (BankPicker *)bankPicker{
    if (! _bankPicker) {
        _bankPicker = [[BankPicker alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        _bankPicker.delegate = self;
    }
    return _bankPicker;
}


@end
