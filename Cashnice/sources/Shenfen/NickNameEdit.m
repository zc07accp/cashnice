//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NickNameEdit.h"
#import "EditIntro.h"
 
#import "FabuJiekuanTableViewCell.h"
#import "FabuStep2.h"
#import "EditProvince.h"
#import "NonRotateImgPicker.h"

@interface NickNameEdit () {

}
@property (strong, nonatomic) NSArray *                   nameArray;
@property (strong, nonatomic) NSArray *                   imageArray;
@property (strong, nonatomic) IBOutlet UITableView *      table;
@property (weak, nonatomic) UITextField *                 tf0;

@property (strong, nonatomic) NextButtonViewController *        next;
@property (strong, nonatomic) MKNetworkOperation *              op;

@end

@implementation NickNameEdit

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor         = ZCOLOR(COLOR_BG_GRAY);
	self.table.allowsSelection        = NO;
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"修改昵称"];
	[self setTitle:@"修改昵称"];
	
	[self hide];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self hide];
	[self didChanged:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"修改昵称"];

	[self hide];
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

- (void)loseData {

}

- (void)setCommitData {

    [Util toastStringOfLocalizedKey:@"tip.savedSuccess"];
		[self.navigationController popViewControllerAnimated:YES];
}

- (void)connectToCommit {
	[self.op cancel];
	bugeili_net

    progress_show
    self.op = [ZAPP.netEngine postNickNameWithComplete:^{[self setCommitData];progress_hide} error:^{[self loseData];progress_hide} nickname:self.tf0.text];
    
	//self.op = [ZAPP.netEngine commitIdcardWithComplete:^{[self setCommitData]; progress_hide} error:^{[self loseData]; progress_hide}  realname:self.tf0.text idnumber:self.tf1.text attach:uploadDict];
}


- (void)nextButtonPressed {
    [self connectToCommit];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}
- (BOOL)lastRow:(NSInteger)row {
	return row == 0;
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
		_imageArray =@[@"user"];
	}
	return _imageArray;
}
- (NSArray *)nameArray {
	if (_nameArray == nil) {
		_nameArray = @[@"请输入昵称"];
	}
	return _nameArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	FabuJiekuanTableViewCell *cell;
	static NSString *         CellIdentifier = @"cell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	cell.txtImg.hidden   = NO;
	cell.moneyImg.hidden = YES;
	[cell.tf setEnabled:YES];

	cell.sepLine.hidden = [self lastRow:indexPath.row];
	cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
	cell.tf.delegate    = self;

	cell.txtImg.image    = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
	cell.detail.text     = @"";
	cell.tf.keyboardType = UIKeyboardTypeDefault;

	if (indexPath.row == 0) {
		self.tf0     = cell.tf;
        [self.tf0 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.tf.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_NICKNAME];//[Util getUserRealNameOrNickName:ZAPP.myuser.gerenInfoDict];
	}
	cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	[self didChanged:nil];
	return cell;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.tf0) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
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

- (IBAction)didChanged:(id)sender {
	[self.next setTheEnabled:[self.tf0.text notEmpty]];
}
@end
