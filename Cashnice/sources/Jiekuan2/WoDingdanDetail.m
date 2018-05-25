//
//  JiekuanDetailViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "WoDingdanDetail.h"
#import "JiekuanDetailViewController.h"
#import "RTLabel.h"
#import "QuerenTouzi.h"

@interface WoDingdanDetail () {

}

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeRed;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGreen;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeBlack;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeWhite;
@property (weak, nonatomic) IBOutlet UILabel *number1;
@property (weak, nonatomic) IBOutlet UILabel *number2;
@property (weak, nonatomic) IBOutlet UILabel *number3;
@property (weak, nonatomic) IBOutlet UILabel *number4;
@property (weak, nonatomic) IBOutlet UIView *textBg;
@property (weak, nonatomic) IBOutlet UILabel *descText;
@property (weak, nonatomic) IBOutlet RTLabel *descDownText;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_w;

@end

@implementation WoDingdanDetail



- (void)viewDidLoad {
    [super viewDidLoad];
    self.con_w.constant = [ZAPP.zdevice getDesignScale:390];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    
    self.textBg.backgroundColor = ZCOLOR( COLOR_TEXT_LIGHT_GRAY);
    
    for (UILabel *l in self.largeWhite) {
        l.textColor = [UIColor whiteColor];
        l.font = [UtilFont systemLarge];
    }
    
    [Util setUILabelLargeGray:self.largeGray];
    [Util setUILabelLargeRed:self.largeRed];
    [Util setUILabelLargeGreen:self.largeGreen];
    [Util setUILabelLargeBlack:self.largeBlack];
    
    _descDownText.font      =[UtilFont systemLarge];
    _descDownText.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    
    [self ui];
}

- (IBAction)detailAction:(id)sender {
    JiekuanDetailViewController * detail  = ZJKDetail(@"JiekuanDetailViewController");
    detail.dataDict = self.betDict[@"loan"];
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)ui {
    NSDictionary *dict = [self.betDict objectForKey:NET_KEY_LOAN];
    
    BOOL shouldHideName = [Util loanShouldHideNameWithDict:dict];
    self.descText.text = [NSString stringWithFormat:@"借款人:%@发起的借款", shouldHideName ? [Util getUserMaskNameOrNickName:dict] : [Util getUserRealNameOrNickName:dict]];
    
    int loanty = [[dict objectForKey:NET_KEY_LOANTYPE] intValue];
    self.descDownText.text = [NSString stringWithFormat:@"<font color=\"%@\">%@</font> <font color=\"%@\">%@</font>", COLOR_NAV_BG_RED, [Util getLoantype:loanty], COLOR_BUTTON_BLUE, [dict objectForKey:NET_KEY_TITLE]];
    //self.descDownText.hidden = YES;
    
    NSString *touzishijian = [self.betDict objectForKey:NET_KEY_BETTIME];
    double touzijine = [[self.betDict objectForKey:NET_KEY_BETVAL] doubleValue];
    
    int betstatus = [[self.betDict objectForKey:NET_KEY_BETSTATUS] intValue];
    self.number1.text = [self.betDict objectForKey:NET_KEY_ORDERNO];
    self.number2.text = [UtilString getBetStateString:[UtilString cvtIntToBetState:betstatus]];
    self.number3.text = [Util formatRMB:@(touzijine)];
//    self.number4.text =  [Util shortDateFromFullFormat:touzishijian];
    self.number4.text =  touzishijian;
    
    [self.view needsUpdateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"订单详情"];
    [self setTitle:@"订单详情"];
    
    
    [self ui];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"订单详情"];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ui];
}


@end
