//
//  UtilDef.h
//  YQS
//
//  Created by l on 3/14/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#ifndef YQS_UtilDef_h
#define YQS_UtilDef_h
//#import "TableDef.h"

#define KUSER_INFO_FRESH @"KUSER_INFO_FRESH"
#define POST_USERINFOFRESH_NOTI  [[NSNotificationCenter defaultCenter] postNotificationName:KUSER_INFO_FRESH object:nil];

#define KVISABANK_FRESH @"KVISABANK_FRESH"
#define POST_VISABANK_FRESH_NOTI  [[NSNotificationCenter defaultCenter] postNotificationName:KVISABANK_FRESH object:nil];


#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define URL_OPEN_SETTING [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

//是否跳转
#define CANSET(DIC) ([dic[@"canset"] integerValue]==0?NO:YES)


// 过期
#define MKNetAPIDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#define ZNULL(__A__)     ((__A__) == nil)
#define ZNOTNULL(__A__)  ((__A__) != nil)
#define ZCHECKSTR(__A__) ((__A__).length > 0)
#define ZCOLOR(__A__)    [DefColor colorParseString : (__A__)]

#define ISNSNULL(__A__)  [__A__ isKindOfClass :[NSNull class]]
#define MainScreenBounds    [UIScreen mainScreen].bounds
#define MainScreenHeight    [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth    [UIScreen mainScreen].bounds.size.width

#define ZAPP            [AppDelegate zapp]
#define ZROOT           (ViewController *)[AppDelegate zapp].window.rootViewController
#define ZSTORY(__A__)   [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZBill(__A__)   [[UIStoryboard storyboardWithName:@"Bill" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZBorrow(__A__)   [[UIStoryboard storyboardWithName:@"Borrow" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZEdit(__A__)   [[UIStoryboard storyboardWithName:@"Edit" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZJIEKUAN(__A__) [[UIStoryboard storyboardWithName:@"Jiekuan" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZIOU(__A__) [[UIStoryboard storyboardWithName:@"IOU" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define ZWIOU(__A__) [[UIStoryboard storyboardWithName:@"WriteIOU" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define ZMYIOU(__A__)  [[UIStoryboard storyboardWithName:@"myiou" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZINVST(__A__)  [[UIStoryboard storyboardWithName:@"investment" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZLOAN(__A__)  [[UIStoryboard storyboardWithName:@"Loan" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZGUARANTEE(__A__)  [[UIStoryboard storyboardWithName:@"Guarantee" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZJKDetail(__A__) [[UIStoryboard storyboardWithName:@"JkDetail" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZRENMAI(__A__)  [[UIStoryboard storyboardWithName:@"RenMai" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZPERSON(__A__)  [[UIStoryboard storyboardWithName:@"Person" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define DQC(__A__)  [[UIStoryboard storyboardWithName:@"dqc" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZBANK(__A__)  [[UIStoryboard storyboardWithName:@"Bank" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZINVSTFP(__A__)  [[UIStoryboard storyboardWithName:@"InvestmentFirstPage" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define ZSEC(__A__)     [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define LTStory(__A__)  [[UIStoryboard storyboardWithName:@"lt" bundle:nil] instantiateViewControllerWithIdentifier : __A__]
#define CcStory(__A__)  [[UIStoryboard storyboardWithName:@"cc" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define SISTORY(__A__)  [[UIStoryboard storyboardWithName:@"SupplementInfo" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define MBDSTORY(__A__)  [[UIStoryboard storyboardWithName:@"MyBillDetail" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define SEARCHSTORY(__A__)  [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define GUIDESTORY(__A__)  [[UIStoryboard storyboardWithName:@"Guide" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define SENDLOANSTORY(__A__)  [[UIStoryboard storyboardWithName:@"SendLoan" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define MYINFOSTORY(__A__)  [[UIStoryboard storyboardWithName:@"MyInfo" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define CARDSTORY(__A__)  [[UIStoryboard storyboardWithName:@"idcard" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define REDSTORY(__A__)  [[UIStoryboard storyboardWithName:@"redmoney" bundle:nil] instantiateViewControllerWithIdentifier : __A__]

#define POST_REDMONEYLISTFRESH_NOTI  [[NSNotificationCenter defaultCenter] postNotificationName:@"redmoneyfresh" object:nil]


