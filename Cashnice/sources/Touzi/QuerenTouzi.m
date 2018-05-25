//
//  JiekuanDetailViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "QuerenTouzi.h"
#import "GongtongHaoyouTableViewCell.h"

#import "JiekuanInfoViewController.h"
#import "TextField.h"
#import "Chongzhi.h"

@interface QuerenTouzi () {
    NSInteger rowCnt;
    NSInteger rowHeight;
    
    LoanState _jiekuan_state;
    BOOL _blackList;
    
    NSInteger _selectedIndex;
}

@property (strong,nonatomic) JiekuanInfoViewController*         jiekuanInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_info_height;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeRed;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *smallRed;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *smallGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *smallBlue;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkBox;
@property (weak, nonatomic) IBOutlet UILabel *yongtuPrompt;
@property (weak, nonatomic) IBOutlet UILabel *yongtuLabel;
@property (weak, nonatomic) IBOutlet UILabel *haixuLabel;
@property (weak, nonatomic) IBOutlet UILabel *haixu2Label;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (strong, nonatomic) TextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *disKeyboard;

@property (strong, nonatomic) NSDictionary *dataDict;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NextButtonViewController *next;

@property (strong, nonatomic) IBOutlet UIView* jujianView;

@end

@implementation QuerenTouzi

- (void)setTheDataDict:(NSDictionary *)dict {
    self.dataDict = dict;
    //[self ui];
}

- (IBAction)dismissk:(id)sender {
    [self endEditing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    
    rowCnt = 2;
    rowHeight = 80;
    
    [Util setUILabelLargeGray:self.largeGray];
    [Util setUILabelLargeRed:self.largeRed];
    [Util setUILabelSmallRed:self.smallRed];
    [Util setUILabelSmallBlue:self.smallBlue];
    [Util setUILabelSmallGray:self.smallGray];
    
    self.jujianView.hidden = YES;
    [Util setScrollHeader:self.scrollView target:self header:@selector(connectToServerLoadDetailWithNoProgress) dateKey:[Util getDateKey:self]];
    [self connectToServer];
    
    [self tapBackground];
}

-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}

-(void)tapOnce//手势方法
{
    [self endEditing];
}

- (float)getNeedVal {
    CGFloat loaned = [[self.dataDict objectForKey:NET_KEY_LOANEDMAINVAL] doubleValue];
    CGFloat loantarget = [[self.dataDict objectForKey:NET_KEY_LOANMAINVAL] doubleValue];
    CGFloat need = loantarget - loaned;
    need = need < 0 ? 0 : need;
    
    return need;
}

- (void)ui {
    CGFloat need = [self getNeedVal];
    
    /*
     if (need < 100) {
     self.tf.tf.placeholder = [NSString stringWithFormat:@"最多可以投资%@元", [Util formatFloat:@(need)] ];
     }else{
     self.tf.tf.placeholder = @"请输入100的整数倍";
     }
     */
    //    NSString *x = [NSString stringWithFormat:@"%@ (最低起投金额%@)", [Util formatRMB:@(need)], [Util formatRMB:@([ZAPP.myuser getMinInvest])]];
    NSString *x = [NSString stringWithFormat:@"%@", [Util formatRMB:@(need)] ];
    self.haixu2Label.text = x;
    self.haixuLabel.text = [Util formatRMB:@(need)];
    
    CGFloat yuyue = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];
    self.yueLabel.text = [Util formatRMB:@(yuyue)];
    
    int blocktype = [[self.dataDict objectForKey:NET_KEY_BLOCKTYPE] intValue];
    _blackList                    = [Util isBlocked:blocktype];
    self.con_info_height.constant = [ZAPP.zdevice getDesignScale:(_blackList ? 320 : 250)];
    
    [self.jiekuanInfo setTheDataDict:self.dataDict];
    
    NSString *str = [self.dataDict objectForKey:NET_KEY_PURPUSE];
    if (str.length > 0) {
        self.yongtuLabel.text = str;
        self.yongtuPrompt.text = @"借款用途:";
    }
    else {
        self.yongtuLabel.text = @" ";
        self.yongtuPrompt.text = @" ";
    }
    
    
    [self.view needsUpdateConstraints];
}

