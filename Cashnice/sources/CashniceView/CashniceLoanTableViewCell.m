//
//  CashniceLoanTableViewCell.m
//  Cashnice
//
//  Created by a on 16/2/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CashniceLoanTableViewCell.h"
#import "AmountOfMoneyView.h"
#import "LoanItemsView.h"
#import "LoanProgressView.h"
#import "InvestActionView.h"
#import "JieKuanUtil.h"

@interface CashniceLoanTableViewCell() <LoanItemsDelegate, InvestActionDelegate>

@property (strong, nonatomic) AmountOfMoneyView *amountLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *periodLabel;
@property (strong, nonatomic) UILabel *guarLabel;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) InvestActionView *investActionView;
@property (strong, nonatomic) LoanItemsView *itemsView;
@property (strong, nonatomic) LoanProgressView *progressView;

@property (weak, nonatomic) NSDictionary *dataDictionary;
@end

@implementation CashniceLoanTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)updateCellData:(NSDictionary *)dataDictionary{
    
    _dataDictionary = dataDictionary;
    
    int loanstatus = [[dataDictionary objectForKey:NET_KEY_LOANSTATUS] intValue];
    if (loanstatus == 1) {
        //正在借款
        _amountLabel.isLight = YES;
        _investActionView.hidden = NO;
    }
    else {
        _amountLabel.isLight = NO;
        _investActionView.hidden = YES;
    }
    
    // 1：投资过，0：未投
    NSInteger isBet = [dataDictionary[@"isbet"] integerValue];
    _investActionView.isBet = isBet;
    
    NSString *rate = [Util percentProgress:[[dataDictionary objectForKey:NET_KEY_LOANRATE] doubleValue]];//@"10.00%";
    NSString *amount = [Util formatRMBWithoutUnit:@([[dataDictionary objectForKey:NET_KEY_LOANMAINVAL] doubleValue])];
    double progressValue = [[dataDictionary objectForKey:NET_KEY_LOANPROGRESS] doubleValue];
    NSString *progress = [Util percentProgress:progressValue];
    NSString *guar = [Util intWithUnit:[[dataDictionary objectForKey:NET_KEY_WARRANTYCOUNT ] intValue] unit:@"人"];
    int loaddaycnt = [[dataDictionary objectForKey:NET_KEY_interestdaycount] intValue];
    NSString *period = [Util intWithUnit:loaddaycnt unit:@"天"];
    
    self.itemsView.dataArray = @[rate,progress,guar,period,];
    if ([JieKuanUtil isPrivilegedWithLoan:dataDictionary]) {
        //抵押用户
        self.itemsView.loanItemsViewType = LoanItemsViewTypePrivilege;
    }else{
        self.itemsView.loanItemsViewType = LoanItemsViewTypeNormal;
    }
    
    self.progressView.progress = progressValue;
    self.amountLabel.amount = amount;
    self.titleLabel.text = dataDictionary[NET_KEY_LOANTITLE];
    
    [self setNeedsLayout];
}

- (void)investAction{
    
    id tableView = self.superview;
    if (! [tableView isKindOfClass:[UITableView class]]) {
        tableView = [tableView superview];
    }
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    if (_delegate) {
        [_delegate cashniceLoanInvestAction:indexPath];
    }
}

- (void)guaranteeAction{
    id tableView = self.superview;
    if (! [tableView isKindOfClass:[UITableView class]]) {
        tableView = [tableView superview];
    }
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    if (_delegate) {
        [_delegate cashniceLoanGuaranteeAction:indexPath];
    }
}

- (void)layoutSubviews{
    CGFloat margin = [ZAPP.zdevice getDesignScale:25];
    CGFloat btmMargin = [ZAPP.zdevice getDesignScale:5];
    
//    UIControl *containerControl = [[UIControl alloc] initWithFrame:CGRectMake(margin, margin, self.frame.size.width-2*margin, self.frame.size.height-2*margin+btmMargin)];
    
    self.containerView.frame = CGRectMake(margin, margin, self.frame.size.width-2*margin, self.frame.size.height-2*margin+btmMargin);
    
    CGFloat itemsViewHeight = [ZAPP.zdevice getDesignScale:45];
    self.itemsView.frame = CGRectMake(0, self.containerView.height-itemsViewHeight, self.containerView.width, itemsViewHeight);
    
    CGFloat progressViewHeight = [ZAPP.zdevice getDesignScale:25];
    CGFloat progressViewSpacing = [ZAPP.zdevice getDesignScale:15];
    self.progressView.frame = CGRectMake(0, self.itemsView.top-progressViewHeight-progressViewSpacing, self.containerView.width, progressViewHeight);
    
    CGFloat labelSpacing = [ZAPP.zdevice getDesignScale:5];
    CGFloat titleLabelHight = [ZAPP.zdevice getDesignScale:23];
    self.titleLabel.frame = CGRectMake(0, self.progressView.top-titleLabelHight-labelSpacing, self.containerView.width/4*3, titleLabelHight);

    CGFloat amountLabelHight = [ZAPP.zdevice getDesignScale:30];
    self.amountLabel.frame = CGRectMake(0, self.titleLabel.top-amountLabelHight- labelSpacing, self.containerView.width/2, amountLabelHight);
    
    
    //投资按钮
    CGFloat segmentWidth = (self.containerView.width - 3)/4;
//    CGFloat investActionViewPadding = [ZAPP.zdevice getDesignScale:15];
    _investActionView.frame = CGRectMake(segmentWidth*3+1, 0, segmentWidth, segmentWidth);

}

- (void)setupUI{
    [self addSubview:self.containerView];
    
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.amountLabel];
    [self.containerView  addSubview:self.itemsView];
    [self.containerView addSubview:self.progressView];
    [self.containerView addSubview:self.investActionView];
}

- (LoanProgressView *)progressView{
    if (! _progressView) {
        _progressView = [[LoanProgressView alloc]init];
    }
    return _progressView;
}
- (LoanItemsView *)itemsView{
    if (! _itemsView) {
        _itemsView = [[LoanItemsView alloc]init];
        _itemsView.delegate = self;
    }
    return _itemsView;
}
- (InvestActionView *)investActionView{
    if (! _investActionView) {
        _investActionView = [[InvestActionView alloc]init];
        _investActionView.delegate = self;
    }
    return _investActionView;
}
- (UIView *)containerView{
    if (! _containerView) {
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UtilFont system:20];
    }
    return _titleLabel;
}
- (AmountOfMoneyView *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[AmountOfMoneyView alloc]init];
    }
    return _amountLabel;
}
- (UILabel *)rateLabel{
    if (!_rateLabel) {
        _rateLabel = [[UILabel alloc]init];
    }
    return _rateLabel;
}
- (UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]init];
    }
    return _progressLabel;
}
- (UILabel *)periodLabel{
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc]init];
    }
    return _periodLabel;
}
- (UILabel *)guarLabel{
    if (!_guarLabel) {
        _guarLabel = [[UILabel alloc]init];
    }
    return _guarLabel;
}
@end
