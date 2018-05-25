//
//  JieKuanViewController.m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "PersonHomePage.h"
#import "QuerenShouxin.h"
#import "NewNewShenFen.h" 
#import "CreditStrategy.h"
#import "PersonInfo.h"
#import "RTLabel.h"
#import "CreditHintViewController.h"

@interface PersonHomePage () {
	BOOL dataSet;//是否已经从服务器获取到数据
	BOOL goDetail;
    
    NSInteger acquirecreditinlastdays;
}


@property (strong, nonatomic)IBOutletCollection(UIView) NSArray *hiddenViews;
@property (strong, nonatomic) PersonInfo *                geren;
//@property (strong, nonatomic) NSDictionary *             dataDict;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_button_me_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_info_height;

@property (strong, nonatomic) MKNetworkOperation *      op;
@property (strong, nonatomic) NextB *next;

@property (weak, nonatomic) IBOutlet RTLabel *hintLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hintViewHeight;


@property (strong, nonatomic) CreditStrategy *creditStrategy;
@end


BLOCK_NAV_BACK_BUTTON
@implementation PersonHomePage

- (void)setTheDataDict:(NSDictionary *)dict {
    
    self.creditDict = dict;
    self.creditStrategy = [[CreditStrategy alloc] init];
    self.creditStrategy.delegate = self;
    
    acquirecreditinlastdays = [dict[NET_KEY_acquirecreditinlastdays] integerValue];
	
	[self ui];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.title  =  @"个人主页";
    [self setNavButton];
    
    self.con_info_height.constant = [ZAPP.zdevice getDesignScale:100];
	
	self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
	
	[Util setUIViewArrayHidden:self.hiddenViews hidden:YES];
}

- (void)setData {
    if ([ZAPP.myuser.personInfoDict objectForKey:NET_KEY_USERID]) {
        dataSet = YES;
        self.creditDict = ZAPP.myuser.personInfoDict;
    }
	[self ui];
	[Util setUIViewArrayHidden:self.hiddenViews hidden:NO];
}

- (void)setInfoData {
}

- (void)loseData {
}

- (void)ui {
	[self.geren setTheInfoDict:self.creditDict];
	[self.next setTheButtonEnabled:dataSet];
    
    self.hintLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.hintLabel.font      = [UtilFont systemLarge];
    
    
    if (dataSet) {
        int v = [[ZAPP.myuser.personMeRelationshipDict objectForKey:NET_KEY_CREDITVAL] intValue];
        if (v == 0) {
            if ([ZAPP.myuser getUserLevel] == UserLevel_Unauthed) {
                self.hintLabel.text = @"您未认证，无法加好友并授信";
                [self setNextButtonHide];
            }
            else {
                int thetype = [[self.creditDict objectForKey:NET_KEY_USERLEVEL] intValue];
                if (thetype == 0) {
                    NSString *str = @"此用户未认证，无法对其授信";
                    self.hintLabel.text = str;
                    [self setNextButtonHide];
                }
                else {
                    [self setupHintLabel];
                    [self setNextButton];
                }
            }
        }
        else {
            [self setupHintLabel];
            [self setNextButton];
        }
    }
    
    CGSize optimumSize = self.hintLabel.optimumSize;
    self.hintViewHeight.constant = optimumSize.height;
    
	if (dataSet) {
		int v = [[ZAPP.myuser.personMeRelationshipDict objectForKey:NET_KEY_CREDITVAL] intValue];
		if (v == 0) {
			if ([ZAPP.myuser getUserLevel] == UserLevel_Unauthed) {
				[self.next setTheTitleString:@"您未认证，无法加好友并授信"];
				[self.next setTheButtonEnabled:NO];
				[self.next setTheBgGray];
			}
			else {
				int thetype = [[self.creditDict objectForKey:NET_KEY_USERLEVEL] intValue];
				if (thetype == 0) {
					NSString *str = @"此用户未认证，无法对其授信";
					[self.next setTheTitleString:str];
					[self.next setTheButtonEnabled:NO];
				}
				else {
					[self.next setTheTitleString:@"加好友并授信"];
					[self.next setTheBgRed];
					[self.next setTheButtonEnabled:YES];
				}
			}
		}
		else {
			NSString *str = @"删除好友并取消授信";
			[self.next setTheTitleString:str];
			[self.next setTheButtonEnabled:YES];
			[self.next setTheBgGray];
		}
	}
	
	if ([[self.creditDict objectForKey:NET_KEY_USERID] intValue] == [ZAPP.myuser getUserIDInt]) {// me
//		self.con_button_me_height.constant = [ZAPP.zdevice getDesignScale:0];
//		self.next.view.hidden              = YES;
        [self setNextButtonHide];
        self.hintLabel.hidden = YES;
	}
	else {
//		self.con_button_me_height.constant = [ZAPP.zdevice getDesignScale:60];
//		self.next.view.hidden              = NO;
	}
}

