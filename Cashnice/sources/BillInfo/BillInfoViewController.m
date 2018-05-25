//
//  BillInfoViewController.m
//  Cashnice
//
//  Created by a on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillInfoViewController.h"
#import "LoanDetailEngine.h"
#import "GuaDetailListViewController.h"
#import "LoanInfoViewModel.h"
#import "InvestmentInfoViewModel.h"
#import "GuaranteeInfoViewModel.h"
#import "LoanInfoViewModel.h"
#import "BillInfoViewModel.h"
#import "BILLWebViewUtil.h"
#import "BillThreeCell.h"
#import "RedPackageWidget.h"
#import "RedPackageWrapper.h"
#import "CheckingGuaranteeViewController.h"

static CGFloat const TABLEVIEW_HEADERHEIGHT = 33;


@interface BillInfoViewController () {
    NSDictionary *_dataModel;
    RedPackageWrapper *red;
    
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *appreciationPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainValLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDatePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDatePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *mainValPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *protectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *protectionView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageWidthCon;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *normalLabels;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionsViewHeightConstraint;


@property (weak, nonatomic) IBOutlet UIView *amountTitleView;
@property (weak, nonatomic) IBOutlet UIView *packageView;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageViewWidth;

@end

@implementation BillInfoViewController


+ (instancetype)instanceWithLoanType:(LoanBillType)loanBillType loanId:(NSUInteger)loanId betId:(NSUInteger)betId{
    switch (loanBillType) {
        case LoanBillTypeMyLoan:
        {
            LoanInfoViewModel *vm = [[LoanInfoViewModel alloc] initWithLoanId:loanId];
            return [BillInfoViewController initStaticWithViewModel:vm];
        }
            break;
        case LoanBillTypeMyInvestment:
        {
            InvestmentInfoViewModel *vm= [[InvestmentInfoViewModel alloc] initWithLoanId:loanId betid:betId];
            return [BillInfoViewController initStaticWithViewModel:vm];
        }
            break;
        case LoanBillTypeMyGuarantee:
        {
            GuaranteeInfoViewModel *vm = [[GuaranteeInfoViewModel alloc] initWithLoanId:loanId];
            return [BillInfoViewController initStaticWithViewModel:vm];;
        }
            break;
        default:
            return nil;
            break;
    }
}

+ (instancetype)initStaticWithViewModel:(BillInfoViewModel *)vm{
    BillInfoViewController *vc = [[BillInfoViewController alloc] initWithViewModel:vm];
    return vc;
}

- (instancetype)initWithViewModel:(BillInfoViewModel *)vm{
    if (self = [super init]) {
        self.vm = vm;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavRightBtn];
    [self setNavButton];
    self.contentView.hidden = YES;
    progress_show
    self.vm.vc = self;
    
    self.protectionLabel.font = CNFont_28px;
    self.accountPromptLabel.font = CNFont_34px;
    self.accountLabel.font = CNFont_58px;
    self.yuanLabel.font = CNFont_30px;
    self.appreciationPromptLabel.font = CNFont_28px;
    self.transferInfoLabel.font = CNFont_28px;
    self.transferInfoLabel.textColor = CN_UNI_RED;
    
    [self.normalLabels enumerateObjectsUsingBlock:^(UILabel*  _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        lab.font = CNFont_24px;
        lab.textColor = CN_TEXT_GRAY;
    }];

    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    self.detailTableView.bounces = NO;
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.detailTableView.hidden = YES;
    [self setDetailTableViewHeight:0];
    
    self.transferInfoLabel.text  =  @"";
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    if ([self.vm isKindOfClass:[InvestmentInfoViewModel class]]) {
        [self.vm connectToServer];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.vm isKindOfClass:[LoanInfoViewModel class]]) {
        SharedTrigger;
    }
}

- (void)refreshView {
    [self.vm connectToServer];
}

- (void)refreshViewAndDelay{
    progress_show
    [self performSelector:@selector(refreshView) withObject:nil afterDelay:3.0f];
}

