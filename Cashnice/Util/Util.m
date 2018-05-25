#import "Util.h"
#import "Base64EncoderDecoder.h"
#import "MJRefresh.h"
#import "RealReachability.h"
#import <objc/runtime.h>

@implementation Util

+ (void)sendEmail:(NSString*)address subject:(NSString*)subject content:(NSString*)content {
	if ([address notEmpty]) {
		subject = (subject == nil) ? @"" : subject;
		content = (content == nil) ? @"" : content;
		NSString* urlString = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@", [address trimmed], [subject trimmed], [content trimmed]];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
}

+ (NSString*)randomMacAddress {
	NSArray*         xarray = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F", nil];
	NSMutableString* xres   = [NSMutableString string];
	for (int i = 0; i < 12; i++) {
		int res = arc4random() % 16;
		[xres appendString:[xarray objectAtIndex:res]];
	}
	return xres;
}

+ (void)dispatch:(NSString *)msg {
	if ([msg notEmpty]) {
		[UtilLog string:msg];
		NSNotification* ntf = [NSNotification notificationWithName:msg object:nil userInfo:nil];
		[[NSNotificationQueue defaultQueue] enqueueNotification:ntf postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnName forModes:nil];
	}
}

+ (void)dispatch:(NSString *)msg info:(NSDictionary *)info {
	if ([msg notEmpty]) {
		NSNotification* ntf = [NSNotification notificationWithName:msg object:nil userInfo:info];
		[[NSNotificationQueue defaultQueue] enqueueNotification:ntf postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnName forModes:nil];
	}
	
}

+ (void)toastStringOfLocalizedKey:(NSString *)key{
    if ([key notEmpty]) {
        NSString *info = CNLocalizedString(key, nil);
        if ([info notEmpty]) {
            [Util toast:[info trimmed]];
            //[ZAPP.nav.view makeToast:[info trimmed]];
        }
    }
}

+ (void)toastInGray:(NSString *)str  {
    if ([str notEmpty]) {
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        
        NSUInteger i = windows.count - 1;
        UIWindow *window = windows[i];
        while (! [NSStringFromClass(window.class) isEqualToString:@"UIWindow"]) {
            window = windows[--i];
        }
        
        //[window makeToast:[str trimmed]];
        [window makeToast:[str trimmed] bkColor:[UIColor lightGrayColor]];
    }
}

+ (void)toastCenter:(NSString *)str {
    if ([str notEmpty]) {
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        
        NSUInteger i = windows.count - 1;
        UIWindow *window = windows[i];
        while (! [NSStringFromClass(window.class) isEqualToString:@"UIWindow"]) {
            window = windows[--i];
        }
        
        [window makeToastCenter:[str trimmed]];
    }
}

+ (void)toast:(NSString *)str {
	if ([str notEmpty]) {
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        
        NSUInteger i = windows.count - 1;
        UIWindow *window = windows[i];
        while (! [NSStringFromClass(window.class) isEqualToString:@"UIWindow"]) {
            window = windows[--i];
        }
        
        [window makeToast:[str trimmed]];
        
        /*
        NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
        
        [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
            if([window isKindOfClass:[UIWindow class]] && [window isKeyWindow]) {
                [window makeToast:[str trimmed]];
                *stop = YES;
            }
        }];
        */
        //[ZAPP.window makeToast:[str trimmed]];
        
//        
//        if([ZAPP.nav.viewControllers lastObject]){
////            [[ZAPP.nav.viewControllers lastObject].view makeToast:[str trimmed]];
//            [ZAPP.window.rootViewController.view makeToast:[str trimmed]];
//        }else{
//            [ZAPP.window makeToast:[str trimmed]];
//        }
	}
}

+ (void)toastExceptTopView:(NSString *)str {
    if ([str notEmpty]) {
        
//        NSArray *vcs = ZAPP.tabViewCtrl.viewControllers;
//        if (vcs.count > 1) {
            [ZAPP.window makeToast:[str trimmed]];
//        }
        //        [window makeToast:[str trimmed]];
    }
}

+ (void)toastFrontKeyboard:(NSString *)str {
    if ([str notEmpty]) {
        
        UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
        [window makeToast:[str trimmed]];
    }
}


+(void)noticeServiceErrorWithMessage:(NSString *)message{
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        if (status != RealStatusNotReachable) {
            //网络可达
            [Util dispatch:MSG_system_service_updating];
            [Util toastExceptTopView:message];
        }else{
            //网络不通
            [Util toast:net_error_msg];
        }
    }];
}

