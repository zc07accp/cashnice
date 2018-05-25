//
//  PhoneEditValidation.m
//  Cashnice
//
//  Created by a on 2016/12/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "PhoneEditValidation.h"
#import "VerifyEngine.h"
#import "PhoneEdit.h"

@interface PhoneEditValidation (){
    BOOL alreadySent;
    UILabel *_timerLabel;
    
    NSTimer *_getCodeTimer;
    NSUInteger _timerRepectCnt;
}

@property (strong,nonatomic) VerifyEngine *engine;
@property (strong,nonatomic) NSString *validateuuid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConsistant;


@end

@implementation PhoneEditValidation

BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改手机号码";
    [self setNavButton];
    
    self.getCodeBtn.layer.cornerRadius =3;
    self.getCodeBtn.layer.borderColor = HexRGB(0x3399ff).CGColor;
    self.getCodeBtn.titleLabel.textColor = HexRGB(0x3399ff);
    self.getCodeBtn.titleLabel.font = CNFontNormal;
    self.getCodeBtn.layer.borderWidth = 1;
    self.getCodeBtn.layer.masksToBounds = YES;
    
    _timerLabel = [[UILabel alloc] init];
    [self.view addSubview:_timerLabel];
    [_timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getCodeBtn);
        make.left.equalTo(self.getCodeBtn);
        make.right.equalTo(self.getCodeBtn);
        make.bottom.equalTo(self.getCodeBtn);
    }];
    
    [self setupUI];
    [self backviewTouchedGesture];
}

- (void)setupUI{
    
    self.promptLabel.font = CNFontNormal;
    self.phoneLabel.font = CNFontNormal;
    
    self.phoneLabel.text = [self userPhoneNumberMasked:YES];
    
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    _timerLabel.font = [UtilFont systemLarge];
    _confirmActionBtn.titleLabel.font = [UtilFont systemButtonTitle];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
    
    //[self validatecode_time_update];
    
    if (ScreenInch4s) {                                                                                                                                                                                                      NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
}

- (void)validatecode_time_update {
    //int t = [ZAPP.zvalidation getRemainTime];
    
    NSInteger resverd = [ZAPP.myuser getSMSWaitingSencods] - ++_timerRepectCnt;
    
    if (resverd <= 0) {
        
        if (_getCodeTimer) {
            [self stopTimer];
        }
        
        self.getCodeBtn.enabled = YES;
        _timerLabel.hidden   = YES;
        [self.getCodeBtn setTitle:(alreadySent ? @"重新获取" : @"获取验证码") forState:UIControlStateNormal];
        self.getCodeBtn.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
    }
    else {
        self.getCodeBtn.enabled = NO;
        alreadySent                 = YES;
        _timerLabel.hidden   = NO;
        _timerLabel.text = [NSString stringWithFormat:@"%zd秒后重发", resverd];
        [self.getCodeBtn setTitle:@"" forState:UIControlStateNormal];
        self.getCodeBtn.layer.borderColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY).CGColor;
    }
}

- (NSString *)userPhoneNumberMasked:(BOOL)masked{
    
    NSString *phNo = masked ? [ZAPP.myuser getPhoneMask] : [ZAPP.myuser getPhoneNo];
    
//    if (masked ) {
//        phNo = [phNo stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
//    }
    
    return phNo;
}

- (NSInteger)userNationality{
    NSDictionary *userInfo = ZAPP.myuser.gerenInfoDict;
    NSInteger nationality = [userInfo[@"nationality"] integerValue];
    
    return nationality;
}

- (void)backviewTouchedGesture{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backviewTouched:)];
    tap1.cancelsTouchesInView = NO;
    //tap1.delegate = self;
    [self.view addGestureRecognizer:tap1];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }else if ([touch.view isKindOfClass:[UITableView class]])
    {
        return NO;
    }
    return YES;
}

-(void)backviewTouched:(UITapGestureRecognizer*)tap1{
    
    [self.view endEditing:YES];
    
}

- (void)loseData {
    //	[ZAPP clearCache];
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    //[self stopTimer];
    [self validatecode_time_update];
}

- (IBAction)closeKeyb:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)inputChanged:(id)sender {
    NSString *inputedCode = _verifyCodeField.text;
    if (inputedCode.length > 0) {
        [_confirmActionBtn setEnabled:YES];
    }else{
        [_confirmActionBtn setEnabled:NO];
    }
}

