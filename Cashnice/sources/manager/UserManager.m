//
//  UserManager.m
//  YQS
//
//  Created by l on 4/13/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UserManager.h"
#import "IOU.h"

@interface UserManager ()


@property (strong, nonatomic) NSDictionary *       userDict;
@property (strong, nonatomic) NSMutableDictionary *fabuDict;
@end

@implementation UserManager

- (id)init {
	self = [super init];
	if (self != nil) {
		[self load];
	}
	return self;
}

- (NSString *)file {
    return [UtilFile libFile:USER_SESSION_KEY_DICT_FILE_NAME];
}

- (void)load {
    self.userDict = [Util readDictFromFileWithBase64:[self file] key:FILE_ENCODE_KEY];
}

- (void)save {
    [Util saveDictToFileWithBase64:self.userDict file:[self file] key:FILE_ENCODE_KEY];
}

- (void)clear {
    self.userDict = nil;
    [UtilFile fileDelete:[self file]];
}

- (NSMutableDictionary *)fabuDict {
	if(_fabuDict == nil) {
		_fabuDict = [NSMutableDictionary dictionary];
	}
	return _fabuDict;
}

- (void)fabuClear {
	[self.fabuDict removeAllObjects];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:def_key_fabu_yongtu];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:def_key_fabu_name];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:def_key_fabu_money];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:def_key_fabu_borrow_day];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:def_key_fabu_lixi];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:def_key_fabu_friend_type];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:def_key_fabu_huankuan_day];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:def_key_fabu_loanid];
}

- (void)fabuSetTitle:(NSString *)tt val:(CGFloat)val day:(int)day {
	[self.fabuDict setObject:tt forKey:def_key_fabu_name];
	[self.fabuDict setObject:@(val) forKey:def_key_fabu_money];
	[self.fabuDict setObject:@(day) forKey:def_key_fabu_borrow_day];
	
	
}

- (void)fabuSetType:(int)ty lixi:(CGFloat)val day:(int)day {
	[self.fabuDict setObject:@(ty) forKey:def_key_fabu_friend_type];
	[self.fabuDict setObject:@(val) forKey:def_key_fabu_lixi];
	[self.fabuDict setObject:@(day) forKey:def_key_fabu_huankuan_day];
}

- (void)fabuSetYongtu:(NSString *)tt {
	[self.fabuDict setObject:tt forKey:def_key_fabu_yongtu];
}

- (void)fabuSetLoanId:(NSString *)tt {
	[self.fabuDict setObject:tt forKey:def_key_fabu_loanid];
}

- (void)fabuAddFujian:(NSDictionary *)dict {
	NSMutableArray *x = [self.fabuDict objectForKey:def_key_fabu_attach];
	if (x == nil) {
		x = [NSMutableArray array];
		[self.fabuDict setObject:x forKey:def_key_fabu_attach];
	}
	[x addObject:dict];
}

- (void)fabuDelete:(int)idx {
	NSMutableArray *x = [self.fabuDict objectForKey:def_key_fabu_attach];
	if (x == nil) {
		x = [NSMutableArray array];
		[self.fabuDict setObject:x forKey:def_key_fabu_attach];
	}
	if ([x count] > idx && idx >= 0) {
		[x removeObjectAtIndex:idx];
	}
}

- (NSArray *)fabuFujianArray {
	NSMutableArray *x = [self.fabuDict objectForKey:def_key_fabu_attach];
	if (x == nil) {
		if (x == nil) {
			x = [NSMutableArray array];
			[self.fabuDict setObject:x forKey:def_key_fabu_attach];
		}
	}
	return x;
}

- (NSString *)fabuGetTitle {
	return [self.fabuDict objectForKey:def_key_fabu_name];
}

- (NSDictionary *)fabuGetDataDict {
	return self.fabuDict;
}

- (void)setTheUser:(NSDictionary *)dict {
	self.userDict = dict;
    [self save];
}

