//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NewShehuiEdit.h"
#import "EditIntro.h"
 
#import "FabuJiekuanTableViewCell.h"
#import "FabuStep2.h"
#import "EditProvince.h"
#import "NonRotateImgPicker.h"
#import "GeRenTableViewCell.h"
#import "ValidcodeCell.h"

@interface NewShehuiEdit ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_table_height;
@property (strong, nonatomic) NSArray *                   nameArray;
@property (strong, nonatomic) NSArray *                   imageArray;
@property (strong, nonatomic) IBOutlet UITableView *      table;
@property (weak, nonatomic) UITextField *                 tf0;
@property (weak, nonatomic) UITextField *                 tf1;
@property (weak, nonatomic) UITextField *                 tf2;
@property (weak, nonatomic) UITextField *                 tf3;

@property (strong, nonatomic) NextButtonViewController *        next;
@property (strong, nonatomic) MKNetworkOperation *              op;

@property (strong, nonatomic) NSArray *optArr;


@end

@implementation NewShehuiEdit

- (NSArray *)optArr {
    if (_optArr == nil) {
        _optArr = [NSArray arrayWithArray:[ZAPP.myuser getShehuiOptions]];
    }
    return _optArr;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor         = ZCOLOR(COLOR_BG_GRAY);
	self.table.allowsSelection        = YES;
    
    [UtilLog dict:ZAPP.myuser.systemOptionsDictShehuiZhiwu];
    
    self.con_table_height.constant = [ZAPP.zdevice getDesignScale:[ZAPP.myuser getUserLevel] == UserLevel_VIP ? 236 : 280];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"公司和社会职务"];
    [self setTitle:[ZAPP.myuser getUserLevel] == UserLevel_VIP ? @"修改公司和社会职务" : @"验证公司和社会职务"];
[self setNavButton];
    
	

	[self hide];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self hide];
    
	[self didChanged:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"公司和社会职务"];

	[self hide];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	 if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate    = self;
		((NextButtonViewController *)[segue destinationViewController]).titleString = @"提交审核";
		self.next                                                                   =        ((NextButtonViewController *)[segue destinationViewController]);
	}
}


- (void)loseData {
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (alertView.tag == 10) {
        }
        else {
           [self connectToCommitData];
        }
    }
}

- (void)setDataTheThe {

    [Util toastStringOfLocalizedKey:@"tip.submittedForReview"];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)connectToCommitData{
    [self.op cancel];
    bugeili_net
    progress_show
//    self.op = [ZAPP.netEngine newCommitCompanyWithComplete:^{[self setDataTheThe]; progress_hide} error:^{progress_hide} company:self.tf0.text job:self.tf1.text address:self.tf2.text zhiwu:self.tf3.text];
}

- (void)nextButtonPressed {
    [self.view endEditing:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.newshehuiEdit", nil) message:nil delegate:self cancelButtonTitle:@"返回修改" otherButtonTitles:@"提交审核", nil];
    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0 ? ([ZAPP.myuser getUserLevel] == UserLevel_VIP ? 0 : 1) : 4);
}
- (BOOL)lastRow:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    else {
        return indexPath.row == 3;
    }
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
		_imageArray =@[@"company", @"star", @"address", @"group"];
	}
	return _imageArray;
}
- (NSArray *)nameArray {
	if (_nameArray == nil) {
		_nameArray = @[@"请输入所在公司", @"请输入公司职务", @"请输入公司地址", @"请选择社会职务"];
	}
	return _nameArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GeRenTableViewCell *cell;
        static NSString *CellIdentifier2 = @"cell2";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        NSString *str1 = [ZAPP.myuser limitLoanAmountForVIPuser];
        
        NSString *tt = [NSString stringWithFormat:@"继续认证成功: 获得授信额度%@，借款额度%@", str1, str1];
        cell.biaoti.text = tt;
        cell.detail.text = @"";
        cell.arrow.hidden = YES;
        cell.sepLine.hidden = YES;
        
        return cell;
    }
    else {
            FabuJiekuanTableViewCell *cell;
            static NSString *         CellIdentifier = @"cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.txtImg.hidden   = NO;
            cell.moneyImg.hidden = YES;
            [cell.tf setEnabled:YES];
            
            cell.sepLine.hidden = [self lastRow:indexPath];
            cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
            cell.tf.delegate    = self;
            
            cell.txtImg.image    = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
            cell.detail.text     = @"";
            cell.tf.keyboardType = UIKeyboardTypeDefault;
        cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.rightRow.hidden = YES;
        if (indexPath.row == 0) {
            self.tf0 = cell.tf;
            self.tf0.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ORGANIZATIONNAME];
        }
        else if (indexPath.row == 1) {
    cell.tf.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ORGANIZATIONDUTY];
            self.tf1 = cell.tf;
        }
        else if (indexPath.row == 2) {
    cell.tf.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ADDRESS];
            self.tf2 = cell.tf;
        }
        else if (indexPath.row == 3) {
            self.tf3 = cell.tf;
    cell.tf.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_SOCIALFUNC];
            self.tf3.enabled = NO;
            cell.rightRow.hidden = NO;
        }
            [self didChanged:nil];
            return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        ChooseShehui *s = ZEdit(@"ChooseShehui");
        s.delegate = self;
        [self.navigationController pushViewController:s animated:YES];
    }
}

- (void)selecteWith:(NSString *)opt {
    self.tf3.text = opt;
    [self didChanged:nil];
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
//	[self.stroke setTheEnabled:self.canEdit];
//	[self.stroke setTheEnabled:YES];
	[self.next setTheEnabled:[self.tf0.text notEmpty] && [Util isValidIdCard:self.tf1.text] && [self.tf2.text notEmpty] && [self.tf3.text notEmpty]];
}
@end
