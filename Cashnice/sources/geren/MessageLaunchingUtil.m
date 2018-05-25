//
//  MessageLaunchingUtil.m
//  YQS
//
//  Created by a on 16/1/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MessageLaunchingUtil.h"

#import "BillDetail.h"
#import "ShouxinList.h"
#import "MyLoansListViewController.h"
#import "PersonHomePage.h"
#import "WebDetail.h"
#import "LoanInfoViewModel.h"
#import "BillInfoViewController.h"
#import "BillDetailViewController.h"
#import "InvestmentInfoViewModel.h"
#import "ScoreWebViewController.h"
#import "GuaranteeConfirmingViewController.h"

#import "ServiceMsgEngine.h"

static ServiceMsgEngine *engine;

@implementation MessageLaunchingUtil


+ (NSString *)getTypeOfNotice:(NSDictionary *)noticeDict {
    
    NSDictionary *typeDataDictionary =
    @{  @"1" : @{
                    @"0" : @"系统通知-系统通知",
                    @"1" : @"系统通知-系统通知",
                    @"2" : @"系统通知-转账通知",
                    @"7" : @"系统通知-系统通知",
                },
        @"2" : @{
                    @"1" : @"借款-等待审核",
                    @"2" : @"借款-审核通过",
                    @"3" : @"借款-筹满",
                    @"4" : @"借款-失败",
                    @"5" : @"借款-新增资金",
                    @"6" : @"借款-审核失败",
                    @"7" : @"借款-担保",
                    @"9" : @"借款-关闭",
                    @"11" : @"借款-",
                    @"13" : @"借款-筹满充值到银行卡",
                    @"14" :	@"借款-借款预审通过，等待上线	",
                    @"15" :	@"借款-借款筹满，发起代付到卡",
                    @"16" :		@"借款-借款筹满，发起代付到余额",
                    @"17" :		@"借款-担保人收回担保金",
                },
        @"3" : @{
                    @"1" : @"投资-成功",
                    @"2" : @"投资-失败",
                    @"3" : @"投资-失败",
                    @"4" : @"投资-",                     //被过滤，不显示
                    //@"5" : @"",
                    @"6" : @"投资-收益",
                    //@"7" : @"",
                    @"8" : @"",                     //被过滤，不显示
                    @"9" : @"投资-还款逾期",
                    @"10" :     @"投资-投资收益（投资人收回部分逾期还款",
                    @"11" : 	@"投资-投资收益（投资人收回全额逾期还款",
                    @"12" : 	@"投资-担保金下发",
                    @"13" : 	@"投资-投资收益",       //转让
                    @"14" : 	@"投资-投资收益",       //转让  //14没有
                },
        @"4" : @{
                    @"1" : @"还款-借款还款成功",
                    @"2" : @"还款-",                     //被过滤，不显示
                    //@"3" : @"",
                    @"4" : @"还款-",                     //被过滤，不显示
                },
        @"5" : @{
                },
        @"6" : @{
                    @"1" : @"催款-还款提醒",
                    @"2" : @"催款-还款提醒",
                    @"3" : @"催款",
                    @"4" : @"催款",
                    @"5" : @"催款",
                },
        @"7" : @{
                    @"4" : @"授信-好友授信",
                    @"5" : @"授信-好友取消",
                    @"6" : @"授信-好友授信调整",
                },
        @"8" : @{
                    @"0" : @"索要授信-好友授信调整",
                },
        @"9" : @{
                    @"1" : @"充值提现-充值成功",
                    @"2" : @"充值提现-充值失败",
                    @"3" : @"充值提现-提现成功",
                },
        @"13" :     @"黑名单-",
        @"15" : @{
                    @"0" : @"审核通知-系统通知",
                },
        @"16" :     @"借条通知-",
    };
    
    
    int type = [[noticeDict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[noticeDict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    NSString *typeStr = [NSString stringWithFormat:@"%zd", type];
    NSString *behaveStr = [NSString stringWithFormat:@"%zd", behave];
    
    NSString *typeDesc = nil;
    
    id typeLevel1 = typeDataDictionary[typeStr];
    if ([typeLevel1 isKindOfClass:[NSString class]]) {
        return typeLevel1;
    }else if ([typeLevel1 isKindOfClass:[NSDictionary class]]){
        return typeLevel1[behaveStr];
    }
    
    return typeDesc;
}


+ (NSString *)iconNameOfNoticeDict:(NSDictionary *)noticeDict{
    NSString *typeDesc = [MessageLaunchingUtil getTypeOfNotice:noticeDict];
    
    if([typeDesc hasSuffix:@"担保人收回担保金"])  return @"alt_system.png";
    if ([typeDesc hasPrefix:@"系统通知"])  return @"alt_system.png";
    if ([typeDesc hasPrefix:@"借款"])     return @"alt_borrow.png";
    if ([typeDesc hasPrefix:@"投资"])     return @"alt_invest.png";
    if ([typeDesc hasPrefix:@"还款"])     return @"alt_repayment.png";
    if ([typeDesc hasPrefix:@"收益"])     return @"alt_earn.png";
    if ([typeDesc hasPrefix:@"催款"])     return @"alt_dept.png";
    if ([typeDesc hasPrefix:@"授信"])     return @"alt_credit.png";
    if ([typeDesc hasPrefix:@"索要授信"])  return @"alt_ask_credit.png";
    if ([typeDesc hasPrefix:@"黑名单"])   return @"alt_blacklist.png";
    if ([typeDesc hasPrefix:@"充值提现"])  return @"alt_in_out.png";
    if ([typeDesc hasPrefix:@"审核通知"])  return @"alt_check.png";
    if ([typeDesc hasPrefix:@"借条通知"])  return @"alt_iou.png";
    return @"alt_system.png";;
}

+ (UIImage *)iconImageOfNoticeDict:(NSDictionary *)noticeDict{
    return [UIImage imageNamed:[MessageLaunchingUtil iconNameOfNoticeDict:noticeDict]];
}

+(BOOL)satisfyJiekuan:(NSDictionary *)dict{
    
    BOOL ret = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 2) {
        
        if ( behave == 1 || behave ==2 || 3 == behave || 5 == behave || 13 == behave || behave == 14|| behave == 15|| behave == 16) {
            ret=YES;
        }

    }
    else if (ty == 4) {
        if (behave == 1){
            ret=YES;
        }
    }
    
    else if (ty == 6) {
        if (behave == 1 || behave == 3){
            ret=YES;
        }
    }
    
    return ret;
    
}

+(UIViewController *)openJiekun:(NSDictionary *)dict{
    
    BOOL ret =  [self satisfyJiekuan:dict];
    if (ret) {
//        [[self class] loadJiekuanDetail:dict viewController:view];
        
        return [self loadJiekuanDetail:dict];
    }

    return nil;
}


+(BOOL)satisfyHomePage:(NSDictionary *)dict{
    
    BOOL ret = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 7) {
        
        if ( behave == 4 || behave == 5 || 6 == behave ) {
            ret=YES;
        }
        
    }
    else if (ty == 8) {
        
        if ( behave == 0 ) {
            ret=YES;
        }
    }
    
    return ret;
    
}

+(UIViewController *)openHomePage:(NSDictionary *)dict{
    
    BOOL ret = [self satisfyHomePage:dict];
    
    if (ret) {
//        [[self class] loanPersonHomePage:dict viewController:view];
        return [self loanPersonHomePage:dict];
    }
    
    return nil;
}

+(BOOL)satisfyBillDetail:(NSDictionary *)dict{
    
    BOOL ret = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 9) {
        
        if ( behave == 1 ||  behave == 3 ) {
            ret=YES;
        }
        
    }
    else if (ty == 1) {
        
        if ( behave == 2 ) {
            ret=YES;
        }
    }
    return ret;
    
}
//账单详情
+(UIViewController *)openBillDetail:(NSDictionary *)dict {
    
    BOOL ret = [self satisfyBillDetail:dict];
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ret) {
        
        //充值提现
        if (ty == 9) {
            return  [MeRouter servemsgChongzhiTixianPushedBillViewController: [[dict objectForKey:NET_KEY_NOTCEID] integerValue]];
        }else{
            //账单详情
            return [MeRouter notificationPushedBillViewController: [[dict objectForKey:NET_KEY_NOTCEID] integerValue]];
        }
        
    }
    
    return nil;
}