- (int)getUserIDInt {
	NSString *str = @"";
	if (self.userDict != nil) {
		str = [self.userDict objectForKey:NET_KEY_USERID];
	}
	if (str.length > 0 && [str intValue] >= 0) {
		return [str intValue];
	}
	else {
		return -1;
	}
}

- (UserLevelType)getUserLevel {
//    return UserLevel_Normal;
	int ty = [[self.gerenInfoDict objectForKey:NET_KEY_USERLEVEL] intValue];
	if (ty == 0) {
		return UserLevel_Unauthed;
	}
	else if (ty == 1) {
		return UserLevel_Normal;
	}
	else if (ty == 2) {
		return UserLevel_VIP;
	}
	return UserLevel_Unauthed;
}
- (BOOL)hasIdentifyWaiting {
    int st = -1;
    if (self.identifyProgressDict) {
        st = [[self.identifyProgressDict objectForKey:NET_KEY_status] intValue];
    }
    
	return st == 0;
}

- (NSArray *)getShehuiOptions {
	NSMutableArray *res = [NSMutableArray new];
	
	int cnt = [[self.systemOptionsDictShehuiZhiwu objectForKey:NET_KEY_itemcount] intValue];
	if (cnt > 0) {
		NSArray *arr = [self.systemOptionsDictShehuiZhiwu objectForKey:NET_KEY_items];
		if (cnt == [arr count]) {
			for (int i = 0; i < cnt; i++) {
				NSDictionary *dict = [arr objectAtIndex:i];
				NSString *x = [dict objectForKey:NET_KEY_itemvalue];
				if ([x notEmpty]) {
					[res addObject:x];
				}
			}
		}
		
	}
	
	return res;
}

- (NSString *)getUserID {
	NSString *str = @"";
	if (self.userDict != nil) {
		str = [self.userDict objectForKey:NET_KEY_USERID];
	}
	return str;
}

- (NSString *)getUserRealNamepExplictly{
    
    NSString *str = [self.gerenInfoDict objectForKey:NET_KEY_USERREALNAME];
    if ([str notEmpty]) {
        return str;
    }

    return nil;
}

- (NSString *)getUserRealName {
	NSString *str = [self.gerenInfoDict objectForKey:NET_KEY_USERREALNAME];
	if ([str notEmpty]) {
		return str;
	}
	str = [self.gerenInfoDict objectForKey:NET_KEY_NICKNAME];
	if ([str notEmpty]) {
		return str;
	}
	return [ZAPP.zlogin getNickName];
}

- (int)getWarrantyCount {
	return [[self.gerenInfoDict objectForKey:NET_KEY_CREDITMECOUNT] intValue] + [[self.gerenInfoDict objectForKey:NET_KEY_CREDITEACHOTHERCOUNT] intValue];
}

- (double)getRemainCreditLimit {
	return [[self.gerenInfoDict objectForKey:NET_KEY_REMAINCREDITLIMIT] doubleValue];
}

