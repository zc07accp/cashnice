
#import "UtilLog.h"


@implementation UtilLog

+ (void)format:(NSString *)format, ... {
    va_list params;
    va_start(params, format);
//    NSString *logstr = [[NSString alloc] initWithFormat:format arguments:params];

#ifdef TEST_ENABLE_LOG
    DDLogWarn(@"%@", logstr);
    DDLogError(@"*******************************************************");
#endif

    va_end(params);
}

+ (void)colonFormat:(NSString *)first second:(NSString *)second {
    [self format:@"%@ : %@", first, second];
}

+ (void)tagFormat:(NSString *)str tag:(NSString *)tag {
    if ([tag notEmpty]) {
        [self colonFormat:tag second:str];
    } else {
        [self format:@"%@", str];
    }
}

+ (void)rect:(CGRect)rc {
    [self rect:rc tag:nil];
}

+ (void)rect:(CGRect)rc tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"%f %f %f %f %f", CGRectGetMinX(rc), CGRectGetMinY(rc), CGRectGetWidth(rc), CGRectGetHeight(rc), CGRectGetWidth(rc) / CGRectGetHeight(rc)];
    [self tagFormat:str tag:tag];
}

+ (void)edgeInset:(UIEdgeInsets)ed {
    [self edgeInset:ed tag:nil];
}

+ (void)edgeInset:(UIEdgeInsets)ed tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"left: %f top: %f right: %f bottom: %f ", ed.left, ed.top, ed.right, ed.bottom];
    [self tagFormat:str tag:tag];
}

+ (void)size:(CGSize)sz {
    [self size:sz tag:nil];
}

+ (void)size:(CGSize)sz tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"%f %f %f", sz.width, sz.height, sz.width / sz.height];
    [self tagFormat:str tag:tag];
}

+ (void)point:(CGPoint)pt {
    [self point:pt tag:nil];
}

+ (void)point:(CGPoint)pt tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"%f %f", pt.x, pt.y];
    [self tagFormat:str tag:tag];
}

+ (void)string:(NSString *)string {
    [self string:string tag:nil];
}

+ (void)string:(NSString *)string tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"%@", string];
    [self tagFormat:str tag:tag];
}

+ (void)boolValue:(BOOL)val {
    [self boolValue:val tag:nil];
}

+ (void)boolValue:(BOOL)val tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"%@", val ? @"YES" : @"NO"];
    [self tagFormat:str tag:tag];
}

+ (void)intValue:(NSInteger)int_v {
    [self intValue:int_v tag:nil];
}

+ (void)intValue:(NSInteger)int_v tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"%d", (int)int_v];
    [self tagFormat:str tag:tag];
}

+ (void)floatValue:(CGFloat)float_v {
    [self floatValue:float_v tag:nil];
}

+ (void)floatValue:(CGFloat)float_v tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"%lf", float_v];
    [self tagFormat:str tag:tag];
}

+ (void)dict:(NSDictionary *)obj {
    [self dict:obj tag:nil];
}

+ (void)dict:(NSDictionary *)obj tag:(NSString *)tag {
    if (obj == nil) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@", obj];
    [self tagFormat:str tag:tag];
}

+ (void)array:(NSArray *)obj {
    [self array:obj tag:nil];
}

+ (void)array:(NSArray *)obj tag:(NSString *)tag {
    NSString *str = [NSString stringWithFormat:@"%@", obj];
    [self tagFormat:str tag:tag];
}

+ (void)device {
    [self format:@"__UIDevice__localizedModel : %@", [[UIDevice currentDevice] localizedModel]];
    [self format:@"__UIDevice__systemVersion  : %@", [[UIDevice currentDevice] systemVersion]];
    [self format:@"__UIDevice__name           : %@", [[UIDevice currentDevice] name]];
    [self format:@"__UIDevice__model          : %@", [[UIDevice currentDevice] model]];
    [self format:@"__UIDevice__systemName     : %@", [[UIDevice currentDevice] systemName]];
}

+ (void)simulatorLocation {
    [self format:@"__simulator__ : %@", [UtilFile libRoot]];
}

@end
