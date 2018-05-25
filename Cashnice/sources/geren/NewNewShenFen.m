//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NewNewShenFen.h"
#import "NewBorrowViewController.h"
#import "SocietyPositionViewController.h"
#import "PhoneEdit.h"
#import "NewShehuiEdit.h"
#import "NewIdEdit.h"
#import "IDCardIdentifyMgr.h"

@interface NewNewShenFen ()
{
}
@property (weak, nonatomic) IBOutlet UILabel *    topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIView *     btnBgView;

@property (strong, nonatomic) IBOutlet UIScrollView* scroll;
@property (assign, nonatomic) int selectedButtonIndex;

@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray *buttonArray;
@property (strong, nonatomic)IBOutletCollection(UIImageView) NSArray *btnImageArray;
@property (strong, nonatomic)IBOutletCollection(UIImageView) NSArray *btnRightArray;
@property (strong, nonatomic)IBOutletCollection(UIView) NSArray *btnBgViewArray;

@property (strong, nonatomic) ShenfenScrollRect *srect0;
@property (strong, nonatomic) ShenfenScrollRect *srect1;
@property (strong, nonatomic) ShenfenScrollRect *srect2;

@property (strong, nonatomic) MKNetworkOperation *op;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_w;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_scroll_w;


@end

@implementation NewNewShenFen

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.con_w.constant = [ZAPP.zdevice getDesignScale:390];
	self.con_scroll_w.constant = [ZAPP.zdevice getDesignScale:320];
	
	self.btnBgView.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
	
	self.topLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
	self.topLabel.font      = [UtilFont systemLarge];
	
	CGFloat xlim = [ZAPP.myuser getLoanLimit];
	int x    = (int)((int)xlim/10000);
	self.topLabel.text = [NSString stringWithFormat:@"授信、借款额度上限: %d万", x];
	
	self.topImage.image = [UIImage imageNamed:@"progress_no_user"];
	if (x == 200) {
		self.topImage.image = [UIImage imageNamed:@"progress_pt_user"];
	}
	else if (x == 1000) {
		self.topImage.image = [UIImage imageNamed:@"progress_vip_user"];
	}
	
	self.selectedButtonIndex = 0;
    
    [self setTitle:@"认证资料"];
    

    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(100, 200, 100, 30)];
//    btn.backgroundColor = [UIColor blueColor];
////    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(seeB) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)openAlbum{
    
//    [cameraEngine openPhotoAlbum:self editable:YES];
}

//-(void)CameraDidChosePhotoFromAlbum:(UIImage *)_img{
//    
//    [IDCardIdentifyMgr identify:_img success:^(BOOL resultCode) {
//        
//    }];
//}

-(void)seeB{
    [self openAlbum];
}

- (IBAction)buttonPressed:(UIButton *)sender {
	self.selectedButtonIndex = (int)sender.tag;
	[self uibuttons];
	[self uiscrolls:YES];
}

- (void)uibuttons {
	for (int i = 0; i < self.btnBgViewArray.count; i++) {
		UIView *     bgv       = [self.btnBgViewArray objectAtIndex:i];
		UIButton *   btn       = [self.buttonArray objectAtIndex:i];
		UIImageView *mainImage = [self.btnImageArray objectAtIndex:i];
		BOOL sel       = (i == self.selectedButtonIndex);
		btn.enabled           = !sel;
		bgv.backgroundColor   = sel ?[UIColor whiteColor] :[UIColor clearColor];
		mainImage.highlighted = sel;
	}
}

- (void)uiscrolls:(BOOL)anim {
	if (anim) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3f];
		
	}
	
	CGPoint sz = self.scroll.contentOffset;
	sz.x                      = self.selectedButtonIndex * CGRectGetWidth(self.scroll.frame);
	self.scroll.contentOffset = sz;
	
	if (anim) {
		[UIView commitAnimations];
	}
}