+(void)noticeServiceError{
    [Util noticeServiceErrorWithMessage:net_error_msg];
}

+(void)noticeServiceRecoveryMessage{
    [Util dispatch:MSG_system_service_recovery];
}

+ (void)saveHeadImgUrl:(NSString *)url{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:url forKey:@"cache_head_imge_url"];
    [userDefault synchronize];
}

+ (NSString *)getSavedHeadImgUrl{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id obj = [userDefault objectForKey:@"cache_head_imge_url"];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return nil;
}

+ (id)getValueFromUserDefaultWithKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

+ (void)setUserDefaultValue:(id)value withKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:value forKey:key];
    [userDefault synchronize];
}

+ (CGPoint)getRectCenter:(CGRect)rc {
	CGPoint p;
	p.x = rc.origin.x + CGRectGetWidth(rc)/2;
	p.y = rc.origin.y + CGRectGetHeight(rc)/2;
	return p;
}

+ (CATransition *)getFadeTransition {
	CATransition *transition = [CATransition animation];
	transition.duration       = 1.0f;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type           = kCATransitionFade;
	return transition;
}

+ (void)startAni:(UIView *)view scale:(float)s {
	CGFloat f_max                    = MAX(view.frame.size.width, view.frame.size.height);
	CGFloat f_min                    = MIN(view.frame.size.width, view.frame.size.height);
	BOOL width_larger_than_height = view.frame.size.width > view.frame.size.height;
	
	CGFloat s_for_small = s;
	CGFloat s_for_large = 1.0 + (s - 1.0) * f_min / f_max;
	
	CGFloat s_for_width  = width_larger_than_height ? s_for_large : s_for_small;
	CGFloat s_for_height = width_larger_than_height ? s_for_small : s_for_large;
	[UIView animateWithDuration:0.15 animations: ^{
	         [view setTransform:CGAffineTransformMakeScale(s_for_width, s_for_height)];
	 }];
}

+ (void)endAni:(UIView *)view {
	//[UIView animateWithDuration:0.3 animations: ^{
	//   [view setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	//}];
	[UIView animateWithDuration:0.15 delay:0.15 options:UIViewAnimationOptionCurveLinear animations:^{[view setTransform:CGAffineTransformMakeScale(1.0, 1.0)]; } completion:nil];
}

+ (BOOL)imagePngSave:(UIImage *)img path:(NSString *)path {
	BOOL suc = NO;
	if (img != nil && img.size.width > 0 && img.size.height > 0) {
		NSData *imageData = UIImagePNGRepresentation(img);//slow
		if (imageData&&imageData.length!=0) {
			suc = [imageData writeToFile:path atomically:YES];
		}
	}
	return suc;
}

+ (UIImage *)imageLoadWithPath:(NSString *)path {
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	if (img != nil && img.size.width > 0 && img.size.height > 0) {
		return img;
	}
	else {
		return nil;
	}
}

+ (NSData *)dataFromHexString:(NSString *)str {
	return [str hexStringToData];
}

+ (NSString *)formatFloat:(NSNumber *)money {
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
	NSString *numberAsString = [numberFormatter stringFromNumber:money];
	return [NSString stringWithFormat:@"%@", numberAsString];
}

//+ (NSString *)formatRMBUnitedWithString:(NSString *)string {
//    return [NSString stringWithFormat:@"￥%@", [Util formatRMBWithString:string]];
//}
//+ (NSString *)formatRMBWithString:(NSString *)string {
//    NSDecimalNumber *money = [NSDecimalNumber decimalNumberWithString:string];
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
//    NSString *numberAsString = [numberFormatter stringFromNumber:money];
//    return [NSString stringWithFormat:@"%@", numberAsString];
//}

