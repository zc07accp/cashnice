//
//  IocInfoViewController.m
//  Cashnice
//
//  Created by a on 16/7/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IocInfoViewController.h"
#import "MyIOUDetailViewController.h"
#import "IouRepaymentViewController.h"
#import "WebDetail.h"

@interface IocInfoViewController ()


@property (strong, nonatomic) MKNetworkOperation *operation;


@property (weak, nonatomic) IBOutlet HeadImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *normalLabelCollection;
@property (weak, nonatomic) IBOutlet UILabel *capitalPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *capitalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *startValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *endValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionButtonWidth;

@property (nonatomic, strong) NSDictionary *iouDict;
@property (copy, nonatomic) NSString *creditor;
@property (copy, nonatomic) NSString *debtor;
@property (copy, nonatomic) NSString *amountDescription;
@property (copy, nonatomic) NSString *totalAmountDescription;

@property (nonatomic) BOOL iouStatusRepayConfirm;
@end

@implementation IocInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.ui_orderno;//@"借条信息";
    
    [self setNavButton];
    [self setRightNavBar];
    [self setupUI];
    
    if (self.iouDict) {
        [self refreshData];
    }
    
    [self connectToServer];
}

- (void)setupUI{
    [_normalLabelCollection enumerateObjectsUsingBlock:^(UILabel *  _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        
        lab.font = [UtilFont systemSmallNormal];
        lab.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        
    }];
    self.yuanLabel.font = [UtilFont systemLargeNormal];
    self.memberLabel.font  = [UtilFont systemNormal:18];
    self.accountLabel.font = [UtilFont systemNormal:33];
    self.promptLabel.font  = [UtilFont systemLargeNormal];
    
    self.actionButton.titleLabel.font = [UtilFont systemButtonTitle];
    self.actionButton.hidden = YES;
}

- (void)connectToServer
{
    [self.operation cancel];
    bugeili_net
    progress_show

    __weak IocInfoViewController *weakSelf = self;
    self.operation = [ZAPP.netEngine getMyIouDetailIouid:self.iouId complete:^{
        IocInfoViewController *strongSelf = weakSelf;
        weakSelf.iouDict = ZAPP.myuser.gerenMyIouDetail;
        [strongSelf refreshData];
        progress_hide
    } error:^{
        //IocInfoViewController *strongSelf = weakSelf;
        //[strongSelf loseData];
        progress_hide
        
    }];
}

- (IBAction)nextAction:(id)sender {
    if (self.iouListPageType == IouListPageTypeCreditor) {
        //催收进展
        NSString *urlStr = [NSString stringWithFormat:@"%@/iou/CollectionProgress/%@", WEB_DOC_URL_ROOT, @(self.iouId)];
        WebDetail *web = ZSTORY(@"WebDetail");
        web.userAssistantPath = @{@"name" : @"催收进展"};
        web.absolutePath = urlStr;
        [self.navigationController pushViewController:web animated:YES];
    }else{
        // 还款
        IouRepaymentViewController *repayment = ZMYIOU(@"IouRepaymentViewController");
        repayment.iouId = [self.iouDict[@"ui_id"] integerValue];
        repayment.totalAmount = [self.iouDict[@"total_amount"] doubleValue];
        [self.navigationController pushViewController:repayment animated:YES];
    }
}

- (void)refreshData{
    
    self.title = self.iouDict[@"ui_orderno"];
    
    [self setHeadImage];
    
    [self setInfoItems];
    
    [self setActonButtonAppearance];
    
    if (self.iouStatusRepayConfirm) {
        //已完成
        [self setDataForCompletion];
    }else{
        if ([self.iouDict[@"isOverDue"] integerValue]) {
            //逾期
            [self setDataForOverDue];
        }else{
            [self setDataForProcessive];
        }
    }
}

