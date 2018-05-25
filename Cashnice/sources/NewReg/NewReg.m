//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NewReg.h"
#import "WXApi.h"
#import "EditIntro.h"
#import "FabuJiekuanTableViewCell.h"
#import "FabuStep2.h"
#import "EditProvince.h"
#import "ValidcodeCell.h"
#import "NewReg2.h"
#import "WebDetail.h"
#import "WeiXinEngine.h"
#import "RegionPicker.h"
#import "PhoneEdit.h"
#import "UpdateManager.h"

@interface NewReg () <RegionPickerDelegate>{
	NSString *savedPhone;
	BOOL      alreadySent;
    NSArray  *quickArr;
    
    
    UITableView *quicktableview;
}
@property (strong, nonatomic) NSArray *                 nameArray;
@property (strong, nonatomic) NSArray *                 imageArray;
@property (weak, nonatomic)IBOutlet UITextField *               tf0;
@property (weak, nonatomic)IBOutlet UITextField *               tf1;
@property (strong, nonatomic) NextButtonViewController *next;

@property (strong, nonatomic) WeixinButton *wxButton;

@property (strong, nonatomic) MKNetworkOperation *op;

@property (weak, nonatomic) IBOutlet UIView *weixinButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UILabel *                 validateLabel;
@property (weak, nonatomic) IBOutlet UIButton *getValidationCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *weixinPromptLabel;
@property (weak, nonatomic) IBOutlet UIButton *userProtocolActionButton;
@property (weak, nonatomic) IBOutlet UILabel *agreeLable;
@property (weak, nonatomic) IBOutlet UIButton *loginActionButton;

@property (weak, nonatomic) IBOutlet UITextField *regionTextFileld;
@property (weak, nonatomic) IBOutlet UILabel *regionCodeLabel;

@property (strong, nonatomic) UIView *pickerAccessoryView;
@property (strong, nonatomic) RegionPicker *regionPicker;
@property (assign, nonatomic) NSInteger selectedRegionCode;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;

//@property (strong, nonatomic) UITableView *quickTableView;

@end

@implementation NewReg
- (void)viewDidLoad {
	[super viewDidLoad];

    //self.view.backgroundColor = ZCOLOR(COLOR_BG_WHITE);
    
    BOOL wxInstalled = [WXApi isWXAppInstalled];
    self.weixinButtonView.hidden = !wxInstalled;
    self.navigationController.navigationBarHidden = YES;
    
    self.lineHeightConstraint.constant = [ZAPP.zdevice getDesignScale:60];
    self.getValidationCodeButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
    self.getValidationCodeButton.layer.masksToBounds = YES;
    self.getValidationCodeButton.layer.borderWidth = 1;
    self.getValidationCodeButton.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
    self.getValidationCodeButton.titleLabel.textColor = ZCOLOR(COLOR_LIGHT_THEME);
    
    self.loginActionButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
    self.loginActionButton.layer.masksToBounds = YES;
    self.loginActionButton.titleLabel.textColor = [UIColor whiteColor];
    self.loginActionButton.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
    
    self.validateLabel.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    
    self.tf0.font =
    self.tf1.font =
    self.regionCodeLabel.font =
    self.regionTextFileld.font =
    self.validateLabel.font =
    self.weixinPromptLabel.font =
    self.userProtocolActionButton.titleLabel.font =
    self.getValidationCodeButton.titleLabel.font =
    self.agreeLable.font = [UtilFont systemLarge];
    
    self.loginActionButton.titleLabel.font = [UtilFont systemButtonTitle];
    
    self.tf0.keyboardType = self.tf1.keyboardType = UIKeyboardTypeNumberPad;
    self.tf0.clearButtonMode =  self.tf1.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.agreeButton.selected = NO ;
    
    self.headHeightConstraint.constant = [ZAPP.zdevice getDesignScale:180];
    
    self.selectedRegionCode = 86L;
    self.regionTextFileld.inputView = self.regionPicker;
    
    [self.regionTextFileld addTarget:self action:@selector(connectToGetSupportedRegion) forControlEvents:UIControlEventEditingDidBegin];
    
    self.regionTextFileld.inputAccessoryView = self.pickerAccessoryView;
    
    NSArray *regionArray = ZAPP.myuser.systemRegionArray;
    if (regionArray.count > 0) {
        NSDictionary *defaultRegion = regionArray[0];
        self.selectedRegionCode = [defaultRegion[@"code"] integerValue];
    }else{
        //无网 默认选🇨🇳
        self.regionCodeLabel.text = @"+86";
        self.regionTextFileld.text = @"中国";
    }
    
    [self systemRegionUpdate:nil];
    [self backviewTouchedGesture];
    
    [self resetThePage];
    
    
#ifdef DEBUG
    
    NSString *
    _appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];

    if ([_appName isEqualToString:@"com.cashnice.appTest"]) {
        quickArr  = @[@{@"name":@"刘子瑞",@"phone":@"18766124841"},
                      @{@"name":@"李晓云",@"phone":@"13093846896"},
                      @{@"name":@"徐海洋",@"phone":@"13067948401"},
                      @{@"name":@"于娟",@"phone":@"13148379349"}];
        [self addDebugChangeUserQuick];
        
    }
    
