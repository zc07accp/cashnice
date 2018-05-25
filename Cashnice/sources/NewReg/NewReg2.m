//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NewReg2.h"
#import "WXApi.h"
#import "EditIntro.h"
#import "PhoneNumberCell.h"
#import "FabuStep2.h"
#import "EditProvince.h"
#import "ValidcodeCell.h"
#import "NewReg2cell.h"
#import "RegionPicker.h"
#import "ProtocolCell.h"
#import "WebDetail.h"

@interface NewReg2 ()<RegionPickerDelegate> {
	NSString *savedPhone;
	BOOL      alreadySent;
}

@property (strong, nonatomic) NSArray *                 nameArray;
@property (strong, nonatomic) NSArray *                 imageArray;
@property (strong, nonatomic) IBOutlet UITableView *    table;
@property (weak, nonatomic) UITextField *               tf0;
@property (weak, nonatomic) UITextField *               tf1;
@property (strong, nonatomic) UIButton *                validateButton;
@property (strong, nonatomic) UILabel *                 validateLabel;
@property (strong, nonatomic) NextButtonViewController *next;
@property (strong, nonatomic) RegionPicker *regionPicker;
@property (strong, nonatomic) UIView *pickerAccessoryView;
@property (strong, nonatomic) MKNetworkOperation *op;


@property (strong, nonatomic) NewReg2cell *regionCell;
@property (strong, nonatomic) PhoneNumberCell *phoneCell;
@property (weak, nonatomic) UILabel *regionCodeLabel;

@property (weak, nonatomic) UIButton  *protocolCheckButton;
@property (assign, nonatomic) NSInteger selectedRegionCode;
@end

@implementation NewReg2

- (void)viewDidLoad {
	[super viewDidLoad];
    
	//self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
	self.table.allowsSelection = NO;
    self.title = @"绑定手机号";
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemRegUpdate:) name:MSG_system_region_update object:nil];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
    NSArray *regionArray = ZAPP.myuser.systemRegionArray;
    if (regionArray.count > 0) {
        NSDictionary *defaultRegion = regionArray[0];
        self.selectedRegionCode = [defaultRegion[@"code"] integerValue];
    }

}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[MobClick beginLogPageView:@"登录2"];
    
    [self setNavButton];
    
	[self hide];
    [self resetValidateCode];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
	[self validatecode_time_update];
	[self didChanged:nil];
}

