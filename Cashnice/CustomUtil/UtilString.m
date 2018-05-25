//
//  UtilString.m
//  YQS
//
//  Created by l on 3/18/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UtilString.h"

@implementation UtilString

+ (NSString *)getUserType:(UserLevelType)ty {
	if (ty == UserLevel_Unauthed) {
		return @"未认证";
	}
	else if (ty == UserLevel_Normal) {
		return @"认证用户";
	}
	else {
		return @"认证VIP用户";
	}
}

+ (LoanState)cvtIntToJiekuanState:(int)intv {
    if (intv == -1) {
        return JieKuan_FailNow;
    }
    else if (intv == 0) {
        return JieKuan_WaitingNow;
    }
    else if (intv == 1) {
        return JieKuan_GoingNow;
    }
    else if (intv == 2) {
        return JieKuan_FinishedNow;
    }
    else if (intv == 3) {
        return JieKuan_FinishedAndPayed;
    }
    else if (intv == 4) {
        return JieKuan_SelfClosed;
    }
    else if (intv == 5) {
        return JieKuan_UnfinishedClosed;
    }
    else if (intv == 6) {
        return JieKuan_AdminClosed ;
    }
    else if (intv == 7) {
        return JieKuan_Refund;
    }
    else {
        return JieKuan_FailNow;
    }
}

+ (BetType)cvtIntToBetState:(int)intv {
    if (intv == 0) {
        return Bet_Processing;
    }
    else if (intv == 1) {
        return Bet_BetFinished;
    }
    else if (intv == 2) {
        return Bet_BetFailed;
    }
    else if (intv == 3) {
        return Bet_LoanClosedAndRefunded;
    }
    else if (intv == 4) {
        return Bet_RefundFail;
    }
    else if (intv == 5) {
        return Bet_Refunding;
    }
    else {
        return Bet_Processing;
    }
}

+ (NSString *)getJiekuanState:(LoanState)state {
	NSString *str = @"";
	switch (state) {
        case JieKuan_FailNow:
            str = @"审核失败";
            break;
        case JieKuan_WaitingNow:
            str = @"等待审核";
            break;
        case JieKuan_GoingNow:
            str = @"正在借款";
            break;
        case JieKuan_FinishedNow:
            str = @"借款已满";
            break;
        case JieKuan_FinishedAndPayed:
            str = @"完成还款";
            break;
        case JieKuan_SelfClosed:
            str = @"借款人关闭";
            break;
        case JieKuan_UnfinishedClosed:
            str = @"未借满关闭";
            break;
        case JieKuan_AdminClosed:
            str = @"管理员关闭";
            break;
        case JieKuan_Refund:
            str = @"退款处理中";
            break;
	default:
		break;
	}
	return [NSString stringWithFormat:@" %@ ", str];
}

+ (NSString *)getBetStateString:(BetType)state {
    NSString *str = @"";
   	switch (state) {
        case Bet_Processing:
            str = @"正在办理";
            break;
        case Bet_BetFinished:
            str = @"投资完成";
            break;
        case Bet_BetFailed:
            str = @"投资失败";
            break;
        case Bet_LoanClosedAndRefunded:
            str = @"退款成功";
            break;
        case Bet_Refunding:
            str = @"退款处理中";
            break;
        case Bet_RefundFail:
            str = @"退款失败";
            break;
        default:
            break;
    }
    return str;
}

+ (UIColor *)bgColorJiekuanState:(LoanState)state {
	UIColor *color = [UIColor clearColor];
    int ty = 0;//0, gray; 1, red; 2, green
    switch (state) {
        case JieKuan_FailNow:
            break;
        case JieKuan_WaitingNow:
            break;
        case JieKuan_GoingNow:
            ty = 1;
            break;
        case JieKuan_FinishedNow:       //2:已经借满
            ty = 2;
            break;
        case JieKuan_FinishedAndPayed:  //3：完成还款
            ty = 3;
            break;
        case JieKuan_SelfClosed:
            break;
        case JieKuan_UnfinishedClosed:
            break;
        case JieKuan_AdminClosed:
            break;
        default:
            break;
    }
    switch (ty) {
        case 1:
            color = ZCOLOR(@"#1c3681");//正在借款
            break;
        case 2:
            color =  ZCOLOR(@"#3399ff");//已经借满
            break;
        case 3:
            color =  ZCOLOR(@"#b0b0b0");//完成还款
            break;
        case 0:
            color = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);//其他
            break;
        default:
            break;
	}
	return color;
}