- (void)setupHintLabel {
    
    NSString *hintString;
    
    NSInteger creditToMe = [ZAPP.myuser.personMeRelationshipDict[NET_KEY_CREDITVAL] integerValue];//[[self.creditDict objectForKey:NET_KEY_BECREDITVAL] intValue] ;
    //    if (! creditToMe) {
    //        creditToMe = [[self.creditDict objectForKey:NET_KEY_becreditmeval] intValue] ;    //
    //    }
    
    NSInteger creditToHe = [[ZAPP.myuser.personHeRelationshipDict objectForKey:NET_KEY_CREDITVAL] intValue] ; //
    //    if (! creditToHe) {
    //        creditToHe = [[self.creditDict objectForKey:NET_KEY_CREDITOTHERVAL] intValue] ;
    //    }
    
    NSString *numStr ;
    if (creditToHe) {
        //您已经向他授信X万
        numStr = [Util intWithUnit:(int)(creditToHe/1e4) unit:@"万"];
        hintString = [NSString stringWithFormat:@"您已经向Ta授信 <font color=%@>¥%@\n</font>",COLOR_NAV_BG_RED, numStr];
    }else{
        hintString = @"您还没向Ta授信\n";
    }
    if (creditToMe) {
        //他已经向您授信X万
        numStr = [Util intWithUnit:(int)(creditToMe/1e4) unit:@"万"];
        NSString *tmpStr = [NSString stringWithFormat:@"Ta已经向您授信 <font color=%@>¥%@</font>", COLOR_NAV_BG_RED, numStr];
        hintString = [NSString stringWithFormat:@"%@%@", hintString, tmpStr];
    }else{
        NSString *tmpStr = @"Ta还没向您授信";
        hintString = [NSString stringWithFormat:@"%@%@", hintString, tmpStr];
    }
    
    ////  提示已经索要过授信
    if ([self.creditStrategy isCreditRequested]) {
        NSString *reqStr = [NSString stringWithFormat:@"<p align=center><font color=%@>已向Ta索要授信</font></p>", COLOR_TEXT_BLACK];
        hintString = [NSString stringWithFormat:@"%@ %@", hintString, reqStr];
        //self.hintViewHeight.constant = 80;
    }
    self.hintLabel.text = hintString;
    self.hintLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.hintLabel.font = [UtilFont systemLarge];
}

- (void)setNextButtonHide {
    [self.creditStrategy setNextButtonHide];
}
- (void)setNextButton {
    [self.creditStrategy setCreditButton];
}

- (void)setCreditData {
    int v = [[ZAPP.myuser.personMeRelationshipDict objectForKey:NET_KEY_CREDITVAL] intValue];
    if (v == 0) {
        [UtilLog string:@"取消授信成功"];
    }
    else {

        [Util toastStringOfLocalizedKey:@"tip.creditSuccess"];
        //取消授信
    }
    [self ui];
}