- (void)loseData {
	[ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [self validatecode_time_update];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[MobClick endLogPageView:@"登录2"];

	[self hide];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[ZAPP.zvalidation clearRemainTimeAndStopTimer];
}

- (void)validatecode_time_update {
	int t = [ZAPP.zvalidation getRemainTime];
	if (t <= 0) {
		self.validateButton.enabled = YES;
		self.validateLabel.hidden   = YES;
		[self.validateButton setTitle:(alreadySent ? @"重新发送" : @"发送验证码") forState:UIControlStateNormal];
	}
	else {
		self.validateButton.enabled = NO;
		self.validateLabel.hidden   = NO;
		alreadySent                 = YES;
		self.validateLabel.text     = [NSString stringWithFormat:@"%d秒后重发", t];
	}
}

- (void)sendPressed {
	[self.view endEditing:YES];

    if (self.tf0.text.length < 1) {
        [Util toastStringOfLocalizedKey:@"tip.inputingPhoneNumber"];
        return;
    }

	savedPhone = self.tf0.text;
    alreadySent = YES;

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
}

- (void)resetValidateCode {
    savedPhone = nil;
    self.tf0.text = @"";
    self.tf1.text = @"";
    alreadySent = NO;
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [self validatecode_time_update];
}

- (void)nextButtonPressed {
	[self.view endEditing:YES];

    if (self.tf0.text.length < 1) {

        [Util toastStringOfLocalizedKey:@"tip.inputingPhoneNumber"];
        return;
    }

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

	if (![self.tf0.text isEqualToString:savedPhone]) {

        [Util toastStringOfLocalizedKey:@"tip.PNregainGettingValidationCode"];
		return;
	}
    
    if (! self.protocolCheckButton.selected) {

        [Util toastStringOfLocalizedKey:@"tip.agreementProtocal"];
        return;
    }

	NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
	if (uuid != nil && uuid.length == 32) {
		//[self connectToCommitPhoneAndCode:uuid code:self.tf1.text];
        //不单独验证验证码，直接发起登录请求
        [self connectToBindPhone];
	}
	else {

        [Util toastStringOfLocalizedKey:@"tip.regainGettingValidationCode"];
	}
}

- (void)setDataLoginByPhone {
    [ZAPP changeLoginToTabs];
}

- (void)connectToLoginByPhone {
    
    NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
    self.op = [ZAPP.netEngine newloginToServerByPhone:savedPhone validationCode:self.tf1.text validationUUID:uuid complete:^{[self setDataLoginByPhone]; progress_hide} error:^{[self loseData]; progress_hide}];
}

- (void)setDataBindPhone {
	[self setDataLoginByPhone];
}

- (void)connectToBindPhone {
	[self.op cancel];
	bugeili_net
	progress_show

	NSString *    scoi  = [ZAPP.zlogin getSocialAccountId];
	NSString *    token = [ZAPP.zlogin getSessionKey];
    if ([token notEmpty]) {
    }
    else {
        token = [ZAPP.zlogin getWeixinRefreshToken];
    }
    NSString *    nick  = [ZAPP.zlogin getNickName];
	NSString *    head  = [ZAPP.zlogin getHeaderUrl];

    NSString *code = self.tf1.text;
    NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
    
    self.op = [ZAPP.netEngine bindPhoneWithWeiXinAndLoginToServer:savedPhone socialid:scoi token:token nickname:nick headimg:head regionCode:self.selectedRegionCode validationCode:code validationUUID:uuid complete:^{
        [self setDataBindPhone];
        progress_hide
    } error:^{
        progress_hide
        [ZAPP.zvalidation clearRemainTimeAndStopTimer];
        [self validatecode_time_update];
    }];
}

- (void)setData {
	int res = [[ZAPP.myuser.checkValidateCodeRespondDict objectForKey:NET_KEY_RESULT] intValue];
	if (res == 1) {
        [self connectToBindPhone];
	}
	else {
		progress_hide
        [Util toastStringOfLocalizedKey:@"tip.ValidationCodeError"];
	}
}


- (void)connectToCommitPhoneAndCode:(NSString *)uuid code:(NSString *)code {
	[self.op cancel];
	bugeili_net
	if ([savedPhone notEmpty]) {
		progress_show
		self.op = [ZAPP.netEngine checkValidateCodeWithComplete:^{
            [self setData];
        } error:^{
            [self loseData];
            progress_hide
        } uuid:uuid code:code savedphone:savedPhone];
	}
}

- (void)systemRegionUpdate {
    NSArray *regionArray = ZAPP.myuser.systemRegionArray;
    if (regionArray.count > 0) {
        self.selectedRegionCode = [regionArray[0][@"code"] longValue];
    }
}

- (IBAction)regionTypeTouched:(id)sender {
    if ([sender isFirstResponder]) {
        if (_selectedRegionCode < 1) {
            [self.regionPicker pickerView:self.regionPicker didSelectRow:0 inComponent:0];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}
- (BOOL)lastRow:(NSInteger)row {
    return NO;
	//return row == 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ZAPP.zdevice getDesignScale:60];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return [ZAPP.zdevice getDesignScale:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.0;
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
		_imageArray =@[@"phone", @""];
	}
	return _imageArray;
}
- (NSArray *)nameArray {
	if (_nameArray == nil) {
		_nameArray = @[@"手机号", @"输入验证码"];
	}
	return _nameArray;
}

- (void)RegionPicker:(RegionPicker *)picker didSelectRegionWithName:(NSString *)name code:(NSString *)code{
    self.regionCell.regionTextFileld.text = name;
    self.regionCodeLabel.text = [NSString stringWithFormat:@"+%@", code];
    self.selectedRegionCode = [code integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.row == 0) {
        
        NewReg2cell *cell;
        static NSString *         CellIdentifier = @"cell0";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.regionTextFileld.inputView = self.regionPicker;
        cell.regionTextFileld.inputAccessoryView = self.pickerAccessoryView;
        
        
        NSArray *regionArray = ZAPP.myuser.systemRegionArray;
        if (regionArray.count > 0) {
            cell.regionTextFileld.text = regionArray[0][@"name"] ;
        }
        
        self.regionCell = cell;
        
        return cell;
    }
    */
    
    if (indexPath.row == 1) {
        //输入验证码Cell
		PhoneNumberCell *cell;
		static NSString *         CellIdentifier = @"cell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        cell.phoneNumberCell.font = [UtilFont systemLargeNormal];
        self.tf1 = cell.phoneNumberCell;
        self.phoneCell = cell;
        
//		cell.txtImg.hidden   = NO;
//		cell.moneyImg.hidden = YES;
//		[cell.tf setEnabled:YES];
//
//		cell.sepLine.hidden = [self lastRow:indexPath.row];
//		cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
//		cell.tf.delegate    = self;
//
//		cell.txtImg.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
//		cell.detail.text  = @"";
//		NSString *str = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_PHONE];
//		if (!ISNSNULL(str) && [str notEmpty]) {
//			cell.tf.text = str;
//		}
//		else {
//			cell.tf.text = @"";
//		}
//		cell.tf.keyboardType    = UIKeyboardTypeNumberPad;
//		cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
//		self.tf0                = cell.tf;
//		[self didChanged:nil];


		return cell;
    }else if (indexPath.row == 2){
        //用户协议Cell
        ProtocolCell *cell;
        static NSString *         CellIdentifier = @"ProtocolCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        cell.loginActionButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
        cell.loginActionButton.layer.masksToBounds = YES;
        cell.loginActionButton.titleLabel.textColor = [UIColor whiteColor];
        cell.loginActionButton.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
        cell.loginActionButton.titleLabel.font = [UtilFont systemButtonTitle];
        
        self.protocolCheckButton = cell.protocolCheckButton;
        [cell.protocolCheckButton addTarget:self action:@selector(protocolCheckAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.protocolDetailButton addTarget:self action:@selector(userProtocolAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.loginActionButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
	else  {
        //输入手机号Cell,发送验证码
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

        
        NSArray *regionArray = ZAPP.myuser.systemRegionArray;
        if (regionArray.count > 0) {
            cell.regionCodeLabel.text = [NSString stringWithFormat:@"+%ld",[regionArray[0][@"code"] longValue]];
            
        }
        self.regionCodeLabel = cell.regionCodeLabel;
		self.tf0            = cell.tf;
        
        cell.regionCodeLabel.font =
        cell.tf.font = [UtilFont systemLargeNormal];
        
		self.validateButton = cell.validButton;
		self.validateLabel  = cell.validLabel;
		[self validatecode_time_update];
        
        cell.validButton.titleLabel.font =
        cell.validLabel.font = [UtilFont systemLargeNormal];
        
        self.validateButton.titleLabel.font = [UtilFont systemLarge];
        self.validateButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
        self.validateButton.layer.masksToBounds = YES;
        self.validateButton.layer.borderWidth = 1;
        self.validateButton.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
        self.validateButton.titleLabel.textColor = ZCOLOR(COLOR_LIGHT_THEME);
        
        

		[self didChanged:nil];

		return cell;
	}
}

- (IBAction)protocolCheckAction :(UIButton *)sender {
    self.protocolCheckButton.selected = !self.protocolCheckButton.selected;
}

- (IBAction)userProtocolAction {
    self.navigationController.navigationBarHidden =NO;
    WebDetail *s = ZSTORY(@"WebDetail");
    s.webType = WebDetail_RegProtocol;
    [self.navigationController pushViewController:s animated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
	[self hide];
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

- (RegionPicker *)regionPicker{
    if (! _regionPicker) {
        CGFloat pickerHeight = [ZAPP.zdevice getDesignScale:160];
        _regionPicker = [[RegionPicker alloc] initWithFrame:CGRectMake(0, 0, 320, pickerHeight)];
        //[_regionPicker setSelectedRegionCode:[NSString stringWithFormat:@"%ld", 60L]];
        _regionPicker.delegate = self;
    }
    return _regionPicker;
}
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
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
@end
