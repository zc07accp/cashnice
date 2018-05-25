//
//  SocietyPositionViewController.m
//  Cashnice
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SocietyPositionViewController.h"
#import "SocietyPositionItemView.h"
#import "PersonInfoAPIEngine.h"
#import "GetUserInfoEngine.h"
#import "PersonInfoAPIEngine.h"

@interface SocietyPositionViewController () <SocietyPositionItemViewDeleate>

@property (strong, nonatomic) NSMutableArray *selectedPositionItems;

@property (weak, nonatomic) IBOutlet UIScrollView *scollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceHeight;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptViewHeight;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *prompt1;
@property (weak, nonatomic) IBOutlet UILabel *prompt2;

@property (strong, nonatomic) PersonInfoAPIEngine *engine;
@property (strong, nonatomic) GetUserInfoEngine *userInfoEngine;

@property (strong, nonatomic) NSString* socialfunc;
@property (strong, nonatomic) NSArray*  socialfuncArray;
@property (strong, nonatomic) NSString* socialDesc;

@end

@implementation SocietyPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.optionsViewHeight.constant = 1000;
    
    [self setNavButton];
    
//    if ( ZAPP.myuser.systemOptionsDictShehuiZhiwu) {
//        [self setData];
//    }
    
    [self conntectToServer];
    
    [self refreshUserInfo];
    
    self.title = @"社会职务";
    
    
    [self backviewTouchedGesture];
    
    [self setupUI];
    
    //self.commitButton.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"社会职务"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"社会职务"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)refreshUserInfo{
    //[self.op cancel];
    bugeili_net
    
    //lastDate = [NSDate date];
    
    WS(weakSelf)
    
    [self.userInfoEngine getUserInfoSuccess:^{
        
        
        [weakSelf setData];
        
    } failure:^(NSString *error) {
    }];
}

- (void)conntectToServer {
    progress_show
    
    
    if (!_engine) {
        progress_show
    }
    
    WS(weakSelf)
    [self.engine getUserIdentifyResult:ZAPP.myuser.getUserID success:^(NSDictionary *identArr) {
        progress_hide
        
        
        
        
        weakSelf.socialDesc =  EMPTYOBJ_HANDLE(identArr[@"desc"][@"itemvalue"]);
        weakSelf.socialfunc =  EMPTYOBJ_HANDLE(identArr[@"socialfunc"][@"itemvalue"]);
        
        
        
        [weakSelf.engine getSystemSocietyPositionSuccess:^(NSDictionary *dic) {
            
            [weakSelf setData];
            
        } failure:^(NSString *error) {
            progress_hide
        }];
        
    } failure:^(NSString *error) {
        progress_hide
        
    }];
    
//    
//    [ZAPP.netEngine getSystemConfigurationInfoWithComplete:^{
//        progress_hide
//        [self setData];
//    } error:^{
//        progress_hide
//    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
//    self.infoTextView.text = textView.text;
    
    UITextRange *selectedRange=[textView markedTextRange];
    
    
    UITextPosition *position=[textView positionFromPosition:selectedRange.start offset:0];
    
    if (!position) {
        if (textView.text.length>100) {
            textView.text=[textView.text substringToIndex:100];
        }
    }
    
    self.placeholder.hidden = !(textView.text.length == 0);
    [self changeValidate];
}

- (void)setupUI{
    
    self.headerView.hidden = [ZAPP.myuser getUserLevel] == UserLevel_VIP;
    self.promptViewHeight.constant =
    [ZAPP.myuser getUserLevel] == UserLevel_VIP ? 0 : [ZAPP.zdevice getDesignScale:50];
    
    self.placeholder.hidden = !(self.infoTextView.text.length == 0);
    
    self.optionsView.backgroundColor = [UIColor clearColor];
    
    self.prompt1.font =
    self.prompt2.font =
    self.promptPositionLabel.font =
    self.promptInfoLabel.font = [UtilFont systemLargeNormal];

    
    self.nameTextField.font =
    self.positionTextField.font =
    self.addressTextField.font = [UtilFont systemLarge];
    
    self.infoTextView.font = [UtilFont systemLarge];
    
    self.infoTextView.delegate = self;
}

- (void)setData{
    //公司名称
    self.nameTextField.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ORGANIZATIONNAME];
    
    //公司职务
    self.positionTextField.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ORGANIZATIONDUTY];
    
    //公司地址
    self.addressTextField.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ADDRESS];
    
    NSString *lab = [ZAPP.myuser limitLoanAmountForVIPuser];
    self.prompt2.text = [NSString stringWithFormat:@"继续认证成功: 获得授信额度%@，借款额度%@", lab, lab];
    
    
    self.infoTextView.text = self.socialDesc;
    
    self.placeholder.hidden = self.infoTextView.text.length > 0;
    
    [self setSocietyItems];
}

- (void)societyPositionItem:(NSDictionary *)itemDict didSelected:(BOOL)selected{
    
    NSInteger optionsid = [itemDict[@"itemvalue"] integerValue];
    if (selected) {
        [self.selectedPositionItems addObject:@(optionsid)];
    }else{
        [self.selectedPositionItems removeObject:@(optionsid)];
    }
    
    [self changeValidate];
}

