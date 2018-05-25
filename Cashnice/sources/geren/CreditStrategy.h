//
//  CreditStrategy.h
//  YQS
//
//  Created by a on 15/9/21.
//  Copyright © 2015年 l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "askCreditAbstractViewController.h"

@interface CreditStrategy : NSObject

@property (nonatomic, weak)askCreditAbstractViewController *delegate;

- (void)setCreditButton ;
- (BOOL)isCreditRequested;
- (void)setNextButtonHide;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender ;

@end
