//
//  JiekuanInfoViewController.h
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"


@interface JiekuanInfoViewController : CustomViewController

- (void)setJiekuanState:(LoanState)state blacklist:(BOOL)hasBlackList;
- (void)setTheDataDict:(NSDictionary *)dict;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *choukuanqi;
@property (assign, nonatomic) BOOL hideNameAlways;//deprecated
@end