+ (NSString *)formatRMB:(NSNumber *)money {
	return [NSString stringWithFormat:@"%@元", [Util formatRMBWithoutUnit:money]];
}

+ (NSString *)formatRMBPureZero:(NSNumber *)money {
//    return [NSString stringWithFormat:@"%@元", [Util formatRMBPureZeroWithoutUnit:money]];
    return [NSString stringWithFormat:@"%@元", [Util formatRMBPureZeroWithoutUnit:money]];
}


+ (NSString *)UndoRMB:(NSString *)money {
    
    NSString *str = [[money stringByReplacingOccurrencesOfString:@"元" withString:@""]stringByReplacingOccurrencesOfString:@"," withString:@""];
    return str;
}

+ (NSString *)formatRMBOnlyString:(NSNumber *)money {
    if ([money doubleValue] > -0.0001 && [money doubleValue] < 0.0001) {
        return @"0.00";
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    double part = 0;
    double precise = modf([money doubleValue], &part);
    if (precise > 0) {
        [numberFormatter setPositiveFormat:@"###0.00"];
    }else{
        [numberFormatter setPositiveFormat:@"###0.##"];
    }
    NSString *numberAsString = [numberFormatter stringFromNumber:money];
    
    return [NSString stringWithFormat:@"%@", numberAsString];
}

+ (NSString *)formatRMBWithoutUnit:(NSNumber *)money {
    if ([money doubleValue] > -0.0001 && [money doubleValue] < 0.0001) {
        return @"0.00";
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    double part = 0;
    double precise = modf([money doubleValue], &part);
    if (precise > 0) {
        [numberFormatter setPositiveFormat:@"#,##0.00"];
    }else{
        [numberFormatter setPositiveFormat:@"#,##0.##"];
    }
    NSString *numberAsString = [numberFormatter stringFromNumber:money];
    
    return [NSString stringWithFormat:@"%@", numberAsString];
}

+ (NSString *)formatRMBPureZeroWithoutUnit:(NSNumber *)money {
    if ([money doubleValue] > -0.0001 && [money doubleValue] < 0.0001) {
        return @"0";
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    double part = 0;
    double precise = modf([money doubleValue], &part);
    if (precise > 0) {
        [numberFormatter setPositiveFormat:@"#,##0.00"];
    }else{
        [numberFormatter setPositiveFormat:@"#,##0.##"];
    }
    NSString *numberAsString = [numberFormatter stringFromNumber:money];
    
    return [NSString stringWithFormat:@"%@", numberAsString];
}


+ (NSString *)formatPositiveMoney:(NSNumber *)money positive:(BOOL)positive {
	NSString *poStr = positive ? @"+" : @"-";
	return [NSString stringWithFormat:@"%@%@", poStr, [self formatRMB:money]];
}

+ (NSMutableAttributedString *)getAttributedString:(NSString *)str font:(UIFont *)font color:(UIColor *)color {
    
    if(!str) {
        return nil;
    }
    
	NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:str];
	NSInteger len      =[str length];
	
	[attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, len)];
	[attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, len)];
	return attString;
}

+ (void)setAttributedString:(NSMutableAttributedString *)str font:(UIFont *)font color:(UIColor *)color range:(NSRange)range {
	if (font != nil) {
		[str addAttribute:NSFontAttributeName value:font range:range];
	}
	if (color != nil) {
		[str addAttribute:NSForegroundColorAttributeName value:color range:range];
	}
}

+ (void)setAttributedString:(NSMutableAttributedString *)str font:(UIFont *)font color:(UIColor *)color substr:(NSString *)substr allstr:(NSString *)allstr {
	NSRange range = [allstr rangeOfString:substr];
	return [self setAttributedString:str font:font color:color range:range];
}

+ (void)setUILabelLargeBlue:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemLarge];
		l.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
	}
}
+ (void)setUILabelLargeRed:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemLarge];
		l.textColor = ZCOLOR(COLOR_BUTTON_RED);
	}
}
+ (void)setUILabelLargeGray:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemLarge];
		l.textColor = ZCOLOR(COLOR_TEXT_GRAY);
	}
}

+ (void)setUILabelLargeGreen:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemLarge];
		l.textColor = [DefColor bgGreenColor];
	}
}

