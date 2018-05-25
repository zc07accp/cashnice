//
//  NetworkEngine.h
//  YQS
//
//  Created by l on 3/13/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkEngine : MKNetworkEngine <UIAlertViewDelegate> {
    NSDictionary *respondDict;
}

/**
 *  是否开启网络数据缓存，默认开启
 */
@property (nonatomic) BOOL closeAutoCache;

//使用手机号登录

- (MKNetworkOperation *)newloginToServerByPhone:(NSString *)phone validationCode:(NSString *)validationCode validationUUID:(NSString *)validationUUID complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
- (MKNetworkOperation *)newloginToServerByPhone:(NSString *)phone regionCode:(NSInteger)regionCode validationCode:(NSString *)validationCode validationUUID:(NSString *)validationUUID  complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
// 用于测试的登录
- (MKNetworkOperation *)newloginToServerByPhone4Test:(NSString *)phone regionCode:(NSInteger)regionCode complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//手机号绑定微信
//微信登录 微信绑定
- (MKNetworkOperation *)bindPhoneWithWeiXinAndLoginToServer:(NSString *)phone socialid:(NSString *)socialid token:(NSString *)token nickname:(NSString *)nickname headimg:(NSString *)headimg regionCode:(NSInteger)regionCode  validationCode:(NSString *)validationCode validationUUID:(NSString *)validationUUID complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//微信登录
- (MKNetworkOperation *)newloginToServerByWeixinWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock regionCode:(NSInteger)regionCode;

//warning 新接口替换，逐步抛弃不用
//获取系统配置
- (MKNetworkOperation *)getSystemConfigurationInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock; MKNetAPIDeprecated("已废弃");



// 获取国际化地区
- (MKNetworkOperation *)getSupportedRegionWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
// 大额充值上传二维码内容
- (MKNetworkOperation *)postQrCode:(NSString *)code step:(NSString *)step complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
// 提现算费
- (MKNetworkOperation *)getWithDrawLimit:(CGFloat)amount complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;

//用户信息，他人
- (MKNetworkOperation *)getUserInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid;
//用户信息，我
- (MKNetworkOperation *)getUserInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//投资详情  用于投资首页
- (MKNetworkOperation *)getBetDetailWithBetid:(NSString *)betid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;

//投资列表，即借款列表
- (MKNetworkOperation *)getLoanListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//获取还款账单列表
- (MKNetworkOperation *)getRepaymentListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock ;

//我的借款详情
- (MKNetworkOperation *)getMyLoanDetailWithLoanID:(NSString *)loanid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//借款详情
- (MKNetworkOperation *)getLoanDetailWithLoanID:(NSString *)loanid userid:(NSString *)loanuserid page:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//我的借款详情
- (MKNetworkOperation *)getGerenMyLoanDetailWithLoanID:(NSString *)loanid fromtype:(NSNumber *)fromtype userid:(NSString *)loanuserid page:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//借款详情 用于投资首页
- (MKNetworkOperation *)getLoanDetailWithLoanID:(NSString *)loanid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//借款详情 我的借款
- (MKNetworkOperation *)getGerenMyLoanDetailWithLoanID:(NSString *)loanid fromtype:(NSNumber *)fromtype userid:(NSString *)loanuserid page:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock witnStage:(NSInteger)stage withOrder:(NSInteger)order;
//借款附件
- (MKNetworkOperation *)getLoanDetailAttachmentsWithLoanID:(NSString *)loanid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//所有授信人
- (MKNetworkOperation *)getAllShouxinPeopleWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock loadid:(NSString *)loadid page:(int)page pagesize:(int)pagesize;
//关闭借款
- (MKNetworkOperation *)closeTheLoanWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock loanid:(NSString *)loanid;
//投资约束检查
- (MKNetworkOperation *)touziValidateWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value loanid:(NSString *)loanid;
//投资
- (MKNetworkOperation *)touziWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value loanid:(NSString *)loanid betid:(NSString *)betid;
// 投资
- (MKNetworkOperation *)investWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value loanid:(NSString *)loanid;

//我的借款
- (MKNetworkOperation *)getGerenMyLoanListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//我的借款带排序
- (MKNetworkOperation *)getOrderedLoanListWithPage:(int)page pagesize:(int)pagesize order:(NSInteger)order ishistoric:(BOOL)historic complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//我的投资
- (MKNetworkOperation *)getGerenMyBetListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock withStage:(NSInteger)stage withOrder:(NSInteger)order;
//我的投资详情
- (MKNetworkOperation *)getMyBetDetailWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock loanid:(NSInteger)loanid;
//我授信的借款
- (MKNetworkOperation *)getGerenMyShouxinLoanListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock withStage:(NSInteger)stage withOrder:(NSInteger)order historic:(BOOL)historic;

