//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NoRemain.h"
#import "NewBorrowViewController.h"
 
#import <CoreText/CoreText.h>

@interface NoRemain ()

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIView *textbgview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_textHeight;

@end

@implementation NoRemain

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.textbgview.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5];
    
    NSString *str1 = [ZAPP.myuser limitLoanAmountForNormalUser];
    NSString *str2 = [ZAPP.myuser limitLoanAmountForVIPuser];
    
    NSString *infoStr = [NSString stringWithFormat:@"您尚未通过身份验证。\n1、如您要发布借款，必须先身份验证，成功后，您就有200万的授信额度。\n2、之后邀请好友，并向他们授信(200人上限)，再向他们索要授信。\n3、好友经过身份验证，并向您授信之后，您就可以发布借款了。 \n4、有多少好友向您多少额度的授信，您就可以发布多少额度的借款。(认证用户借款额度上限为%@，认证VIP用户上限为%@)", str1, str2];
    
    NSMutableAttributedString *attString= [Util getAttributedString:infoStr font:[UtilFont systemLarge] color:ZCOLOR(COLOR_TEXT_BLACK)];
    
    NSString *target1 = str1;
    NSString *target2 = [NSString stringWithFormat:@"认证VIP用户上限为%@", str2];
    
    NSRange range = [infoStr rangeOfString:target1];
    NSRange range2 = [infoStr rangeOfString:target1 options:NSBackwardsSearch];
    [Util setAttributedString:attString font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:range];
    [Util setAttributedString:attString font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:range2];
    [Util setAttributedString:attString font:nil color:ZCOLOR(COLOR_BILL_BG_YELLOW) range:[infoStr rangeOfString:target2]];
    
    
    self.textview.attributedText = attString;
    
    self.textview.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.textview.font = [UtilFont systemLarge];
    
    CGSize textViewSize = [self.textview sizeThatFits:CGSizeMake([ZAPP.zdevice getDesignScale:390], FLT_MAX)];
    self.con_textHeight.constant = textViewSize.height;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self setNavButton];
	[self setTitle:@"发布借款"];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = [segue identifier];
	}
}



- (void)nextButtonPressed {
    [Util toast:@"shen fen yan zheng"];
}

@end