+ (void)setUILabelLargeBlack:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemLarge];
		l.textColor = ZCOLOR(COLOR_TEXT_BLACK);
	}
}

+ (void)setUILabelSmallBlue:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemSmall];
		l.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
	}
}
+ (void)setUILabelSmallRed:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemSmall];
		l.textColor = ZCOLOR(COLOR_BUTTON_RED);
	}
}
+ (void)setUILabelSmallBlack:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemSmall];
		l.textColor = ZCOLOR(COLOR_TEXT_BLACK);
	}
}
+ (void)setUIViewArrayHidden:(NSArray *)arr hidden:(BOOL)hidden {
	for (UIView *v in arr) {
		[v setHidden:hidden];
	}
}
+ (void)setUILabelSmallGray:(NSArray *)arr {
	for (UILabel *l in arr) {
		l.font      =[UtilFont systemSmall];
		l.textColor = ZCOLOR(COLOR_TEXT_GRAY);
	}
}

+ (CGFloat)getCornerRadiusLarge {
	return [ZAPP.zdevice getDesignScale:5];
}
+ (CGFloat)getCornerRadiusSmall {
	return [ZAPP.zdevice getDesignScale:3];
}

+ (void)saveDictToFileWithBase64:(NSDictionary *)dict file:(NSString *)file key:(int)key {
	if (dict != nil) {
		[[Base64EncoderDecoder customEncodeToData:[dict dataSerialized] keyNegativeAndPlus:key] writeToFile:file atomically:YES];
	}
}

+ (NSMutableDictionary *)readDictFromFileWithBase64:(NSString *)file key:(int)key {
	NSMutableDictionary *dict = nil;
	if ([UtilFile fileExists:file]) {
		NSData *data = [[NSData alloc] initWithContentsOfFile:file];
		if (data.length > 0) {
            
            data = [Base64EncoderDecoder customDecode:data keyMinusAndNegative:key];
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            return [dictionary mutableCopy];
            
			//return [ dictionarySerialized];
		}
	}
	return dict;
}

+ (int)totalCount:(NSDictionary *)dict {
	return [[dict objectForKey:NET_KEY_TOTALCOUNT] intValue];
}

+ (int)pageCount:(NSDictionary *)dict {
	return [[dict objectForKey:NET_KEY_PAGECOUNT] intValue];
	
}

+ (int)curPage:(NSDictionary *)dict {
	return [[dict objectForKey:NET_KEY_CURPAGE] intValue];
}

+ (NSString *)percentInt:(int)v {
	return [NSString stringWithFormat:@"%d%%", v];
}

+ (NSString *)percentFloat:(CGFloat)v {
	return [NSString stringWithFormat:@"%.1f%%", v];
}
+ (NSString *)percentProgress:(CGFloat)v {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numberFormatter setPositiveFormat:@"#,##0.##"];
    NSString *numberAsString = [numberFormatter stringFromNumber:@(v)];
    return [NSString stringWithFormat:@"%@%%", numberAsString];
}

+ (NSString *)intWithUnit:(int)v unit:(NSString *)unit {
	return [NSString stringWithFormat:@"%d%@", v, unit];
}

#pragma mark - pull to refresh
+ (void)setScrollHeader:(UIScrollView *)scroll target:(id)target header:(SEL)sel dateKey:(NSString *)datekey{
//	[scroll addLegendHeaderWithRefreshingTarget:target refreshingAction:sel dateKey:datekey];
    [scroll addCNFreshWithRefreshingTarget:target refreshingAction:sel dateKey:datekey];
}

+ (void)setScrollFooter:(UIScrollView *)scroll target:(id)target footer:(SEL)sel {
	[scroll addLegendFooterWithRefreshingTarget:target refreshingAction:sel];
}

