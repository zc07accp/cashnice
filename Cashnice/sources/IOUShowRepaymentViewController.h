//
//  IOUWaitSurePaymentViewController.h
//  Cashnice
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

/**
 *  待确认还款，线下还款的
 */

@interface IOUShowRepaymentViewController : CustomViewController

@property (strong, nonatomic) NSDictionary *dic;
@property (strong,nonnull) NSString *iou_title;

@end
