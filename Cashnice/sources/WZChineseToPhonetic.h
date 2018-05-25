//
//  WZChineseToPhonetic.h
//  BlockContacts
//
//  Created by willonboy on 13-2-5.
//
//

#import <Foundation/Foundation.h>

@interface WZChineseToPhonetic : NSObject

+ (void)preInitData;

+ (NSString *)getPhonetic:(NSString *)chineseStr;


@end
