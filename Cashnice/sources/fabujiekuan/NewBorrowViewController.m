//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NewBorrowViewController.h"
 
#import "FabuJiekuanTableViewCell.h"
#import "FabuStep2.h"

@interface NewBorrowViewController () {
	NSInteger _selectedIndex;
}

@property (weak, nonatomic) IBOutlet UILabel *remainEdu;
@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) UITextField *tf0;
@property (weak, nonatomic) UITextField *tf1;
@property (strong, nonatomic) NextButtonViewController *next;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* chou_width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* chou_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;


@end

@implementation NewBorrowViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    self.chou_width.constant = [ZAPP.zdevice getDesignScale:390];
    self.chou_height.constant = [ZAPP.zdevice getDesignScale:70];

	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    
    for (UILabel *x in self.labels) {
        x.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        x.font = [UtilFont systemLarge];
    }
    
    self.remainEdu.textColor = ZCOLOR(COLOR_BUTTON_RED);
    self.remainEdu.font = [UtilFont systemLarge];
    
    
    self.table.allowsSelection = NO;
    
    _contentWidth.constant = [[UIScreen mainScreen] bounds].size.width;

    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"发布借款(1/4)"];
	[self setTitle:@"发布借款(1/4)"];
	

    [self.table reloadData];
    [self uiButtons];
    [self editingChanged:nil];
    [self.view endEditing:YES];
    
    [self readTempData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // [self readTempData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"发布借款(1/4)"];
    [self.view endEditing:YES];
    [self setTempData];
}

- (IBAction)backgroundTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
        ((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        self.next = (NextButtonViewController *)[segue destinationViewController];
    }
}


- (IBAction)selectButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    _selectedIndex = sender.tag;
    [self uiButtons];
}

- (void)uiButtons {
    for (UIButton *x in self.buttons) {
        [x setEnabled:(x.tag != _selectedIndex)];
    }
    
    self.remainEdu.text = [Util formatRMB:@([ZAPP.myuser getRemainLoanLimit])];
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
    return [ZAPP.zdevice getDesignScale:20];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FabuJiekuanTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.sepLine.hidden = [self lastRow:indexPath.row];
    
    BOOL istext = indexPath.row == 0;
    cell.txtImg.hidden = !istext;
    cell.moneyImg.hidden = istext;
    cell.tf.placeholder = istext ? @"借款标题，限15个字" : @"借款总额，请输入整数";
    cell.detail.hidden = istext;
    cell.detail.text = istext ? @"" : @"万元";
    cell.detail.textColor = ZCOLOR( COLOR_BUTTON_RED);
    cell.tf.keyboardType = istext ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;

    cell.tf.delegate = self;
    cell.tf.tag = indexPath.row;
    if (istext) {
        self.tf0 = cell.tf;
    self.tf0.text = [[NSUserDefaults standardUserDefaults] objectForKey:def_key_fabu_name];
    }
    else {
        self.tf1 = cell.tf;
    self.tf1.text = [[NSUserDefaults standardUserDefaults] objectForKey:def_key_fabu_money];
    }
    [self editingChanged:nil];
    
    return cell;
}

- (void)readTempData {
    _selectedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:def_key_fabu_borrow_day] intValue];
    [self editingChanged:nil];
    [self uiButtons];
}

- (void)setTempData {
    [[NSUserDefaults standardUserDefaults] setObject:self.tf0.text forKey:def_key_fabu_name];
    [[NSUserDefaults standardUserDefaults] setObject:self.tf1.text forKey:def_key_fabu_money];
    [[NSUserDefaults standardUserDefaults] setObject:@(_selectedIndex) forKey:def_key_fabu_borrow_day];
}

- (void)nextButtonPressed {
    [self.view endEditing:YES];
    
    self.tf0.text = [self.tf0.text trimmed];
    
    if ([self.tf0.text notEmpty]) {
    }
    else {
        
        [Util toastStringOfLocalizedKey:@"tip.fillLoanTitle"];
        return;
    }
    
    if (self.tf0.text.length > 15) {
        
        [Util toastStringOfLocalizedKey:@"tip.LoantitleNotMore"];
    
        return;
    }
    
    CGFloat minMOney = [ZAPP.myuser getMinLoan];
    if (minMOney < 0) {
        return;
    }
    
    
    CGFloat money = [self.tf1.text intValue] * 1e4;
    
    if (money < minMOney) {
        [Util toast:[NSString stringWithFormat:@"最低借款金额%@", [Util formatRMB:@(minMOney)]]];
        return;
    }
    
    
    BOOL hasMoney = (money <= [ZAPP.myuser getRemainLoanLimit] && money > 0);
#ifdef TEST_RELEASE_SMALL_VAL
    hasMoney = YES;
#endif
    
#ifdef TEST_FABU_JIEKUAN
#else
    if (!hasMoney) {

        [Util toastStringOfLocalizedKey:@"tip.loanAmountNotEnough"];
        return;
    }
#endif

    //[Util toast:[NSString stringWithFormat:@"%@ %@", self.tf0.text, self.tf1.text]];
    int dd = 7;
    if (_selectedIndex == 0) {
        dd = 3;
    }
    else if (_selectedIndex == 1) {
        dd = 5;
    }
    [ZAPP.myuser fabuSetTitle:self.tf0.text val:[self.tf1.text intValue]*1e4 day:dd];
    
    FabuStep2 *fabu = ZBorrow(@"FabuStep2");
    [self.navigationController pushViewController:fabu animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)editingChanged:(id)sender {
    self.tf1.text = [Util cutInteger:self.tf1.text];
    [self.next setTheEnabled:[self.tf0.text notEmpty] && [self.tf1.text notEmpty]];
}
@end
