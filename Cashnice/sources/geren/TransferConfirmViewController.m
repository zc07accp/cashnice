//
//  TransferConfirmViewController.m
//  Cashnice
//
//  Created by a on 16/10/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TransferConfirmViewController.h"
#import "TransferIndexViewController.h"
#import "SinaCashierModel.h"
#import "SinaCashierWebViewController.h"
#import "TransferHistoryViewController.h"
#import "CNActionButton.h"

@interface TransferConfirmViewController ()<UIGestureRecognizerDelegate,  HandleCompletetExport>{
    double _balanceVal;
    double _leftVal;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountPromptLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UILabel *balancePromptLabel;
@property (weak, nonatomic) IBOutlet CNActionButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *promptTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *prompt1Label;
@property (weak, nonatomic) IBOutlet UILabel *prompt2Label;

@end

@implementation TransferConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认转账";
    [self setNavButton];
    
    [self setupUI];
    [self tapBackground];
    [self setNavRightBtn];
    
    [self connectToServer];
}

- (void)setupUI{
    self.nameLabel.font = CNFont_28px;
    self.phoneLabel.font = CNFont_28px;
    self.commentPromptLabel.font  =
    self.commentTextField.font    =
    self.accountPromptLabel.font  =
    self.accountTextField.font    = CNFont_28px;
    self.balancePromptLabel.font = CNFont_26px;
    
    
    self.promptTitleLabel.font = CNFont_26px;
    self.prompt1Label.font = self.prompt2Label.font = CNFont_24px;
    
    self.commentTextField.borderStyle = UITextBorderStyleNone;
    self.headImageView.layer.cornerRadius = [ZAPP.zdevice scaledValue:68.0/2];
    self.headImageView.layer.masksToBounds = YES;
    
    //self.actionButton.associatedTextField = self.accountTextField;
    
    
    [self.headImageView setImageFromURL:[NSURL URLWithString:self.targetUserDict[@"headimg"]] placeHolderImage:[Util imagePlaceholderPortrait]];
    self.nameLabel.text = self.targetUserDict[@"userrealname"];
    NSString *userphone = self.targetUserDict[@"userphone"];
    if (userphone.length < 1) {
        userphone = EMPTYSTRING_HANDLE(self.targetUserDict[@"phone"]);
    }
    self.phoneLabel.text  = userphone.length>0?userphone:nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"确认转账"];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"确认转账"];
}

-(void)setNavRightBtn{
    
    self.isRightNavBtnBorderHidden = YES;
    
    [super setNavRightBtn];
    
    [self.rightNavBtn.titleLabel setFont:CNFontNormal];
    [self.rightNavBtn setTitle:@"转账记录" forState:UIControlStateNormal];
    [self.rightNavBtn sizeToFit];
    
    [self.rightNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(3);
        make.top.equalTo(self.rightNavBtn.superview);
    }];
    
    [self.rightNavBtn addTarget:self action:@selector(showHistory) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showHistory {
    TransferHistoryViewController *history = ZPERSON(@"TransferHistoryViewController");
    
    history.userName = EMPTYSTRING_HANDLE(self.targetUserDict[@"userrealname"]);
    history.targetUserId = [NSString stringWithFormat:@"%@",self.targetUserDict[@"userid"]];
    [self.navigationController pushViewController:history animated:YES];
}

- (IBAction)transferAction:(id)sender {
    [self finishEditing];
    
    NSString *transferVal = self.accountTextField.text;
    NSString *comment = self.commentTextField.text;
    NSString *userid = self.targetUserDict[@"userid"];
    
    __weak typeof(self) weakSelf = self;
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    progress_show
    [model transfer:transferVal target:userid comment:comment success:^(NSData *contentData) {
        progress_hide
        SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
        web.loadData = contentData;
        web.titleString = @"充值";
        web.completeHandle = self;
        [weakSelf.navigationController pushViewController:web animated:YES];
    } failure:^(NSString *error) {
        progress_hide;
    }];
}

- (void)complete {
    NSArray *vcs = self.navigationController.viewControllers;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[TransferIndexViewController class]]) {
            TransferIndexViewController *tvc = (TransferIndexViewController *)vc;
            tvc.needRefresh = YES;
            [self.navigationController popToViewController:tvc animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)connectToServer {
    progress_show
    WS(ws)
    [ZAPP.netEngine getTransferLimitComplete:^{
        progress_hide
        NSDictionary *limtDcit = ZAPP.myuser.withdrawLimitRespondDict;
        _balanceVal = [limtDcit[@"balance"] doubleValue];
        _leftVal = ZAPP.myuser.transferLimitLeft;
        ws.balancePromptLabel.text = [NSString stringWithFormat:@"当前账户余额%@", [Util formatRMB:@(_balanceVal)]];
        ws.accountTextField.placeholder = [NSString stringWithFormat:@"今日还可以转账%@", [Util formatRMB:[NSNumber numberWithDouble:(_leftVal)]]];
    } error:^{
        progress_hide;
    }];
}
- (IBAction)inputChanged:(id)sender {
    if (sender == self.accountTextField) {
        self.accountTextField.text = [Util cutMoney:self.accountTextField.text];
        double inputedVal = [self.accountTextField.text doubleValue];
        self.actionButton.enabled = (inputedVal > 0 && inputedVal <= _balanceVal && inputedVal <= _leftVal );
    }
    if (sender == self.commentTextField) {
        if (self.commentTextField.text.length > 20) {
            self.commentTextField.text = [self.commentTextField.text substringToIndex:20];
        }
    }
    
}

-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishEditing)];
    tap.delegate = self;
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}
-(void)finishEditing//手势方法
{
    //[self.view endEditing:NO];
    
    [self.accountTextField resignFirstResponder];
    [self.commentTextField resignFirstResponder];
}

@end
