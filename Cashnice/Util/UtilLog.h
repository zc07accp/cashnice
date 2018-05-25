#import <Foundation/Foundation.h>

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelError;
#endif


@interface UtilLog : NSObject

+ (void)format:(NSString *)format, ...;

+ (void)rect:(CGRect)rc;
+ (void)rect:(CGRect)rc tag:(NSString *)tag;
+ (void)edgeInset:(UIEdgeInsets)ed;
+ (void)edgeInset:(UIEdgeInsets)ed tag:(NSString *)tag;
+ (void)size:(CGSize)sz;
+ (void)size:(CGSize)sz tag:(NSString *)tag;
+ (void)point:(CGPoint)pt;
+ (void)point:(CGPoint)pt tag:(NSString *)tag;

+ (void)string:(NSString *)string;
+ (void)string:(NSString *)string tag:(NSString *)tag;
+ (void)boolValue:(BOOL)val;
+ (void)boolValue:(BOOL)val tag:(NSString *)tag;
+ (void)intValue:(NSInteger)int_v;
+ (void)intValue:(NSInteger)int_v tag:(NSString *)tag;
+ (void)floatValue:(CGFloat)float_v;
+ (void)floatValue:(CGFloat)float_v tag:(NSString *)tag;
+ (void)dict:(NSDictionary *)obj;
+ (void)dict:(NSDictionary *)obj tag:(NSString *)tag;
+ (void)array:(NSArray *)obj;
+ (void)array:(NSArray *)obj tag:(NSString *)tag;

+ (void)device;
+ (void)simulatorLocation;

@end