+ (NSString *)getFirstLetter:(NSString *)str
{
    if (!str || [str isEqualToString:@""])
    {
        return @"#";
    }
    NSString *theFirstLetter = [str substringToIndex:1];
    
    NSString* rule1 = @"[a-zA-Z]";
    NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
    BOOL isMatch=[pred evaluateWithObject:theFirstLetter];
    
    if (isMatch)
    {
        return [theFirstLetter uppercaseString];
    }
    return @"#";
}

//+ (NSAttributedString *)xxxXuzhi {
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.headIndent          = 0;
//    paragraphStyle.tailIndent = 0;
//    paragraphStyle.firstLineHeadIndent = 0;
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    paragraphStyle.lineSpacing         = 8;
//    
//    NSString *allstr = @"CashniceTM借款人须知\n一、借款条件\n\t1、借款人为符合中华人民共和国法律规定的具有完全民事权利能力和民事行为能力，独立行使和承担本协议项下权利义务的自然人。借款人为“众筹（上海）商业管理有限公司”（“ CashniceTM”）的注册用户。\n\t2、借款人提出合法的借款用途。\n\t3、借款人在CashniceTM获得其他用户的有效担保。\n\n二、借款金额\n\t1、借款金额必须是人民币一万元的整数倍。\n\t2、借款总金额不得超过借款人在CashniceTM获得其他用户的有效担保总额。\n\t3、普通用户借款总额上限为人民币200万元。\n\t4、VIP用户借款总额上限为人民币1000万元。\n\n三、借款利率及费用\n\t1、利率：借款利率下限为0，上限为银行同类贷款利率的四倍。\n\t2、逾期：发生逾期，借款人需承担每天千分之一的罚息。\n\t3、手续费：普通用户需向CashniceTM缴纳每笔借款每天万分之一作为手续费。VIP用户免手续费。\n\n四、借款流程\n\t1、借款人阅读“CashniceTM服务协议”、“CashniceTM借款须知”等相关协议及资料。\n\t2、在首页“借款”功能菜单选择“发布借款”，并完整填写。\n\t3、借款人点击“确认发布”。\n\t4、借款人收到借款后，转入指定的个人银行账户。\n\t5、借款到期后，借款人及时归还本息。\n\n五、借款人责任及义务\n\t1、借款人必须按期归还本息。\n\t2、借款人必须配合CashniceTM提出的资产及信用抽查要求。\n\t3、借款人不得将所借到的借款用于任何违法犯罪活动(包括但不限于赌博、吸毒、卖淫嫖娼等)。\n";
//    NSMutableAttributedString *sss = [Util getAttributedString:allstr font:[UtilFont systemLarge] color:ZCOLOR(COLOR_TEXT_GRAY)];
//    [sss addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, allstr.length)];
//    
//    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle2.headIndent          = 0;
//    paragraphStyle2.tailIndent = 0;
//    paragraphStyle2.firstLineHeadIndent = 0;
//    paragraphStyle2.alignment = NSTextAlignmentCenter;
//    paragraphStyle2.lineSpacing         = 8;
//    paragraphStyle2.paragraphSpacing = 8;
//    [sss addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:[allstr rangeOfString:@"CashniceTM借款人须知"]];
//    
//    CGFloatx = 15;
//    UIColor *y = ZCOLOR(COLOR_TEXT_BLACK);
//    [Util setAttributedString:sss font:[UIFont boldSystemFontOfSize:22] color:y range:[allstr rangeOfString:@"CashniceTM借款人须知"]];
//    [Util setAttributedString:sss font:[UIFont boldSystemFontOfSize:x] color:y range:[allstr rangeOfString:@"一、借款条件"]];
//    [Util setAttributedString:sss font:[UIFont boldSystemFontOfSize:x] color:y range:[allstr rangeOfString:@"二、借款金额"]];
//    [Util setAttributedString:sss font:[UIFont boldSystemFontOfSize:x] color:y range:[allstr rangeOfString:@"三、借款利率及费用"]];
//    [Util setAttributedString:sss font:[UIFont boldSystemFontOfSize:x] color:y range:[allstr rangeOfString:@"四、借款流程"]];
//    [Util setAttributedString:sss font:[UIFont boldSystemFontOfSize:x] color:y range:[allstr rangeOfString:@"五、借款人责任及义务"]];
//    return sss;
//}

@end
