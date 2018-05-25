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

@protocol ScoreJSHandleExport <NSObject, JSExport, WKScriptMessageHandler>

@optional

- (void)scoreJSHandleInvest;

- (void)scoreJSHandleLoan;

- (void)scoreJSHandleRecharge;

- (void)scoreJSHandleBank;

- (void)scoreJSHandleEmail;

- (void)scoreJSHandleLicense;

@end

@interface ScoreJSHandle : NSObject <ScoreJSHandleExport>

//@property (nonatomic, weak) UIViewController *targetViewController;

@property (nonatomic, weak) id<ScoreJSHandleExport> chainedHandle;


@end