- (void)setupUI{
    if ([self.vm alreadyToUse]) {
        
        [self setNavRightBtn];
        
        self.title = [self.vm viewTitle];
        [self setHeadImage];
        self.accountPromptLabel.attributedText = [self.vm accountPromptString];
        //self.accountLabel.text = [self getFormatedNumber:[self.vm accountNumber]];
        self.accountLabel.text = [self.vm accountString];
        self.appreciationPromptLabel.text = [self.vm appreciationPromptString];
        
        //if ([self.vm isTransferEnabled]) {  API判断
        self.transferInfoLabel.text = [self.vm title4PromptString];
        //}
        
        self.mainValLabel.text = [NSString stringWithFormat:@"%@元", [self getFormatedNumber:[self.vm mainvalNumber]]];
        self.rateLabel.text = [NSString stringWithFormat:@"%@%%", [Util formatFloat:[self.vm rateNumber]]];
        self.startDateLabel.text = [self.vm startDate];
        self.endDateLabel.text = [self.vm endDate];
        
        if ([[self.vm endDate] length]  <=  1) { ////避免没有收回日时，有时会传0
            self.endDatePromptLabel.hidden = YES;
            self.endDateLabel.hidden = YES;
        }
        
        self.contentView.hidden = NO;
        
        if ([self.vm isKindOfClass:[LoanInfoViewModel class]]) {
            //我的借款
            self.startDatePromptLabel.text = [self.vm startPromptText];
            if ([self.vm isOverdue] && ![self.vm isGrace]) {
                self.detailTableView.hidden = NO;
            }else{
                self.detailTableView.hidden = YES;
                [self setDetailTableViewHeight:0];
            }
            //宽限期 - 红色
            if ([self.vm isGrace]){
                self.appreciationPromptLabel.textColor = CN_UNI_RED;
            }
            //担保确认
            if (-3 == (int)[self.vm loanState]) {
                self.mainValPromptLabel.text = @"已确认担保人数";
                self.startDatePromptLabel.text = @"已确认担保额度";
                self.endDatePromptLabel.text = @"提交日";
                
                self.mainValLabel.text = [NSString stringWithFormat:@"%@人",self.vm.model[@"confirmed_people"]];
                
                double d = [self.vm.model[@"confirmed_money"] doubleValue];
                self.startDateLabel.text = [Util formatRMB:[NSNumber numberWithDouble:d]];
                self.endDateLabel.text = self.vm.model[@"datetime1"];
                
                self.endDatePromptLabel.hidden =
                self.endDateLabel.hidden = NO;
            }
            
        }else if([self.vm isKindOfClass:[InvestmentInfoViewModel class]]){
            //我的投资
            self.mainValPromptLabel.text = @"借款";
            self.detailTableView.hidden = YES;
            [self setDetailTableViewHeight:0];
            self.endDatePromptLabel.text = @"收回日";
            
            //逾期
            if (self.vm.loanState != JieKuan_FinishedAndPayed && self.vm.isOverdue) {
                //不在宽限期
                if (! [self.vm isGrace]) {
                    self.yuanLabel.font = [UIFont systemFontOfSize:0.0f];
                    self.yuanLabel.text = @"";
                    self.accountLabel.font = CNFont_34px;
                }
            }
            
            if ([self.vm packageValue] > 0) {
                //逾期不显示
                if (self.vm.isOverdue) {
                    //宽限期显示
                    if ([self.vm isGrace]) {
                        [self setupPackageView];
                    }
                }else if(self.vm.loanState == JieKuan_FinishedAndPayed){
                    //已还款 不显示
                }else{
                    [self setupPackageView];
                }
            }
            
            /*
            if (([self.vm packageValue] <= 0 ||
                 self.vm.loanState == JieKuan_FinishedAndPayed ||
                 (self.vm.loanState == JieKuan_FinishedNow && self.vm.isOverdue)) //逾期未还款不显示
                
                &&(self.vm.loanState == JieKuan_FinishedNow && ![self.vm isGrace])//并且 不在宽限期
                
                ){}
            else
            {
                
            }
            */
            
            //加息券
            RedPackageWidget *coupon =  [self.couponView viewWithTag:10011];
            
            
            if ([self.vm couponValue] > 0) {
                
                if (!coupon) {
                    CGFloat width = [ZAPP.zdevice scaledValue:52.0];
                    CGFloat height = width/120*40 + 1;
                    self.couponViewHeight.constant = height;
                    
                    //CGFloat left = self.rateLabel.right + [ZAPP.zdevice scaledValue:1.0];
                
                    coupon = [[RedPackageWidget alloc] initWithFrame:CGRectMake(0, 0, width, height) font:CNFont_24px];
                    
                    coupon.tag = 10011;
                    [self.couponView addSubview:coupon];
                }
                
                double precent = kcoupan_rate_precision * [self.vm couponValue];
                coupon.value = [NSString stringWithFormat:@"+%@%%", [Util formatFloat:@(precent)]];
                
                coupon.isCoupon = YES;
                
                //coupon.left = self.rateLabel.right + [ZAPP.zdevice scaledValue:4.0];
                //coupon.bottom = self.couponView.bottom;
                
            }else{
                if (coupon) {
                    [coupon removeFromSuperview];
                }
            }
        }else if([self.vm isKindOfClass:[GuaranteeInfoViewModel class]]){
            //我的担保
            self.mainValPromptLabel.text = @"借款";
            self.detailTableView.hidden = YES;
            [self setDetailTableViewHeight:0];
            
            //担保确认中
            if ((int)self.vm.loanState == -3) {
                self.rightNavBtn.hidden = YES;
                
                self.startDatePromptLabel.text = @"提交日";
            }
            
            //self.endDatePromptLabel.text = @"还款日";
        }
        [self setActionButton];
        [self setHeadImageViewRoundCorner];
        
        [self.detailTableView reloadData];
        [self setDetailTableViewHeight:([self.vm warrantyRepayment].count+1)*IPHONE6_ORI_VALUE(30)+IPHONE6_ORI_VALUE(TABLEVIEW_HEADERHEIGHT)+20];
        
        _dataModel = [self.vm model];
    }
    progress_hide
}