- (void)uirects {
	[self.srect0 setTheButtonDisabled:NO];
	[self.srect1 setTheButtonDisabled:NO];
	[self.srect2 setTheButtonDisabled:NO];
	
    UserLevelType x = [ZAPP.myuser getUserLevel];
    if (x >= UserLevel_Normal) {
		[self.srect1 setLabelStrings:@"查看身份信息"];
		[[self.btnRightArray objectAtIndex:1] setHidden:NO];
	}
	else {
		[[self.btnRightArray objectAtIndex:1] setHidden:YES];
        
#ifdef TEST_UPLOAD_PROFILE
        [self.srect1 setLabelStrings:@"表明身份"]; return;
#endif
		if ([ZAPP.myuser hasIdentifyWaiting]) {
			[self.srect1 setLabelStrings:@"审核中"];
			[self.srect1 setTheButtonDisabled:YES];
		}
		else {
			[self.srect1 setLabelStrings:@"表明身份"];
		}
	}
	
	if (x == UserLevel_VIP) {
		[self.srect2 setLabelStrings:@"修改公司和社会职务"];
		[[self.btnRightArray objectAtIndex:2] setHidden:NO];
		
		if ([ZAPP.myuser hasIdentifyWaiting]) {
			[self.srect2 setLabelStrings:@"审核中"];
			[self.srect2 setTheButtonDisabled:YES];
		}
	}
	else {
		[[self.btnRightArray objectAtIndex:2] setHidden:YES];
		if (x == UserLevel_Normal) {
			if ([ZAPP.myuser hasIdentifyWaiting]) {
				[self.srect2 setLabelStrings:@"审核中"];
				[self.srect2 setTheButtonDisabled:YES];
			}
			else {
				[self.srect2 setLabelStrings:@"提高额度"];
			}
		}
		else {
			[self.srect2 setLabelStrings:@"提高额度"];
		}
		
	}
}

- (void)rectbuttonPressed:(int)idx {

	if (idx == 0) {//modify phone
		PhoneEdit *pro = ZEdit(@"PhoneEdit");
		[self.navigationController pushViewController:pro animated:YES];
	}
	else if (idx == 1) {
		NewIdEdit *shen = ZEdit(@"NewIdEdit");
		[self.navigationController pushViewController:shen animated:YES];
	}
	else if (idx == 2) {
#ifdef TEST_SHEHUI_APPLY
        SocietyPositionViewController  * society =ZEdit(@"SocietyPositionViewController");
        [self.navigationController pushViewController:society animated:YES];
		return;
#endif
		UserLevelType x = [ZAPP.myuser getUserLevel];
		if (x == UserLevel_VIP) {
			//修改社会职务信息
            SocietyPositionViewController  * society =ZEdit(@"SocietyPositionViewController");
            [self.navigationController pushViewController:society animated:YES];
		}
		else {
			if (x == UserLevel_Normal) {
				//申请验证社会职务
                SocietyPositionViewController  * society =ZEdit(@"SocietyPositionViewController");
                [self.navigationController pushViewController:society animated:YES];
			}
			else {

                [Util toastStringOfLocalizedKey:@"tip.improvePreviousInformation"];
			}
			
		}
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.selectedButtonIndex = (int)((roundf(self.scroll.contentOffset.x) / roundf(CGRectGetWidth(self.scroll.frame))));
	[self uibuttons];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	[self uibuttons];
	[self uiscrolls:NO];
	[self uirects];
	
}

- (void)setDataUpdate {
	[self uirects];
}

- (void)loseData {

}

- (void)connectToUpdateInfo {
	bugeili_net
	self.op = [ZAPP.netEngine getUserInfoWithComplete:^{[self setDataUpdate]; }
	           error:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self setNavButton];
	[MobClick beginLogPageView:@"认证资料"];
	
	
	[self connectToUpdateInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[MobClick endLogPageView:@"认证资料"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	
	if ([[segue destinationViewController] isKindOfClass:[ShenfenScrollRect class]]) {
		int idx = [[segue identifier] intValue];
		if (idx == 0) {
			self.srect0          = ((ShenfenScrollRect*)[segue destinationViewController]);
			self.srect0.delegate = self;
			self.srect0.idx      = idx;
		}
		else if (idx == 1) {
			self.srect1          = ((ShenfenScrollRect*)[segue destinationViewController]);
			self.srect1.delegate = self;
			self.srect1.idx      = idx;
		}
		else if (idx == 2) {
			self.srect2          = ((ShenfenScrollRect*)[segue destinationViewController]);
			self.srect2.delegate = self;
			self.srect2.idx      = idx;
		}
	}
}

@end
