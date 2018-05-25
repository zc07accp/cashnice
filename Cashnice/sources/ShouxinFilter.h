//
//  ShouxinFilter.h
//  Cashnice
//
//  Created by apple on 2016/10/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShouxinFilter : NSObject

+(NSArray *)filterShouxinList:(NSArray *)list searchText:(NSString *)text searchTextHighlighted:(BOOL)highlighted;


@end