#endif
    
#ifndef HUBEI
    self.logoImgView.image = [UIImage imageNamed:@"usr_logo"];
#else
    self.logoImgView.image = [UIImage imageNamed:@"usr_hb_logo"];
    
#endif
    
    

    
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[MobClick beginLogPageView:@"登录"];
    
    [self setNavButton];
    
    self.wxButton.view.hidden = NO;
    //[ZAPP.zvalidation clearRemainTimeAndStopTimer];
    //[self validatecode_time_update];
    
	[self hide];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self hide];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
	[self validatecode_time_update];
	[self didChanged:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixin_login_suc:) name:MSG_weixin_login_suc object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemRegionUpdate:) name:MSG_system_region_update object:nil];
    
    UpdateTrigger
    
//    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    
//    if (! ZAPP.myuser.systemRegionArray) {
//        progress_show
//        [ZAPP.netEngine getSupportedRegionWithComplete:^{
//            progress_hide
//            [self systemRegionUpdate:nil];
//        } error:^{
//            progress_hide;
//        }];
//    }
}

- (void)systemRegionUpdate:(NSNotification *)ntf {
    NSArray *regionArray = ZAPP.myuser.systemRegionArray;
    
    for (NSDictionary *dict in regionArray) {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == self.selectedRegionCode) {
            NSString *name = dict[@"name"];
            self.regionCodeLabel.text = [NSString stringWithFormat:@"+%zd", self.selectedRegionCode];
            self.regionTextFileld.text = name ;
        }
    }
}

- (void)weixin_login_suc:(NSNotification *)ntf {
	[self connectToLoginByWeixin];
}

- (void)setDataLoginByWeixin {
	if ([ZAPP.zlogin hasSavedPhone]) {
		savedPhone = [ZAPP.zlogin getSavedPhone];
        
        self.selectedRegionCode = [ZAPP.zlogin getRegionCode];
        
		//[self connectToLoginByPhone];
        [self setDataLoginByPhone];
	}
	else {
        //绑定手机号
        [self resetValidateCode];
        self.tf0.text = @"";
        self.tf1.text = @"";
        
        self.navigationController.navigationBarHidden =NO;
        NewReg2 *vc = ZSTORY(@"NewReg2");
        [self.navigationController pushViewController:vc animated:YES];
	}
}
- (IBAction)agreeAction:(UIButton *)sender {
    self.agreeButton.selected = !self.agreeButton.selected;
}

- (IBAction)weixinLoginAction:(id)sender {
//    WeiXinEngine *_wxEngine = [[WeiXinEngine alloc] initWithHostName:WEIXIN_SERVER_URL];
//    [_wxEngine accessToken:@"001fc28947c9c9618a6a721833c2c35v" compeletionHandler:^{
//        //        [_wxEngine getInfoWithCompeletionHandler:^{
//        //            [Util dispatch:MSG_weixin_login_suc];
//        //        } errorHandler:nil];
//    } errorHandler:nil];
//    return;
    
    if (!self.agreeButton.selected) {

        [Util toastStringOfLocalizedKey:@"tip.agreementProtocal"];
        return;
    }
    [self weixinButtonPressed];
}
- (IBAction)userProtocolAction:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    WebDetail *s = ZSTORY(@"WebDetail");
    s.webType = WebDetail_RegProtocol;
    [self.navigationController pushViewController:s animated:YES];
}

