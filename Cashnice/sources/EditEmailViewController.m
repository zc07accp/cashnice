//
//  EditEmailViewController.m
//  Cashnice
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "EditEmailViewController.h"
#import "VerifyEngine.h"

@interface EditEmailViewController (){
    BOOL alreadySent;
    UILabel *_timerLabel;
}
@property (strong,nonatomic) VerifyEngine *engine;
@property (strong,nonatomic) NSString *validateuuid;

@end

@implementation EditEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];

    self.title = @"邮箱";
    // Do any additional setup after loading the view.
    
//    self.emailField.delegate = self;
//    self.verifyCodeField.delegate = self;
    
    self.getCodeBtn.layer.cornerRadius =3;
    self.getCodeBtn.layer.borderColor = HexRGB(0x3399ff).CGColor;
    self.getCodeBtn.titleLabel.textColor = HexRGB(0x3399ff);
    self.getCodeBtn.titleLabel.font = [UtilFont systemLargeNormal];
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
}

- (void)setupUI{
    
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    _timerLabel.font = [UtilFont systemLarge];
    _confirmActionBtn.titleLabel.font = [UtilFont systemButtonTitle];
    
    CGFloat spaceWidth = [ZAPP.zdevice getDesignScale:10];
    
    [_getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.emailField);
        //make.right.equalTo(self.view).mas_offset(-spaceWidth);
        make.right.equalTo(self.sperateLineView);
        make.width.equalTo(_confirmActionBtn);
    }];
    
    [_confirmActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyCodeField.mas_bottom).mas_offset(3*spaceWidth);
        make.right.equalTo(_getCodeBtn);
        make.width.mas_equalTo(10 * spaceWidth);
    }];
    
    self.confirmActionBtn.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    
    
    if (ScreenInch4s) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    

    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)validatecode_time_update {
    int t = [ZAPP.zvalidation getRemainTime];
    if (t <= 0) {
        self.getCodeBtn.enabled = YES;
        _timerLabel.hidden   = YES;
        [self.getCodeBtn setTitle:(alreadySent ? @"重新获取" : @"获取验证码") forState:UIControlStateNormal];
        self.getCodeBtn.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
    }
    else {
        self.getCodeBtn.enabled = NO;
        alreadySent                 = YES;
        _timerLabel.hidden   = NO;
        _timerLabel.text = [NSString stringWithFormat:@"%d秒后重发", t];
        [self.getCodeBtn setTitle:@"" forState:UIControlStateNormal];
        self.getCodeBtn.layer.borderColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY).CGColor;
    }
}
- (IBAction)closeKeyb:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)inputChanged:(id)sender {
    NSString *inputedEmail = self.emailField.text;
    NSString *inputedCode = _verifyCodeField.text;
    if (inputedCode.length > 0 && inputedEmail.length > 0) {
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *)trimedEmail{
    //[self.emailField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [self.emailField.text trimmed];
}

- (IBAction)getCode:(id)sender {
    
    [self dismissKeyboard];
    
    if ([self trimedEmail].length == 0) {
        [Util toast:@"请输入您的邮箱"];
        return;
    }
    
    if (![Util isValidEmail:[self trimedEmail]]) {
        [Util toast:@"请输入正确的邮箱"];
        return;
    }
    
    [ZAPP.zvalidation startTimer];
    WS(weakSelf)
    [self.engine getEmailVerifyCode:[self trimedEmail] success:^(NSString *validateuuid) {
        [Util toastStringOfLocalizedKey:@"tip.ValidationCodeHasSend"];;
        weakSelf.validateuuid = validateuuid;
    } failure:^(NSString *error) {
        
        [ZAPP.zvalidation clearRemainTimeAndStopTimer];
        [self validatecode_time_update];
    }];
}

- (IBAction)sureAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (![Util isValidCode:self.verifyCodeField.text]) {
        [Util toastStringOfLocalizedKey:@"tip.gettingValidationCode"];
        return;
    }
    
    WS(weakSelf)
    progress_show
    [self.engine verifyCode:[self trimedEmail]
               validateuuid:self.validateuuid
               validatecode:self.verifyCodeField.text success:^() {
                   
                   [ZAPP.netEngine getUserInfoWithComplete:^{
                       progress_hide
                       [weakSelf.navigationController popViewControllerAnimated:YES];
                   } error:^{
                       progress_hide
                   }];
               } failure:^(NSString *error) {
                   progress_hide
                   [ZAPP.zvalidation clearRemainTimeAndStopTimer];
                   [self validatecode_time_update];
               }];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)handleKeyboardWillShow:(NSNotification *)notification {
    
    //当前是显示的，而且调整到键盘的上方
    [UIView animateWithDuration:0.2 animations:^{

        self.bkView.top = -30;

    }];
    
}

-(void)handleKeyboardWillHide:(NSNotification *)notification {
    
    
    [UIView animateWithDuration:0.2 animations:^{

        self.bkView.top = 0;
    }];
    
}



@end
