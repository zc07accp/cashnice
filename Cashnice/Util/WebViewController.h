//
//  WebViewController.h
//  Haen
//
//  Created by zengyuan on 16/6/15.
//  Copyright © 2016年 ZengYuan. All rights reserved.
//

#import "CustomViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController : CustomViewController

@property (strong, nonatomic) IBOutlet WKWebView *webVIew;

@property (strong, nonatomic)  WKWebViewConfiguration *webVIewConfiguration;

@property (assign, nonatomic)BOOL parameterizedTitle;

@property (nonatomic) NSString * urlStr;
@property (nonatomic) NSString * atitle;

-(void)removeNoNetwork;

-(void)initWebView;

@end