- (void)loseData {
//	[ZAPP clearCache];
	[ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [self validatecode_time_update];
}

// 微信登录
- (void)connectToLoginByWeixin {
	[self.op cancel];
    _isNavigationBack = NO;
	bugeili_net
	progress_show
    
    WS(weakSelf)

	self.op = [ZAPP.netEngine newloginToServerByWeixinWithComplete:^{
        [weakSelf setDataLoginByWeixin];
        progress_hide
    } error:^{
        [weakSelf loseData];
        progress_hide
    } regionCode:self.selectedRegionCode];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[MobClick endLogPageView:@"登录"];

	[self hide];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)validatecode_time_update {
    int t =  [ZAPP.zvalidation getRemainTime]; //[ZAPP.zvalidation getRemainTimeWithTotaltime:120];//
	if (t <= 0) {
		self.getValidationCodeButton.enabled = YES;
		self.validateLabel.hidden   = YES;
		[self.getValidationCodeButton setTitle:(alreadySent ? @"重新获取" : @"获取验证码") forState:UIControlStateNormal];
        self.getValidationCodeButton.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
	}
	else {
		self.getValidationCodeButton.enabled = NO;
		self.validateLabel.hidden   = NO;
		alreadySent                 = YES;
        self.validateLabel.text = [NSString stringWithFormat:@"%d秒后重发", t];
        [self.getValidationCodeButton setTitle:@"" forState:UIControlStateNormal];
        self.getValidationCodeButton.layer.borderColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY).CGColor;
	}
}

- (IBAction)sendPressed {
	[self.view endEditing:YES];

    if (self.tf0.text.length < 1) {
        [Util toastStringOfLocalizedKey:@"tip.inputingPhoneNumber"];
        return;
    }
	savedPhone = self.tf0.text;

//    [ZAPP.zvalidation sendPhoneCode:self.tf0.text withComplete:nil error:nil];
    [ZAPP.zvalidation sendPhoneCode:self.tf0.text withRegionCode:self.selectedRegionCode Complete:nil error:nil];
	[self validatecode_time_update];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate    = self;
		((NextButtonViewController *)[segue destinationViewController]).titleString = @"登录";
		self.next                                                                   =        ((NextButtonViewController *)[segue destinationViewController]);
	}
	else if ([[segue destinationViewController] isKindOfClass:[WeixinButton class]]) {
		((WeixinButton *)[segue destinationViewController]).delegate = self;
		self.wxButton                                                = (WeixinButton *)[segue destinationViewController];
	}
}

- (void)resetThePage {
    [self.view endEditing:YES];
    [self.wxButton.view setHidden:NO];
    [self resetValidateCode];           //added by cc to refresh resend button
}

- (void)resetValidateCode {
    savedPhone = nil;
    alreadySent = NO;
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [self validatecode_time_update];
}

- (IBAction)nextButtonPressed {    
    //点击登录按钮

	[self.view endEditing:YES];

    if (self.selectedRegionCode < 1) {
        [Util toastStringOfLocalizedKey:@"tip.selectionRegion"];
        return;
    }
    
    if (self.tf0.text.length < 1) {
        [Util toastStringOfLocalizedKey:@"tip.inputingPhoneNumber"];
        return;
    }
    /**
     *  用于App Store审核的账户
     */
    if (([self.tf0.text isEqualToString:@"13717600884"] || [self.tf0.text isEqualToString:@"18264153825"] )  && [self.tf1.text isEqualToString:@"999999"]) {
        savedPhone = self.tf0.text;
        [self connectToLoginByPhone4Ttest];
        return;
    }
    
#ifdef TEST_LOGIN_WITHOUT_VALIDATION_CODE
    
	savedPhone = self.tf0.text;
	if (self.wxButton.view.hidden) {
//		[self connectToBindPhone];
	}
	else {
		[self connectToLoginByPhone4Ttest];

	}
	return;
#endif

	if ([savedPhone notEmpty]) {
	}
	else {
		[Util toastStringOfLocalizedKey:@"tip.gettingValidationCode"];
		return;
	}

	if (![Util isValidCode:self.tf1.text]) {
        [Util toastStringOfLocalizedKey:@"tip.inputingRightSMSCode"];
		return;
	}

    if (! [savedPhone notEmpty]) {
        [Util toastStringOfLocalizedKey:@"tip.PNregainGettingValidationCode"];
        return;
    }
    
    if (!self.agreeButton.selected) {
        [Util toastStringOfLocalizedKey:@"tip.agreementProtocal"];
        return;
    }
    

	NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
	if (uuid != nil && uuid.length == 32) {
		//[self connectToCommitPhoneAndCode:uuid code:self.tf1.text];
        //不单独验证验证码
        [self connectToLoginByPhone];
	}
	else {
        [Util toastStringOfLocalizedKey:@"tip.regainGettingValidationCode"];
	}
}