- (void)setupPackageView{
    
    //我的投资-红包
    
    NSString *valText = [NSString stringWithFormat:@"%zd", [self.vm packageValue]];
    red = [[RedPackageWrapper alloc]
           initWithPackageWidth:[ZAPP.zdevice scaledValue:44.0]
           packageFont:CNFont_30px
           wrapperFont:CNFont_30px
           value:valText];
    [self.packageView addSubview:red];
    
    CGRect frame = red.frame;
    self.pageViewWidth.constant = frame.size.width;
    
    CGFloat redY = self.packageView.frame.size.height - frame.size.height;
    red.frame = CGRectMake(0, redY, frame.size.width, frame.size.height);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.pageViewWidth.constant = red.frame.size.width;
}

-(void)setHeadImage{
    NSString *imageName = [self.vm headImageName];
    if ([imageName length]<1 || [imageName hasPrefix:@"http"]) {
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[Util imagePlaceholderPortrait]];
//        [self.headImageView setImageFromURL:[NSURL URLWithString:imageName] placeHolderImage:[Util imagePlaceholderPortrait]];
    }else{
        self.headImageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setHeadImageViewRoundCorner{
    CGFloat width = [ZAPP.zdevice getDesignScale:74.0f];
    self.headImageWidthCon.constant = width;
    self.headImageView.layer.cornerRadius = width/2;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setActionButton{
    
    CGFloat padding = [ZAPP.zdevice getDesignScale:20.0];
    CGFloat btnHeight = [ZAPP.zdevice getDesignScale:37.0];
    
    [[self.actionView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    //self.actionView.backgroundColor = [UIColor cyanColor];
    //self.protectionView.backgroundColor = [UIColor redColor];
    
    [self.actionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((padding+btnHeight) * ([self.vm actions].count + [self.vm showProtection]));
    }];
    
    [[self.vm actions] enumerateObjectsUsingBlock:^(NSArray*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = [obj firstObject];
        NSString *actionName = [obj lastObject];
        
        SEL selector = NSSelectorFromString(actionName);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.actionView addSubview:btn];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
        
        //UIImage *backImage = [Util imageWithColor:ZCOLOR(COLOR_NAV_BG_RED)];
        //UIImage *highlightdBackImage = [Util imageWithColor:ZCOLOR(COLOR_BILL_BG_YELLOW)];
        //[btn setBackgroundImage:backImage forState:UIControlStateNormal];
        //[btn setBackgroundImage:highlightdBackImage forState:UIControlStateHighlighted];
        
        
        //转让按钮不可用时 置灰
        if (obj.count > 2) {
            BOOL available = [obj[1] boolValue];
            if (! available) {
                btn.enabled = NO;
                btn.backgroundColor = ZCOLOR(COLOR_BUTTON_DISABLE);
            }
        }
        
        
        btn.titleLabel.font = CNFont_32px;
        [btn addTarget:self.vm action:selector forControlEvents:UIControlEventTouchUpInside];
        //[btn addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4.0];
        btn.layer.masksToBounds = YES;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.actionView);
            make.right.equalTo(self.actionView);
            make.height.mas_equalTo(btnHeight);
            make.top.equalTo(self.actionView).mas_offset((padding+btnHeight) * (idx + [self.vm showProtection]) );
        }];
        
    }];
    
    self.actionsViewHeightConstraint.constant = ((padding+btnHeight) * ([self.vm actions].count + [self.vm showProtection]) );
    
    //催收保护中按钮
    if ([self.vm showProtection]) {
        self.protectionView.hidden = NO;
        [self.actionView addSubview: self.protectionView];
    }else{
        self.protectionView.hidden = YES;
    }
}

