//
//  CNConstantConstraint.m
//  Cashnice
//
//  Created by a on 16/6/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNConstantConstraint.h"

@implementation CNConstantConstraint


- (CGFloat)constant{
    return [ZAPP.zdevice getDesignScale:[super constant]];
}
@end