+ (NSString *)shortDateFromFullFormat:(NSString *)fulldate {
	if (fulldate.length > 10) {
		//[UtilLog format:@"[%@]",[fulldate substringToIndex:10]];
		return [fulldate substringToIndex:10];
	}
	else {
		return fulldate;
	}
}
+ (NSString *)shortDateUntilMin:(NSString *)dateString {
    if (dateString.length >= 16) {
        return [dateString substringToIndex:16];
    }
    else {
        return dateString;
    }
}
+ (NSString *)spaceWithString:(NSString *)str {
	if ([str notEmpty]) {
		return [NSString stringWithFormat:@"  %@", str];
	}
	else {
		return @"";
	}
}
+ (BOOL)isBlocked:(int)blockType {
	return blockType == 3;
}

+ (NSString *)removeNonNum:(NSString *)m hasdot:(BOOL)hasdot {
	NSString *allstr = hasdot ? @".0123456789" : @"0123456789";
	NSMutableString *x = [NSMutableString string];
	m = [m trimmed];
	for (int i = 0; i < m.length; i++) {
		NSString *z = [m substringWithRange:NSMakeRange(i, 1)];
		if ([allstr mycontainsString:z]) {
			[x appendString:z];
		}
	}
	return x;
}

+ (NSString *)cutMoney:(NSString *)m {
	m = [self removeNonNum:m hasdot:YES];
	NSString *dot = @".";
	if ([m notEmpty]) {
		//m = [NSString stringWithFormat:@"%f", [m doubleValue]];
		if ([m mycontainsString:dot]) {
			NSRange r = [m rangeOfString:dot];
			NSString *x = [m substringToIndex:r.location + 1];
			if (x.length == 1) {
				x = @"0.";
			}
			while ([x hasPrefix:@"0"] && x.length > 2) {
				x = [x substringFromIndex:1];
			}
			NSString *s = [m substringFromIndex:r.location + 1];
			if (s== nil || s.length == 0) {
				return x;
			}
			if ([s mycontainsString:dot]) {
				s = [s substringToIndex:[s rangeOfString:dot].location];
			}
			if (s.length > 2) {
				s = [s substringToIndex:2];
			}
			NSString *y = [NSString stringWithFormat:@"%@%@", x, s];
			
			return y;
		}
		else {
			NSString *x = m;
			while ([x hasPrefix:@"0"] && x.length > 1) {
				x = [x substringFromIndex:1];
			}
			return x;
		}
	}
	else {
		return @"";
	}
}
+ (NSString *)cutInteger:(NSString *)m {
	m = [self removeNonNum:m hasdot:NO];
	NSString *dot = @".";
	if ([m notEmpty]) {
		while ([m hasPrefix:@"0"]) {
			m = [m substringFromIndex:1];
		}
		if ([m mycontainsString:dot]) {
			NSRange r = [m rangeOfString:dot];
			NSString *x = [m substringToIndex:r.location];
			
			return x;
		}
		else {
			return m;
		}
	}
	else {
		return @"";
	}
}
//+ (NSString *)cutTitle:(NSString *)m {
//	if ([m notEmpty]) {
//		NSString *x = [m trimmed];
//		if (x.length > 15) {
//			x = [x substringToIndex:15];
//		}
//		return x;
//	}
//	else {
//		return @"";
//	}
//}

+(BOOL)isValidateMobile:(NSString *)mobile
{
    if ([mobile notEmpty]) {
        return YES;
    }
    else {
        return NO;
    }
    //	//手机号以13， 15，18开头，八个 \d 数字字符
    //	NSString *   phoneRegex = @"^(1)\\d{10}$";
    //	NSPredicate *phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //	//    NSLog(@"phoneTest is %@",phoneTest);
    //	return [phoneTest evaluateWithObject:mobile];
}

+(BOOL)isValidCode:(NSString *)code
{
	if (code == nil || code.length == 0) {
		return NO;
	}
	
	if ([code notEmpty]) {
	
	}
	else {
		return NO;
	}
    
    return YES;
}

+(BOOL)isValidIdCard:(NSString *)card
{
	if (card == nil || card.length == 0) {
		return NO;
	}
	if ([card notEmpty]) {
	
	}
	else {
		return NO;
	}
	return YES;
}

+(BOOL)isValidEmail:(NSString *)card
{
	if ([card notEmpty]) {
	
	}
	else {
		return NO;
	}
	
	NSString *   emailRegex = @"^(\\w)+[A-Z0-9a-z._%+-]+@(\\w)+((\\.\\w+)+)$";//@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:card];
}

