//
//  NSMutableArray+Replace.m
//  YQS
//
//  Created by a on 15/12/23.
//  Copyright © 2015年 l. All rights reserved.
//

#import "NSMutableArray+Replace.h"

@implementation NSMutableArray (NSMutableArray_Replace)

- (void) addOrReplaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray{
    
    if (self.count >= range.location + range.length ) {
        [self removeObjectsInRange:range];
        [self addObjectsFromArray:otherArray];
    }else{
        [self addObjectsFromArray:otherArray];
    }
    
    /*
     if (self.count > range.location + range.length - 1) {
     [self replaceObjectsInRange: range withObjectsFromArray:otherArray];
     }else{
     [self addObjectsFromArray:otherArray];
     }
     */
}

- (void)insertPage:(NSInteger)page objects:(NSArray *)objects{

    [self insertPage:page pageSize:DEFAULT_PAGE_SIZE objects:objects];
    
}

- (void)insertPage:(NSInteger)page offset:(NSInteger)offset objects:(NSArray *)objects{
    
    [self insertPage:page offset:(NSInteger)offset pageSize:DEFAULT_PAGE_SIZE objects:objects];
    
}

- (void)insertPage:(NSInteger)page pageSize:(NSInteger)pageSize objects:(NSArray *)objects{
    
//    NSRange range = NSMakeRange(page * pageSize, self.count-page * pageSize);
//    if (range.location > self.count) {
//        range.location = self.count;
//        range.length = 0;
//    }
//    if (self.count < page*pageSize) {
//        range.length = 0;
//    }
//    [self addOrReplaceObjectsInRange:range withObjectsFromArray:objects];
    
    [self insertPage:page offset:0 pageSize:pageSize objects:objects];
}

- (void)insertPage:(NSInteger)page offset:(NSInteger)offset pageSize:(NSInteger)pageSize objects:(NSArray *)objects{
    
    NSRange range = NSMakeRange(page * pageSize + offset, self.count-page * pageSize - offset);
    if (range.location > self.count) {
        range.location = self.count;
        range.length = 0;
    }
    if (self.count < page*pageSize) {
        range.length = 0;
    }
    [self addOrReplaceObjectsInRange:range withObjectsFromArray:objects];
}


@end