////// ============================================                 ===================================================
////// ============================================     借条相关      ===================================================
////// ============================================                 ===================================================
//借条-我的借款
- (MKNetworkOperation *)getMyIouListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock
                                      withIouType:(int)iouType historical:(BOOL)historical andOrder:(NSInteger)order;
//借条-借条详情
- (MKNetworkOperation *)getMyIouDetailIouid:(NSInteger)iouid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;

//借条-还款方式
- (MKNetworkOperation *)getIouRepayTypesWithCompelte:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;

//借条-发起还款
- (MKNetworkOperation *)iouRepayActionWithUiId:(NSString *)UiId
                                        amount:(CGFloat)amount
                                     repayType:(NSInteger)repayType
                                   attachments:(NSArray *)attachments
                                      Compelte:(NetResponseBlock)compelteBlock
                                         error:(NetErrorBlock)errorBlock;

//借条-上传凭证
-(MKNetworkOperation*) uploadIOUImages:(NSArray<UIImage *> *)images
                     completionHandler:(IDBlock) completionBlock
                          errorHandler:(NetErrorBlock) errorBlock;
////// ============================================                 ===================================================
////// ============================================                 ===================================================

//共同好友
- (MKNetworkOperation *)getMutualFriendWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock friendUserid:(NSString *)friendUserid page:(int)page pagesize:(int)pagesize;
/**
 *  没向我授信的人、已向我授信的人、已相互授信的人
 */
- (MKNetworkOperation *)getShouxinWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid page:(int)page pagesize:(int)pagesize shouxintype:(int)ty;

//搜索好友 (废弃**********************************)
- (MKNetworkOperation *)searchWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock searchkey:(NSString *)searchkey page:(int)page pagesize:(int)pagesize MKNetAPIDeprecated("已废弃");
//获取他人的个人信息
- (MKNetworkOperation *)getPersonInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid;
//授信
- (MKNetworkOperation *)creditWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid intv:(int)v;
//索要授信
- (MKNetworkOperation *)requestCreditWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid;

//我的账单
- (MKNetworkOperation *)getBillNGWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock page:(int)page pagesize:(int)pagesize begin:(NSString *)begin end:(NSString *)end bill_type:(NSInteger)bill_type;

- (MKNetworkOperation *)getBillWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid page:(int)page pagesize:(int)pagesize;
//账单详情
- (MKNetworkOperation *)getBillDetailWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock noticeID:(NSString *)noticeid;

//微信分享
- (MKNetworkOperation *)getShareTriggerWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
- (MKNetworkOperation *)postShareTriggerWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock triggerid:(NSString *)triggerid;

//new borrow
- (MKNetworkOperation *)getMortgateComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
- (MKNetworkOperation *)fabuWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;

- (MKNetworkOperation *)loanCalWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
- (MKNetworkOperation *)loanCalWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock mainval:(NSInteger)mainval loanrate:(CGFloat)loanrate couponrate:(CGFloat)couponrate daycount:(NSInteger)daycount;

//ti xing
- (MKNetworkOperation *)deleteRemindListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock notices:(NSArray *)notices;
- (MKNetworkOperation *)getRemindNumWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock date:(NSDate *)date;
- (MKNetworkOperation *)getRemindListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock page:(int)page pagesize:(int)pagesize;

//validation
// 发送验证码，带有区号
- (MKNetworkOperation *)sendValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock phonenum:(NSString *)phonenum  regionCode:(NSInteger)regionCode;
// 发送验证码
- (MKNetworkOperation *)sendValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock phonenum:(NSString *)phonenum;

- (MKNetworkOperation *)sendValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock email:(NSString *)email;
- (MKNetworkOperation *)checkValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock uuid:(NSString *)uuid code:(NSString *)code savedphone:(NSString *)savedphone;

//修改手机号
- (MKNetworkOperation *)postPhoneAfterValidationWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock savedphone:(NSString *)savedphone regionCode:(NSInteger)regionCode validationCode:(NSString *)validationCode  validationUUID:(NSString *)validationUUID;

- (MKNetworkOperation *)postNickNameWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock nickname:(NSString *)nickname;
- (MKNetworkOperation *)postHeadUrlWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock headrul:(NSString *)headurl;

- (MKNetworkOperation *)bindBankcardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock cardnumber:(NSString *)cardnumber phonenumber:(NSString *)phonenumber bankCode:(NSString *)bankCode userName:(NSString *)username idNumber:(NSString *)idnumber;