+(BOOL)satisfyInvestDetail:(NSDictionary *)dict{
    
    BOOL ret = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 3) {
        
        if ( behave == 1 ||  behave == 6 || behave == 9|| behave == 10|| behave == 11|| behave == 12) {
            ret=YES;
        }
        if (behave == 13 || behave == 14){
            ret=YES;
        }
        
    }else if (ty == 6) {
        
        if ( behave == 5 ) {
            ret=YES;
        }
    }
    
    return ret;
}

+(UIViewController *)openInvestDetail:(NSDictionary *)dict{
    
    BOOL ret = [self satisfyInvestDetail:dict];

    if (ret) {
        return  [[self class] loadInvestDetail:dict];
    }
    
    return nil;
}

+(BOOL)satisfyGuaranteeJiekuanDetail:(NSDictionary *)dict{
    
    BOOL ret = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 2) {
        
        if ( behave == 7 || behave == 17) {
            ret=YES;
        }
        
    }else if (ty == 6) {
        
        if ( behave == 4 ) {
            ret=YES;
        }
    }
    return ret;

}

+(UIViewController*)openGuaranteeJiekuanDetail:(NSDictionary *)dict {

    BOOL ret = [self satisfyGuaranteeJiekuanDetail:dict];

    if (ret) {
       return  [[self class] loadGuatanteeJiekuanDetail:dict];
    }
    
    return nil;
}

