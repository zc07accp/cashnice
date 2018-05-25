//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BindBank1.h"
#import "EditIntro.h"

#import "FabuJiekuanTableViewCell.h"
#import "BindBank2.h"
#import "BindBankPicker.h"
#import "ProgressIndicator.h"
#import "GYBankCardFormatTextFieldDelate.h"

@interface BindBank1 () <UITextFieldDelegate> {
	NSString *provinceName;
	NSString *cityName;
//	NSString *phoneNumber;
//	NSString *cardNumber;
    GYBankCardFormatTextFieldDelate *bankCardFieldDelegate;
}
@property (strong, nonatomic) NSArray *           nameArray;
@property (strong, nonatomic) NSArray *           imageArray;
@property (strong, nonatomic) IBOutlet UIView* progressHolder;
@property (strong, nonatomic)  ProgressIndicator* progressIndicator;



@property (strong, nonatomic) UITextField *tf0;
@property (strong, nonatomic) UITextField *tf1;
@property (strong, nonatomic) UITextField *tf2;

@property (strong, nonatomic) MKNetworkOperation *op;

@property (strong, nonatomic) NextButtonViewController *next;
@property (strong, nonatomic) BindBank2 *               e;

@end

@implementation BindBank1

CODE_BLOCK_PROGRESS_INDICATOR_ADD_AND_ALLOC

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
	
	provinceName = @"";
	cityName     = @"";
//	phoneNumber  = @"";
//	cardNumber   = @"";

	[self addProgressBar];
	
	if (self.hasId) {
		[self.progressIndicator setCurrentPage:0 strings:BIND_BANK_TITLES_3_STEP];
	}
	else {
		[self.progressIndicator setCurrentPage:1 strings:BIND_BANK_TITLES_4_STEP];
	}
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setData {
	NSString *orderno = [ZAPP.myuser.bindBankcardRespondDict objectForKey:NET_KEY_ORDERNO];
	if ([orderno notEmpty]) {
		self.e          = ZSTORY(@"BindBank2");
		self.e.hasId = self.hasId;
		self.e.orderno  = orderno;
		self.e.delegate = self;
		self.e.phone = self.tf1.text;
		self.e.card = [self deleteWhitespaceOfString:self.tf0.text];
		[self.navigationController pushViewController:self.e animated:YES];
	}
}

- (void)setData2 {
	NSString *orderno = [ZAPP.myuser.bindBankcardRespondDict objectForKey:NET_KEY_ORDERNO];
	if ([orderno notEmpty]) {
		self.e.orderno = orderno;
	}
}

- (void)resendValidationCode {
//	[ZAPP.zvalidation sendBindBankcardWithComplete:^{[self setData2]; } error:nil cardnumber:[self deleteWhitespaceOfString:self.tf0.text] phonenumber:self.tf1.text province:provinceName city:cityName];
}

- (void)connectToCommitPhoneCardCityProvince {
//	self.e          = ZSTORY(@"BindBank2");
//	self.e.hasId = self.hasId;
//	self.e.orderno  = @"";
//	self.e.delegate = self;

//	[self.navigationController pushViewController:self.e animated:YES];
    
    BindBankPicker *vc = ZSTORY(@"BindBankPicker");
    vc.hasId = self.hasId;
    vc.PhoneNum = self.tf1.text;
    vc.cardCode = [self deleteWhitespaceOfString:self.tf0.text];
    [self.navigationController pushViewController:vc animated:NO];
	return;
}

BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self setNavButton];
	[MobClick beginLogPageView:@"绑定银行卡"];
	
	[self.navigationItem setTitle:@"绑定银行卡"];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[MobClick endLogPageView:@"绑定银行卡"];
	
	[self.op cancel];
	self.op = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	
	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate = self;
		self.next                                                               = ((NextButtonViewController *)[segue destinationViewController]);
	}
}

