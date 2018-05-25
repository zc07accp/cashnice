//
//  UtilProvince.m
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UtilProvince.h"

@interface UtilProvince ()

@property (strong, nonatomic) NSArray *provinceArray;
@end

@implementation UtilProvince


- (id)init {
    self = [super init];
    if (self != nil) {
        [self load];
    }
    return self;
}

- (void)load {
   	//load language files
    self.provinceArray = [NSArray arrayWithContentsOfFile:[UtilFile resFile:@"province" type:@"plist"]];
}

- (NSInteger)getProvinceCount {
    return [[self.provinceArray objectAtIndex:0] count];
}
- (NSString *)getProvinceName:(NSInteger)provinceIndex {
    return [[self.provinceArray objectAtIndex:0] objectAtIndex:provinceIndex];
}
- (NSInteger)getCityCount:(NSInteger)provinceIndex {
    return [[self.provinceArray objectAtIndex:provinceIndex + 1] count];
}
- (NSString *)getCityName:(NSInteger)provinceIndex cityindex:(NSInteger)cityIndex {
    return [[self.provinceArray objectAtIndex:provinceIndex + 1] objectAtIndex:cityIndex];
}
@end
