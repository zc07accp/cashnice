//
//  DetailItemView.h
//  YQS
//
//  Created by a on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestDetailItemView : UIView

@property (nonatomic, strong)NSArray *itemsDataArray;

- (CGFloat)fitHeight;

- (void)setUpView;

@end