+(BOOL)satisfyCouponWeb:(NSDictionary *)dict{
    
    BOOL ret = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 1) {
        if ( behave == 7) {
            ret=YES;
        }
    }
    
    return ret;
}

+(BOOL)satisfyScoreWeb:(NSDictionary *)dict{
    
    BOOL ret = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 17) {
        if ( behave == 1) {
            ret=YES;
        }
    }
    
    return ret;
}

+(BOOL)satisfyMyLoanList:(NSDictionary *)dict{
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 2) {
        if ( behave == 19) {
            return YES;
        }
    }

    return NO;
}

+(BOOL)satisfyMyGuarList:(NSDictionary *)dict{
    //if ([self fromRemoteNotification:dict]) {
        //来自消息列表
        int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
        int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
        
        if (ty == 2) {
            if ( behave == 18) {
                return YES;
            }
        }
    //}
    return NO;
}

// 担保确认
+(BOOL)satisfyConfrimGuar:(NSDictionary *)dict{
    if (! [self fromRemoteNotification:dict]) {
        //来自消息列表
        int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
        int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
        
        if (ty == 2) {
            if ( behave == 18) {
                return YES;
            }
        }
    }
    return NO;
}

+(UIViewController*)openMyLoanDetail:(NSDictionary *)dict {
    BOOL ret = [self satisfyMyLoanList:dict];
    
    if (ret) {
        //return ZLOAN(@"MyLoansListViewController");
        NSUInteger loanid = [dict[@"loanid"] integerValue];
        BillInfoViewController *c = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyLoan loanId:loanid betId:0];
        return c;
    }
    
    return nil;
}

+(UIViewController*)openMyGuarList:(NSDictionary *)dict {
    BOOL ret = [self satisfyMyGuarList:dict];
    
    if (ret) {
        return ZGUARANTEE(@"GuaranteeListViewController");
    }
    
    return nil;
}