- (BOOL)validInput {
    if (self.tf.tf.text.length > 0 && [self.tf.tf.text intValue] > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)updateButtons {
    for (UIButton *x in self.checkBox) {
        x.selected = (x.tag == _selectedIndex);
    }
    if (_selectedIndex != -1) {
        self.tf.tf.text = @"";
    }
    
    //[self.next setTheEnabled:([self getTouziVal] > 0 && [self getTouziVal] <= [self getNeedVal])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavButton];
    [MobClick beginLogPageView:@"确认投资"];
    [self setTitle:@"确认投资"];
    
    //[self.jiekuanInfo setJiekuanState:_jiekuan_state blacklist:_blackList];
    
    [self connectToServerLoadDetail];
    [self ui];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _selectedIndex = 0;
    [self updateButtons];
    self.disKeyboard.hidden = YES;
    self.tf.tf.keyboardType = UIKeyboardTypeNumberPad;
    self.tf.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tf.tf.text = @"";
    self.tf.tf.delegate = self;
    [self.tf.tf addTarget:self action:@selector(didChanged:) forControlEvents:UIControlEventEditingChanged];
    [self endEditing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"确认投资"];
    [self endEditing];
}

- (void)setData {
    int betres = [[ZAPP.myuser.touziRespondDict objectForKey:NET_KEY_betresult] intValue];
    if (betres == 0) {
        [self connectToServerLoadDetailWithNoProgress];
        CGFloat rema = [[ZAPP.myuser.touziRespondDict objectForKey:NET_KEY_loanremainval] doubleValue];
        if (rema > 0) {
            [self connectToServerLoadDetail];
            NSString *monestr = [Util formatRMB:@(rema)];
            NSString *tstr = [NSString stringWithFormat:@"因网络延时，您的投资额超出借款所需额度%@。", monestr];
            NSString *mstr = [NSString stringWithFormat:@"继续投资将直接投资借款所需额度%@。", monestr];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tstr message:mstr delegate:self cancelButtonTitle:@"取消投资" otherButtonTitles:@"修改额度",@"继续投资", nil];
            alert.tag = 10;
            [alert show];
        }
        else {
            [Util toast:@"因网延延时，借款已满，投资失败。"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        [Util toast:@"正在处理中，返回结果稍后请查看消息提醒。"];
        [self.delegate touziOkDone];
        if (self.fromTouzi) {
            self.fromTouzi = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)loseData {
}

- (void)connectToValidate {
    NSString *loanid = [self.dataDict objectForKey:NET_KEY_LOANID];
    NSString *value = [NSString stringWithFormat:@"%.2f", [self getTouziVal]];
    [self.op cancel];
    bugeili_net
    //    _isNavigationBack=NO;
    progress_show
    
    WS(weakSelf)
    
    self.op = [ZAPP.netEngine touziValidateWithComplete:^{[weakSelf connectToTouzi];progress_hide} error:^{[weakSelf loseData];progress_hide} value:value loanid:loanid];
}

- (void)connectToTouzi {
    NSString *loanid = [self.dataDict objectForKey:NET_KEY_LOANID];
    NSString *value = [NSString stringWithFormat:@"%.2f", [self getTouziVal]];
    
    [self processedNextButton];
    
    [self.op cancel];
    bugeili_net
    progress_show
    WS(weakSelf)

    self.op = [ZAPP.netEngine touziWithComplete:^{
        [weakSelf setData];
        [weakSelf disprocessedNextButton];
        progress_hide
    } error:^{
        [weakSelf loseData];
        [weakSelf disprocessedNextButton];
        progress_hide
    } value:value loanid:loanid betid:self.betid];
}

- (void)setDataDetail {
    self.dataDict   = ZAPP.myuser.loanDetailDict;
    [self ui];
}

- (void)setIsNavigationBack:(BOOL)isNavigationBack{
    _isNavigationBack = isNavigationBack;
}

- (void)loseDataDetail {
}

- (void)connectToServer {
    //progress_show
    [ZAPP.netEngine getUserInfoWithComplete:^{
        //progress_hide
        [self ui];
    } error:^{
        //progress_hide
        [self ui];
    }];
}

- (void)connectToServerLoadDetail {
    [self.op cancel];
    bugeili_net
    NSString *loanid = [self.dataDict objectForKey:NET_KEY_LOANID];
    NSString *userid = [self.dataDict objectForKey:NET_KEY_USERID];
    if ([loanid notEmpty] && [userid notEmpty]) {
        progress_show
        WS(weakSelf)

        self.op  = [ZAPP.netEngine getLoanDetailWithLoanID:loanid userid:userid page:0 pagesize:LARGEST_PAGE_SIZE complete:^{[weakSelf setDataDetail]; progress_hide} error:^{[weakSelf loseDataDetail]; progress_hide}];
    }
}

- (void)connectToServerLoadDetailWithNoProgress {
    [self.op cancel];
    bugeili_net
    NSString *loanid = [self.dataDict objectForKey:NET_KEY_LOANID];
    NSString *userid = [self.dataDict objectForKey:NET_KEY_USERID];
    WS(weakSelf)

    [ZAPP.netEngine getUserInfoWithComplete:^{
        if ([loanid notEmpty] && [userid notEmpty]) {
            self.op  = [ZAPP.netEngine getLoanDetailWithLoanID:loanid userid:userid page:0 pagesize:LARGEST_PAGE_SIZE complete:^{
                [weakSelf setDataDetail];
                [weakSelf.scrollView.header endRefreshing];
            } error:^{
                [weakSelf loseDataDetail];
                [weakSelf.scrollView.header endRefreshing];
            }];
        }
    } error:^{
        [weakSelf.scrollView.header endRefreshing];
        [weakSelf ui];
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (alertView.tag == 10) {
            if (buttonIndex == 1) {
            }
            else if (buttonIndex == 2) {
                NSString *loanid = [self.dataDict objectForKey:NET_KEY_LOANID];
                CGFloat rema = [[ZAPP.myuser.touziRespondDict objectForKey:NET_KEY_loanremainval] doubleValue];
                NSString *value = [NSString stringWithFormat:@"%f", rema];
                
                [self.op cancel];
                bugeili_net
                
                WS(weakSelf)
                
                progress_show
                self.op = [ZAPP.netEngine touziWithComplete:^{[weakSelf setData];progress_hide} error:^{[weakSelf loseData];progress_hide} value:value loanid:loanid betid:self.betid];
            }
        }
        else {
            //        [self.navigationController popToRootViewControllerAnimated:NO];
            //        [Util dispatch:MSG_change_tab_to_chongzhi];
            Chongzhi *cz = ZSEC(@"Chongzhi");
            cz.level = 1;
            [self.navigationController pushViewController:cz animated:YES];
        }
    }
    else {
        if (alertView.tag == 10) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)processedNextButton {
    [self.next setTheEnabled:NO];
    [self.next setTheGray];
    [self.next setTheTitleString:@"处理中"];
}

- (void)disprocessedNextButton {
    [self.next setTheEnabled:YES];
    [self.next setTheRed];
    [self.next setTheTitleString:@"确认投资"];
}

- (void)nextButtonPressed {
    
    //    CGFloat minInvest = [ZAPP.myuser getMinInvest];
    //    if (minInvest < 0) {
    //        return;
    //    }
    //
    //    if ([self getTouziVal] < minInvest) {
    //            [Util toast:[NSString stringWithFormat:@"最低起投金额%@", [Util formatRMB:@(minInvest)]]];
    //            return;
    //    }
    
    if ([self getTouziVal] <= 0) {
        [self.view endEditing:YES];
        [Util toast:@"请输入投资金额！"];
        return;
    }
    if ([self getTouziVal] > [self getNeedVal]) {
        [self.view endEditing:YES];
        NSString *x = [NSString stringWithFormat:@"%@", [Util formatRMB:@([self getNeedVal])] ];
        [Util toast:[NSString stringWithFormat:@"投资金额不能超过借款总数%@",x]];
        return;
    }
    
#ifndef TEST_TOUZI_PAGE
    if ([self getTouziVal] > [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您当前余额不足，请先充值。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
#endif
    //[self connectToValidate];
    
    [self.view endEditing:YES];
    [self connectToTouzi];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
        ((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = [segue identifier];
        self.next =  ((NextButtonViewController *)[segue destinationViewController]);
    }
    else if ([[segue destinationViewController] isKindOfClass:[JiekuanInfoViewController class]]) {
        self.jiekuanInfo = ((JiekuanInfoViewController*)[segue destinationViewController]);
    }
    else if ([[segue destinationViewController] isKindOfClass:[TextField class]]) {
        self.tf = ((TextField*)[segue destinationViewController]);
        
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        _selectedIndex = -1;
        [self updateButtons];
    }
    self.disKeyboard.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.disKeyboard.hidden = NO;
}

- (IBAction)checkPressed:(UIButton *)sender {
    _selectedIndex = sender.tag;
    [self endEditing];
    [self updateButtons];
}

- (void)endEditing {
    [self.view endEditing:YES];
    [self.tf.tf resignFirstResponder];
}

- (float)getTouziVal {
    if (_selectedIndex == -1) {
        return [self.tf.tf.text doubleValue]; //单位改为元
    }
    else if (_selectedIndex == 0) {
        return 1*1e4;
    }
    else if (_selectedIndex == 1) {
        return 2*1e4;
    }
    else if (_selectedIndex == 2){
        return 5*1e4;
    }
    return 0;
}

- (void)didChanged:(id)sender {
    if ([self.tf.tf.text notEmpty]) {
        //        self.tf.tf.text = [Util cutMoney:self.tf.tf.text];
        self.tf.tf.text = [Util cutInteger:self.tf.tf.text];
        _selectedIndex = -1;
    }
    else {
        _selectedIndex = 0;
    }
    
    [self updateButtons];
}
- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    [self performSelector:@selector(keyboardWillShow:) withObject:nil afterDelay:0];
}
//添加完成按钮
static const NSInteger NUM_PAD_DONE_BUTTON_TAG = 1001;
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / 3.0f;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0){
        doneButton.frame = CGRectMake(0, 163, buttonWidth, 53);
    }else{
        doneButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-53, buttonWidth, 53);
    }
    doneButton.tag = NUM_PAD_DONE_BUTTON_TAG;
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *windowArr = [[UIApplication sharedApplication] windows];
    if (windowArr != nil && windowArr.count > 1){
        UIWindow *needWindow = [windowArr objectAtIndex:1];
        UIView *keyboard;
        for(int i = 0; i < [needWindow.subviews count]; i++) {
            keyboard = [needWindow.subviews objectAtIndex:i];
            NSLog(@"%@", [keyboard description]);
            if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) || ([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) || ([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES)){
                
                UIView *doneButtonView = [keyboard viewWithTag:NUM_PAD_DONE_BUTTON_TAG];
                if (doneButtonView == nil){
                    [keyboard addSubview:doneButton];
                }
            }
        }
    }
}
//移除完成按钮
-(void)removeDoneButtonFromNumPadKeyboard
{
    UIView *doneButton = nil;
    
    NSArray *windowArr = [[UIApplication sharedApplication] windows];
    if (windowArr != nil && windowArr.count > 1){
        UIWindow *needWindow = [windowArr objectAtIndex:1];
        UIView *keyboard;
        for(int i = 0; i < [needWindow.subviews count]; i++) {
            keyboard = [needWindow.subviews objectAtIndex:i];
            if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) || ([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) || ([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES)){
                doneButton = [keyboard viewWithTag:NUM_PAD_DONE_BUTTON_TAG];
                if (doneButton != nil){
                    [doneButton removeFromSuperview];
                }
            }
        }
    }
}
//点击完成按钮事件，收起键盘
-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}
@end
