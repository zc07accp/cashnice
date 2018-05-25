//
//  CNServiceWarningView.m
//  Cashnice
//
//  Created by a on 16/11/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNServiceWarningViewFactory.h"

@implementation CNServiceWarningView

@end

@implementation CNServiceWarningViewFactory


//+ (CNWarningView *)getView{
//    static CNWarningView *sharedAccountManagerInstance = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        sharedAccountManagerInstance = [[CNWarningView alloc] initWithTitle:@"系统正在升级维护中，稍后恢复服务，请耐心等待。"];
//    });
//    return sharedAccountManagerInstance;
//}

+ (CNWarningView *)getViewWithFrame:(CGRect)frame andType:(CNServiceWarningViewType)type{
    return [[CNWarningView alloc] initWithFrame:frame andType:type];;
}

+ (CNWarningView *)getRejectionViewWithFrame:(CGRect)frame{
    return [CNServiceWarningViewFactory getViewWithFrame:frame andType:CNServiceWarningViewTypeLoanReject];
}

+ (CNWarningView *)getViewWithFrame:(CGRect)frame{
    return [CNServiceWarningViewFactory getViewWithFrame:frame andType:CNServiceWarningViewTypeNetwork];
}


@end
