//
//  CNWarningView.h
//  Cashnice
//
//  Created by a on 16/11/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CNServiceWarningViewTypeNetwork,
    CNServiceWarningViewTypeLoanReject,
} CNServiceWarningViewType;


@protocol CNWarningViewDelegate <NSObject>

- (void)warningViewAction;

@end

@interface CNWarningView : UIView

@property (strong, nonatomic) NSString *externelTitle;
@property (weak, nonatomic) id<CNWarningViewDelegate> delegate;

- (instancetype)initWithType:(CNServiceWarningViewType)type;
- (instancetype)initWithFrame:(CGRect)frame andType:(CNServiceWarningViewType)type;

@end
