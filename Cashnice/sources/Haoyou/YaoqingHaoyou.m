//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "YaoqingHaoyou.h"
#import "NewBorrowViewController.h"
#import "BlueButtonViewController.h"
 
#import "YaoqingJilu.h"

@interface YaoqingHaoyou ()

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIView *textbgview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_textHeight;

@end

@implementation YaoqingHaoyou

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.textbgview.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5];
    
    NSString *str1 = [ZAPP.myuser limitLoanAmountForNormalUser];
    NSString *str2 = [ZAPP.myuser limitLoanAmountForVIPuser];
    self.textview.text = [NSString stringWithFormat:@"• 如您要发布借款，必须先有好友为您提供授信；\n• 邀请好友，并向他们授信，再向他们索要授信；\n• 有多少好友向您授信，您就可以发布多少额度的借款；(认证用户借款额度上限为%@，认证VIP用户上限为%@)\n• 成为平台认证VIP用户后，可以向每位好友授信1万或5万元。", str1, str2];
    
    self.textview.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.textview.font = [UtilFont systemLarge];
    CGSize textViewSize = [self.textview sizeThatFits:CGSizeMake([ZAPP.zdevice getDesignScale:390], FLT_MAX)];
    self.con_textHeight.constant = textViewSize.height ;
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
    [MobClick beginLogPageView:@"邀请好友"];
	[self setTitle:@"邀请好友"];
	
    
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"邀请好友"];
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
	else if ([[segue destinationViewController] isKindOfClass:[BlueButtonViewController class]]) {
		((BlueButtonViewController *)[segue destinationViewController]).delegate = self;
        ((BlueButtonViewController *)[segue destinationViewController]).titleString = [segue identifier];
	}
}




- (void)nextButtonPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.yaoQingHaoYou", nil) message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"微信朋友圈", @"微信好友", nil];
   // //[alert customLayout];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [ZAPP inviteViaWeixin:NO];
    }
    else if (buttonIndex == 2) {
        [ZAPP inviteViaWeixin:YES];
    }
}

- (void)blueButtonPressed {
    YaoqingJilu *yaoqing = ZSTORY(@"YaoqingJilu");
    [self.navigationController pushViewController:yaoqing animated:YES];
}

@end