#define MIDDLE_SCALE (MainScreenWidth == 375 ? 1:(MainScreenWidth < 375?(MainScreenWidth+15)/375:(MainScreenWidth-15)/375))
#define SCALED(__VAL__) (MIDDLE_SCALE * MIDDLE_SCALE)

#define WITHOUT_EMAIL_PUSH \
BOOL emailExit = [ZAPP.myuser hasEmail]; \
if (!emailExit) { \
    UIViewController *vc = SISTORY(@"EditEmailViewController"); \
    [self.navigationController pushViewController:vc animated:YES];\
    return; \
}

#define CODE_BLOCK_PROGRESS_INDICATOR_ADD_AND_ALLOC - (ProgressIndicator *)progressIndicator {\
if (_progressIndicator == nil) {\
    _progressIndicator = [[ProgressIndicator alloc] init];\
}\
return _progressIndicator;\
}\
\
- (void)addProgressBar {\
    self.progressIndicator.view.translatesAutoresizingMaskIntoConstraints = NO;\
    [self.progressHolder addAutolayoutSubview:self.progressIndicator.view];\
}
#define BIND_BANK_TITLES_4_STEP    @[@"用户信息  ", @"银行卡信息    ", @"输入绑卡验证码    ", @"激活银行卡    "]
#define BIND_BANK_TITLES_3_STEP    @[@"银行卡信息  ", @"输入绑卡验证码  ", @"激活银行卡  "]

#define BLOCK_NAV_BACK_BUTTON \
//- (void)customNavBackPressed {\
//    NSInteger __navcount = self.navigationController.viewControllers.count;\
//    if (__navcount >= 2) {\
//        CustomViewController *__navVC = (CustomViewController *)self.navigationController.viewControllers[__navcount-2];\
//        if ([__navVC isKindOfClass:[UITabBarController class]]) {\
//            UITabBarController *tabvc = (UITabBarController *)__navVC;\
//            NSArray *vcs = tabvc.viewControllers;\
//            NSInteger idx = tabvc.selectedIndex;\
//            CustomViewController *vc = vcs[idx];\
//            __navVC = vc;\
//        }\
//        __navVC.isNavigationBack = YES;\
//        [self.navigationController popToViewController:self.navigationController.viewControllers[__navcount-2] animated:YES];\
//    }\
//}\
- (void)setNavButton {\
UIBarButtonItem *btn = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"fanhui"] target:self action:@selector(customNavBackPressed)];\
UIBarButtonItem *space = [UIBarButtonItem spacer];\
[self.navigationItem setLeftBarButtonItems:@[space, btn]];\
}


#define TABLE_TEXT_ROW_HEIGHT 44
#define TABLE_FOOTER_HEIGHT   80
#define DEFAULT_PAGE_SIZE     25
#define LARGEST_PAGE_SIZE     999

#define USER_FILE_NAME          @"setting0.dat"
#define TOKEN_FILE_NAME         @"setting1.dat"
#define LOGIN_RESPOND_FILE_NAME @"setting2.dat"
#define USER_SESSION_KEY_DICT_FILE_NAME @"setting3.dat"
#define LOG_FILE_NAME           @"log.dat"
#define FILE_ENCODE_KEY         0x55

#define UPDATE_TIME_INTERVAL 600

#define SEPERATOR_LINELEFT_OFFSET ([ZAPP.zdevice getDesignScale:10])


#define CNCOMMON_LISTTABLEROW_HEIGHT IPHONE6_ORI_VALUE(50)


#define net_error_msg @"网络不给力，请检查您的网络是否正常"
#define bugeili_net   //if (![UtilDevice isNetworkConnected]) {  [Util toast:net_error_msg];  [self loseData]; return; }
#define bugeili_net_new   if (![UtilDevice isNetworkConnected]) {  [Util toastExceptTopView:net_error_msg];  return; }

#define bugeili_net_new_withouttoast   if (![UtilDevice isNetworkConnected]) { return; }


#define bugeili_net_new_block(block)   if (![UtilDevice isNetworkConnected]) {  [Util toast:net_error_msg]; block(); return; }

#define bugeili_net_new_withouttoas_block(block)   if (![UtilDevice isNetworkConnected]) {  block(); return; }



#define progress_show {[SVProgressHUD show];}

#define progress_show_cn  [SVProgressHUD show];

#define progress_hide [SVProgressHUD dismiss];
#define progress_show_suc_text(_A_) [SVProgressHUD showSuccessWithStatus:_A_];