+(UIViewController*)openConfrimGuar:(NSDictionary *)dict {
    BOOL ret = [self satisfyConfrimGuar:dict];
    
    if (ret) {
        
        NSInteger loanstatus = [dict[@"loanstatus"] integerValue];
        if (loanstatus == -3 && [dict[@"ulw_confirmed"] integerValue] == 0) {
            
            GuaranteeConfirmingViewController *c = [[GuaranteeConfirmingViewController alloc] init];
            c.loanInfo = dict;
            return c;
            
        }else{
            NSUInteger loanid = [dict[@"loanid"] integerValue];
            BillInfoViewController *c = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyGuarantee loanId:loanid betId:0];
            return c;
        }
        
        //GuaranteeConfirmingViewController *c = [[GuaranteeConfirmingViewController alloc] init];
        //c.loanInfo = dict;
        //return  c;
    }
    
    return nil;
}

+(UIViewController*)openCouponWeb:(NSDictionary *)dict {
    
    BOOL ret = [self satisfyCouponWeb:dict];
    
    if (ret) {
        
        WebDetail *x = ZSTORY(@"WebDetail");
        x.userAssistantPath = @{@"name" : dict[@"target"]};
        //x.absolutePath =  [NSString stringWithFormat:@"%@", dict[@"url"]];
        x.absolutePath =  [NSString stringWithFormat:@"%@%@" ,WEB_DOC_URL_ROOT, dict[@"url"]];
        return  x;
    }
    
    return nil;
}



+(UIViewController*)openScoreWeb:(NSDictionary *)dict {
    
    BOOL ret = [self satisfyScoreWeb:dict];
    
    if (ret) {
        
        NSString *httpPrefix = @"";
        if (USESSL) {
            httpPrefix = @"https://";
        }else{
            httpPrefix = @"http://";
        }
        
        NSString *url = [NSString stringWithFormat:@"%@%@%@%@", [YQS_SERVER_URL rangeOfString:httpPrefix].location == NSNotFound?httpPrefix:@"", YQS_SERVER_URL, @"/score/index/user_id/",[ZAPP.myuser getUserID]];
        
        ScoreWebViewController *swvc = [[ScoreWebViewController alloc]init];
        swvc.urlStr = url;
        return swvc;
    }
    
    return nil;
}


+(BOOL)satisfyWebDetail:(NSDictionary *)dict{
    
    BOOL ret = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 1) {
        
        if ( behave == 7) {
            ret=YES;
        }
        
    }else if (ty == 6) {
        
        if ( behave == 4 ) {
            ret=YES;
        }
    }

    return ret;

}

+(UIViewController*)openWebDetail:(NSDictionary *)dict {
    
    BOOL ret = [self satisfyWebDetail:dict];

    if (ret) {
        
        WebDetail *x = ZSTORY(@"WebDetail");
        //x.userAssistantPath = @{@"name" : dict[@"title"]};
        x.userAssistantPath = @{@"name" : @"消息详情"};
        x.absolutePath =  [NSString stringWithFormat:@"%@%@" ,WEB_DOC_URL_ROOT, dict[@"sys_jump_url"]];
        return  x;
        
    }
    
    return nil;
}

+(void)readMarkRequest:(NSDictionary *)dict{
    
    if (!engine) {
        engine = [[ServiceMsgEngine alloc]init];
    }
    
    [engine setNoticeRead:[dict[@"noticeid"] integerValue] success:^{
        //NSLog(@"setNoticeRead ok ");
    } failure:^(NSString *error) {
        
    }];
}

// 系统消息 - 跳转详情
+ (void)MesssageLaunchAction:(NSDictionary *)dict viewController:(UIViewController *)view{

    
    if (16 == [[dict objectForKey:NET_KEY_NOTICETYPE] intValue]) {
        //借条详
        [ZAPP changeViewToIOU];
        [view.navigationController popToRootViewControllerAnimated:YES];
    }else{
        UIViewController *dest = [MessageLaunchingUtil destViewControllerOfNotice:dict];
        if (dest) {
            [view.navigationController pushViewController:dest animated:YES];
        }
    }
}

