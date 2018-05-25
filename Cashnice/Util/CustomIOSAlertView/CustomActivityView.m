//
//  CustomIOSAlertView.m
//  CustomIOSAlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013-2015 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import "CustomActivityView.h"
#import <QuartzCore/QuartzCore.h>
#import <WebKit/WebKit.h>
#import "CouponJSHandle.h"

@interface CustomActivityView () <CAAnimationDelegate,WKNavigationDelegate,WKScriptMessageHandler, CouponJSHandleExport> {
    
    int animationDidStopIndex;
}

@property (nonatomic, strong) UIWindow *overlayWindow;

@property (nonatomic, strong) NSMutableArray *webViewArray;

@property (nonatomic) BOOL isShown;


@end


@implementation CustomActivityView

@synthesize delegate;

static NSMutableArray *dispaliedAlertView ;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        //self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        delegate = self;
        
        //[self createContainerView];
        
        //dialogView = [self createContainerView];
        
        _webViewArray = @[].mutableCopy;

    }
    return self;
}

- (id)initWithWebData:(NSData *)webData {
    if (self = [super init]) {
        //[self createViewWithWebData:webData];
        //[self setButtonTitles:titleArray];
        //[self setDelegate:closeDelegate];
    }
    return self;
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    UIView *v = [self.webViewArray lastObject];
    if (v) {
        
        
        CATransform3D currentTransform = v.layer.transform;
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            CGFloat startRotation = [[v valueForKeyPath:@"layer.transform.rotation.z"] doubleValue];
            CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
            
            v.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
        }
        
        v.layer.opacity = 1.0f;
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                             v.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                             v.layer.opacity = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [v removeFromSuperview];
                             [self.webViewArray removeLastObject];
                             
                             [self.delegate activityViewDidClose:self];
                             
                             if (self.webViewArray.count < 1) {
                                 [self closeWindow];
                             }
                         }
         ];
        

    }else{
        [self closeWindow];
    }
}

- (void)closeWindow{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    [self removeFromSuperview];
    
    // Make sure to remove the overlay window from the list of windows
    // before trying to find the key window in that same list
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
    [windows removeObject:_overlayWindow];
    _overlayWindow = nil;
    
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
        if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
            [window makeKeyWindow];
            *stop = YES;
        }
    }];
}

- (void)closeWithoutAnimation
{
    [self removeFromSuperview];
}


- (UIWindow *)overlayWindow {
    if(! _overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.tag = 10111;
    }
    return _overlayWindow;
}

- (UIColor *)separatorLineColor{
    return [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
}

- (void)addViewWithWebData:(NSData *)webData{
    WKWebView *web1 = [self createWebView];
    
    [web1 loadData:webData MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"https://newm.cashnice.com/"]];
    
    
    [self.webViewArray addObject:web1];
    
    //[self setContainerView:web1];
    
    
    web1.layer.shouldRasterize = YES;
    web1.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self.overlayWindow addSubview:self];
    
}

- (void)addViewWithWebUrl:(NSString *)url{
    WKWebView *web1 = [self createWebView];
    
    [web1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
    [self.webViewArray addObject:web1];
    
    //[self setContainerView:web1];
    
    
    web1.layer.shouldRasterize = YES;
    web1.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [self.overlayWindow addSubview:self];
}

- (void)show{
    
    //////    不可重入     //////
    if (! dispaliedAlertView) {
        dispaliedAlertView = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < dispaliedAlertView.count; i++) {
        CustomActivityView *v = dispaliedAlertView[i];
        [v close];
        v = nil;
    }
    [dispaliedAlertView addObject:self];
    /////
    
    [self.overlayWindow makeKeyAndVisible];
    
    [self animateWebViewWithIndex:animationDidStopIndex];
    
}


- (void)animateWebViewWithIndex:(NSInteger)index{
    
    UIView *v = self.webViewArray[index];
    
    if (v) {
        [self addSubview:v];
        
        
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.3;
        animation.removedOnCompletion = NO;
        
        animation.fillMode = kCAFillModeForwards;
        
        animation.delegate = self;
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        animation.values = values;
        animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
        
        [v.layer addAnimation:animation forKey:nil];
        
        /*
        UIButton *cls = [[UIButton alloc] initWithFrame:CGRectMake(80, 100, 100, 50)];
        cls.backgroundColor = [UIColor redColor];
        [cls addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
        [v addSubview:cls];
        */
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.webViewArray.count > ++animationDidStopIndex) {
        [self animateWebViewWithIndex:animationDidStopIndex];
    }
}

- (WKWebView *)createWebView{
    //if (! _webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    
        CouponJSHandle *handle = [CouponJSHandle new] ;
        handle.chainedHandle = self;
        /*
        if (! _jsHandle) {
            //handle.targetViewController = self;
            //self.completeHandle = handle;
        }else{
            handle.chainedHandle = self.jsHandle;
        }
         */
    [config.userContentController addScriptMessageHandler:handle name:@"closePopUp"];
    [config.userContentController addScriptMessageHandler:handle name:@"goNative"];
    [config.userContentController addScriptMessageHandler:handle name:@"goWeb"];
    [config.userContentController addScriptMessageHandler:handle name:@"success"];
    [config.userContentController addScriptMessageHandler:handle name:@"continueInvest"];
    
    CGSize screenSize = [self countScreenSize];
    
    CGRect screenFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:screenFrame configuration:config];
    webView.navigationDelegate = self;
    webView.tintColor = [UIColor clearColor];
    webView.backgroundColor = [UIColor clearColor];
    [webView setOpaque:NO];
    
    webView.scrollView.bounces = NO;
    //}
    return webView;
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    return CGSizeMake(screenWidth, screenHeight);
}

- (void)couponJSHandleClose{
    [self close];
}


- (void)couponJSHandleGoNative:(id)object{
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *type = (NSNumber *)object;
        if ([self.delegate respondsToSelector:@selector(activityView:willGoNative:)]) {
            [self.delegate activityView:self willGoNative:[type integerValue]];
        }
    }
}

- (void)couponJSHandleGoWeb:(id)object{
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *type = (NSNumber *)object;
        if ([self.delegate respondsToSelector:@selector(activityView:willGoWeb:)]) {
            [self.delegate activityView:self willGoNative:[type integerValue]];
        }
    }
}

- (void)couponJSHandleGoWeb:(NSString *)url title:(NSString *)title{
    if(url) {
        if ([self.delegate respondsToSelector:@selector(activityView:willGoWeb:title:)]) {
            [self.delegate activityView:self willGoWeb:url title:title];
        }
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //progress_show
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    progress_hide
    [self close];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    progress_hide
    
    
    if (! self.isShown) {
        [self show];
        self.isShown = YES;
    }
    
}


@end
