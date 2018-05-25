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

@protocol HandleCompletetExport <NSObject, JSExport, WKScriptMessageHandler>

@optional
- (void)complete;

- (void)cancel;

- (void)shareWithObject:(id)object;

@end

@interface HandleComplete : NSObject <HandleCompletetExport>

@property (nonatomic, weak) UIViewController *targetViewController;

@property (nonatomic, weak) id<HandleCompletetExport> chainedHandle;

- (void)complete;

@end
