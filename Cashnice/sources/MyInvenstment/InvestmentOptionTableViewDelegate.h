//
//  OptionTableViewDelegate.h
//  YQS
//
//  Created by a on 16/5/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OptionTableViewTarget <NSObject>

@required
- (void)optionTableViewDidSelectedIndex:(NSInteger)index title:(NSString *)title image:(UIImage *)image isInited:(BOOL)inited;

@end

@interface InvestmentOptionTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<OptionTableViewTarget> delegate;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) NSArray *options;

- (NSUInteger)orderForRow:(NSUInteger)row ;

@end
