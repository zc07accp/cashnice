//
//  CustomIOSAlertView.h
//  CustomIOSAlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013-2015 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CouponJSHandle.h"

@protocol CustomActivityViewDelegate  <NSObject>
- (void)activityViewDidClose:(id)view;

- (void)couponJSHandleGoWeb:(id)object;
- (void)activityView:(id)view willGoWeb:(NSString *)webUrl title:(NSString *)title;
- (void)activityView:(id)view willGoNative:(NSInteger)native;


@end

@interface CustomActivityView : UIView<CustomActivityViewDelegate>

@property (nonatomic, assign) id <CustomActivityViewDelegate> delegate;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) CouponJSHandle *jsHandle;


@property (copy) void (^onButtonTouchUpInside)(CustomActivityView *view, int buttonIndex) ;

- (id)init;
- (void)addViewWithWebData:(NSData *)webData;
- (void)addViewWithWebUrl:(NSString *)url;

- (void)show;
- (void)close;

- (void)dealloc;

@end