- (void)setDataLoginByPhone {
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    self.navigationController.navigationBarHidden = NO;
    [ZAPP changeLoginToTabs];
}

- (void)connectToLoginByPhone {
    NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
    _isNavigationBack = NO;
    //self.loginActionButton.titleLabel.text = @"处理中";
    progress_show
    
    WS(weakSelf)
    
    self.op = [ZAPP.netEngine newloginToServerByPhone:savedPhone regionCode:self.selectedRegionCode validationCode:self.tf1.text validationUUID:uuid complete:^{
        //self.loginActionButton.titleLabel.text = @"登录";
        [weakSelf setDataLoginByPhone];
        progress_hide
    } error:^{
        //self.loginActionButton.titleLabel.text = @"登录";
        [weakSelf loseData];
        progress_hide
    }];
}

- (void) connectToLoginByPhone4Ttest {
    
    WS(weakSelf)

    self.op = [ZAPP.netEngine newloginToServerByPhone4Test:savedPhone regionCode:self.selectedRegionCode complete:^{
        [weakSelf setDataLoginByPhone];
        progress_hide} error:^{
            [weakSelf loseData]; progress_hide
        }];
}

- (void)setDataBindPhone {
	[self setDataLoginByPhone];
}

- (void)setData {
	int res = [[ZAPP.myuser.checkValidateCodeRespondDict objectForKey:NET_KEY_RESULT] intValue];
	if (res == 1) {
		[self connectToLoginByPhone];
	}
	else {
		progress_hide
        [Util toastStringOfLocalizedKey:@"tip.ValidationCodeError"];
	}
}

- (void)connectToCommitPhoneAndCode:(NSString *)uuid code:(NSString *)code {
    
    WS(weakSelf)
    
	[self.op cancel];
	bugeili_net
	if ([savedPhone notEmpty]) {
        _isNavigationBack = NO;
		progress_show
		self.op = [ZAPP.netEngine checkValidateCodeWithComplete:^{[weakSelf setData]; } error:^{[weakSelf loseData]; progress_hide} uuid:uuid code:code savedphone:savedPhone];
	}
}

- (void)connectToGetSupportedRegion{

    if (! ZAPP.myuser.systemRegionArray) {
        
        WS(weakSelf)
        
        [ZAPP.netEngine getSupportedRegionWithComplete:^{
            [weakSelf.regionPicker reloadComponent:0];
        } error:^{
            ;
        }];
    }else{
        [self.regionPicker reloadComponent:0];
    }
    
}

- (void)RegionPicker:(RegionPicker *)picker didSelectRegionWithName:(NSString *)name code:(NSString *)code{
    self.regionTextFileld.text = name;
    self.regionCodeLabel.text = [NSString stringWithFormat:@"+%@", code];
    self.selectedRegionCode = [code integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == quicktableview){
        return quickArr.count;
    }
    
	return 2;
}
- (BOOL)lastRow:(NSInteger)row {
	return row == 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ZAPP.zdevice getDesignScale:44];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return [ZAPP.zdevice getDesignScale:20];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}

