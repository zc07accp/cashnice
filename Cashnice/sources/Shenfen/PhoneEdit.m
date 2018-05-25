//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "PhoneEdit.h"
#import "EditIntro.h"
#import "PhoneEditCell.h"
#import "PhoneNumberCell.h"
#import "FabuStep2.h"
#import "EditProvince.h"
#import "ValidcodeCell.h"
#import "RegionPicker.h"
#import "CNActionButton.h"
#import "GetUserInfoEngine.h"
#import "NewPersonDetailViewController.h"

@interface PhoneEdit ()<RegionPickerDelegate> {
	NSString *savedPhone;
    BOOL alreadySent;
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

@property (strong, nonatomic) PhoneEditCell *regionCell;
@property (strong, nonatomic) PhoneNumberCell *phoneCell;
@property (weak, nonatomic) UILabel *regionCodeLabel;

@property (strong, nonnull) NSString *phone;

@property (weak, nonatomic) IBOutlet CNActionButton *saveButton;
@property (assign, nonatomic) NSInteger selectedRegionCode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConsistant;

@end

@implementation PhoneEdit

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	//self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
	self.table.allowsSelection = NO;
    
    NSDictionary *infoDict = ZAPP.myuser.gerenInfoDict;
    NSInteger nationality = [infoDict[@"nationality"] integerValue];
    //NSString * phone = infoDict[@"phone"];
    //self.phone = phone;
    
    if (nationality) {
        self.selectedRegionCode = nationality;
    }
    [self backviewTouchedGesture];
}

- (void)setSelectedRegionCode:(NSInteger)selectedRegionCode {
    _selectedRegionCode = selectedRegionCode;
    [self.regionPicker setSelectedRegionCode:[NSString stringWithFormat:@"%ld", (long)_selectedRegionCode]];
}


BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"修改手机号"];
	[self setTitle:@"修改手机号码"];
	
	[self dismissKeyboard:nil];

	[ZAPP.zvalidation clearRemainTimeAndStopTimer];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self dismissKeyboard:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[self setSendCodeEnable: NO];
	[self didChanged:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"修改手机号"];

	[self dismissKeyboard:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[ZAPP.zvalidation clearRemainTimeAndStopTimer];
}

- (void)validatecode_time_update {
	int t = [ZAPP.zvalidation getRemainTime];
	if (t <= 0) {
		[self setSendCodeEnable: YES];
		self.validateLabel.hidden   = YES;
        [self.validateButton setTitle:(alreadySent? @"重新获取" : @"获取验证码") forState:UIControlStateNormal];
	}
	else {
		[self setSendCodeEnable: NO];
		self.validateLabel.hidden   = NO;
        alreadySent = YES;
		self.validateLabel.text     = [NSString stringWithFormat:@"%d秒后重发", t];
	}
}

- (void)setSendCodeEnable:(BOOL)enable{
    self.validateButton.enabled = enable;
    self.validateLabel.hidden   = enable ? YES : NO;
    self.validateLabel.text     = @"获取验证码";
    self.validateButton.layer.borderColor = enable?ZCOLOR(COLOR_LIGHT_THEME).CGColor : ZCOLOR(COLOR_TEXT_LIGHT_GRAY).CGColor;
    //[self.validateButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)sendPressed {
	//[self.view endEditing:YES];

    if (self.tf0.text.length < 1) {

        [Util toastStringOfLocalizedKey:@"tip.inputingPhoneNumber"];
        return;
    }

	savedPhone = self.tf0.text;

    [ZAPP.zvalidation sendPhoneCode:self.tf0.text withRegionCode:self.selectedRegionCode Complete:^(){
        alreadySent = YES;
    }error:nil];
    
	[self validatecode_time_update];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate    = self;
		((NextButtonViewController *)[segue destinationViewController]).titleString = @"保存";
		self.next                                                                   =        ((NextButtonViewController *)[segue destinationViewController]);
	}
}

- (void)backviewTouchedGesture{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backviewTouched:)];
    tap1.cancelsTouchesInView = NO;
    //tap1.delegate = self;
    [self.view addGestureRecognizer:tap1];
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[UIButton class]])
//    {
//        return NO;
//    }
////    else if ([touch.view isKindOfClass:[UITableView class]])
////    {
////        return NO;
////    }
//    return YES;
//}
-(void)backviewTouched:(UITapGestureRecognizer*)tap1{
    [self dismissKeyboard:nil];
}