- (void)nextButtonPressed {
	[self.view endEditing:YES];
    
    
//    [self connectToCommitPhoneCardCityProvince];return;
    
    
    
#ifndef TEST_BIND_BANK_STEPS
	if (![Util isValidateMobile:self.tf1.text]) {
		[Util toast:@"请输入正确的手机号码"];
		return;
	}
#endif
//	cardNumber  = [self deleteWhitespaceOfString:self.tf0.text];
//	phoneNumber = self.tf1.text;
	[self connectToCommitPhoneCardCityProvince];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}
- (BOOL)lastRow:(NSInteger)row {
	return row == 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ZAPP.zdevice getDesignScale:44];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.01;
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
		_imageArray =@[@"bank_card", @"phone", @"address"];
	}
	return _imageArray;
}
- (NSArray *)nameArray {
	if (_nameArray == nil) {
		_nameArray = @[@"请输入银行卡号", @"请输入银行预留手机号", @"请选择银行地址"];
	}
	return _nameArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	FabuJiekuanTableViewCell *cell;
	static NSString *         CellIdentifier = @"cell";
	cell                 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell.txtImg.hidden   = NO;
	cell.moneyImg.hidden = YES;
	
	NSInteger idx = indexPath.row;
	cell.sepLine.hidden  = [self lastRow:indexPath.row];
	cell.txtImg.image    = [UIImage imageNamed:[self.imageArray objectAtIndex:idx]];
	cell.detail.text     = @"";
	cell.tf.keyboardType = UIKeyboardTypeNumberPad;
	cell.rightRow.hidden = YES;
	[cell.tf setEnabled:NO];
	cell.tf.userInteractionEnabled = NO;
	
	if (idx == 0) {
		[cell.tf setEnabled:YES];
		cell.tf.userInteractionEnabled = YES;
		cell.tf.placeholder            = [self.nameArray objectAtIndex:idx];
//		cell.tf.text                   = cardNumber;
		self.tf0                       = cell.tf;
        bankCardFieldDelegate = [[GYBankCardFormatTextFieldDelate alloc] initWithTextField:self.tf0];
        self.tf0.delegate = bankCardFieldDelegate;
	}
	else if (idx == 1) {
		[cell.tf setEnabled:YES];
//		cell.tf.text                   = phoneNumber;
		cell.tf.userInteractionEnabled = YES;
		cell.tf.placeholder            = [self.nameArray objectAtIndex:idx];
		self.tf1                       = cell.tf;
	}
	else if (idx == 2) {
		cell.rightRow.hidden = NO;
		cell.tf.placeholder = [self.nameArray objectAtIndex:idx];
		if ([provinceName notEmpty] && [cityName notEmpty]) {
			cell.tf.text = [NSString stringWithFormat:@"%@ %@", provinceName, cityName];
		}
		cell.txtImg.image = [UIImage imageNamed:[self.imageArray objectAtIndex:idx]];
		self.tf2          = cell.tf;
	}
	[self didchanged:nil];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 2) {
		[self.view endEditing:YES];
//		cardNumber  = [self deleteWhitespaceOfString:self.tf0.text];
//		phoneNumber = self.tf1.text;
		EditProvince *ed = ZEdit(@"EditProvince");
		ed.delegate = self;
		[self.navigationController pushViewController:ed animated:YES];
	}
}

#pragma mark -
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    //NSLog(@"--------  %@", textField.text);
    return YES;
}

- (IBAction)didchanged:(id)sender {
	[self.next setTheEnabled:[[self deleteWhitespaceOfString:self.tf0.text] notEmpty] && [self.tf1.text notEmpty]];
}

// 限制输入框输入长度
- (void)limitInputTextField:(UITextField *)textField  length:(NSUInteger)lenght  {
    if (textField.text.length > lenght) {
        textField.text = [textField.text substringToIndex:lenght];
    }
}

- (NSString *)deleteWhitespaceOfString : (NSString*)source{
    return [source stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)selecteWith:(int)province city:(int)city {
	provinceName  = [ZAPP.zprovince getProvinceName:province];
	cityName      = [ZAPP.zprovince getCityName:province cityindex:city];
	self.tf2.text = [NSString stringWithFormat:@"%@ %@", provinceName, cityName];
	[self didchanged:nil];
}

@end