- (NSArray *)imageArray {
	if (_imageArray == nil) {
		_imageArray =@[@"phone", @"code"];
	}
	return _imageArray;
}
- (NSArray *)nameArray {
	if (_nameArray == nil) {
		_nameArray = @[@"请输入手机号", @"请输入短信验证码"];
	}
	return _nameArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == quicktableview) {
        NSString *cellid=@"cell_id";
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        NSDictionary *dic = quickArr[indexPath.row];
        cell.textLabel.text = dic[@"name"];
        cell.detailTextLabel.text = dic[@"phone"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
	if (indexPath.row == 0) {
		FabuJiekuanTableViewCell *cell;
		static NSString *         CellIdentifier = @"cell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		cell.txtImg.hidden   = NO;
		cell.moneyImg.hidden = YES;
		[cell.tf setEnabled:YES];

		cell.sepLine.hidden = [self lastRow:indexPath.row];
		cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
		cell.tf.delegate    = self;

		cell.txtImg.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
		cell.detail.text  = @"";
		NSString *str = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_PHONE];
		if (!ISNSNULL(str) && [str notEmpty]) {
			cell.tf.text = str;
		}
		else {
			cell.tf.text = @"";
		}
		cell.tf.keyboardType    = UIKeyboardTypeNumberPad;
		cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
		self.tf0                = cell.tf;
		[self didChanged:nil];


		return cell;
	}

	else {
		ValidcodeCell *cell;
		cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];

		[cell.tf setEnabled:YES];

		cell.sepLine.hidden = [self lastRow:indexPath.row];
		cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
		cell.tf.delegate    = self;

		cell.txtImg.image       = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
		cell.tf.keyboardType    = UIKeyboardTypeNumberPad;
		cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
		cell.delegate           = self;

		self.tf1            = cell.tf;
		self.getValidationCodeButton = cell.validButton;
		self.validateLabel  = cell.validLabel;
		[self validatecode_time_update];

		[self didChanged:nil];

		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == quicktableview) {
        
        NSDictionary *dic = quickArr[indexPath.row];
        NSString *phone = dic[@"phone"];
        self.tf0.text = phone;
//        savedPhone = phone;
        [self nextButtonPressed];
    }
}

- (void)backviewTouchedGesture{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backviewTouched:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}

-(void)backviewTouched:(UITapGestureRecognizer*)tap1{
    [self.view endEditing:YES];
    
}
- (IBAction)dismissKeyboard:(id)sender {
	//[self hide];
}

- (void)hide {
	[self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)didChanged:(id)sender {
	[self.next setTheEnabled:YES];
}

- (void)weixinButtonPressed {
    [self.view endEditing:YES];
	[ZAPP loginToWeiXin];
}

- (UIView *)pickerAccessoryView{
    if (! _pickerAccessoryView) {
        _pickerAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        _pickerAccessoryView.backgroundColor = ZCOLOR(@"#EEEEEE");
        
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _pickerAccessoryView.width, 1)];
        separateLine.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
        [_pickerAccessoryView addSubview:separateLine];

        UIButton *doneButton = [[UIButton alloc] init];
        doneButton.titleLabel.font = [UtilFont systemLarge];
        [doneButton setTitleColor:ZCOLOR(COLOR_LIGHT_THEME) forState:UIControlStateNormal];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [doneButton sizeToFit];
        doneButton.left = (_pickerAccessoryView.width - doneButton.width - [ZAPP.zdevice getDesignScale:10]);
        [doneButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [_pickerAccessoryView addSubview:doneButton];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.titleLabel.font = [UtilFont systemLarge];
        [cancelButton setTitleColor:ZCOLOR(COLOR_LIGHT_THEME) forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton sizeToFit];
        cancelButton.left = [ZAPP.zdevice getDesignScale:10];
        [cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [_pickerAccessoryView addSubview:cancelButton];
        
        UILabel *prompt = [[UILabel alloc] init];
        prompt.text = @"请选择地区";
        prompt.font = [UtilFont systemLarge];
        [prompt sizeToFit];
        prompt.center = _pickerAccessoryView.center;
        [_pickerAccessoryView addSubview: prompt];
    }
    return _pickerAccessoryView;
}

- (RegionPicker *)regionPicker{
    if (! _regionPicker) {
        CGFloat pickerHeight = [ZAPP.zdevice getDesignScale:160];
        _regionPicker = [[RegionPicker alloc] initWithFrame:CGRectMake(0, 0, 320, pickerHeight)];
        //[_regionPicker setSelectedRegionCode:[NSString stringWithFormat:@"%ld", 60L]];
        _regionPicker.delegate = self;
        _regionPicker.backgroundColor = [UIColor whiteColor];
    }
    return _regionPicker;
}

-(void)addDebugChangeUserQuick{
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popGes)];
    tapGes.numberOfTapsRequired = 1;
    self.logoImgView.userInteractionEnabled = YES;
    [self.logoImgView addGestureRecognizer:tapGes];

    
}

-(void)popGes{
    
    if (!quicktableview) {
        quicktableview = [[UITableView alloc] initWithFrame:CGRectMake(10, 200, MainScreenWidth - 20, 250)style:UITableViewStylePlain];
        quicktableview.delegate = self;
        quicktableview.dataSource = self;
        quicktableview.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:quicktableview];
    }else{
        quicktableview.delegate = nil;
        quicktableview.dataSource = nil;
        [quicktableview removeFromSuperview];
        quicktableview= nil;
    }
    

    
}



@end