+ (void)navPopTheTopN:(int)n nav:(UINavigationController *)nav {
	if (nav != nil && ([[nav viewControllers] count] > n)) {
		[nav popToViewController:[[nav viewControllers] objectAtIndex:[[nav viewControllers] count] - n - 1] animated:YES];
	}
}

+ (NSString *)getLoantype:(int)loantype {
	//return (loantype == 0 ? @"[公开借款]" : @"[好友借款]");
    return @"";
}

+ (BOOL)isPublicLoan:(int)loantype {
	return loantype == 0;
}
+ (NSString *)getUserMaskNameOrNickName:(NSDictionary *)dict {
    NSString *firstName = [Util getUserFirstNameOrNickName:dict];
    NSString *realName = [Util getUserRealNameOrNickName:dict];
    for (int i = 1; i < realName.length; i++) {
        firstName = [firstName stringByAppendingString:@"*"];
    }
    return firstName;
}
+ (NSString *)getUserFirstNameOrNickName:(NSDictionary *)dict {
    NSString *realName = [Util getUserRealNameOrNickName:dict];
    if (realName.length > 0) {
        NSString *firstName = [realName substringToIndex:1];
        return  firstName;
    }
    return @"";
}
+ (NSString *)getUserRealNameOrNickName:(NSDictionary *)dict {
	if (dict != nil) {
		NSString *real = [dict objectForKey:NET_KEY_USERREALNAME];
		NSString *nick = [dict objectForKey:NET_KEY_NICKNAME];
		if (!ISNSNULL(real) && [real notEmpty]) {
			return real;
		}
		else if (!ISNSNULL(nick) && [nick notEmpty]) {
			return nick;
		}
	}
	return @"";
}

+ (NSString *)getNickNameUserOrRealName:(NSDictionary *)dict {
    if (dict != nil) {
        NSString *nick = [dict objectForKey:NET_KEY_NICKNAME];
        NSString *real = [dict objectForKey:NET_KEY_USERREALNAME];
        if (!ISNSNULL(nick) && [nick notEmpty]) {
            return nick;
        }
        else if (!ISNSNULL(real) && [real notEmpty]) {
            return real;
        }
    }
    return @"";
}


+ (BOOL)loanIsPublic:(NSDictionary *)dict {
	int v = [[dict objectForKey:NET_KEY_LOANTYPE] intValue];
	return v == 0;
}

+ (BOOL)loanIsHaoyou:(NSDictionary *)dict {
	int v = [[dict objectForKey:@"loanuseriscredittome"] intValue];
	return v != 0;
}

+ (BOOL)loanIsWeiYue:(NSDictionary *)dict {
	int v = [[dict objectForKey:@"isoverdue"] intValue];
	return v != 0;
}

+ (BOOL)loanIsMine:(NSDictionary *)dict {
	int v = [[dict objectForKey:@"userid"] intValue];
	return v == [ZAPP.myuser getUserIDInt];
}

+ (BOOL)loanShouldHideNameWithPublic:(BOOL)isPublic weiyue:(BOOL)isWeiyue mine:(BOOL)isMine {
    
    ////////    modify by cc :  修改显示借款人
    if (isWeiyue) {
        return NO;
    }else{
        return YES;
    }
    /*
	if (isMine || isWeiyue) {
		return NO;
	}
	else {
		if (isPublic) {
			return YES;
		}
		else {
			return NO;
		}
	}
     */
}

+ (BOOL)loanShouldHideNameWithDict:(NSDictionary *)dict {
	BOOL isPublic = [self loanIsPublic:dict];
	//BOOL isHaoyou = [self loanIsHaoyou:dict];
	BOOL isMine = [self loanIsMine:dict];
	BOOL isWeiyue = [self loanIsWeiYue:dict];
	return [self loanShouldHideNameWithPublic:isPublic weiyue:isWeiyue mine:isMine];
}

+ (BOOL)isMyUserID:(NSString *)userid {
	if ([userid intValue] == [ZAPP.myuser getUserIDInt]) {
		return YES;
	}
	return NO;
}