- (MKNetworkOperation *)bindBankcardCommitNameAndIdNumberWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userrealname:(NSString *)name idcardnumber:(NSString *)idcard;

- (MKNetworkOperation *)commitIdcardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock realname:(NSString *)realname idnumber:(NSString *)idnumber attach:(NSDictionary *)attach;
- (MKNetworkOperation *)newCommitCompanyWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock company:(NSString *)company job:(NSString *)job address:(NSString *)address positions:(NSArray *)positions explain:(NSString *)explain;
- (MKNetworkOperation *)commitProvinceCityWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock province:(NSString *)provinceName city:(NSString *)cityName;
- (MKNetworkOperation *)commitIntroWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock intro:(NSString *)intro;

//bank card
/**
 *  api 1.0, bankcard list, deprecated
 *
 *  @param MKNetworkOperation
 *
 *  @return
 */
//- (MKNetworkOperation *)api1_getBankcardListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
/**
 *  api 2.0 get bankcard list, used for bankList page only
 *
 *  @param compelteBlock
 *  @param errorBlock
 *
 *  @return 
 */
- (MKNetworkOperation *)api2_getBankcardListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
/**
 *  获取支持的银行
 */
- (MKNetworkOperation *)api2_getBanksListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
/**
 *  获取用户银行卡
 */
- (MKNetworkOperation *)getUserBankcardListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
- (MKNetworkOperation *)guestBankWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock bankCard:(NSString *)bankCard;
- (MKNetworkOperation *)checkBankcardValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock orderno:(NSString *)orderno code:(NSString *)code;
- (MKNetworkOperation *)unbindBankcardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock cardid:(NSString *)cardid;
///////  获取绑定银行卡验证码
- (MKNetworkOperation *) requestVisaActiveValidateCodeComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock ;

//获取银行信处，充值转账限额等；非银行卡本身的信息
//bankcode, 银行代码，如cmb是招商银行
- (MKNetworkOperation *)getBankInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock bankcode:(NSString *)bankcode;

//apply
/*- (MKNetworkOperation *)applyLevelWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock level:(int)level;*/

//chong zhi, ti xian
- (MKNetworkOperation *)sendChongzhiValidationCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock val:(NSString *)val visaid:(NSString *)visaid;
// 充值验证
- (MKNetworkOperation *)checkChongzhiValidateWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value;
- (MKNetworkOperation *)checkChongzhiValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock orderno:(NSString *)orderno code:(NSString *)code;
//体现验证
- (MKNetworkOperation *)tixianValidateWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value;
- (MKNetworkOperation *)tixianWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value;
- (MKNetworkOperation *)huankuanWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value debtid:(NSString *)debtid;

//invite list
- (MKNetworkOperation *)getInviteWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock page:(int)page pagesize:(int)pagesize;

-(MKNetworkOperation*) uploadImages:(NSArray *)imagesArr
                              files:(NSArray *)filesArr
                  completionHandler:(CardIDBlock) completionBlock
                       errorHandler:(NetErrorBlock) errorBlock;

//upload image
-(MKNetworkOperation*) uploadImageFromFile:(NSString*) file image:(UIImage *)img completionHandler:(IDBlock) completionBlock errorHandler:(NetErrorBlock) errorBlock;

- (MKNetworkOperation *)accessToken:(NSString *)code compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock;

//检查版本更新
- (MKNetworkOperation *)checkUpdateInfo:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;

- (NSString *)jsonDictionaryWithSessionkeyAndVersion:(NSString *)sessionkey uid:(int)uid namesArr:(NSArray *)namesArr parasArr:(NSArray *)parasArr versionArr:(NSArray *)verArr;

//预计到账时间
- (MKNetworkOperation *)getPaymentDate:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;

//转账限额
- (MKNetworkOperation *)getTransferLimitComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//最近转账
- (MKNetworkOperation *)getTransferDataComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//*********************

- (MKNetworkOperation *)sendRequest:(NSString *)jsonString compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock;

- (MKNetworkOperation *)sendPost:(NSString *)jsonString compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock;

- (MKNetworkOperation *)sendGet:(NSString *)jsonString compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock ;

- (void)generalErrorBlock:(MKNetworkOperation *)errorOperation error:(NSError *)error;

- (void)generalCompleteBlock:(MKNetworkOperation *)completedOperation ;

-(BOOL)needCacheHandle:(NSString *)jsonString;

-(NSArray *)requestArr:(NSString *)jsonString;

-(NSString *)cacheKey:(NSString *)jsonString;

-(void)getCacheIfExisted:(NSString *)jsonString complete:(void (^)(id obj))complete;

@end