-(VerifyEngine *)engine{
    
    if(!_engine){
        _engine = [[VerifyEngine alloc]init];
    }
    
    return _engine;
}

- (IBAction)getCode:(id)sender {
    
    //[self dismissKeyboard];
    
    //if (self.tf0.text.length < 1) {
    //    [Util toastStringOfLocalizedKey:@"tip.inputingPhoneNumber"];
    //    return;
    //}
    
    //savedPhone = self.tf0.text;
    //    [ZAPP.zvalidation sendPhoneCode:self.tf0.text withComplete:nil error:nil];
    
    [ZAPP.zvalidation sendPhoneCode:[self userPhoneNumberMasked:NO] withRegionCode:[self userNationality] Complete:^{
        [self startTimer];
    } error:^{
        [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    }];
    
    
    /*
    [ZAPP.zvalidation startTimer];
    WS(weakSelf)
    [self.engine getEmailVerifyCode:[self trimedEmail] success:^(NSString *validateuuid) {
        [Util toastStringOfLocalizedKey:@"tip.ValidationCodeHasSend"];;
        weakSelf.validateuuid = validateuuid;
    } failure:^(NSString *error) {
        
        [ZAPP.zvalidation clearRemainTimeAndStopTimer];
        [self validatecode_time_update];
    }];
     */
}

- (IBAction)sureAction:(id)sender {
    
//#ifdef TEST_TEST_SERVER
//    PhoneEdit *pro = ZEdit(@"PhoneEdit");
//    [self.navigationController pushViewController:pro animated:YES];
//    return;
//#endif
    
    //[self.view endEditing:YES];
    
    //if (![Util isValidCode:]) {
    if (! alreadySent) {
        [Util toastStringOfLocalizedKey:@"tip.gettingValidationCode"];
        return;
    }
    
    NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
    bugeili_net
    
    if (uuid != nil && uuid.length == 32) {
        
        progress_show
        [ZAPP.netEngine checkValidateCodeWithComplete:^{
            PhoneEdit *pro = ZEdit(@"PhoneEdit");
            [self.navigationController pushViewController:pro animated:YES];
            [ZAPP.zvalidation clearRemainTimeAndStopTimer];
            progress_hide
        } error:^{
            [self loseData];
            progress_hide
        } uuid:uuid code:self.verifyCodeField.text savedphone:[self userPhoneNumberMasked:NO]];

    }
    else {
        [Util toastStringOfLocalizedKey:@"tip.regainGettingValidationCode"];
    }
}


- (void)loseDataPostPhone {
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    
    //[self stopTimer];
    //[self validatecode_time_update];
}

- (void)connectToPostPHone {
    WS(weakSelf)
    
    progress_show
    NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
    [ZAPP.netEngine postPhoneAfterValidationWithComplete:^{
        //[self setDataPostPhone];
        progress_hide
        
        PhoneEdit *pro = ZEdit(@"PhoneEdit");
        [weakSelf.navigationController pushViewController:pro animated:YES];
        
    } error:^{
        [self loseDataPostPhone];
        progress_hide
    } savedphone:[self userPhoneNumberMasked:NO] regionCode:[self userNationality] validationCode:self.verifyCodeField.text validationUUID:uuid];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)handleKeyboardWillShow:(NSNotification *)notification {
    
    //当前是显示的，而且调整到键盘的上方
    //[UIView animateWithDuration:0.2 animations:^{
        
    //    self.bkView.top = -30;
        
    //}];
    
    self.bottomConsistant.constant = 240;
    
}

-(void)handleKeyboardWillHide:(NSNotification *)notification {
    
    
    //[UIView animateWithDuration:0.2 animations:^{
        
//        self.bkView.top = 0;
    
    //}];
    
    self.bottomConsistant.constant = 0;
    
}

- (void)stopTimer{
    [_getCodeTimer invalidate];
    _getCodeTimer = nil;
    
    _timerRepectCnt = 9999;
    [self validatecode_time_update];
}

- (void)startTimer{
    _getCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(validatecode_time_update) userInfo:nil repeats:YES];
    _timerRepectCnt = 0;
    //[_getCodeTimer fire];
}

@end