- (void)setActonButtonAppearance{
    
    if (self.iouListPageType == IouListPageTypeCreditor) {
        //出款人
        [self.actionButton setTitle:@"催收进展" forState:UIControlStateNormal];
        self.actionButton.hidden = (self.iouStatusRepayConfirm || ![self.iouDict[@"isOverDue"] integerValue]);
        [self.actionButtonWidth setPriority:UILayoutPriorityFittingSizeLevel];
        
        self.startPromptLabel.text = @"出借日";
        self.endPromptLabel.text = @"收回日";
    }else{
        //借款人
        [self.actionButton setTitle:@"还款给TA" forState:UIControlStateNormal];
        self.actionButton.hidden = self.iouStatusRepayConfirm;
        
        self.startPromptLabel.text = @"借入日";
        self.endPromptLabel.text = @"还款日";
    }
}

- (void)setInfoItems{
    //本金
    self.capitalValueLabel.text = [NSString stringWithFormat:@"%@元", self.amountDescription];
    
    //年利率
    double ui_loan_rate = [self.iouDict[@"ui_loan_rate"] doubleValue];
    self.rateValueLabel.text = [NSString stringWithFormat:@"%@%%", @(ui_loan_rate)];
    
    //出借日
    self.startValueLabel.text = self.iouDict[@"ui_loan_start_date"];
    
    //收回日
    if (self.iouStatusRepayConfirm) {
        self.endValueLabel.text = self.iouDict[@"format_repay_confirm_time"];//还款确认的时间
    }else{
        self.endValueLabel.text = self.iouDict[@"ui_loan_end_date"];
    }
    
}

//设置头像
- (void)setHeadImage{
    NSDictionary *counterpartUser = nil;
    if (self.iouListPageType == IouListPageTypeCreditor) {
        //显示借款人
        counterpartUser = self.iouDict[@"destUser"];
    }else{
        //显示出借人
        counterpartUser = self.iouDict[@"srcUser"];
    }
    NSString *headImgUrlStr = counterpartUser[@"head_img"];
    [self.headImageView setHeadImgeUrlStr:headImgUrlStr];
}

//已完成
- (void)setDataForCompletion{
    NSString *thinStr;
    NSMutableAttributedString *attStr;
    if (self.iouListPageType == IouListPageTypeCreditor) {
        thinStr = [NSString stringWithFormat:@"已全部收回%@的借款，共收回", self.debtor];
        attStr = [[NSMutableAttributedString alloc] initWithString:thinStr];
        [Util setAttributedString:attStr font:nil color:ZCOLOR(COLOR_BUTTON_BLUE) substr:self.debtor allstr:thinStr];
        
    }else{
        thinStr = [NSString stringWithFormat:@"已全部还清%@给您的借款，共支出", self.creditor];
        attStr = [[NSMutableAttributedString alloc] initWithString:thinStr];
        [Util setAttributedString:attStr font:nil color:ZCOLOR(COLOR_BUTTON_BLUE) substr:self.creditor allstr:thinStr];
        
    }
    self.memberLabel.attributedText = attStr;
    self.accountLabel.text = [Util formatRMBWithoutUnit:@([self.iouDict[@"ui_repay_amount"] doubleValue])];
    //self.totalAmountDescription;
    self.promptLabel.text = @"赞！赞！赞！";
}
//进行中
- (void)setDataForProcessive{
    
    NSInteger daysleft = [self.iouDict[@"daysleft"] integerValue];
    if (self.iouListPageType == IouListPageTypeCreditor) {
        NSString *thinStr = [NSString stringWithFormat:@"已经借给%@", self.debtor];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:thinStr];
        [Util setAttributedString:attStr font:nil color:ZCOLOR(COLOR_BUTTON_BLUE) substr:self.debtor allstr:thinStr];
        
        self.memberLabel.attributedText = attStr;
        if (daysleft > 0) {
            self.promptLabel.text = [NSString stringWithFormat:@"还有%zd天到期，预计到期可以收回%@元", daysleft, self.totalAmountDescription];
        }else{
            self.promptLabel.text = [NSString stringWithFormat:@"今日到期，预计到期可以收回%@元", self.totalAmountDescription];
        }
        self.accountLabel.text = self.amountDescription;
        
    }else{
        NSString *thinStr;
        if (daysleft > 0) {
            thinStr = [NSString stringWithFormat:@"到期应还款给出借人%@", self.creditor];
        }else{
            thinStr = [NSString stringWithFormat:@"今日到期，应还款给出借人%@", self.creditor];
        }
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:thinStr];
        [Util setAttributedString:attStr font:nil color:ZCOLOR(COLOR_BUTTON_BLUE) substr:self.creditor allstr:thinStr];
        self.memberLabel.attributedText = attStr;
        self.promptLabel.text = nil;
        self.accountLabel.text = self.totalAmountDescription;
    }
}
//已逾期
- (void)setDataForOverDue{
    
    NSInteger overDueDays = [self.iouDict[@"overDueDays"] integerValue];
    NSString *overDueDaysDesc = [NSString stringWithFormat:@"%zd", overDueDays];
    double ui_loan_rate = [self.iouDict[@"ui_loan_rate"] doubleValue];
    
    UIColor *redColor = CN_UNI_RED;
    
    if (self.iouListPageType == IouListPageTypeCreditor) {
        NSString *thinStr = [NSString stringWithFormat:@"%@已逾期%@天，等待其还款", self.debtor, overDueDaysDesc];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:thinStr];
        [Util setAttributedString:attStr font:nil color:redColor substr:self.debtor allstr:thinStr];
        [Util setAttributedString:attStr font:nil color:redColor substr:overDueDaysDesc allstr:thinStr];
        self.memberLabel.attributedText = attStr;
        
        self.promptLabel.text = [NSString stringWithFormat:@"正按%@%%的利率向对方计收入利息", @(ui_loan_rate)];
    }else{
        NSString *thinStr = [NSString stringWithFormat:@"已逾期%@天，请立即还款给%@", overDueDaysDesc, self.creditor];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:thinStr];
        [Util setAttributedString:attStr font:nil color:redColor substr:self.creditor allstr:thinStr];
        [Util setAttributedString:attStr font:nil color:redColor substr:overDueDaysDesc allstr:thinStr];
        self.memberLabel.attributedText = attStr;
        
        self.promptLabel.text = [NSString stringWithFormat:@"正按%@%%的利率计算逾期利息", @(ui_loan_rate)];
    }
    
    self.accountLabel.text = self.totalAmountDescription; //self.amountDescription;
}

