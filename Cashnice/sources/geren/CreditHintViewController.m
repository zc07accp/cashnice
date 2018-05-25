//
//  CreditHintViewController.m
//  YQS
//
//  Created by a on 15/9/22.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CreditHintViewController.h"
#import "CreditStrategy.h"
#import "RTLabel.h"
#import "WebDetail.h"

@interface CreditHintViewController () <RTLabelDelegate>

@property (weak, nonatomic) IBOutlet RTLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBHeight3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBTop2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBTop3;

@property (strong, nonatomic) CreditStrategy *creditStrategy;
@end

@implementation CreditHintViewController

BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"授信提示"];
    [self setNavButton];
    self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
    
    //用户等级
    NSInteger userlevel =  [ZAPP.myuser.gerenInfoDict[@"userlevel"] integerValue];
    
    //剩余额度
    float mylimit = [ZAPP.myuser getRemainCreditLimit];
    
    NSString *str = nil;
    if (userlevel==2 && mylimit >= 5*1e4) {
        str = @"<font size=12 color=#333333>重要提示，请认真阅读：</font><br><font size=12 color=#666666>为对方授信（担保）后，如果对方发生借款违约，您将需要代对方偿还，赔偿上限<font color=#A7281F>1万</font>或<font color=#A7281F>5万</font>（取决于您向对方授信的额度），如有不明，请再仔细阅读<font color=#4c9cdb><a href='http://serviceNotice.com'>《服务协议》</font></a>和<a href='http://loanNotice.com'><font color=#4c9cdb>《借款须知》</font></a>。</font>";
    }else {
        str = @"<font size=12 color=#333333>重要提示，请认真阅读：</font><br><font size=12 color=#666666>为对方授信（担保）后，如果对方发生借款违约，您将需要代对方偿还，赔偿上限<font color=#A7281F>1万</font>，如有不明，请再仔细阅读<font color=#4c9cdb><a href='http://serviceNotice.com'>《服务协议》</font></a>和<a href='http://loanNotice.com'><font color=#4c9cdb>《借款须知》</font></a>。</font>";
    }
    
    //self.contentLabel.lineSpacing = 8.0;
    self.contentLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.contentLabel.font = [UtilFont systemLarge];
    
    [self.contentLabel setText:str];
    self.contentLabel.delegate = self;
    
    NSString *numStr = [Util intWithUnit:(int)(mylimit/1e4) unit:@"万元"];
    NSString *hintString = [NSString stringWithFormat:@"(您的剩余授信额度 %@) ", numStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString : hintString];
    [attStr addAttribute:NSForegroundColorAttributeName value:ZCOLOR(COLOR_NAV_BG_RED) range:[hintString rangeOfString:numStr]];
    
    self.hintLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.hintLabel.font = [UtilFont systemLarge];
    self.hintLabel.attributedText = attStr;
    
    CGFloat nextBheight = [ZAPP.zdevice getDesignScale:60];
    self.nextBHeight1.constant = self.nextBHeight2.constant = self.nextBHeight3.constant = nextBheight;
    self.nextBTop2.constant = nextBheight;
    self.nextBTop3.constant = nextBheight * 2;
    
    [self.creditStrategy setCreditButton];
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    WebDetail *w = ZSTORY(@"WebDetail");
    NSString *urlString = url.host;
    if ([urlString hasPrefix:@"service"]) {
        w.webType = WebDetail_service_agreement;
    }
    if ([urlString hasPrefix:@"loan" ]) {
        w.webType = WebDetail_borrow_xuzhi;
    }
    [self.navigationController pushViewController:w animated:YES];
}



- (void)askCredit {
    NSLog(@"=================================");
    NSLog(@"======    向他索要授信   ==========");
    
}

- (void)creditTo {
    NSLog(@"=================================");
    NSLog(@"======    加好友并向他授信   ==========");
}

- (void)changeCreditValue {
    NSLog(@"=================================");
    NSLog(@"======    改成XX万   ==========");
}

- (void)abandonCredit {
    NSLog(@"=================================");
    NSLog(@"======    取消授信   ==========");
}

- (CreditStrategy *)creditStrategy {
    if (! _creditStrategy) {
        _creditStrategy = [[CreditStrategy alloc] init];
        _creditStrategy.delegate = self;
        self.shouXintype = ShouXin_NoneHint;
    }
    return _creditStrategy;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    [self.creditStrategy prepareForSegue:segue sender:sender];
    
}


@end
