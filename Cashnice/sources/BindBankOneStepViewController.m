//
//  BindBankOneStepViewController.m
//  Cashnice
//
//  Created by a on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BindBankOneStepViewController.h"
#import "BindBankEditCell.h"
#import "BindBankActionCell.h"
#import "BindVerification.h"
#import "BindBankInfoCell.h"
#import "BankPicker.h"
#import "IDCardUploadViewController.h"
#import "GYBankCardFormatTextFieldDelate.h"
#import "SinaCashierModel.h"
#import "SinaCashierWebViewController.h"
#import "MyRemainMoneyInterestViewController.h"
#import "PersonInfoAPIEngine.h"
#import "NewPersonDetailViewController.h"

@interface BindBankOneStepViewController ()<BankPickerDelegate, UITextFieldDelegate, BindBankEditChanged, IDCardUploadDelegate, HandleCompletetExport>{
    BOOL        alreadySent;
    
    NSString *  _idnumber;
    NSString *  _userName;
    NSString *  _orderno;
    
    UILabel     *_userNameLabel;
    UILabel     *_idCardLabel;
    
    UIButton    *_okButton;
    UILabel     *_timerLabel;
    UIButton    *_getCodeBtn;
    
    UITextField    *_cardNoTextField;
    UITextField    *_phoneNoTextField;
    UITextField    *_cardTypeTextFileld;
    UITextField    *_validateCodeTextFileld;
    
    BindVerification    *_bindVerificationCell;
    
    NSString *_selectedBankCode;
    
    GYBankCardFormatTextFieldDelate *bankCardFieldDelegate;
    GYBankCardFormatTextFieldDelate *phoneFieldDelegate;
    
    
    BindBankInfoCell *infoCell1;
    BindBankInfoCell *infoCell2;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;

@property (nonatomic, strong) NSArray *tableItems;

@property (strong, nonatomic) BankPicker *bankPicker;

@property (nonatomic) BOOL isIdentified;

@end

@implementation BindBankOneStepViewController


BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"绑定银行卡";
    [self setNavButton];
    
    [self connectToServer];
    
