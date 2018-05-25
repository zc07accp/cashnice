//
//  UtilProvince.h
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilProvince : NSObject


- (id)init;

- (NSInteger)getProvinceCount;
- (NSString *)getProvinceName:(NSInteger)provinceIndex;
- (NSInteger)getCityCount:(NSInteger)provinceIndex;
- (NSString *)getCityName:(NSInteger)provinceIndex cityindex:(NSInteger)cityIndex;
@end
