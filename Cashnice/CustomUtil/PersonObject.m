//
//  PersonObject.m
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "PersonObject.h"

@implementation PersonObject

-(id)init{
    self = [super init];
    
    self.userrealname = @"";
    self.nickname = @"";
    self.phone = @"";
    
    return self;
}


-(NSString *)nameShowed{
    
    if ([self.userrealname length]) {
        return self.userrealname;
    }else{
        return
        [self.nickname length]? self.nickname:@"";
    }

}


@end
