//
//  CreditStrategy.m
//  YQS
//
//  Created by a on 15/9/21.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CreditStrategy.h"
#import "PersonHomePage.h"
#import "NextB.h"
#import "CustomIOSAlertView.h"

typedef enum CreditButtonActionType {
    CreditButtonActionAddFriden = 1001,
    CreditButtonActionCancelFriden,
    CreditButtonActionRequireCredit,
    CreditButtonActionCreditToFive,
    CreditButtonActionCreditToOne,
    CreditButtonActionCreditNone
}CreditButtonActionType;

@interface CreditStrategy ()  <NextBDelegate, CustomIOSAlertViewDelegate>
{
    CreditButtonActionType operationType;
}

@end


@implementation CreditStrategy

- (void)setCreditButton {
    
    //用户等级
    NSInteger userlevel =  [ZAPP.myuser.gerenInfoDict[@"userlevel"] integerValue];
    
    //剩余额度
    float mylimit = [ZAPP.myuser getRemainCreditLimit];
    
    
    if (_delegate.shouXintype == ShouXin_NoneHint) {
        if (userlevel != 2 || mylimit < 5*1e4) {    ///// 不足5万
            [_delegate.firstButton setTheTitleString:@"给Ta授信1万"];
            [_delegate.secondButton setTheTitleString:@"不授信"];
            [_delegate.firstButton setTheButtonIndex:CreditButtonActionCreditToOne];
            [_delegate.secondButton setTheButtonIndex:CreditButtonActionCreditNone];
            [_delegate.secondButton setTheBgGray];

            [_delegate.secondButton setHidden:NO];
            [_delegate.thirdButton setHidden:YES];
        }else{
            [_delegate.firstButton setTheTitleString:@"给Ta授信5万"];
            [_delegate.secondButton setTheTitleString:@"给Ta授信1万"];
            [_delegate.thirdButton setTheTitleString:@"不授信"];
            [_delegate.firstButton setTheButtonIndex:(CreditButtonActionCreditToFive)];
            [_delegate.secondButton setTheButtonIndex:CreditButtonActionCreditToOne];
            [_delegate.thirdButton setTheButtonIndex:CreditButtonActionCreditNone];
            [_delegate.secondButton setTheBgGray];
            [_delegate.thirdButton setTheBgGray];
            [_delegate.secondButton setHidden:NO];
            [_delegate.thirdButton setHidden:NO];
        }
    }else{
        
        //NSInteger creditToMe = [ZAPP.myuser.personMeRelationshipDict[NET_KEY_CREDITVAL] integerValue];
        NSInteger creditToHe = [ZAPP.myuser.personHeRelationshipDict[NET_KEY_CREDITVAL] integerValue];//[[_delegate.creditDict objectForKey:@"creditval"] intValue] ;
//        BOOL required = [[_delegate.creditDict objectForKey:NET_KEY_acquirecreditinlastdays] intValue] == 1;
        if (! creditToHe) {
            //// 加好友按钮
            [_delegate.firstButton setTheTitleString:@"加好友并授信"];
            [_delegate.firstButton setTheButtonIndex:CreditButtonActionAddFriden];
            
            if (! [self isCreditRequested] && 0<creditToHe && 0>=[ZAPP.myuser.personMeRelationshipDict[NET_KEY_CREDITVAL] integerValue]) {
                //// 索要授信按钮
                [_delegate.secondButton setTheTitleString:@"向其索要授信"];
                [_delegate.secondButton setTheButtonIndex:CreditButtonActionRequireCredit];
                [_delegate.secondButton setTheBgGray];
                [_delegate.secondButton setHidden:NO];
            }else{
                [_delegate.secondButton setHidden:YES];
            }
            [_delegate.thirdButton setHidden:YES];
        }else {
            
            if (userlevel != 2 || mylimit < 5*1e4) {    ///// 不足5万
                
                ////  删除好友按钮
                [_delegate.firstButton setTheTitleString:@"删除好友并取消授信"];
                [_delegate.firstButton setTheButtonIndex:CreditButtonActionCancelFriden];
//                [_delegate.firstButton setTheBgGray];
                
                if (! [self isCreditRequested] && 0<creditToHe && 0>=[ZAPP.myuser.personMeRelationshipDict[NET_KEY_CREDITVAL] integerValue]) {
                    //// 索要授信按钮
                    [_delegate.secondButton setTheTitleString:@"向其索要授信"];
                    [_delegate.secondButton setTheButtonIndex:CreditButtonActionRequireCredit];
                    [_delegate.secondButton setTheBgGray];
                    [_delegate.secondButton setHidden:NO];
                }else{
                    [_delegate.secondButton setHidden:YES];
                }
                [_delegate.thirdButton setHidden:YES];
            }else{
                ////  改成5万
                if (creditToHe == 1e4) {
                    [_delegate.firstButton setTheTitleString:@"改成5万"];
                    [_delegate.firstButton setTheButtonIndex:CreditButtonActionCreditToFive];
                }else{
                    //// 改成1万
                    [_delegate.firstButton setTheTitleString:@"改成1万"];
                    [_delegate.firstButton setTheButtonIndex:CreditButtonActionCreditToOne];
                }
                
                ////  删除好友按钮
                [_delegate.secondButton setTheTitleString:@"删除好友并取消授信"];
                [_delegate.secondButton setTheButtonIndex:CreditButtonActionCancelFriden];
                [_delegate.secondButton setTheBgGray];
                [_delegate.secondButton setHidden:NO];
                
                if (! [self isCreditRequested] && 0<creditToHe && 0>=[ZAPP.myuser.personMeRelationshipDict[NET_KEY_CREDITVAL] integerValue]) {
                    //// 索要授信按钮
                    [_delegate.thirdButton setTheTitleString:@"向其索要授信"];
                    [_delegate.thirdButton setTheButtonIndex:CreditButtonActionRequireCredit];
                    [_delegate.thirdButton setTheBgGray];
                    [_delegate.thirdButton setHidden:NO];
                }else{
                    [_delegate.thirdButton setHidden:YES];
                }
            }
        }
    }
}

