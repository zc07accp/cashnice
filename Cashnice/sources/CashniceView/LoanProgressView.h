//
//  LoanProgressView.h
//  Cashnice
//
//  Created by a on 16/2/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanProgressView : UIView

@property (nonatomic)CGFloat progress;
@property (nonatomic,copy)NSString * status;

@property (nonatomic) BOOL remarkable;
@property (nonatomic) BOOL bold;

@end
