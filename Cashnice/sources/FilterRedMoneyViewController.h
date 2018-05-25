//
//  FilterRedMoneyViewController.h
//  Cashnice
//
//  Created by apple on 2017/2/13.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CustomViewController.h"

@protocol FilterRedMoneyControllerDelegate<NSObject>
-(void)filterRedMoneyDidSelected:(NSString *)fiterTitle tag:(NSInteger)tag;
-(void)filterRedMoneDidTapClose;
@end


@interface FilterRedMoneyViewController : CustomViewController

@property(weak,nonatomic) id<FilterRedMoneyControllerDelegate> delegate;

@end
