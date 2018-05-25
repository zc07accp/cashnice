//
//  JiekuanDetailViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "QuerenShouxin.h"
#import "TTTAttributedLabel.h"
#import "WebDetail.h"

@interface QuerenShouxin() {
    NSInteger _selectedIndex;
}

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *smallGray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkBox;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tishiLabel;
@property (weak, nonatomic) IBOutlet UIView *button3;
@property (weak, nonatomic) IBOutlet UIView *button2;

@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NextButtonViewController *next;

@end

@implementation QuerenShouxin 


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    
    [Util setUILabelLargeGray:self.largeGray];
    [Util setUILabelSmallGray:self.smallGray];
    
    _selectedIndex = 0;
    
    self.button2.hidden = YES;
    
    [self getAttrFooter];
}

- (NSString *)getAllString:(NSString *)moneystr {
    return [NSString stringWithFormat:@"重要提示，请认真阅读：\n为对方授信（担保）后，如果对方发生借款违约，您将需要代对方赔偿，赔偿上限5万元。如有不明，请再仔细阅读《服务协议》和《借款须知》。\n（您的剩余授信额度%@）", moneystr];
}

- (void)getAttrFooter {
    int mylimit = [ZAPP.myuser getRemainCreditLimit];
    NSString *moneystr = [NSString stringWithFormat:@"%d万元", (int)(mylimit/10000)];
    NSString *x = [self getAllString:moneystr];
    NSMutableAttributedString *z = [Util getAttributedString:x font:[UtilFont systemLarge] color:ZCOLOR(COLOR_TEXT_BLACK)];
    
    NSRange r1 = [x rangeOfString:@"《服务协议》"];
    NSRange r2 = [x rangeOfString:@"《借款须知》"];
    NSRange r3 = [x rangeOfString:@"重要提示，请认真阅读："];
    NSRange r4 = [x rangeOfString:moneystr];
    [Util setAttributedString:z font:nil color:ZCOLOR(COLOR_BUTTON_BLUE) range:r1];
    [Util setAttributedString:z font:nil color:ZCOLOR(COLOR_BUTTON_BLUE) range:r2];
    [Util setAttributedString:z font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:r4];
    [Util setAttributedString:z font:[UIFont boldSystemFontOfSize:15] color:[UIColor blackColor] range:r3];
    
    NSMutableParagraphStyle *pa = [[NSMutableParagraphStyle alloc] init];
    pa.lineSpacing = 5;
    pa.firstLineHeadIndent= 5;
    pa.headIndent = 5;
    pa.tailIndent = -5;
    [z addAttribute:NSParagraphStyleAttributeName value:pa range:NSMakeRange(0, x.length)];
    
    self.tishiLabel.attributedText = z;
    
    self.tishiLabel.userInteractionEnabled = YES;
    self.tishiLabel.numberOfLines = 0;
    
    self.tishiLabel.linkAttributes = @{ NSForegroundColorAttributeName : (id)ZCOLOR(COLOR_BUTTON_BLUE).CGColor };
    self.tishiLabel.activeLinkAttributes = @{ NSForegroundColorAttributeName: (id)ZCOLOR(COLOR_BUTTON_BLUE).CGColor };
    
    [self.tishiLabel addLinkToURL:[NSURL URLWithString:@"0"] withRange:r1];
    [self.tishiLabel addLinkToURL:[NSURL URLWithString:@"1"] withRange:r2];
    
    self.tishiLabel.delegate = self;
    
    [self updateLabelContent];
}

- (void)updateLabelContent {
    NSString *x = @"5万";
    if (_selectedIndex == 0) {
        x = @"1万";
    }
    
    NSMutableAttributedString *z = [[NSMutableAttributedString alloc] initWithAttributedString:self.tishiLabel.attributedText];
    [z replaceCharactersInRange:[[self getAllString:@""] rangeOfString:@"5万"] withString:x];
    self.tishiLabel.attributedText = z;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    int tag = [[url absoluteString] intValue];
    WebDetail *w = ZSTORY(@"WebDetail");
    if (tag == 0) {
        w.webType = WebDetail_service_agreement;
    }
    else {
        w.webType = WebDetail_borrow_xuzhi;
    }
    [self.navigationController pushViewController:w animated:YES];
}

- (IBAction)checkPressed:(UIButton *)sender {
    _selectedIndex = sender.tag;
    [self.view endEditing:YES];
    [self updateButtons];
}

- (void)updateButtons {
    for (UIButton *x in self.checkBox) {
        x.selected = (x.tag == _selectedIndex);
    }
    
    self.button3.hidden = !self.allowFive;
    
    [self updateLabelContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"授信提求"];
    [self setTitle:@"授信提示"];
    
    
    
    _selectedIndex = 0;
    [self updateButtons];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"授信提求"];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _selectedIndex = 0;
    [self updateButtons];
}



- (void)setData {
    [self.delegate shouxinOkdone];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loseData {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonPressed {
    [self connectToCredit:[self getShouxinVal]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
        ((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = @"确定";
        self.next =  ((NextButtonViewController *)[segue destinationViewController]);
    }
}

- (void)connectToCredit:(int)v {
    [self.op cancel];
    bugeili_net
    progress_show
    self.op = [ZAPP.netEngine creditWithComplete:^{[self setData]; progress_hide} error:^{progress_hide} userid:self.uid intv:v];
}


- (int)getShouxinVal {
    if (_selectedIndex == 0) {
        return 1e4;
    }
    else {
        return 5*1e4;
    }
}


@end