- (void)testAction{
    NSLog(@"TEST");
}

- (void)setDetailTableViewHeight:(CGFloat)height{
    self.detailTableViewHeightConstraint.constant = height;
    [self.view setNeedsLayout];
}

-(void)setNavRightBtn{
    
    [super setNavRightBtn];
    
    if (-3 == (int)[self.vm loanState]) {
        [self.rightNavBtn setTitle:@"查看担保" forState:UIControlStateNormal];
    }else{
        [self.rightNavBtn setTitle:@"详情" forState:UIControlStateNormal];
    }
}

- (void)rightNavItemAction{
    if (-3 == (int)[self.vm loanState]) {
        CheckingGuaranteeViewController *vc = [CheckingGuaranteeViewController new];
        vc.loanInfo = [self.vm model];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.vm pushDetailView];
    }
}

- (IBAction)protectionViewAction:(id)sender {
    //NSLog(@"催收系统保护中");
    [BILLWebViewUtil presentOverdueIndexFrom:self];
}

- (NSString *)getFormatedNumber:(NSNumber *)number{
    return [Util formatRMBWithoutUnit:number];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if([self.vm warrantyRepayment].count == 0){
        return 0;
    }
    
    return IPHONE6_ORI_VALUE(TABLEVIEW_HEADERHEIGHT);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //逾期  loantype != 2  都显示
    if ([self.vm isOverdue] && [self.vm loantype]!=2) {
        return [self.vm warrantyRepayment].count + 1;

    }else{
       // loantype ==2 啥也不显示
        return 0;
    }

}


- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, IPHONE6_ORI_VALUE(TABLEVIEW_HEADERHEIGHT))];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *_headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _headerView.bounds.size.width, 20)];
    _headerLabel.font = [UIFont systemFontOfSize:15];
    _headerLabel.textColor = CN_TEXT_GRAY ;
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_headerLabel];

    _headerLabel.text = @"担保明细";
    
    UIView*lineview = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height-1, _headerLabel.frame.size.width, 1)];
    [lineview setBackgroundColor:CN_SEPLINE_GRAY];
    [_headerView addSubview:lineview];
    
    return _headerView;
}

//子类根据情况重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self cellForThreeLabel:tableView indexPath:indexPath];
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return IPHONE6_ORI_VALUE(30);
}


-(UITableViewCell *)cellForThreeLabel:(UITableView *)tw indexPath:(NSIndexPath *)indexPath{
    
    BillThreeCell *cell = [BillThreeCell cellWithNib:tw];
    cell.bottomLineHidden = YES;

    if (indexPath.row == 0) {
        cell.showTitle = YES;
    }else{
        NSArray *arr = [self.vm warrantyRepayment];
        if (indexPath.row-1 < arr.count) {
            cell.dic = arr[indexPath.row-1];
        }
        
    }

    
    return cell;

}


@end
