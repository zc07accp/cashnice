//
//  CNScaledConstraint.m
//  Cashnice
//
//  Created by a on 16/9/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNScaledConstraint.h"

@implementation CNScaledConstraint

- (CGFloat)constant{
    return [ZAPP.zdevice scaledValue:[super constant]];
}

@end
