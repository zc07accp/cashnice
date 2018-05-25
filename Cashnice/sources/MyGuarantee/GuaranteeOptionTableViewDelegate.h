//
//  GuaranteeOptionTableViewDelegate.h
//  YQS
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GuaranteeOptionTableViewTarget <NSObject>

- (void)guaranteeOptionTableViewDidSelectedIndex:(NSInteger)index title:(NSString *)title image:(UIImage *)image isInited:(BOOL)inited;

@end
@interface GuaranteeOptionTableViewDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id<GuaranteeOptionTableViewTarget> delegate;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end
