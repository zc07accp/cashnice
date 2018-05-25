#import <Foundation/Foundation.h>
#import "Masonry.h"

@interface Util : NSObject

//处理nsnull string
#define EMPTYSTRING_HANDLE(str) ([Util emptyStringResolve:str])
//处理nsnull 对象
#define EMPTYOBJ_HANDLE(str) ([Util emptyObjResolve:str])

#define TOAST_LOCAL_STRING(key) [Util toastStringOfLocalizedKey:key]

#define NAV_POP [self.navigationController popViewControllerAnimated:YES];


+ (void)sendEmail:(NSString *)address subject:(NSString *)subject content:(NSString *)content;
+ (NSString *)randomMacAddress;

+ (void)dispatch:(NSString *)msg;
+ (void)dispatch:(NSString *)msg info:(NSDictionary *)info;

+ (void)toast:(NSString *)str;
+ (void)toastExceptTopView:(NSString *)str;
+ (void)toastInGray:(NSString *)str ;
+ (void)toastCenter:(NSString *)str ;
+ (void)toastFrontKeyboard:(NSString *)str;
+ (void)toastStringOfLocalizedKey:(NSString *)key;
+ (void)noticeServiceErrorWithMessage:(NSString *)message;
+ (void)noticeServiceError;
+ (void)noticeServiceRecoveryMessage;
/**
 *  持久化头像
 */
+ (id)getValueFromUserDefaultWithKey:(NSString *)key;
+ (void)setUserDefaultValue:(id)value withKey:(NSString *)key;

+ (void)saveHeadImgUrl:(NSString *)url;
+ (NSString *)getSavedHeadImgUrl;

+ (CGPoint)getRectCenter:(CGRect)rc;
+ (CATransition *)getFadeTransition ;

+ (void)startAni:(UIView *)view scale:(float)s;
+ (void)endAni:(UIView *)view;

+ (BOOL)imagePngSave:(UIImage *)img path:(NSString *)path;
+ (UIImage *)imageLoadWithPath:(NSString *)path;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (NSData *)dataFromHexString:(NSString *)str;

//+ (NSString *)formatRMBUnitedWithString:(NSString *)string;
//+ (NSString *)formatRMBWithString:(NSString *)string;
+ (NSString *)UndoRMB:(NSString *)money ;

//格式：返回12.23元
+ (NSString *)formatRMB:(NSNumber *)money;
//格式：同上。0返回0元
+ (NSString *)formatRMBPureZero:(NSNumber *)money;

+ (NSString *)formatRMBWithoutUnit:(NSNumber *)money;
+ (NSString *)formatRMBPureZeroWithoutUnit:(NSNumber *)money;
+ (NSString *)formatRMBOnlyString:(NSNumber *)money;
+ (NSString *)formatFloat:(NSNumber *)money;
+ (NSString *)formatPositiveMoney:(NSNumber *)money positive:(BOOL)positive;

+ (NSMutableAttributedString *)getAttributedString:(NSString *)str font:(UIFont *)font color:(UIColor *)color;
+ (void)setAttributedString:(NSMutableAttributedString *)str font:(UIFont *)font color:(UIColor *)color range:(NSRange)range;
+ (void)setAttributedString:(NSMutableAttributedString *)str font:(UIFont *)font color:(UIColor *)color substr:(NSString *)substr allstr:(NSString *)allstr;

+ (void)setUILabelLargeGray:(NSArray *)arr;
+ (void)setUILabelLargeRed:(NSArray *)arr;
+ (void)setUILabelLargeBlue:(NSArray *)arr;
+ (void)setUILabelSmallGray:(NSArray *)arr;
+ (void)setUILabelSmallRed:(NSArray *)arr;
+ (void)setUILabelSmallBlue:(NSArray *)arr;
+ (void)setUILabelLargeGreen:(NSArray *)arr;
+ (void)setUILabelLargeBlack:(NSArray *)arr;
+ (void)setUILabelSmallBlack:(NSArray *)arr;
+ (void)setUIViewArrayHidden:(NSArray *)arr hidden:(BOOL)hidden;