- (double)getRemainLoanLimit {
	return [[self.gerenInfoDict objectForKey:NET_KEY_REMAINLOANLIMIT] doubleValue];
}
- (double)getLoanLimit {
	return [[self.gerenInfoDict objectForKey:NET_KEY_LOANLIMIT] doubleValue];
}
- (double)getAccountVal {
	return [[self.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];
}
- (BOOL)hasMoneyInAccount {
	CGFloat x = [self getAccountVal];
	return x > 0;
}
- (BOOL)hasDefaultBank {
	BOOL b1 = [[self.gerenInfoDict objectForKey:NET_KEY_visaid] notEmpty];
	BOOL b2 = [[self.gerenInfoDict objectForKey:NET_KEY_visacode] notEmpty];
	BOOL b3 = [[self.gerenInfoDict objectForKey:NET_KEY_bankcode] notEmpty];
	return b1 && b2 && b3;
}

- (BOOL)hasIdCardByUserLevel {
    UserLevelType level = [self getUserLevel];
    return level == UserLevel_VIP;
}

- (BOOL)hasIdCardInUserInfo {
	if ([[self.gerenInfoDict objectForKey:NET_KEY_IDNUMBER] notEmpty]) {
		return YES;
	}
	return NO;
}

- (NSString *)getIdCard {
	return EMPTYSTRING_HANDLE([self.gerenInfoDict objectForKey:NET_KEY_IDNUMBER]);
}
- (BOOL)hasBankBinded {
	int bankCount = [[self.bankcardListRespondDict objectForKey:NET_KEY_visacount] intValue];
	if (bankCount > 0 ) {
		return YES;
	}
	return NO;
}

- (BOOL)hasBankCardNumber {
    NSArray *visas = ZAPP.myuser.bankcardListRespondDict[@"visas"];
    NSString *visacode = @"";
    if ([visas isKindOfClass:[NSArray class]] && visas.count > 0) {
        visacode = visas[0][@"visacode"];
    }
    return (visacode.length > 1);
}

- (NSString *)getMaskedPhone:(NSString *)phone{
    if (phone && phone.length >= 11 ) {
        return [phone stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    }
    return nil;
}

- (NSString *)getPhoneMask {
    NSString *phone = [self getPhoneNo];
    return [self getMaskedPhone:phone];
}

- (NSString *)getPhoneNo{
    
    return EMPTYSTRING_HANDLE([self.gerenInfoDict objectForKey:NET_KEY_PHONE]);
}

- (BOOL)hasPhone {
	if ([[self.gerenInfoDict objectForKey:NET_KEY_PHONE] notEmpty]) {
		return YES;
	}
	return NO;
}

- (BOOL)hasEmail{
    if ([[self.gerenInfoDict objectForKey:NET_KEY_USERemail] notEmpty]) {
        return YES;
    }
    return NO;
}

- (BOOL)hasBusinessLicense{
    
    return [EMPTYOBJ_HANDLE([self.gerenInfoDict objectForKey:@"businessLicense"]) integerValue]==1?YES:NO;

}

// 银行卡
// 是否已经激活
- (BOOL)isActiveCard  {
    if (self.bankcardListRespondDict) {
        NSArray *visaArray = self.bankcardListRespondDict[@"visas"];
          if (![visaArray isKindOfClass:[NSNull class]] && visaArray.count) {
              int visastatus = [visaArray[0][NET_KEY_visastatus] intValue];
              return visastatus == NET_KEY_visastatusActived; //NET_KEY_visastatusBinded; //
          }
    }
    return NO;
}

- (NSNumber *)getFriendAvailableLoanMoney {
	return @([[self.userDict objectForKey:NET_KEY_LOANLIMIT] doubleValue]);
}

- (NSNumber *)getPublicAvailableLoanMoney {
	return @([[self.userDict objectForKey:NET_KEY_REMAINLOANLIMIT] doubleValue]);
}

- (void)clearAllCache {
	self.userDict = nil;
    [self clear];
	
	self.gerenInfoDict                     = nil;
	/**
	 *  系统参数，不清空；app加载后获取，每次登录后获取，与是否登录无关，常驻内存
	 */
	//self.systemInfoDict                    = nil;
	self.systemOptionsDictShehuiZhiwu      = nil;
	self.loanFabuSucDetailDict             = nil;
	self.gerenBankDict                     = nil;
	self.loanListDict                      = nil;
	self.gerenMyBetList                    = nil;
	self.gerenMyLoanList                   = nil;
	self.gerenMyShouxinLoanList            = nil;
	self.loanDetailDict                    = nil;
	self.loanDetailCommonShouxinrenDict    = nil;
	self.loanDetailLoanUserDict            = nil;
	self.loanDetailAttachmentList          = nil;
//	self.mightKnownDict                    = nil;
	self.searchListDict                    = nil;
	self.billDict                          = nil;
	self.billDetailDict                    = nil;
	self.inviteListDict                    = nil;
	self.personInfoDict                    = nil;
	self.personMeRelationshipDict          = nil;
	self.personLoanListDict                = nil;
	self.shouxinListDict                   = nil;
	self.allShouxinPeopleListDict          = nil;
//	self.shenfenInfoDict                   = nil;
	self.identifyProgressDict              = nil;
	self.sendValidateCodeRespondDict       = nil;
	self.sendValidateCodeEmailRespondDict  = nil;
	self.checkValidateCodeRespondDict      = nil;
	self.checkValidateCodeEmailRespondDict = nil;
	self.bindBankcardRespondDict           = nil;
	self.commitProvinceCityRespondDict     = nil;
	self.bankcardListRespondDict           = nil;
//	self.bankcardListRespondDictApi2       = nil;
	self.bankcardPayListRespondDict        = nil;
	self.allBankcardPayListRespondDict     = nil;
	self.checkBankValidateCodeRespondDict  = nil;
	self.unbindBankcardRespondDict         = nil;
	self.bankInfoRespondDict               = nil;
	self.visaValidationCodeRespondDict     = nil;
	self.visaValidationCheckRespondDict    = nil;
	self.identifyIdCardRespondDict         = nil;
	self.identifyEmailRespondDict          = nil;
	self.identifyCompanyRespondDict        = nil;
	self.identifySocialRespondDict         = nil;
	self.touziRespondDict                  = nil;
}

- (void)saveDataToFile {
	NSMutableDictionary *dd = [NSMutableDictionary dictionary];
	if ( self.userDict != nil ) {
		[dd setObject: self.userDict forKey:@"userDict"];
	}
	if ( self.gerenInfoDict != nil ) {
		[dd setObject: self.gerenInfoDict forKey:@"gerenInfoDict"];
	}
	if ( self.systemInfoDict != nil ) {
		[dd setObject: self.systemInfoDict forKey:@"systemInfoDict"];
	}
	if (self.systemOptionsDictShehuiZhiwu != nil) {
		[dd setObject:self.systemOptionsDictShehuiZhiwu forKey:@"systemOptionsDictShehuiZhiwu"];
	}
	if ( self.loanFabuSucDetailDict != nil ) {
		[dd setObject: self.loanFabuSucDetailDict forKey:@"loanFabuSucDetailDict"];
	}
	if ( self.gerenBankDict != nil ) {
		[dd setObject: self.gerenBankDict forKey:@"gerenBankDict"];
	}
	if ( self.loanListDict != nil ) {
		[dd setObject: self.loanListDict forKey:@"loanListDict"];
	}
	if ( self.gerenMyBetList != nil ) {
		[dd setObject: self.gerenMyBetList forKey:@"gerenMyBetList"];
	}
	if ( self.gerenMyLoanList != nil ) {
		[dd setObject: self.gerenMyLoanList forKey:@"gerenMyLoanList"];
	}
	if ( self.gerenMyShouxinLoanList != nil ) {
		[dd setObject: self.gerenMyShouxinLoanList forKey:@"gerenMyShouxinLoanList"];
	}
	if ( self.loanDetailDict != nil ) {
		[dd setObject: self.loanDetailDict forKey:@"loanDetailDict"];
	}
	if ( self.loanDetailCommonShouxinrenDict != nil ) {
		[dd setObject: self.loanDetailCommonShouxinrenDict forKey:@"loanDetailCommonShouxinrenDict"];
	}
	if ( self.loanDetailLoanUserDict != nil ) {
		[dd setObject: self.loanDetailLoanUserDict forKey:@"loanDetailLoanUserDict"];
	}
	if ( self.loanDetailAttachmentList != nil ) {
		[dd setObject: self.loanDetailAttachmentList forKey:@"loanDetailAttachmentList"];
	}
//	if ( self.mightKnownDict != nil ) {
//		[dd setObject: self.mightKnownDict forKey:@"mightKnownDict"];
//	}
	if ( self.searchListDict != nil ) {
		[dd setObject: self.searchListDict forKey:@"searchListDict"];
	}
	if ( self.billDict != nil ) {
		[dd setObject: self.billDict forKey:@"billDict"];
	}
	if ( self.billDetailDict != nil ) {
		[dd setObject: self.billDetailDict forKey:@"billDetailDict"];
	}
	if ( self.inviteListDict != nil ) {
		[dd setObject: self.inviteListDict forKey:@"inviteListDict"];
	}
	if ( self.personInfoDict != nil ) {
		[dd setObject: self.personInfoDict forKey:@"personInfoDict"];
	}
	if ( self.personMeRelationshipDict != nil ) {
		[dd setObject: self.personMeRelationshipDict forKey:@"personMeRelationshipDict"];
	}
	if ( self.personLoanListDict != nil ) {
		[dd setObject: self.personLoanListDict forKey:@"personLoanListDict"];
	}
	if ( self.shouxinListDict != nil ) {
		[dd setObject: self.shouxinListDict forKey:@"shouxinListDict"];
	}
	if ( self.allShouxinPeopleListDict != nil ) {
		[dd setObject: self.allShouxinPeopleListDict forKey:@"allShouxinPeopleListDict"];
	}
//	if ( self.shenfenInfoDict != nil ) {
//		[dd setObject: self.shenfenInfoDict forKey:@"shenfenInfoDict"];
//	}
	if ( self.identifyProgressDict != nil ) {
		[dd setObject: self.identifyProgressDict forKey:@"identifyProgressDict"];
	}
	if ( self.sendValidateCodeRespondDict != nil ) {
		[dd setObject: self.sendValidateCodeRespondDict forKey:@"sendValidateCodeRespondDict"];
	}
	if ( self.sendValidateCodeEmailRespondDict != nil ) {
		[dd setObject: self.sendValidateCodeEmailRespondDict forKey:@"sendValidateCodeEmailRespondDict"];
	}
	if ( self.checkValidateCodeRespondDict != nil ) {
		[dd setObject: self.checkValidateCodeRespondDict forKey:@"checkValidateCodeRespondDict"];
	}
	if ( self.checkValidateCodeEmailRespondDict != nil ) {
		[dd setObject: self.checkValidateCodeEmailRespondDict forKey:@"checkValidateCodeEmailRespondDict"];
	}
	if ( self.bindBankcardRespondDict != nil ) {
		[dd setObject: self.bindBankcardRespondDict forKey:@"bindBankcardRespondDict"];
	}
	if ( self.commitProvinceCityRespondDict != nil ) {
		[dd setObject: self.commitProvinceCityRespondDict forKey:@"commitProvinceCityRespondDict"];
	}
	if ( self.bankcardListRespondDict != nil ) {
		[dd setObject: self.bankcardListRespondDict forKey:@"bankcardListRespondDict"];
	}
//	if ( self.bankcardListRespondDictApi2 != nil ) {
//		[dd setObject: self.bankcardListRespondDictApi2 forKey:@"bankcardListRespondDictApi2"];
//	}
	if ( self.bankcardPayListRespondDict != nil ) {
		[dd setObject: self.bankcardPayListRespondDict forKey:@"bankcardPayListRespondDict"];
	}
	if (self.allBankcardPayListRespondDict != nil) {
		[dd setObject:self.allBankcardPayListRespondDict forKeyedSubscript:@"allBankcardPayListRespondDict"];
	}
	if ( self.checkBankValidateCodeRespondDict != nil ) {
		[dd setObject: self.checkBankValidateCodeRespondDict forKey:@"checkBankValidateCodeRespondDict"];
	}
	if ( self.unbindBankcardRespondDict != nil ) {
		[dd setObject: self.unbindBankcardRespondDict forKey:@"unbindBankcardRespondDict"];
	}
	if ( self.bankInfoRespondDict != nil ) {
		[dd setObject: self.bankInfoRespondDict forKey:@"bankInfoRespondDict"];
	}
	if ( self.visaValidationCodeRespondDict != nil ) {
		[dd setObject: self.visaValidationCodeRespondDict forKey:@"visaValidationCodeRespondDict"];
	}
	if ( self.visaValidationCheckRespondDict != nil ) {
		[dd setObject: self.visaValidationCheckRespondDict forKey:@"visaValidationCheckRespondDict"];
	}
	if ( self.identifyIdCardRespondDict != nil ) {
		[dd setObject: self.identifyIdCardRespondDict forKey:@"identifyIdCardRespondDict"];
	}
	if ( self.identifyEmailRespondDict != nil ) {
		[dd setObject: self.identifyEmailRespondDict forKey:@"identifyEmailRespondDict"];
	}
	if ( self.identifyCompanyRespondDict != nil ) {
		[dd setObject: self.identifyCompanyRespondDict forKey:@"identifyCompanyRespondDict"];
	}
	if ( self.identifySocialRespondDict != nil ) {
		[dd setObject: self.identifySocialRespondDict forKey:@"identifySocialRespondDict"];
	}
	if ( self.touziRespondDict != nil ) {
		[dd setObject: self.touziRespondDict forKey:@"touziRespondDict"];
	}
	
	
	[UtilFile fileDelete:[UtilFile docFile:LOG_FILE_NAME]];
	[UtilFile fileDelete:[UtilFile docFile:TOKEN_FILE_NAME]];
	[UtilFile fileDelete:[UtilFile docFile:USER_FILE_NAME]];
	
	
	[Util saveDictToFileWithBase64:dd file:[UtilFile docFile:LOG_FILE_NAME] key:0x33];
	[[NSFileManager defaultManager] copyItemAtPath:[UtilFile libFile:TOKEN_FILE_NAME] toPath:[UtilFile docFile:TOKEN_FILE_NAME] error:nil];
	[[NSFileManager defaultManager] copyItemAtPath:[UtilFile libFile:USER_FILE_NAME] toPath:[UtilFile docFile:USER_FILE_NAME] error:nil];
}

- (NSString *)getValueOfKey:(NSString *)key fromConfig:(NSDictionary *)config {
    
    if ([config isKindOfClass:[NSArray class]]  && config.count > 0) {
        NSArray *arr = (NSArray *)config;
        for (int i = 0; i < arr.count; i++) {
            NSString *k = [[arr objectAtIndex:i] objectForKey:NET_KEY_NAME];
            if ([k notEmpty] && [k isEqualToString:key]) {
                return [[arr objectAtIndex:i] objectForKey:NET_KEY_VALUE];
            }
        }
    }
    
    return @"-1";
}

- (NSString *)getValueStringFromSystemPara:(NSString *)thekey {
	if (self.systemInfoDict == nil) {
		//[ZAPP.zlogin loginToServer:nil];
		//[Util toast:@"请先登录"];
	}
	else {
		int cnt = [[self.systemInfoDict objectForKey:NET_KEY_itemcount] intValue];
		NSArray *arr = [self.systemInfoDict objectForKey:NET_KEY_items];
		for (int i = 0; i < cnt; i++) {
			NSString *k = [[arr objectAtIndex:i] objectForKey:NET_KEY_NAME];
			if ([k notEmpty] && [k isEqualToString:thekey]) {
				return [[arr objectAtIndex:i] objectForKey:NET_KEY_VALUE];
			}
		}
	}
	return @"-1";
}

- (NSArray *)getInterestDayCountWithMortgate:(BOOL)mortgate fromConfig:(NSDictionary *)config {
    NSArray *loanDays = [NSArray new];
    
    NSString *key = mortgate ? @"专属用户借款天数" : @"公开借款计息天数";
    
    if ([config isKindOfClass:[NSArray class]]  && config.count > 0) {
        NSArray *arr = (NSArray *)config;
        for (int i = 0; i < arr.count; i++) {
            NSString *k = [[arr objectAtIndex:i] objectForKey:NET_KEY_NAME];
            if ([k notEmpty] && [k isEqualToString:key]) {
                loanDays =  [[arr objectAtIndex:i] objectForKey:@"loan_days"];
            }
        }
    }
    
    return loanDays;
}

- (NSInteger)getLoanDayCount {
    return [[self getValueStringFromSystemPara:@"筹款天数"] integerValue];
}

- (float)getMinInvest {
	return [[self getValueStringFromSystemPara:@"最低起投金额"] doubleValue];
}

- (float)getMinLoan {
	return [[self getValueStringFromSystemPara:@"最低借款金额"] doubleValue];
}

- (float)getMinPublicRatePerYear {
	return [[self getValueStringFromSystemPara:@"公开借款最低年化利率"] doubleValue];
}

- (int)getMinFriendNum {
	return [[self getValueStringFromSystemPara:@"发布借款好友数下限"] intValue];
}
- (NSString *)getInvestPrompt {
    return EMPTYSTRING_HANDLE([self getValueStringFromSystemPara:@"投资提示语"]);
}

- (BOOL)satisfyFriendNum:(NSInteger)numberLimit {
    int num = [[self.gerenInfoDict objectForKey:NET_KEY_CREDITEACHOTHERCOUNT] intValue] + [[self.gerenInfoDict objectForKey:NET_KEY_CREDITMECOUNT] intValue];
    return num >= numberLimit;
}

- (BOOL)satisfyFriendNum {
	int num = [[self.gerenInfoDict objectForKey:NET_KEY_CREDITEACHOTHERCOUNT] intValue] + [[self.gerenInfoDict objectForKey:NET_KEY_CREDITMECOUNT] intValue];
	return num >= [self getMinFriendNum];
}

- (NSString *)infoNotFriendNum:(NSInteger)numberLimit {
    return [NSString stringWithFormat:@"您的授信人数不足%zd人无法借款！", numberLimit];
}

- (NSString *)infoNotFriendNum {
	return [NSString stringWithFormat:@"您的授信人数不足%d人无法借款！", [self getMinFriendNum]];
}

- (NSString *)limitLoanAmountForNormalUser {
	NSString *str = [self getValueStringFromSystemPara:@"普通认证最高借款额度"];
	return [NSString stringWithFormat:@"%d万", (int)([str intValue]/(int)1e4)];
}

- (NSString *)limitLoanAmountForVIPuser {
	NSString *str = [self getValueStringFromSystemPara:@"VIP认证最高借款额度"];
	return [NSString stringWithFormat:@"%d万", (int)([str intValue]/(int)1e4)];
}

- (int)getSMSWaitingSencods {
	NSString *str = [self getValueStringFromSystemPara:@"短信验证码等待秒数"];
	int x = [str intValue];
	if (x < 30) {
		return 121;
	}
	return x + 1;
}

-(NSString *)getIOUSMS{
    
    NSString *str = [self getValueStringFromSystemPara:@"借条短信内容"];
    if ([str length]==0) {
        return IOU_SMS;
    }
    return str;
}

-(CGFloat)getHighestYearRate{
    
    CGFloat rate = [[self getValueStringFromSystemPara:@"借条借款最高年化利率"] doubleValue];
    if (rate == 0) {
        return 24;
    }
    return rate;
}

-(CGFloat)getLowestIOUMoney{
    CGFloat rate = [[self getValueStringFromSystemPara:@"借条最低金额"] doubleValue];
    return rate;
}

-(BOOL)allowedContactsUpload{
    NSInteger rate = [[self getValueStringFromSystemPara:@"是否开启通讯录上传"] integerValue];
    return rate==1;
}

-(CGFloat)getSmartBidSingLower{
    CGFloat rate = [[self getValueStringFromSystemPara:@"智能投标单笔下限"] doubleValue];
    return rate;
}

-(CGFloat)getSmartBidSingUpper{
    CGFloat rate = [[self getValueStringFromSystemPara:@"智能投标单笔上限"] doubleValue];
    return rate;
}

-(NSInteger)getContactsUploadInterval{
    NSInteger value = [[self getValueStringFromSystemPara:@"上传通讯录时间间隔"] doubleValue];
    return value;
}

-(NSInteger)getSex{
    
    return  [[self.gerenInfoDict objectForKey:NET_KEY_SEX] integerValue];
}

//-(NSString *)workIn{
//    
//    return  EMPTYSTRING_HANDLE([self.gerenInfoDict objectForKey:NET_KEY_ORGANIZATION]);
//
//}

@end