- (void)connectToCredit:(int)v {
	[self.op cancel];
	bugeili_net
	progress_show
	self.op = [ZAPP.netEngine creditWithComplete:^{[self setCreditData]; progress_hide} error:^{progress_hide} userid:[self.creditDict objectForKey:NET_KEY_USERID] intv:v];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
	dataSet = NO;
	if ([self.creditDict objectForKey:NET_KEY_USERID]) {
		progress_show
		self.op = [ZAPP.netEngine getPersonInfoWithComplete:^{[self setData]; progress_hide} error:^{[self loseData]; progress_hide} userid:[self.creditDict objectForKey:NET_KEY_USERID]];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[MobClick beginLogPageView:@"个人主页"];
	
	[self ui];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([ZAPP.zlogin isLogined]) {
		if (goDetail) {
			goDetail = NO;
			[self setData];
		}
		else {
            [self connectToServer];
		}
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[MobClick endLogPageView:@"个人主页"];
	
	[self.op cancel];
	self.op = nil;
	[self loseData];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	
    [self.creditStrategy prepareForSegue:segue sender:sender];
    
	if ([[segue destinationViewController] isKindOfClass:[PersonInfo class]]) {
        [self.geren setIsNotMe:YES];
		self.geren = ((PersonInfo*)[segue destinationViewController]);
	}
//	else if ([[segue destinationViewController] isKindOfClass:[NextB class]]) {
//		self.next = (NextB *)[segue destinationViewController];
//		self.next.delegate = self;
//	}
}



- (void)nextBPressed:(int)idx {
	int thetype = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_USERLEVEL] intValue];
	if (thetype == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.PersonHomePage", nil) message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"去验证",nil];
		alert.tag = 10;
//		//[alert customLayout];
		[alert show];
		return;
	}
	
	int v = [[ZAPP.myuser.personMeRelationshipDict objectForKey:NET_KEY_CREDITVAL] intValue];
	if (v == 0) {
		int mylimit = [ZAPP.myuser getRemainCreditLimit];
		if (mylimit < 1e4) {
            NSString *s = [NSString localizedStringWithFormat:CNLocalizedString(@"tip.creditWanBalanceNotEnough", nil), (int)(mylimit/10000)];
            [Util toast : s];
            return;
		}
		else  {
			//是否允许授信5万
			BOOL allowfive = NO;
			if (mylimit < 5*1e4 || thetype == 1) {
				allowfive = NO;
			}
			else {
				allowfive = YES;
			}
			QuerenShouxin *q = ZSEC(@"QuerenShouxin");
			q.allowFive = allowfive;
			q.uid       = [self.creditDict objectForKey:NET_KEY_USERID];
			q.delegate  = self;
			goDetail    = YES;
			[self.navigationController pushViewController:q animated:YES];
		}
	}
	else {
        NSString *    t     = [Util getUserRealNameOrNickName:self.creditDict];
        NSString *s =[NSString localizedStringWithFormat:CNLocalizedString(@"alert.title.PersonHomePag2", nil), t, v];
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:s message:CNLocalizedString(@"alert.message.PersonHomePage", nil) delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//		//[alert customLayout];
		[alert show];
	}
}

- (void)creditTo {
    CreditHintViewController *hintViewController = DQC(@"CreditHintViewController");
    hintViewController.creditDict = self.creditDict;
    [self.navigationController pushViewController:hintViewController animated:YES];
}

- (void)shouxinOkdone {
	[self setCreditData];
}

- (NSInteger)getAcquirecreditinlastdays{
    return acquirecreditinlastdays;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [alertView cancelButtonIndex]) {
		if (alertView.tag == 10) {
			NewNewShenFen *e = ZEdit(@"NewNewShenFen");
			[self.navigationController pushViewController:e animated:YES];
		}
		else {
			int v = [[ZAPP.myuser.personMeRelationshipDict objectForKey:NET_KEY_CREDITVAL] intValue];
			int t = 0;//取消授信
			if (v == 0) {
				if (buttonIndex == 1) {
					//1万
					t = 1e4;
				}
				else {
					//5万
					t = 5 * 1e4;
				}
			}
			[self connectToCredit:t];
		}
	}
}

@end