+ (CGFloat)getCornerRadiusLarge;
+ (CGFloat)getCornerRadiusSmall;

+ (void)saveDictToFileWithBase64:(NSDictionary *)dict file:(NSString *)file key:(int)key;
+ (NSMutableDictionary *)readDictFromFileWithBase64:(NSString *)file key:(int)key;

+ (int)pageCount:(NSDictionary *)dict;
+ (int)totalCount:(NSDictionary *)dict;
+ (int)curPage:(NSDictionary *)dict;
+ (NSString *)percentInt:(int)v;
+ (NSString *)percentFloat:(CGFloat)v;
+ (NSString *)percentProgress:(CGFloat)v;
+ (NSString *)intWithUnit:(int)v unit:(NSString *)unit;

#pragma mark - pull to refresh
+ (void)setScrollHeader:(UIScrollView *)scroll target:(id)target header:(SEL)sel dateKey:(NSString *)datekey;
+ (void)setScrollFooter:(UIScrollView *)scroll target:(id)target footer:(SEL)sel;

+ (NSString *)shortDateFromFullFormat:(NSString *)fulldate;
+ (NSString *)spaceWithString:(NSString *)str;
+ (NSString *)shortDateUntilMin:(NSString *)dateString;
+ (BOOL)isBlocked:(int)blockType;

+ (NSString *)cutMoney:(NSString *)m;
+ (NSString *)cutInteger:(NSString *)m;
//+ (NSString *)cutTitle:(NSString *)m;

+(BOOL)isValidateMobile:(NSString *)mobile;
+(BOOL)isValidCode:(NSString *)code;
+(BOOL)isValidIdCard:(NSString *)card;
+(BOOL)isValidEmail:(NSString *)card;


+ (void)navPopTheTopN:(int)n nav:(UINavigationController *)nav;

+ (NSString *)getLoantype:(int)loantype;
+ (BOOL)isPublicLoan:(int)loantype;
+ (NSString *)getUserMaskNameOrNickName:(NSDictionary *)dict;
+ (NSString *)getUserFirstNameOrNickName:(NSDictionary *)dict;
+ (NSString *)getUserRealNameOrNickName:(NSDictionary *)dict;
+ (NSString *)getNickNameUserOrRealName:(NSDictionary *)dict;

//+ (BOOL)loanIsPublic:(NSDictionary *)dict;
//+ (BOOL)loanIsHaoyou:(NSDictionary *)dict;
//+ (BOOL)loanIsWeiYue:(NSDictionary *)dict;
//+ (BOOL)loanIsMine:(NSDictionary *)dict;
//+ (BOOL)loanShouldHideNameWithPublic:(BOOL)isPublic haoyou:(BOOL)isHaoyou weiyue:(BOOL)isWeiyue mine:(BOOL)isMine;
+ (BOOL)loanShouldHideNameWithDict:(NSDictionary *)dict;

+ (BOOL)isMyUserID:(NSString *)userid;
+ (NSString *)addSpaceToName:(NSString *)name;

+ (UIImage *)imagePlaceholderPortrait;
+ (UIImage *)imagePlaceholderAttachment;

+ (NSString *)getStringInvestWithNoMoney;
+ (NSMutableAttributedString *)getRemainDaysString:(NSDictionary *)dict;
+ (NSMutableAttributedString *)getDetailRemainDaysString:(NSDictionary *)dict;

+ (BOOL)canRepay:(NSDictionary *)dict;
+ (BOOL)hasFailDebt:(NSDictionary *)dict;

+ (NSNumber *)formatMoneyNumber:(NSString *)str;
+ (NSNumber *)formatRateNumber:(NSString *)str;

+ (void)checkFrameWidth:(CGRect)rc tag:(NSString *)tag;
+ (NSString *)getDateKey:(id)obj;

+ (NSString*)stringByDateMD:(NSDate*)date;
+ (NSDate*)dateMDByString:(NSString*)string;

+ (NSString*)dateToMinute:(NSString*)string;

+ (id)emptyStringResolve:(id)text;
+ (id)emptyObjResolve:(id)obj;

+ (NSString *)appVersion;


@end
