//
//  NSMutableArray+Replace.h
//  YQS
//
//  Created by a on 15/12/23.
//  Copyright © 2015年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NSMutableArray_Replace)

//默认一页25
- (void)insertPage:(NSInteger)page objects:(NSArray *)objects;
- (void)insertPage:(NSInteger)page offset:(NSInteger)offset objects:(NSArray *)objects;


- (void) addOrReplaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray;

- (void)insertPage:(NSInteger)page pageSize:(NSInteger)pageSize objects:(NSArray *)objects;

@end
