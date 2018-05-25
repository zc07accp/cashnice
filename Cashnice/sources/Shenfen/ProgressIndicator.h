//
//  ProgressIndicator.h
//  YQS
//
//  Created by l on 8/31/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@interface ProgressIndicator : CustomViewController

/**
 *  设定进度条位置与标题
 *
 *  @param sel 0 based index
 */
- (void)setCurrentPage:(int)curPage strings:(NSArray *)strs;
@end
