//
//  askCreditAbstractViewController.h
//  YQS
//
//  Created by a on 15/9/22.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "NextB.h"

@interface askCreditAbstractViewController : CustomViewController


@property (nonatomic) ShouXinType shouXintype;
@property (nonatomic, strong) NSString *creditRelationshipUserId;
@property (nonatomic, strong) NSDictionary *creditDict;

@property (strong, nonatomic) NextB *firstButton;
@property (strong, nonatomic) NextB *secondButton;
@property (strong, nonatomic) NextB *thirdButton;



- (void)askCredit ;
- (void)creditTo;
- (void)changeCreditValue ;
- (void)abandonCredit ;

- (NSInteger)getAcquirecreditinlastdays;


@end
