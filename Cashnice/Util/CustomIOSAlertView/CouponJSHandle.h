//
//  HandleComplete.h
//  Cashnice
//
//  Created by a on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@protocol CouponJSHandleExport <NSObject, JSExport, WKScriptMessageHandler>

@optional

- (void)couponJSHandleClose;

//////

- (void)couponJSHandleGoWeb:(NSString *)url title:(NSString *)title;

- (void)couponJSHandleGoWeb:(id)object;

- (void)couponJSHandleGoNative:(id)object;

- (void)couponJSHandleGiftSuc;

- (void)shareWithObject:(id)object;

- (void)continueInvest;


- (void)continueInvest;


@end

@interface CouponJSHandle : NSObject <CouponJSHandleExport>

//@property (nonatomic, weak) UIViewController *targetViewController;

@property (nonatomic, weak) id<CouponJSHandleExport> chainedHandle;


@end
