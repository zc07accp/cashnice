//
//  MeRouter.m
//  Cashnice
//
//  Created by apple on 2016/11/1.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MeRouter.h"
#import "BillDetailViewController.h"
#import "CardVideoViewController.h"
#import "EditUserInfoViewController.h"
#import "IDCardUploadViewController.h"
#import "TradeHistoryViewController.h"

@implementation MeRouter

+(UIViewController *)commonPushedBillViewController:(NSDictionary *)dic{
    
    BillDetailViewController *bdvc = MBDSTORY(@"BillDetailViewController");
    bdvc.dic = dic;
    return bdvc;
}

+(UIViewController *)notificationPushedBillViewController:(NSInteger )noticeid{
    
    BillDetailViewController *bdvc = MBDSTORY(@"BillDetailViewController");
    bdvc.source_type = BILLDETAIL_SOURCETYPE_NOTIFICATION;
    bdvc.noticeid = noticeid;
    return bdvc;
}


+(UIViewController *)servemsgChongzhiTixianPushedBillViewController:(NSInteger )noticeid{
    
    BillDetailViewController *bdvc = MBDSTORY(@"BillDetailViewController");
    bdvc.source_type = BILLDETAIL_SOURCETYPE_FROMSERVICEMSG_CHONGZHITIXIAN;
    bdvc.noticeid = noticeid;
    return bdvc;
}

+(UIViewController *)cardIDTakeViewController:(NSInteger)type delegate:(id<CardVideoViewControllerDelegate>)delgate{

    CardVideoViewController *controller = CARDSTORY(@"CardVideoViewController");
    controller.delegate = delgate;
    controller.currentType = type;
    return controller;
}

+(UIViewController *)IDCardUploadViewController:(id<IDCardUploadDelegate>)delegate{
    
    IDCardUploadViewController *controller = CARDSTORY(@"IDCardUploadViewController");
    controller.delegate = delegate;
    return controller;
}


+(UIViewController *)IDCardIdentifiedViewController{
    
    UIViewController *controller = CARDSTORY(@"IDCardIdentifiedViewController");
    return controller;
}

+(UIViewController *)friendsTradeHistoryViewController{
    TradeHistoryViewController *controller = ZINVSTFP(@"TradeHistoryViewController");
    controller.tradeHistoryType = FriendsTradeHistory;
    return controller;
}

+(UIViewController *)OuterTradeHistoryViewController{
    TradeHistoryViewController *controller = ZINVSTFP(@"TradeHistoryViewController");
    controller.tradeHistoryType = OuterFriendsTradeHistory;
    return controller;
}

+(UIViewController *)newPersonDetailViewController{
    
    UIViewController *controller = MYINFOSTORY(@"NewPersonDetailViewController");
    return controller;
}

+(UIViewController *)editUserWorkplace:(NSString *)workplace;{
    EditUserInfoViewController *controller = ZEdit(@"EditUserInfoViewController");
    controller.editUserInfoType = EditUserInfo_Workplace;
    controller.content = workplace;
    return controller;
}

+(UIViewController *)editUserPosition:(NSString *)position{
    EditUserInfoViewController *controller = ZEdit(@"EditUserInfoViewController");
    controller.editUserInfoType = EditUserInfo_Position;
    controller.content = position;
    return controller;
}

+(UIViewController *)editUserAddress:(NSString *)address{
    EditUserInfoViewController *controller = ZEdit(@"EditUserInfoViewController");
    controller.editUserInfoType = EditUserInfo_Address;
    controller.content = address;
    return controller;
}

+(UIViewController *)editUserEmailViewController{
    BOOL emailExit = [ZAPP.myuser hasEmail];
    if (!emailExit) {
        UIViewController *controller = SISTORY(@"EditEmailViewController");
        return controller;
    }else{
        UIViewController *controller = SISTORY(@"EmailInfoViewController");
        return controller;
    }
}

+(UIViewController *)editUserSocietyViewController{
    UIViewController *controller = ZEdit(@"SocietyPositionViewController");
    return controller;
}

+(UIViewController *)editUserPhoneViewController{
    UIViewController *controller = ZEdit(@"PhoneEditValidation");
    return controller;
}

+(UIViewController *)UserBindBankViewController{
    UIViewController *controller = ZSTORY(@"BindBankOneStepViewController");
    return controller;
}

+(UIViewController *)businessLicense{
    
    UIViewController *vc = CARDSTORY(@"LicenseUploadViewController");
    return vc;
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