+ (NSString *)addSpaceToName:(NSString *)name {
	if ([name notEmpty]) {
		return [NSString stringWithFormat:@" %@ ", [name trimmed]];
	}
	return @"  ";
}

+ (UIImage *)imagePlaceholderAttachment {
	return [UIImage imageNamed:@"fujian_placeholder.png"];
}

+ (UIImage *)imagePlaceholderPortrait {
	return [UIImage imageNamed:@"portrait_place.png"];
}

+ (NSString *)getStringInvestWithNoMoney {
	return @"您当前余额不足，请先充值";
}

+ (NSMutableAttributedString *)getRemainDaysString:(NSDictionary *)dict {
	CGFloat day =[[ dict objectForKey:NET_KEY_LOANREMAINDAYCOUNT] doubleValue];
	if (day < 1) {
		NSMutableAttributedString *s = [self getAttributedString:@"不足1" font:[UtilFont systemLarge] color:ZCOLOR(COLOR_TEXT_BLACK)];
		[self setAttributedString:s font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:[@"不足1" rangeOfString:@"1"]];
		return s;
	}
	else {
		int d = (int)day;
		return [self getAttributedString:[NSString stringWithFormat:@"%d", d] font:[UtilFont systemLarge] color:ZCOLOR(COLOR_BUTTON_RED)];
	}
}

+ (NSMutableAttributedString *)getDetailRemainDaysString:(NSDictionary *)dict {
	CGFloat day =[[ dict objectForKey:NET_KEY_LOANREMAINDAYCOUNT] doubleValue];
	if (day < 1) {
		NSMutableAttributedString *s = [self getAttributedString:@"不足1" font:[UtilFont systemSmall] color:ZCOLOR(COLOR_TEXT_GRAY)];
		[self setAttributedString:s font:nil color:ZCOLOR(COLOR_BUTTON_RED) range:[@"不足1" rangeOfString:@"1"]];
		return s;
	}
	else {
		int d = (int)day;
		return [self getAttributedString:[NSString stringWithFormat:@"%d", d] font:[UtilFont systemSmall] color:ZCOLOR(COLOR_BUTTON_RED)];
	}
}

+ (BOOL)canRepay:(NSDictionary *)dict {
	int debtstartrepay = [[dict objectForKey:NET_KEY_debtstartrepay] intValue];
	return debtstartrepay > 0;
}

+ (BOOL)hasFailDebt:(NSDictionary *)dict {
	int x = [[dict objectForKey:NET_KEY_failuredrepaymentid] intValue];
	return x > 0;
}

+ (NSNumber *)formatMoneyNumber:(NSString *)str {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setMaximumFractionDigits:2];
	if ([str notEmpty]) {
		return [formatter numberFromString:str];
	}
	return [formatter numberFromString:@"0"];
}

+ (NSNumber *)formatRateNumber:(NSString *)str {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setMaximumFractionDigits:1];
	if ([str notEmpty]) {
		return [formatter numberFromString:str];
	}
	return [formatter numberFromString:@"0"];
}

+(void) checkFrameWidth:(CGRect)rc tag:(NSString *)tag {
	[UtilLog rect:rc tag:tag];
	if (CGRectGetWidth(rc) < 320) {
		NSLog(@"*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n*\n");
	}
}

+ (NSString *)getDateKey:(id)obj {
    NSString *cn = NSStringFromClass([obj class]);
    return [NSString stringWithFormat:@"date_key_%@", cn];
}


+ (NSString*)stringByDateMD:(NSDate*)date
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    return [formater stringFromDate:date];
}



+ (NSDate*)dateMDByString:(NSString*)string
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    return [formater dateFromString:string];
}

+ (NSString*)dateToMinute:(NSString*)string
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formater dateFromString:string];
    
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formater stringFromDate:date];
}



+ (id)emptyStringResolve:(id)text{
    
    if (text && ![text isEqual:[NSNull null]] && [text isKindOfClass:[NSString class]] &&[text length]
        ) {
        return text;
    }
    
    return @"";
}


+ (id)emptyObjResolve:(id)obj{
    
    if (obj && ![obj isEqual:[NSNull null]]) {
        return obj;
    }
    
    return nil;
}

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *)appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

@end
