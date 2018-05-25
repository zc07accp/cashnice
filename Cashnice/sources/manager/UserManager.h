//
//  UserManager.h
//  YQS
//
//  Created by l on 4/13/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilEnum.h"

@interface UserManager : NSObject

@property (strong, nonatomic) NSDictionary *gerenInfoDict;
@property (strong, nonatomic) NSDictionary *systemInfoDict;
@property (strong, nonatomic) NSDictionary *systemOptionsDictShehuiZhiwu;
@property (strong, nonatomic) NSDictionary *loanFabuSucDetailDict;
@property (strong, nonatomic) NSDictionary *gerenBankDict;
@property (strong, nonatomic) NSArray      *systemRegionArray;
@property (strong, nonatomic) NSDictionary *loanListDict;
@property (strong, nonatomic) NSDictionary *gerenMyBetList;
@property (strong, nonatomic) NSDictionary *gerenMyLoanList;
@property (strong, nonatomic) NSDictionary *gerenMyBetDetail;
@property (strong, nonatomic) NSDictionary *gerenBetDetail;
@property (strong, nonatomic) NSDictionary *gerenMyShouxinLoanList;
@property (strong, nonatomic) NSDictionary *loanDetailDict;
@property (strong, nonatomic) NSDictionary *loanDetailCommonShouxinrenDict;
@property (strong, nonatomic) NSDictionary *loanDetailLoanUserDict;
@property (strong, nonatomic) NSDictionary *loanDetailAttachmentList;
@property (strong, nonatomic) NSDictionary *mightKnownDict;
@property (strong, nonatomic) NSDictionary *searchListDict;
@property (strong, nonatomic) NSDictionary *billDict;
@property (strong, nonatomic) NSDictionary *billDetailDict;
@property (strong, nonatomic) NSDictionary *inviteListDict;
@property (strong, nonatomic) NSDictionary *personInfoDict;
@property (strong, nonatomic) NSDictionary *personMeRelationshipDict;
@property (strong, nonatomic) NSDictionary *personHeRelationshipDict;
@property (strong, nonatomic) NSDictionary *personLoanListDict;
@property (strong, nonatomic) NSDictionary *shouxinListDict;
@property (strong, nonatomic) NSDictionary *allShouxinPeopleListDict;
//NET_FUNC_USER_IDENTIFY_RESULT_GET, 老版的身份验证信息，deprecated
//@property (strong, nonatomic) NSDictionary *shenfenInfoDict;
@property (strong, nonatomic) NSDictionary *identifyProgressDict;
@property (strong, nonatomic) NSDictionary *sendValidateCodeRespondDict;
@property (strong, nonatomic) NSDictionary *sendValidateCodeEmailRespondDict;
@property (strong, nonatomic) NSDictionary *checkValidateCodeRespondDict;
@property (strong, nonatomic) NSDictionary *checkValidateCodeEmailRespondDict;
@property (strong, nonatomic) NSDictionary *bindBankcardRespondDict;
@property (strong, nonatomic) NSDictionary *commitProvinceCityRespondDict;
@property (strong, nonatomic) NSDictionary *bankcardListRespondDict;
//@property (strong, nonatomic) NSDictionary *bankcardListRespondDictApi2;
@property (strong, nonatomic) NSDictionary *bankcardPayListRespondDict;
@property (strong, nonatomic) NSDictionary *allBankcardPayListRespondDict;
@property (strong, nonatomic) NSDictionary *checkBankValidateCodeRespondDict;
@property (strong, nonatomic) NSDictionary *visaGuestBank;
@property (strong, nonatomic) NSDictionary *unbindBankcardRespondDict;
@property (strong, nonatomic) NSDictionary *bankInfoRespondDict;
@property (strong, nonatomic) NSDictionary *visaValidationCodeRespondDict;
@property (strong, nonatomic) NSDictionary *visaValidationCheckRespondDict;
@property (strong, nonatomic) NSDictionary *identifyIdCardRespondDict;
@property (strong, nonatomic) NSDictionary *identifyEmailRespondDict;
@property (strong, nonatomic) NSDictionary *identifyCompanyRespondDict;
@property (strong, nonatomic) NSDictionary *identifySocialRespondDict;
@property (strong, nonatomic) NSDictionary *touziRespondDict;
@property (strong, nonatomic) NSDictionary *repaymentBillsListRespondDict;
@property (strong, nonatomic) NSDictionary *userVisaInfoRespondDict;
@property (strong, nonatomic) NSDictionary *userVisaActiveRespondDict;
@property (strong, nonatomic) NSDictionary *shareInfoDict;
@property (strong, nonatomic) NSDictionary *mutualFriendDict;
@property (strong, nonatomic) NSDictionary *versionUpdateInfoDict;
@property (strong, nonatomic) NSDictionary *gerenMyIouList;
@property (strong, nonatomic) NSDictionary *gerenMyIouDetail;
@property (strong, nonatomic) NSDictionary *qrcodePostRespondDict;
@property (strong, nonatomic) NSDictionary *withdrawLimitRespondDict;
@property (nonatomic) double       transferLimitLeft;
@property (strong, nonatomic) NSArray *transferDataList;
@property (strong, nonatomic) NSArray *iouRepayTypeList;
@property (strong, nonatomic) NSString *paymentDate;