+ (void)readMarkRequestForRemoteNotification:(NSDictionary *)dict{
    if ([self shouldReactForDetail:dict]) {
        //0 未读
        if ([[dict objectForKey:@"un_remind"] integerValue] == 0) {
            //推送来源的，标记已经阅读
            [self readMarkRequest:dict];
        }
    }
}

//消息列表 - 用于远程推送通知
+(UIViewController *)openMessageList:(NSDictionary *)dict{
    
    BOOL retFlag = NO;
    
    int ty = [[dict objectForKey:NET_KEY_NOTICETYPE] intValue];
    int behave = [[dict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
    
    if (ty == 1 && (behave == 0 || behave == 1 || behave == 7)) retFlag = YES;
    if (ty == 2 && (behave == 4 || behave == 6 || behave == 9)) retFlag = YES;
    if (ty == 3 && (behave == 2 || behave == 3)) retFlag = YES;
    if (ty == 9 && (behave == 2))  retFlag = YES;
    if (ty == 15 && (behave == 0)) retFlag = YES;
    
    if (retFlag) {
        return ZBill(@"ServiceMessageViewController");//ServiceMessageViewController
    }
    return nil;
    
}

+(BOOL)shouldReactForDetail:(NSDictionary *)dict{
    
    if (16 == [[dict objectForKey:NET_KEY_NOTICETYPE] intValue]) {
        return YES;
    }
    
    BOOL ret =  [self satisfyJiekuan:dict];
    if (ret) {
        return YES;
    }
    
     ret =  [self satisfyHomePage:dict];
    if (ret) {
        return YES;
    }
    
     ret =  [self satisfyBillDetail:dict];
    if (ret) {
        return YES;
    }
    
     ret =  [self satisfyInvestDetail:dict];
    if (ret) {
        return YES;
    }
    
     ret =  [self satisfyGuaranteeJiekuanDetail:dict];
    if (ret) {
        return YES;
    }
 
    
    ret = [self satisfyWebDetail:dict];
    if (ret) {
        return YES;
    }

    ret = [self satisfyScoreWeb:dict];
    if (ret) {
        return YES;
    }

    ret = [self satisfyMyLoanList:dict];
    if (ret) {
        return YES;
    }
    
    ret = [self satisfyMyGuarList:dict];
    if (ret) {
        return YES;
    }
    
    //ret = [self satisfyConfrimGuar:dict];
    //if (ret) {
    //    return YES;
    //}
    
    return NO;
}

+ (BOOL)fromRemoteNotification:(NSDictionary *)noticeDict{
    return [noticeDict[@"remoteNtf"] boolValue];
}

+ (UIViewController *)destViewControllerOfNotice:(NSDictionary *)noticeDict {

    
    UIViewController *vc = nil;
    
    //消息列表 - 推送通知
    if ([self fromRemoteNotification:noticeDict]) {
        
        //加息券转赠
        vc =  [self openCouponWeb:noticeDict];
        if(vc)return vc;
        
        vc =  [self openMessageList:noticeDict];
        if(vc)return vc;
        
        vc =  [self openMessageList:noticeDict];
        if(vc)return vc;
    }
    
    //我的借款
    vc =  [self openJiekun:noticeDict];
    if(vc)return vc;
    
    //我的主页
    vc =  [self openHomePage:noticeDict];
    if(vc)return vc;

    //我的借款详情
    vc =  [self openJiekun:noticeDict];
    if(vc)return vc;
    
    //账单详情
    vc =  [self openBillDetail:noticeDict];
    if(vc)return vc;

    //我的投资
    vc =  [self openInvestDetail:noticeDict];
    if(vc)return vc;
    
    //我的担保借款详情
    vc =  [self openGuaranteeJiekuanDetail:noticeDict];
    if(vc)return vc;
    
    //打开web
    vc = [self openWebDetail:noticeDict];
    if(vc)return vc;
    
    //积分
    vc = [self openScoreWeb:noticeDict];
    if(vc)return vc;
    
    //我的担保列表
    vc = [self openMyGuarList:noticeDict];
    if(vc)return vc;
    
    //我的借款详情
    vc = [self openMyLoanDetail:noticeDict];
    if(vc)return vc;
    
    //我的担保确认
    //vc = [self openConfrimGuar:noticeDict];
    //if(vc)return vc;
    
    return nil;
    /*
     
 int ty = [[noticeDict objectForKey:NET_KEY_NOTICETYPE] intValue];
     int behave = [[noticeDict objectForKey:NET_KEY_NOTICEBEHAVIOR] intValue];
   if (ty == 1 && behave == 7) {

       WebDetail *x = ZSTORY(@"WebDetail");
        x.userAssistantPath = @{@"name" : noticeDict[@"title"]};
        x.absolutePath =  [NSString stringWithFormat:@"%@%@" ,WEB_DOC_URL_ROOT, noticeDict[@"sys_jump_url"]];
        return  x;
    }else
        if (ty == 2) {
            if (behave == 9 || behave == 6) {
                return nil;
            }
            return [[self class] loadJiekuanDetail:noticeDict];
        }
        else if (ty == 3) {
            return [[self class] loadBill:noticeDict];
        }
        else if (ty == 4) {
            if (behave == 1) {//还款成功
                //ding dan detail
                return [[self class] loadBill:noticeDict];
            }
            else if (behave == 2){//还款失败
                //jie kuan detail
                return [[self class] loadJiekuanDetail:noticeDict];
            }
        }
        else if (ty == 5) {
            return [[self class] loadBill:noticeDict];
        }
        else if (ty == 6) {
            //wo de jie kuan
            if (behave == 1) {
                return ZLOAN(@"MyLoansListViewController");
            }
            else if (behave == 2) {
                //wo shou xin de jie kuan
                return ZGUARANTEE(@"GuaranteeListViewController");
            }
            else if(behave == 3){
                //6.3 从系统消息到借款详情
                NSInteger loanid = [noticeDict[@"loan_id"] integerValue];
                BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyLoan loanId:loanid betId:0];
                return vc;
            }else if(behave == 4){
                //6.4 从系统消息到担保详情
                NSUInteger loanid = [noticeDict[@"loan_id"] integerValue];
                BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyGuarantee loanId:loanid betId:0];
                return vc;
            }else if(behave == 5){
                //6.5 从系统消息到投资详情
                NSUInteger loanid = [noticeDict[@"loanid"] integerValue];
                NSUInteger betid = [noticeDict[@"bets_id"] integerValue];
                BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyInvestment loanId:loanid betId:betid];
                return vc;
            }
        }
        else if(ty == 7 || ty == 8) {
            return  [[self class] loanPersonHomePage:noticeDict];
        }
        else if (ty == 9) {
            return [[self class] loadBill:noticeDict];
        }else if (ty == 16) {
            return nil;
        }else if (ty == 1 && behave == 2) {
            //转账通知
            return [MeRouter notificationPushedBillViewController: [[noticeDict objectForKey:NET_KEY_NOTCEID] integerValue]];
        }
    return nil;
     
     */
}

+ (UIViewController *)loanPersonHomePage:(NSDictionary *)dict{
    
    NSInteger useridNo = [[dict objectForKey:@"user_id"] integerValue];
    NSString *userid = [NSString stringWithFormat:@"%zd",  useridNo];
    
    if (!userid || [userid isEqualToString:@"0"]) {
        userid = [dict objectForKey:@"fromuserid"];
    }
    //NSString *realname = [dict objectForKey:NET_KEY_FROMUSERREALNAME];
    
    if ([userid notEmpty] && ![userid isEqualToString:@"0"] /*&& [realname notEmpty]*/) {
        PersonHomePage *per = DQC(@"PersonHomePage");
        [per setTheDataDict:@{NET_KEY_USERID:userid}];
        return per;
    }else{
        return nil;
    }
}


+ (UIViewController *)loadJiekuanDetail:(NSDictionary *)dict{
    LoanInfoViewModel *vm = [[LoanInfoViewModel alloc] initWithLoanId:[dict[@"loanid"] integerValue]];
    BillInfoViewController *vc = [[BillInfoViewController alloc] initWithViewModel:vm];
    return vc;
}
//    
//    + (void)loadJiekuanDetail:(NSDictionary *)dict viewController:(UIViewController *)view{
//    /*
//    MyLoansDetailViewController *e = ZLOAN(@"MyLoansDetailViewController");
//    e.loanid = [dict[@"loanid"] integerValue];
//    [view.navigationController pushViewController:e animated:YES];
//    */
//    
////    LoanInfoViewModel *vm = [[LoanInfoViewModel alloc] initWithLoanId:[dict[@"loanid"] integerValue]];
////    BillInfoViewController *vc = [[BillInfoViewController alloc] initWithViewModel:vm];
////    [view.navigationController pushViewController:vc animated:YES];
//    
//    
//    NSUInteger loanid = [dict[@"loanid"] integerValue];
//    BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyLoan loanId:loanid betId:0];
//    [view.navigationController pushViewController:vc animated:YES];
//
//}

+ (UIViewController *)loadBill:(NSDictionary *)dict {
//    BillDetail *vc = ZBill(@"BillDetail");
//    vc.billID = [dict objectForKey:NET_KEY_NOTCEID];
//    return vc;
    
    //账单详情
    return [MeRouter notificationPushedBillViewController: [[dict objectForKey:NET_KEY_NOTCEID] integerValue]];
}


+ (UIViewController *)loadInvestDetail:(NSDictionary *)dict {
//    BillDetail *vc = ZBill(@"BillDetail");
//    vc.billID = [dict objectForKey:NET_KEY_NOTCEID];
//    return vc;
    
    NSUInteger loanid = [EMPTYOBJ_HANDLE(dict[@"loanid"]) integerValue];
    NSUInteger betid = [EMPTYOBJ_HANDLE(dict[@"betid"]) integerValue];
    
    BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyInvestment loanId:loanid betId:betid];
//    [view.navigationController pushViewController:vc animated:YES];
    return vc;
    
}
//
//
//+ (void)loadInvestDetail:(NSDictionary *)dict viewController:(UIViewController *)view{
////    InvestmentInfoViewModel *vm = [[InvestmentInfoViewModel alloc] initWithLoanId:[dict[@"loanid"] integerValue]];
////    BillInfoViewController *vc = [[BillInfoViewController alloc] initWithViewModel:vm];
////    [view.navigationController pushViewController:vc animated:YES];
//    
//    NSUInteger loanid = [dict[@"loanid"] integerValue];
//    NSUInteger betid = [dict[@"betid"] integerValue];
//
//    BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyInvestment loanId:loanid betId:betid];
//    [view.navigationController pushViewController:vc animated:YES];
//    
//}

+ (UIViewController *)loadGuatanteeJiekuanDetail:(NSDictionary *)dict{

    NSUInteger loanid = [dict[@"loanid"] integerValue];
    BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyGuarantee loanId:loanid betId:0];
//    [view.navigationController pushViewController:vc animated:YES];
    return vc;
}

+ (ShouXinType)getTypeForShouxin:(int)ty {
    if (ty == 1) {
        return ShouXin_MeiYou;
    }
    else if (ty == 2) {
        return ShouXin_YiJing;
    }
    else if (ty == 3) {
        return ShouXin_XiangHu;
    }
    return ShouXin_MeiYou;
}

@end