- (void)changeValidate{
    
//    if (self.selectedPositionItems.count == 0) {
//        self.commitButton.enabled = NO;
//        return;
//    }
    
    NSArray *own = self.socialfuncArray;
    
    NSArray *seled = [self.selectedPositionItems sortedArrayUsingComparator:^NSComparisonResult(NSNumber  *num1, NSNumber *num2) {
        if (num1.integerValue > num2.integerValue) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    own = [own sortedArrayUsingComparator:^NSComparisonResult(NSNumber  *num1, NSNumber *num2) {
        if (num1.integerValue > num2.integerValue) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    if (seled.count > 0 && self.selectedPositionItems.count != own.count) {
        self.commitButton.enabled = YES;
        return;
    }
    
    for (int i = 0; i<seled.count; i++) {
        if ([seled[i] integerValue] != [own[i] integerValue] ) {
            self.commitButton.enabled = YES;
            return;
        }
    }
    
    if (self.infoTextView.text.length > 0 && ![self.infoTextView.text isEqualToString:self.socialDesc]) {
        self.commitButton.enabled = YES;
        return;
    }
    
//    if (self.selectedPositionItems.count <= 0) {
//        self.commitButton.enabled = NO;
//        return;
//    }
    
    self.commitButton.enabled = NO;
}

- (void)setSocietyItems{
    
    [self setSelectedItemData];
    
    CGRect frame = self.optionsView.bounds;
    frame.size.width = self.view.width * 394 / 414;
    
    SocietyPositionItemView *v = [[SocietyPositionItemView alloc] initWithFrame:frame];
    self.optionsViewHeight.constant = v.fitHeight;
    //self.optionsView.height = v.fitHeight;
    //SocietyPositionItemView *v1 = [[SocietyPositionItemView alloc] initWithFrame:frame];
    v.delegate = self;
    v.height = v.fitHeight;
    [v setSelectedItems:self.selectedPositionItems];
    
    [self.optionsView addSubview:v];
}

- (void)setDataTheThe {
    //[Util toastStringOfLocalizedKey:@"tip.submittedForReview"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backviewTouchedGesture{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backviewTouched:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}

-(void)backviewTouched:(UITapGestureRecognizer*)tap1{
    [self.view endEditing:YES];
    
}
- (IBAction)commitAction:(id)sender {
    [self.view endEditing:YES];
    
    /*
    if (self.nameTextField.text.length <  1) {

        [Util toastStringOfLocalizedKey:@"tip.inputtingCompanyName"];
        return;
    }
    if (self.positionTextField.text.length <  1) {

        [Util toastStringOfLocalizedKey:@"tip.inputtingCompanyPosition"];
        return;
    }
    if (self.addressTextField.text.length <  1) {

        [Util toastStringOfLocalizedKey:@"tip.inputtingCompanyAddress"];
        return;
    }
    if (self.selectedPositionItems.count < 1) {
        [Util toastStringOfLocalizedKey:@"tip.inputtingPositionItem"];
        return;
     }
    */
    progress_show
    
    WS(ws);
    
    
    [[PersonInfoAPIEngine sharedInstance] setUserIdentityPositions:self.selectedPositionItems explain:self.infoTextView.text success:^{
        [ws setDataTheThe];
        
        POST_USERINFOFRESH_NOTI
        
        progress_hide
    } failure:^(NSString *error) {
        progress_hide
    }];

    /*
    [ZAPP.netEngine newCommitCompanyWithComplete:^{
        [ws setDataTheThe];
        progress_hide
    } error:^{
        progress_hide
    } company:@"" job:@"" address:@"" positions:self.selectedPositionItems explain:self.infoTextView.text];
     */
}


- (void)keyboardWasShown:(NSNotification *)aNotification {
    if (![self.infoTextView isFirstResponder]) {
        return;
    }
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //[UIView beginAnimations:@"TEXTVIEW_KEYBOARD" context:nil];
    //[UIView setAnimationDuration:animationDuration];
    
    self.bottomSpaceHeight.constant = keyboardRect.size.height + 20;
    
//    CGFloat offset = _scollView.height + 20 - _scollView.contentSize.height;
//    offset = keyboardRect.size.height - offset;
//    
//    CGFloat scrollY =  _scollView.contentOffset.y + offset;
//    _scollView.contentOffset = CGPointMake(0, scrollY);
    
    //[UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"TEXTVIEW_KEYBOARD" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.bottomSpaceHeight.constant = 20;
    [UIView commitAnimations];
}

- (NSMutableArray *)selectedPositionItems {
    if (! _selectedPositionItems) {
    
        _selectedPositionItems = [NSMutableArray new];
        
    }
    
    return _selectedPositionItems;
}

-(void)setSelectedItemData{
    
    NSArray *own = self.socialfuncArray;
    
    
    if ([own isKindOfClass:[NSArray class]] && own.count > 0) {
        [self.selectedPositionItems removeAllObjects];
        for (NSString *gid in own) {
            if ([gid isKindOfClass:[NSString class]] && gid.length  > 0) {
                NSInteger nid = [gid integerValue];
                [self.selectedPositionItems addObject:@(nid)];
            }
        }
    }
}

-(PersonInfoAPIEngine *)engine{
    
    if(!_engine){
        _engine = [PersonInfoAPIEngine sharedInstance];
    }
    
    return _engine;
}

-(GetUserInfoEngine *)userInfoEngine{
    
    if (!_userInfoEngine) {
        _userInfoEngine = [[GetUserInfoEngine alloc]init];
    }
    return _userInfoEngine;
}

- (NSArray *)socialfuncArray{
    if (_socialfunc && _socialfunc.length > 0) {
        NSArray *arr = [_socialfunc componentsSeparatedByString:@","];
        return arr;
    }
    return @[];
}

@end