- (IBAction)nextButtonPressed {
    //[self.view endEditing:YES];

#ifndef TEST_MODIFY_PHONENUM
    
    if (self.tf0.text.length < 1) {
        //验证手机号输入
        [Util toastStringOfLocalizedKey:@"tip.inputingPhoneNumber"];
        return;
    }
    
    if (![savedPhone notEmpty]) {
        //先获取验证码
        [Util toastStringOfLocalizedKey:@"tip.gettingValidationCode"];
        return;
    }
    
	if (![self.tf0.text isEqualToString:savedPhone]) {
        //手机号改变，获取验证码
        [Util toastStringOfLocalizedKey:@"tip.PNregainGettingValidationCode"];
		return;
	}
    
    if (![Util isValidCode:self.tf1.text]) {
        //验证验证码输入
        [Util toastStringOfLocalizedKey:@"tip.inputingRightSMSCode"];
        return;
    }
    
	NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
	if (uuid != nil && uuid.length == 32) {
		//[self connectToCommitPhoneAndCode:uuid code:self.tf1.text];
        //不再单独验证验证码,提交时传入验证码
        [self connectToPostPHone];
	}
	else {

        [Util toastStringOfLocalizedKey:@"tip.regainGettingValidationCode"];
	}
#else
    savedPhone = self.tf0.text;
    [self connectToPostPHone];
#endif
}

