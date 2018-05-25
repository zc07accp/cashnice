//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "TiXian.h"
#import "NewBorrowViewController.h"
#import "BlueButtonViewController.h"
 
#import "YaoqingJilu.h"
#import "LabelsView.h"
#import "ChongzhiCell.h"
#import "CustomAutoCloseAlertView.h"

@interface TiXian() <CustomAutoCloseAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIView *textbgview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_textHeight;

@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) UITextField *tf0;
@property (weak, nonatomic) UITextField *tf1;

@property (strong, nonatomic) UITextField *tfCard;

@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NextButtonViewController *next;
@end

@implementation TiXian
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.textbgview.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5];
    
    self.textview.text = @"重要提示\n15:00前提现，第2天到账\n15:00后提现，第3天到账";
    self.textview.userInteractionEnabled = NO;
    
    self.textview.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.textview.font = [UtilFont systemLarge];
    CGSize textViewSize = [self.textview sizeThatFits:CGSizeMake([ZAPP.zdevice getDesignScale:390], FLT_MAX)];
    self.con_textHeight.constant = textViewSize.height;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"确认提现"];
	[self setTitle:@"确认提现"];
    
    [self ui];
    [self.table reloadData];
    [self didchanged:nil];
    [self connectToGetBankInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"确认提现"];
    [self.op cancel];
    self.op = nil;
}

- (void)ui {
    [self didchanged:nil];
}

- (void)setDataCheck {
    
    CustomAutoCloseAlertView *autoCloseAlertView = [[CustomAutoCloseAlertView alloc] initWithMessage:CNLocalizedString(@"alert.message.tiXian", nil) closeDelegate:self timeInterval:3];
    [autoCloseAlertView show];
    [autoCloseAlertView formatAlertButton];
}

- (void)CustomAutoCloseAlertViewClosed: (id)alertView {
    [Util navPopTheTopN:1 nav:self.navigationController];
}

- (void)connectToValidate{
    [self.op cancel];
    bugeili_net
    [SVProgressHUD show];
    self.op = [ZAPP.netEngine tixianValidateWithComplete:^{
        
        [self connectToCommit];
    } error:^{
        [SVProgressHUD dismiss];
        [self loseData];
    } value:self.tf0.text];
}

- (void)connectToCommit {
    [self.op cancel];
    bugeili_net
    
    self.op = [ZAPP.netEngine tixianWithComplete:^{
        [SVProgressHUD dismiss];
        [self setDataCheck];
    } error:^{
        [SVProgressHUD dismiss];
        [self loseData];
    } value:self.tf0.text];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = @"确认提现";
        self.next =  ((NextButtonViewController *)[segue destinationViewController]);
	}
}


- (void)nextButtonPressed {
    [self hide];
    
//    CGFloat cur = [self.tf0.text doubleValue];
//    CGFloat limit = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];
//    
//    if (cur > 0) {
//        
//    }
//    else {
//
//        [Util toastStringOfLocalizedKey:@"tip.cashWithdrawalAmount"];
//        return;
//    }

//    if (cur > limit) {
//
//        [Util toastStringOfLocalizedKey:@"tip.withdrawalAmountNotMore"];
//        return;
//    }
    
    [self connectToValidate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 1 ) ? 2 : 1;
}
- (BOOL)lastRow:(NSIndexPath *)index {
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:44];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? [ZAPP.zdevice getDesignScale:30] : [ZAPP.zdevice getDesignScale:20];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 1) ? [ZAPP.zdevice getDesignScale:10] : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat yue = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];
        NSString *st = [Util formatRMB:@(yue)];
        LabelsView *v =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
        [v setTexts:@[@"账户余额",st]];
        [v setIndexColor:ZCOLOR(COLOR_BUTTON_RED) index:@[@(1)]];
        return v;
    }
    else {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray =@[@"money", @"", @"bank_card", @"lock"];
    }
    return _imageArray;
}
- (NSArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = @[@"提现金额", @"提现到：", @"建设银行 1234", @"请输入支付密码"];
    }
    return _nameArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChongzhiCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.txtImg.hidden = NO;
    cell.moneyImg.hidden = YES;
    [cell.tf setEnabled:YES];
    
    cell.sepLine.hidden = [self lastRow:indexPath];
    
    if (indexPath.section == 1) {
        NSInteger idx = 1 + indexPath.row;
        cell.tf.text = [self.nameArray objectAtIndex:idx];
        
        cell.txtImg.image = [UIImage imageNamed:[self.imageArray objectAtIndex:idx]];
        cell.detail.text = @"";
        cell.tf.enabled = NO;
        cell.tf.secureTextEntry = NO;

        
        if (indexPath.row== 0) {
            cell.imgAspect.priority = 5;
        }
        else {
            self.tfCard = cell.tf;
            NSString *bname = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_bankcode];
            NSString *cardnumber = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_visacode];
            
            cell.tf.text = [NSString stringWithFormat:@"%@  %@", bname, cardnumber];
        }
    }
    else {
        NSInteger idx = (indexPath.section == 0 ) ? 0 : 3 + indexPath.row;
        cell.tf.placeholder = [self.nameArray objectAtIndex:idx];
        cell.tf.delegate = self;
        cell.tf.tag = indexPath.section;
        
        cell.txtImg.image = [UIImage imageNamed:[self.imageArray objectAtIndex:idx]];
        cell.detail.text = (indexPath.section == 0) ? @"元" : @"";
        cell.tf.enabled = YES;
        cell.tf.secureTextEntry = indexPath.section == 2;
        cell.tf.attributedText = nil;
        
        if (indexPath.section == 0) {
            self.tf0 = cell.tf;
        cell.tf.keyboardType = UIKeyboardTypeDecimalPad;
            cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        }

        else        if (indexPath.section== 2) {
            self.tf1 = cell.tf;
        cell.tf.keyboardType = UIKeyboardTypeDefault;
        }
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self hide];
    }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        textField.text = [Util cutMoney:textField.text];
    }
}

- (IBAction)didchanged:(UITextField *)textField {
    if (textField.tag == 0) {
        textField.text = [Util cutMoney:textField.text];
    }
    
    [self.next setTheEnabled:[self.tf0.text floatValue] > 0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        textField.text = [Util cutMoney:textField.text];
    }
}

- (void)setData {
    NSString *bankname = [ZAPP.myuser.bankInfoRespondDict objectForKey:NET_KEY_bankname];
    NSString *card = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_visacode];
    self.tfCard.text = [NSString stringWithFormat:@"%@  %@", bankname, card];
    [self ui];
}

- (void)loseData {
    
}

- (void)connectToGetBankInfo {
    [self.op cancel];
    bugeili_net
    WS(ws);

    NSString *bankcode = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_bankcode];
    if ([bankcode notEmpty]) {
        progress_show
        self.op = [ZAPP.netEngine getBankInfoWithComplete:^{[ws setData];progress_hide} error:^{[ws loseData];progress_hide} bankcode:bankcode];
    }
}



@end
