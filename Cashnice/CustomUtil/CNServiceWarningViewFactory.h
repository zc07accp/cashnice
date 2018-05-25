//
//  CNServiceWarningView.h
//  Cashnice
//
//  Created by a on 16/11/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNWarningView.h"

@interface CNServiceWarningView : CNWarningView

@end

@interface CNServiceWarningViewFactory : NSObject

+ (CNWarningView *)getViewWithFrame:(CGRect)frame andType:(CNServiceWarningViewType)type;

+ (CNWarningView *)getRejectionViewWithFrame:(CGRect)frame;

+ (CNWarningView *)getViewWithFrame:(CGRect)frame;

@end