- (void)setDataPostPhone {

    
    
    POST_USERINFOFRESH_NOTI;
    
    
    [Util toastStringOfLocalizedKey:@"tip.PhoneNumberCheckSuccess"];
	
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[NewPersonDetailViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loseDataPostPhone {
    //提交失败情况：可否重发验证码
    //[ZAPP.zvalidation clearRemainTimeAndStopTimer];
    //[self validatecode_time_update];
}

- (void)connectToPostPHone {
    progress_show
    NSString *uuid = [ZAPP.myuser.sendValidateCodeRespondDict objectForKey:NET_KEY_VALIDATEUUID];
    self.op = [ZAPP.netEngine postPhoneAfterValidationWithComplete:^{[self setDataPostPhone]; progress_hide} error:^{[self loseDataPostPhone]; progress_hide} savedphone:savedPhone regionCode:self.selectedRegionCode validationCode:self.tf1.text validationUUID:uuid];
}

- (void)setData {
	int res = [[ZAPP.myuser.checkValidateCodeRespondDict objectForKey:NET_KEY_RESULT] intValue];
	if (res == 1) {
        [self connectToPostPHone];
	}
	else {
        [Util toastStringOfLocalizedKey:@"tip.ValidationCodeError"];
	}
}

- (void)loseData {

}

- (void)connectToCommitPhoneAndCode:(NSString *)uuid code:(NSString *)code {
	[self.op cancel];
	bugeili_net
	if ([savedPhone notEmpty]) {
        progress_show
		self.op = [ZAPP.netEngine checkValidateCodeWithComplete:^{[self setData]; progress_hide} error:^{[self loseData]; progress_hide} uuid:uuid code:code savedphone:savedPhone];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (BOOL)lastRow:(NSInteger)row {
	return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ZAPP.zdevice getDesignScale:60];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return [ZAPP.zdevice getDesignScale:0];
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
		_imageArray =@[@"",@"phone", @"code"];
	}
	return _imageArray;
}
- (NSArray *)nameArray {
	if (_nameArray == nil) {
		_nameArray = @[@"",@"手机号码", @"输入短信验证码"];
	}
	return _nameArray;
}

- (void)RegionPicker:(RegionPicker *)picker didSelectRegionWithName:(NSString *)name code:(NSString *)code{
    self.regionCell.regionTextFileld.text = name;
    
    self.regionCodeLabel.text = [NSString stringWithFormat:@"+%@", code];
    if ([code integerValue] > 0) {
        self.selectedRegionCode = [code integerValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
/*
    if (indexPath.row == 0) {
        PhoneEditCell * cell;
        static NSString *         CellIdentifier = @"cell0";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.regionTextFileld.inputView = self.regionPicker;
        cell.regionTextFileld.inputAccessoryView = self.pickerAccessoryView;

        NSArray *regionArray = ZAPP.myuser.systemRegionArray;
        for (NSDictionary *dict in regionArray) {
            NSInteger code = [dict[@"code"] integerValue];
            if (code == self.selectedRegionCode) {
                cell.regionTextFileld.text = dict[@"name"];
            }
        }
//        if (regionArray.count > 0) {
//            cell.regionTextFileld.text = regionArray[0][@"name"] ;
//        }
        
        self.regionCell = cell;
        return cell;
    }else
        */
        if (indexPath.row == 1) {
        //输入验证码 cell
		PhoneNumberCell *cell;
		static NSString *         CellIdentifier = @"cell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        self.tf1 = cell.phoneNumberCell;
        [self.tf1 addTarget:self action:@selector(inputChanged) forControlEvents:UIControlEventEditingChanged];
        
        self.phoneCell = cell;
		return cell;
	}else{
        //输入手机号，发送验证码cell
		ValidcodeCell *cell;
		cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];

		[cell.tf setEnabled:YES];

		cell.sepLine.hidden = [self lastRow:indexPath.row];
		//cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
		cell.tf.delegate    = self;

		cell.txtImg.image       = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
		cell.tf.keyboardType    = UIKeyboardTypeNumberPad;
		cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
		cell.delegate           = self;

		self.tf0            = cell.tf;
		self.validateButton = cell.validButton;
		self.validateLabel  = cell.validLabel;
        self.tf0.text = self.phone;
        [self.tf0 addTarget:self action:@selector(inputChanged) forControlEvents:UIControlEventEditingChanged];
        
        cell.validButton.titleLabel.font =
        cell.validLabel.font = [UtilFont systemLargeNormal];
        
        self.validateButton.titleLabel.font = [UtilFont systemLarge];
        self.validateButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
        self.validateButton.layer.masksToBounds = YES;
        self.validateButton.layer.borderWidth = 1;
        self.validateButton.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
        self.validateButton.titleLabel.textColor = ZCOLOR(COLOR_LIGHT_THEME);
        
        
        
        NSArray *regionArray = ZAPP.myuser.systemRegionArray;
        if (regionArray.count > 0) {
            cell.regionCodeLabel.text = [NSString stringWithFormat:@"+%ld",self.selectedRegionCode];
        }
        self.regionCodeLabel = cell.regionCodeLabel;
        
		[self validatecode_time_update];

		[self didChanged:nil];

		return cell;
	}
}

- (IBAction)dismissKeyboard:(id)sender {
	[self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)inputChanged{
    
    if ([ZAPP.zvalidation getRemainTime] <= 0) {
        if (self.tf0.text.length > 0) {
            [self setSendCodeEnable:YES];
        }else{
            [self setSendCodeEnable:NO];
        }
    }
    
    if (self.tf1.text.length > 0 && self.tf0.text.length > 0) {
        self.saveButton.enabled = YES;
    }else{
        self.saveButton.enabled = NO;
    }
}

- (IBAction)didChanged:(id)sender {
	//  [self.next setTheEnabled:[self.tf0.text notEmpty] && [self.tf1.text notEmpty]];
}


- (void)handleKeyboardWillShow:(NSNotification *)notification {
    
    //当前是显示的，而且调整到键盘的上方
    //[UIView animateWithDuration:0.2 animations:^{
    
    //    self.bkView.top = -30;
    
    //}];
    
    self.bottomConsistant.constant = 260;
    
}

-(void)handleKeyboardWillHide:(NSNotification *)notification {
    
    
    //[UIView animateWithDuration:0.2 animations:^{
    
    //        self.bkView.top = 0;
    
    //}];
    
    self.bottomConsistant.constant = 0;
    
}
- (void)systemRegUpdate:(NSNotification *)ntf {
    NSArray *regionArray = ZAPP.myuser.systemRegionArray;
    if (regionArray.count > 0) {
        self.selectedRegionCode = [regionArray[0][@"code"] longValue];
        //        self.regionCodeLabel.text = [NSString stringWithFormat:@"+%ld", self.selectedRegionCode];
        //        self.regTextFileld.text = regionArray[0][@"name"] ;
    }
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
        [doneButton addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
        [_pickerAccessoryView addSubview:doneButton];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.titleLabel.font = [UtilFont systemLarge];
        [cancelButton setTitleColor:ZCOLOR(COLOR_LIGHT_THEME) forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton sizeToFit];
        cancelButton.left = [ZAPP.zdevice getDesignScale:10];
        [cancelButton addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
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

- (void)hidePicker{
    [self.view endEditing:YES];
}

@end
