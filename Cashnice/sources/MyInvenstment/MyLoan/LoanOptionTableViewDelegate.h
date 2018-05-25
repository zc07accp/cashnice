//
//  OptionTableViewDelegate.h
//  YQS
//
//  Created by a on 16/5/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoanOptionTableViewTarget <NSObject>

- (void)LoanOptionTableViewDidSelectedIndex:(NSInteger)index title:(NSString *)title image:(UIImage *)image isInited:(BOOL)inited;

@end

@interface LoanOptionTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<LoanOptionTableViewTarget> delegate;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end