@property (strong, nonatomic) NSDictionary *creditUserList;
@property (strong, nonatomic) NSDictionary *uploadResponse;
@property (strong, nonatomic) NSArray *rejectReason;    //驳回原因

@property (strong, nonatomic) NSArray *iouUseage;       //借款用途
@property (strong, nonatomic) NSArray *loanRateArr;     //借条年化利率
@property (nonatomic) CGFloat averageRate;              //借条平均借款利率
@property (nonatomic) NSInteger loanMortgateStatus;          //借款抵押状态
@property (strong, nonatomic) NSDictionary  *loanMortgateConfiguration;          //借款抵押配置
@property (strong, nonatomic) NSArray       *loanMortgatedays;          //借款抵押借款天数


@property (nonatomic) BOOL showTransferEntrance; //是否显示转账按钮

//@property (nonatomic) BOOL isAllowContactsUpload; //是否允许通讯录上传



////////////  分享状态   ////////////
@property (nonatomic) BOOL isSharingProcess;


- (id)init;

//user data got from login
- (void)setTheUser:(NSDictionary *)dict;
- (int)getUserIDInt;
- (NSString *)getUserID;
- (NSString *)getUserRealNamepExplictly;
- (NSString *)getUserRealName;
- (int)getWarrantyCount;
- (double)getRemainCreditLimit;
- (double)getRemainLoanLimit;
- (double)getLoanLimit;
- (double)getAccountVal;
- (NSString *)getInvestPrompt;

/**
 *  在用户信息获取手机号码
 */
- (NSString *)getPhoneNo;

/**
 *  在用户信息获取手机号码 并加掩码 
 *  133*****333
 */
- (NSString *)getMaskedPhone:(NSString *)phone;
- (NSString *)getPhoneMask;

- (BOOL)hasMoneyInAccount;
- (BOOL)hasDefaultBank;
- (BOOL)hasPhone;
- (BOOL)hasEmail;
/**
 *  若不是vip用户，则说明身份证尚未通过
 *
 *  @return yes or NO
 */
- (BOOL)hasIdCardByUserLevel;
/**
 *  若用户资料中用id number，则返回true
    原因：ver 2.0中，绑卡流程中提交的id信息被set到用户info中，由此导致，id number与user level并不对等
        此处仅用于绑卡流程入口时，判断用户是否已经输入过身份证信息
 *
 *  @return yes or no
 */
- (BOOL)hasIdCardInUserInfo;

- (NSString *)getIdCard;
- (BOOL)hasBankBinded;
- (BOOL)hasBankCardNumber;

- (UserLevelType)getUserLevel;
- (BOOL)hasIdentifyWaiting;
- (NSArray *)getShehuiOptions;


//- (float)getMinInvest;
- (NSInteger)getLoanDayCount;
- (float)getMinLoan;
- (float)getMinPublicRatePerYear;

- (BOOL)satisfyFriendNum;
- (NSString *)infoNotFriendNum;
- (BOOL)satisfyFriendNum:(NSInteger)numberLimit;
- (NSString *)infoNotFriendNum:(NSInteger)numberLimit;


- (NSString *)limitLoanAmountForNormalUser;
- (NSString *)limitLoanAmountForVIPuser;
- (int)getSMSWaitingSencods;
// 借款天数，包括抵押借款
- (NSArray *)getInterestDayCountWithMortgate:(BOOL)mortgate fromConfig:(NSDictionary *)config;
- (NSString *)getValueStringFromSystemPara:(NSString *)thekey;
- (NSString *)getValueOfKey:(NSString *)key fromConfig:(NSDictionary *)config ;

//- (NSNumber *)getFriendAvailableLoanMoney;
//- (NSNumber *)getPublicAvailableLoanMoney;


// 银行卡
- (BOOL)isActiveCard;

// 营业执照
- (BOOL)hasBusinessLicense;


#pragma mark - fabu

- (void)fabuClear;
- (void)fabuSetTitle:(NSString *)tt val:(CGFloat)val day:(int)day;
- (void)fabuSetType:(int)ty lixi:(CGFloat)val day:(int)day;
- (void)fabuSetYongtu:(NSString *)tt;
- (void)fabuSetLoanId:(NSString *)tt;
- (void)fabuAddFujian:(NSDictionary *)dict;
- (NSArray *)fabuFujianArray;
- (NSString *)fabuGetTitle;
- (NSDictionary *)fabuGetDataDict;
- (void)fabuDelete:(int)idx;

@property (strong, nonatomic) NSDictionary * fabuCalDict;

- (void)clearAllCache;

/**
 *  保存调试信息
 */
- (void)saveDataToFile;

//借条短信内容
-(NSString *)getIOUSMS;

-(CGFloat)getHighestYearRate;

-(CGFloat)getLowestIOUMoney;

-(BOOL)allowedContactsUpload;

-(NSInteger)getContactsUploadInterval;

-(NSInteger)getSex;

-(CGFloat)getSmartBidSingLower;
-(CGFloat)getSmartBidSingUpper;
//-(NSString *)workIn;
 
@end