    [self backviewTouchedGesture];
    
    
    [self refreshView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
    
//    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//    but.frame = CGRectMake(100, 100, 100, 100);
//    but.backgroundColor = [UIColor redColor];
//    [but addTarget:self action:@selector(testCell) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:but];
    
    
}

- (void)refreshView{
    [self.tableView reloadData];
    [self formChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _getCodeBtn.enabled = NO;
    _okButton.enabled = NO;
    
    [self validateForConfirm];
    //[self validatecode_time_update];
    
    [self refreshCodeBtn];
    
}

- (void)refreshCodeBtn{
    if([self validateForSendCode]){
        [_bindVerificationCell setButtonEnabeld:YES];
        _timerLabel.hidden   = YES;
        [_getCodeBtn setTitle:(alreadySent ? @"重新获取" : @"获取验证码") forState:UIControlStateNormal];
        _getCodeBtn.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[ZAPP.zvalidation clearRemainTimeAndStopTimer];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[ZAPP.zvalidation clearRemainTimeAndStopTimer];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardDidShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
}
    
- (void)customNavBackPressed{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [super customNavBackPressed];
}

- (void)bankButtonAction{
    NSLog(@"银行限额");
    UIViewController *vc = ZBANK(@"SupportedBankListViewController");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)okAction{
    
    if (! alreadySent) {
        [Util toastStringOfLocalizedKey:@"tip.gettingValidationCode"];
        return;
    }
    
    bugeili_net
    
    if ([_orderno notEmpty]) {
        progress_show
        
        __weak __typeof__(self) weakSelf = self;
        
        [[PersonInfoAPIEngine sharedInstance] checkBankValidateCode:_validateCodeTextFileld.text orderNo:_orderno success:^{
            
            POST_VISABANK_FRESH_NOTI
            
            progress_hide;
            [weakSelf setDataCheck];
        } failure:^(NSString *error) {
            [weakSelf loseData];
            progress_hide
        }];
        
        /*
        [ZAPP.netEngine checkBankcardValidateCodeWithComplete:^{
            //去掉激活银行卡步骤
            //[weakSelf setData];
            progress_hide;
            [weakSelf setDataCheck];2
        } error:^{
            [weakSelf loseData];
            progress_hide
        } orderno:_orderno code:_validateCodeTextFileld.text];
        */
    }
}

- (void)getCodeAction {
    
    [self dismissKeyboard];
    
    if ([self validateForSendCode]) {
        
        [self sendValidationCode];
        
        /*
        progress_show
        if (self.isIdentified) {
            [self sendValidationCode];
        }else{
            
            [[PersonInfoAPIEngine sharedInstance] bindBankCommitName:_userNameLabel.text idnumber:_idCardLabel.text success:^{
                [self sendValidationCode];
            } failure:^(NSString *error) {
                progress_hide;
            }];
         }
         */
    }
}
- (void)sendValidationCode{
    progress_show
    [ZAPP.zvalidation
     sendBindBankcardWithComplete:^{
         progress_hide
         [ZAPP.zvalidation startTimer];
         [ZAPP.zvalidation sucSend];
         
         POST_USERINFOFRESH_NOTI
         
         _orderno = [ZAPP.myuser.bindBankcardRespondDict objectForKey:NET_KEY_ORDERNO];
         
         self.isIdentified = YES;
         [infoCell1 showArrow:NO];
         [infoCell2 showArrow:NO];
         
         //[self setData];
     }error:^{
         
         POST_USERINFOFRESH_NOTI
         
         progress_hide
#ifdef TEST_TEST_SERVER
         //[ZAPP.zvalidation startTimer];
         //[ZAPP.zvalidation sucSend];
#endif
     }cardnumber:[_cardNoTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]
     phonenumber:[_phoneNoTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]
     bankCode:_selectedBankCode
     userName: self.isIdentified ? @"" : _userNameLabel.text
     idNumber: self.isIdentified ? @"" : _idCardLabel.text
     ];
}

- (void)setDataCheck {
    [self navigationBackToBankInfo];
}

- (void)navigationBackToBankInfo {
    //已经绑卡
    __weak typeof(self) weakSelf = self;
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    progress_show
    [model bankCardManagementWithsuccess:^(NSString *URL, NSData *Content) {
        progress_hide
        SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
        web.URLPath = URL;
        web.titleString = @"管理银行卡";
        web.completeHandle = weakSelf;
        web.navigationBackHandler = ^(void){
            //            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            //[weakSelf yueryouxiStackPopHandle];
            [weakSelf complete];
        };
        [self.navigationController pushViewController:web animated:YES];
    } failure:^(NSString *error) {
        progress_hide
    }];
    /*
     NSArray *viewControllers = self.navigationController.viewControllers;
     for (UIViewController *vc in viewControllers) {
     if ([vc isKindOfClass:[ShowCardViewController class]]) {
     [self.navigationController popToViewController:vc animated:YES];
     return;
     }
     }
     [self.navigationController popToRootViewControllerAnimated:YES];
     */
    
}

- (void)complete{
    
    POST_VISABANK_FRESH_NOTI
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyRemainMoneyInterestViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[NewPersonDetailViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//-(void)yueryouxiStackPopHandle{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)loseData {
    NSDictionary *errorDict = [AppDelegate zapp].myuser.checkBankValidateCodeRespondDict;
    if (errorDict) {
        [Util toast : errorDict[@"msg"]];
    }else{
        [Util toastStringOfLocalizedKey:@"tip.bamkCardBindFail"];
    }
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [self validatecode_time_update];
}

- (void)validatecode_time_update {
    int t = [ZAPP.zvalidation getRemainTime];
    if (t <= 0) {
        //_getCodeBtn.enabled = YES;
        
        [ZAPP.zvalidation clearRemainTimeAndStopTimer];
        [_bindVerificationCell setButtonEnabeld:YES];
        _timerLabel.hidden   = YES;
        [_getCodeBtn setTitle:(alreadySent ? @"重新获取" : @"获取验证码") forState:UIControlStateNormal];
        _getCodeBtn.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
    }
    else {
        //_getCodeBtn.enabled = NO;
        [_bindVerificationCell setButtonEnabeld:NO];
        alreadySent                 = YES;
        _timerLabel.hidden   = NO;
        _timerLabel.text = [NSString stringWithFormat:@"%d秒后重发", t];
        [_getCodeBtn setTitle:@"" forState:UIControlStateNormal];
        _getCodeBtn.layer.borderColor = HexRGB(0xcccccc).CGColor;
    }
}

- (void)connectToServer {
    bugeili_net
    progress_show
    [ZAPP.netEngine api2_getBankcardListWithComplete:^{
        
        progress_hide
    } error:^{
        
        progress_hide
    }];
}

- (void)textFiledValueChanged:(id)sender{
    [self formChanged];
}

- (void)formChanged{
    
//    if (! [self validateForSendCode]) {
//        [ZAPP.zvalidation clearRemainTimeAndStopTimer];
//    }
    
    [_bindVerificationCell setButtonEnabeld:[self validateForSendCode]];
    
    //[self validatecode_time_update];
    
    [self refreshCodeBtn];
}

- (BOOL)validateForSendCode{
    if (_userNameLabel.text.length      > 0  &&
        _idCardLabel.text.length        > 0  &&
      //_cardTypeTextFileld.text.length > 0  &&
        _selectedBankCode.length        > 0  &&
        _cardNoTextField.text.length    > 0  &&
        _phoneNoTextField.text.length   > 0  &&
        [ZAPP.zvalidation getRemainTime] <= 0
        ) {
        return YES;
    }
    return NO;
}

- (void)validateForConfirm{
    BOOL valid = (_userNameLabel.text.length      > 0  &&
        _idCardLabel.text.length        > 0  &&
      //_cardTypeTextFileld.text.length > 0  &&
        _selectedBankCode.length        > 0  &&
        _cardNoTextField.text.length    > 0  &&
        _phoneNoTextField.text.length   > 0  &&
        _validateCodeTextFileld.text.length > 0);
    
    _okButton.enabled = valid;
}

#pragma mark - picker delegate method

- (void)handleKeyboardWillHide:(NSNotification *)notification {

    self.tableBottom.constant = 0;

}

- (void)handleKeyboardDidShow:(NSNotification *)notification {
    if ([_cardTypeTextFileld isFirstResponder]) {
        if (_selectedBankCode.length < 1) {
            [self.bankPicker pickerView:self.bankPicker didSelectRow:0 inComponent:0];
            //[self inputChanged:nil];
        }
    }
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"TEXTVIEW_KEYBOARD" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.tableBottom.constant = keyboardRect.size.height;
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _cardTypeTextFileld) {
        if (_selectedBankCode.length < 1) {
            //[self.bankPicker pickerView:self.bankPicker didSelectRow:0 inComponent:0];
            //[self inputChanged:nil];
        }
    }
    return YES;
}

#pragma mark - picker delegate method

- (void)BankPicker:(__unused BankPicker *)picker didSelectBankWithName:(NSString *)name code:(NSString *)code
{
    _selectedBankCode = code;
    _cardTypeTextFileld.text = [NSString stringWithFormat:@"%@ 储蓄卡",name];
    [self formChanged];
}


#pragma mark - tableview delegate method 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 6) {
        return [ZAPP.zdevice getDesignScale:80];
    }else{
        return [ZAPP.zdevice getDesignScale:50];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *title = [self.tableItems[row] firstObject];
    NSString *content = [self.tableItems[row] lastObject];
    if (row <= 1) {
        BindBankInfoCell *cell = [self getInfoCell];
        [cell setTitle:title content:content];
        if (row == 0) {
            _userNameLabel = cell.contentLabel;
            infoCell1 = cell;
        }else{
            _idCardLabel = cell.contentLabel;
            infoCell2 = cell;
        }
        
        [cell showArrow: !self.isIdentified];
        
        return cell;
    }else if(row <= 4){
        BindBankEditCell *cell = [self getBindBankEditCell];
        [cell setTitle:title andPlaceholder:content];
        cell.delegate = self;
        
        if (row == 2) {
            //选择卡类型
            _cardTypeTextFileld = cell.textField;
            _cardTypeTextFileld.inputView = self.bankPicker;
            _cardTypeTextFileld.clearButtonMode = UITextFieldViewModeNever;
            _cardTypeTextFileld.delegate = self;
        }if (row == 3) {
            //银行卡号
            _cardNoTextField = cell.textField;
            _cardNoTextField.keyboardType = UIKeyboardTypeNumberPad;
            _cardNoTextField.delegate = nil;
            
            if (!bankCardFieldDelegate) {
                bankCardFieldDelegate = [[GYBankCardFormatTextFieldDelate alloc] initWithTextField:_cardNoTextField];
            }else{
                _cardNoTextField.delegate = bankCardFieldDelegate;
            }
            
            
        } else if(row == 4){
            //预留手机号
            _phoneNoTextField = cell.textField;
            _phoneNoTextField.keyboardType = UIKeyboardTypePhonePad;
            _phoneNoTextField.delegate = nil;

            if (!phoneFieldDelegate) {
                phoneFieldDelegate = [[GYBankCardFormatTextFieldDelate alloc] initWithTextField:_phoneNoTextField andTextFieldForametType:GYTextFieldForametTypePhoneNumber];
            }else{
                _phoneNoTextField.delegate = phoneFieldDelegate;
            }
        }
        
        return cell;
    }else if(row == 5){
        BindVerification *cell = [self getBindBankValidateCell];
        _validateCodeTextFileld = cell.codeTextField;
        _bindVerificationCell = cell;
        [_validateCodeTextFileld addTarget:self action:@selector(validateForConfirm) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }else if(row == 6){
        BindBankActionCell *cell = [self getBindBankActionCell];
        
        return cell;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row <= 1 && ![self isIdentified]) {
        UIViewController *vc = [MeRouter IDCardUploadViewController:self];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)IDCardCertifiedUploaded:(NSString *)name cardNumber:(NSString *)cardNumber{
    if (!name) {
        name = @"";
    }
    if (! cardNumber) {
        cardNumber = @"";
    }
    _userName = name;
    _idnumber = cardNumber;
    [self refreshView];
}

- (BindBankInfoCell *)getInfoCell{
    static NSString *cellIdentifier = @"BindBankInfoCell";
    return [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
}

- (BindBankEditCell *)getBindBankEditCell{
    static NSString *cellIdentifier = @"BindBankEditCell";
    return [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
}

- (BindBankActionCell *)getBindBankActionCell{
    static NSString *cellIdentifier = @"BindBankActionCell";
    BindBankActionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    _okButton = cell.okButton;
    [cell.bankButton addTarget:self action:@selector(bankButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (void)backviewTouchedGesture{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backviewTouched:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}

-(void)backviewTouched:(UITapGestureRecognizer*)tap1{
    [self dismissKeyboard];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (BOOL)isIdentified{
    NSDictionary *userInfo = ZAPP.myuser.gerenInfoDict;
    NSString *idnumber = userInfo[@"idnumber"];
    return (idnumber.length > 1) ;
}

- (BindVerification *)getBindBankValidateCell{
    static NSString *cellIdentifier = @"BindBankValidateCell";
    BindVerification *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    _timerLabel = cell.timerLabel;
    _getCodeBtn = cell.getCodeBtn;
    [_getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (BankPicker *)bankPicker{
    if (! _bankPicker) {
        _bankPicker = [[BankPicker alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        _bankPicker.delegate = self;
        
        //[_bankPicker pickerView:_bankPicker didSelectRow:0 inComponent:0];
    }
    
    return _bankPicker;
}

- (NSArray *)tableItems{
    
    NSDictionary *userInfo = ZAPP.myuser.gerenInfoDict;
    NSString *idnumber = EMPTYSTRING_HANDLE(userInfo[@"idnumber"]);;
    NSString *userName = EMPTYSTRING_HANDLE(userInfo[@"userrealname"]);
    
    if (! self.isIdentified) {
        idnumber = _idnumber;
        userName = _userName;
    }
    
    if (! idnumber) {
        idnumber = @"";
    }
    
    if (! userName) {
        userName = @"";
    }
    
    return @[@[@"真实姓名", userName],
             @[@"身份证号", idnumber],
             @[@"卡类型",  @"请选择银行卡类型"],
             @[@"银行卡号", @"请输入银行卡号"],
             @[@"预留手机", @"请输入银行预留手机号码"],
             @[@"", @""],
             @[@"", @""],
             ];
}

@end