- (void)setNextButtonHide {
    [_delegate.firstButton setHidden:YES];
    [_delegate.secondButton setHidden:YES];
    [_delegate.thirdButton setHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier hasPrefix:@"first"]) {
        _delegate.firstButton = (NextB *)[segue destinationViewController];
        _delegate.firstButton.delegate = self;
    }
    if ([segue.identifier hasPrefix:@"second"]) {
        _delegate.secondButton = (NextB *)[segue destinationViewController];
        _delegate.secondButton.delegate = self;
    }
    if ([segue.identifier hasPrefix:@"thirdSegue"]) {
        _delegate.thirdButton = (NextB *)[segue destinationViewController];
        _delegate.thirdButton.delegate = self;
    }
    
    return;
}

///// 是否已经索要 /////
- (BOOL)isCreditRequested {
    BOOL required = [_delegate getAcquirecreditinlastdays] == 1;
    //BOOL required = 0;//= ZAPP.myuser.incomingRequestExists ;
//    NSInteger creditToMe = [ZAPP.myuser.personMeRelationshipDict[NET_KEY_CREDITVAL] integerValue];
//    if (creditToMe > 0) {
//        required = 1;
//    }
    return required;
}


- (void)nextBPressed:(int)idx {
    int thetype = [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_USERLEVEL] intValue];
    if (thetype == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.creditStrategy", nil) message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"去验证",nil];
        alert.tag = 10;
        [alert show];
        return;
    }
    operationType = idx;
    switch (idx) {
        case CreditButtonActionRequireCredit:
            [self requiredCredit];
            break;
        case CreditButtonActionAddFriden:
            [_delegate creditTo];
            break;
        case CreditButtonActionCreditToFive:
            [self addFriendAndCreditValue:50000];
            break;
        case CreditButtonActionCreditToOne:
            [self addFriendAndCreditValue:10000];
            break;
        case CreditButtonActionCancelFriden:
            [self cancelCredit];
            break;
        case CreditButtonActionCreditNone:
            [self addFriendAndCreditValue:-1];//忽略授信请求
            //[_delegate.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (void)loseData {
    
}

- (void)refreshView {
    if ([_delegate isKindOfClass:[PersonHomePage class]]) {
        if (operationType == CreditButtonActionCancelFriden) {

            [Util toastStringOfLocalizedKey:@"tip.cancelCredit"];
        }if (operationType == CreditButtonActionRequireCredit) {
            if (_delegate.creditDict) {
                NSMutableDictionary *tmp = [_delegate.creditDict mutableCopy];
                [tmp setValue:@(1) forKey:@"acquirecreditinlastdays"];
                _delegate.creditDict = [tmp copy];
            }

            [Util toastStringOfLocalizedKey:@"tip.askForCreditSuccess"];
        }
        if ([_delegate isKindOfClass:[PersonHomePage class]]) {
            PersonHomePage *personHomePage = (PersonHomePage *)_delegate;
            [personHomePage performSelector:@selector(connectToServer)];
        }
        
    }else{
        ///// 授信提示页面
        if (operationType == CreditButtonActionCreditNone) {
            [Util toastStringOfLocalizedKey:@"tip.processingSuccess"];
        }else{
            [Util toastStringOfLocalizedKey:@"tip.creditSuccess"];
        }
        [_delegate.navigationController popViewControllerAnimated:YES];
    }
}

////////     索要授信
- (void)requiredCredit{
    bugeili_net
    bool _isNavigationBack = _delegate.isNavigationBack;
    progress_show
    
    WS(ws);

    NSString *userid = [_delegate.creditDict objectForKey:NET_KEY_USERID];
    [ZAPP.netEngine requestCreditWithComplete:^{[ws refreshView];progress_hide} error:^{progress_hide} userid:userid];
}

////////     取消授信
- (void)cancelCredit {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithMessage:CNLocalizedString(@"alert.message.creditStrategy", nil) closeDelegate:self buttonTitles:@[@"取消授信", @"保留授信"]];
    alertView.tag = CreditButtonActionCancelFriden;
    [alertView show];
    [alertView formatAlertButton];
}
- (void)cancelCreditAction {
    bugeili_net
    bool _isNavigationBack = _delegate.isNavigationBack;
    progress_show

    WS(ws);

    NSString *userid = [_delegate.creditDict objectForKey:NET_KEY_USERID];
    [ZAPP.netEngine creditWithComplete:^{[ws refreshView];progress_hide} error:^{progress_hide} userid:userid intv:0];
}

////////     授信
- (void)addFriendAndCreditValue:(int)v {
    bugeili_net
    bool _isNavigationBack = _delegate.isNavigationBack;
    progress_show

    WS(ws);

    NSString *userid = [_delegate.creditDict objectForKey:NET_KEY_USERID];
    [ZAPP.netEngine creditWithComplete:^{[ws refreshView];progress_hide} error:^{progress_hide} userid:userid intv:v];
}

- (void)customIOS7dialogButtonTouchUpInside:(CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSInteger alertViewTag = alertView.tag;
        switch (alertViewTag) {
            case CreditButtonActionCancelFriden:
                [self cancelCreditAction];
                break;
                
            default:
                break;
        }
    }
    [alertView close];
}

@end
