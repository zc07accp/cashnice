//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "FabuStep2.h"
#import "FabuStep3.h"
 
#import "FabuJiekuanTableViewCell.h"

@interface FabuStep2 () {
	NSInteger _selectedIndex;
//    NSString *currentLixi;
}

@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) UITextField *tf0;
@property (weak, nonatomic) UITextField *tf1;
@property (weak, nonatomic) IBOutlet UILabel *haoyouInfo;
@property (weak, nonatomic) IBOutlet UILabel *gongkaiInfo;
@property (strong, nonatomic) NextButtonViewController *next;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_check_height;


@end

@implementation FabuStep2

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.con_check_height.constant = [ZAPP.zdevice getDesignScale:44];

	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    
    for (UILabel *x in self.labels) {
        x.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        x.font = [UtilFont systemLarge];
    }
    
    self.table.allowsSelection = NO;
    
    _selectedIndex = 1; //均为公开借款
    //currentLixi = @"";
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发布借款(2/4)"];
[self setNavButton];
	[self setTitle:@"发布借款(2/4)"];
	
    [self uiButtons];
    [self.table reloadData];
    [self didChanged:nil];
    [self.view endEditing:YES];
    [self readTempData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"发布借款(2/4)"];
    [self.view endEditing:YES];
    [self setTempData];
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
    [self setTempData];
//    if (_selectedIndex == 0) {
//    currentLixi = self.tf0.text;
//    }
    [self.view endEditing:YES];
    _selectedIndex = sender.tag;
    [self uiButtons];
    [self didChanged:nil];
    [self.table reloadData];
}
- (IBAction)didChanged:(id)sender {
    self.tf0.text = [Util cutMoney:self.tf0.text];
    self.tf1.text = [Util cutInteger:self.tf1.text];
    int x = [self.tf1.text intValue];
    [self.next setTheEnabled:[self.tf0.text notEmpty] && x >= 30 && x <=180];
}

- (void)uiButtons {
    for (UIButton *x in self.buttons) {
        [x setEnabled:(x.tag != _selectedIndex)];
    }
    BOOL isHaoyou = _selectedIndex == 0;
    self.haoyouInfo.hidden = !isHaoyou;
    self.gongkaiInfo.hidden = isHaoyou;
    
    self.tf0.enabled = YES;
    //self.tf0.text = isHaoyou ? currentLixi : @"20";
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
    return 0;
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

- (void)readTempData {
    //currentLixi = [[NSUserDefaults standardUserDefaults] objectForKey:def_key_fabu_lixi];
    //_selectedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:def_key_fabu_friend_type] intValue]; //均为公开借款
    [self didChanged:nil];
    [self uiButtons];
    [self.table reloadData];
}

- (void)setTempData {
    [[NSUserDefaults standardUserDefaults] setObject:self.tf0.text forKey:def_key_fabu_lixi];
    [[NSUserDefaults standardUserDefaults] setObject:self.tf1.text forKey:def_key_fabu_huankuan_day];
    [[NSUserDefaults standardUserDefaults] setObject:@(_selectedIndex) forKey:def_key_fabu_friend_type];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FabuJiekuanTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BOOL istext = indexPath.row == 0;
    cell.txtImg.hidden = !istext;
    cell.moneyImg.hidden = istext;
    cell.tf.placeholder = istext ? @"年化利率" : @"借款期限，请输入整数";
    cell.detail.hidden = NO;
    cell.detail.text = istext ? @"%" : @"天";
    cell.tf.keyboardType = istext ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad;
    cell.tf.delegate = self;
    cell.tf.tag = indexPath.row;
    if (istext) {
        self.tf0 = cell.tf;
    cell.tf.text = [[NSUserDefaults standardUserDefaults] objectForKey:def_key_fabu_lixi];
    }
    else {
        self.tf1 = cell.tf;
        self.tf1.text = [[NSUserDefaults standardUserDefaults] objectForKey:def_key_fabu_huankuan_day];
    }
    
    [self didChanged:nil];
    if (istext) {
        BOOL isHaoyou = _selectedIndex == 0;
        cell.bgview.backgroundColor = isHaoyou ? [UIColor whiteColor] : [UIColor whiteColor];
        
//        cell.tf.text = isHaoyou ? currentLixi : @"20";
        cell.tf.userInteractionEnabled = isHaoyou ? YES : YES;
    }
    
    if ([self lastRow:indexPath.row]) {
        cell.sepLine.hidden = YES;
    }
    else {
        cell.sepLine.hidden = NO;
    }
    
    return cell;
}

- (void)nextButtonPressed {
    [self.view endEditing:YES];
    
    BOOL isHaoyou = _selectedIndex == 0;
    if (!isHaoyou) {
        CGFloat curRate = [self.tf0.text doubleValue];
        CGFloat lowestRate = [ZAPP.myuser getMinPublicRatePerYear];
        if (curRate < lowestRate) {
            [Util toast:[NSString stringWithFormat:@"公开借款最低年化利率%.2f%%", lowestRate]];
            
            return;
        }
    }
    
    int ty = 0;
    if (_selectedIndex == 0) {
        ty = 1;
    }
    [ZAPP.myuser fabuSetType:ty lixi:[self.tf0.text doubleValue] day:[self.tf1.text intValue]];
    FabuStep3 *fabu = ZBorrow(@"FabuStep3");
    [self.navigationController pushViewController:fabu animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


@end
