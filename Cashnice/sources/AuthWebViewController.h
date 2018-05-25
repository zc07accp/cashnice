//
//  AuthWebViewController.h
//  Cashnice
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 l. All rights reserved.
//

#import "WebViewController.h"

@interface AuthWebViewController : WebViewController

@property (strong,nonatomic) void  (^AuthComplete)();

@end