#define CNLocalizedString(key, comment) NSLocalizedString(key, comment)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define SS(strongSelf, weakSelf) __strong __typeof(weakSelf)strongSelf = weakSelf;


#define def_key_fabu_name         @"def_key_fabu_name"
#define def_key_fabu_money        @"def_key_fabu_money"
#define def_key_fabu_borrow_day   @"def_key_fabu_borrow_day"
#define def_key_fabu_friend_type  @"def_key_fabu_friend_type"
#define def_key_fabu_lixi         @"def_key_fabu_lixi"
#define def_key_fabu_huankuan_day @"def_key_fabu_huankuan_day"
#define def_key_fabu_loanid       @"def_key_fabu_loanid"
#define def_key_fabu_yongtu       @"def_key_fabu_yongtu"
#define def_key_fabu_attach       @"def_key_fabu_attach"
#define def_key_fabu_is_preview   @"def_key_fabu_is_preview"
#define def_key_fujian_img        @"def_key_fujian_img"
#define def_key_fujian_url        @"def_key_fujian_url"

#define def_key_tixing_update_date @"def_key_tixing_date"

#define MSG_change_tab_to_chongzhi @"msg_change_tab_to_chongzhi"


#define kSynchronizedNotificationOffKey @"kSynchronizedNotificationOffKey"

//iPhone4 4s机型 (逐步被IPHONE4S替换)
#define ScreenInch4s (MainScreenHeight < 568)

// 判断当前设备是不是iPhone4或者4s
#define IPHONE4S    (([[UIScreen mainScreen] bounds].size.height)==480)

// 判断当前设备是不是iPhone5
#define IPHONE5    (([[UIScreen mainScreen] bounds].size.height)==568)

//iphone6 6s机型
#define IPHONE6    (([[UIScreen mainScreen] bounds].size.height)==667)

// 判断当前设备是不是iPhone6Plus
#define IPHONE6_PLUS    (([[UIScreen mainScreen] bounds].size.height)>=736)

//判断屏幕宽度4 4s 5的320宽度
#define ScreenWidth320 (MainScreenWidth <= 320)

//加息券利率精度，必须为数值类型
//千分定义 .1
//万分定义 .01
#define kcoupan_rate_precision     0.1

#define OSVersionIsAtLeastiOS8   ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0 ? YES:NO)

#define OSVersionIsAtLeastiOS9   ([[UIDevice currentDevice].systemVersion floatValue]>= 9.0 ? YES:NO)

#define  KNAV_SUBVIEW_MAXHEIGHT 44.f 

#ifdef TEST_TEST_SERVER
//#define TEST_CODE_WHEN_LAUCH
//#define TEST_RELEASE_SMALL_VAL
//#define TEST_FABU_JIEKUAN
//#define TEST_SHEHUI_APPLY
//#define TEST_SAME_SESSIONKEY
//#define TEST_SEND_LOG
//#define TEST_LOG_SYSTEM_PARAS
//#define TEST_ALL_TIXING_MSGr
//#define TEST_TOUZI_PAGE
//#define TEST_CHONGZHI_PAGE
//#define TEST_SHOW_ALL_NAME
//#define TEST_TOAST_SYSTEM_PARAS
//#define TEST_UPLOAD_PROFILE     //测试提交我的资料
//#define TEST_ENABLE_SERVER_LOG
//#define TEST_ENABLE_LOG
//#define TEST_MODIFY_PHONENUM

//#define TEST_BIND_BANK_STEPS                //测试绑卡

#endif

#define NetworkOperationCacheDisable  NO


#ifdef HUBEI
//  =========   =========   =========   湖北版配置   =========   =========   ==========
//  =========   =========   =========   湖北版配置   =========   =========   ==========
//  #define VersionInfoDescription  @"2.5.0"

//#define TEST_LOGIN_WITHOUT_VALIDATION_CODE
//#define TEST_TEST_SERVER
#else
//  =========   =========   =========   通用版配置   =========   =========   ==========
//  =========   =========   =========   通用版配置   =========   =========   ==========
//  #define VersionInfoDescription  @"2.5.0"

//#define TEST_LOGIN_WITHOUT_VALIDATION_CODE
//#define TEST_TEST_SERVER
#endif



/**
 *  如果是正式服务器，需要使用visa.list 1.0；
 *  原因：正式服务器，暂时不支持visa.list 2.0
 */
//#ifndef TEST_TEST_SERVER
//    #define USER_VISA_LIST_GET_API_VER_1
//#endif

#endif
