//
//  InvestActionView.h
//  Cashnice
//
//  Created by a on 16/2/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvestActionDelegate <NSObject>

- (void)investAction;

@end

@interface InvestActionView : UIView

@property (nonatomic, weak) id<InvestActionDelegate> delegate;

@property (assign,nonatomic) NSInteger isBet;

@end