- (void)setRightNavBar{
    //self.navigationItem.rightBarButtonItem = self.rightNavBar;
    [super setNavRightBtn];
    [self.rightNavBtn setTitle:@"详情" forState:UIControlStateNormal];

}

- (void)rightNavItemAction{
    [self pushDetaillView];
}

- (void)pushDetaillView{
    MyIOUDetailViewController *vc = [[MyIOUDetailViewController alloc]init];
    vc.iouListPageType = self.iouListPageType;
    vc.iouid = [self.iouDict[@"ui_id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];

}

- (NSString *)amountDescription{
    if (self.iouDict) {
        double amountValue = [self.iouDict[@"ui_loan_val"] doubleValue];
        return [Util formatRMBWithoutUnit:@(amountValue)];
    }else{
        return @"";
    }
}

- (NSString *)totalAmountDescription{
    if (self.iouDict) {
        double total_amount = [self.iouDict[@"total_amount"] doubleValue];
        
        return [Util formatRMBWithoutUnit:@(total_amount)];
    }else{
        return @"";
    }
}

- (NSString *)creditor{
    if (self.iouDict) {
        NSDictionary *srcUser = self.iouDict[@"srcUser"];
        if (srcUser) {
            return srcUser[@"user_real_name"];
        }else{
            return @"";
        }
        
    }else{
        return @"";
    }
}

- (NSString *)debtor{
    if (self.iouDict) {
        NSDictionary *srcUser = self.iouDict[@"destUser"];
        if (srcUser) {
            return srcUser[@"user_real_name"];
        }else{
            return @"";
        }
        
    }else{
        return @"";
    }
}

- (BOOL)iouStatusRepayConfirm{
    if (self.iouDict) {
        NSInteger iouStatus = [self.iouDict[@"ui_status"] integerValue];
        return (iouStatus == IOU_STATUS_REPAY_CONFIRM);
    }
    return NO;
}


@end
