//
//  JieKuanViewController.h
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
#import "askCreditAbstractViewController.h"
#import "NextB.h"
#import "QuerenShouxin.h"

@interface PersonHomePage : askCreditAbstractViewController <NextBDelegate,  UIAlertViewDelegate, QuerenShouxinDelegate>

- (void)setTheDataDict:(NSDictionary *)dict;
@end
