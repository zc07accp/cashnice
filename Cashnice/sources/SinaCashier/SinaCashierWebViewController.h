//
//  SinaCashierWebViewController.h
//  Cashnice
//
//  Created by a on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "HandleComplete.h"

@interface SinaCashierWebViewController : CustomViewController

@property (nonatomic, strong) NSString  *URLPath;
@property (nonatomic, strong) NSData    *loadData;
@property (nonatomic, strong) NSString  *titleString;

@property (nonatomic, weak) id<HandleCompletetExport> completeHandle;

@property (copy, nonatomic) void (^navigationBackHandler)();

@end
