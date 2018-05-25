//
//  IOUDetail2ViewController.h
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetailViewController.h"

@interface IOUDetail2ViewController : IOUDetailViewController


/**
 *  别人创建的
 *
 *  0 收到 出借人   1收到 借款人
 //4 被驳回，没有驳回原因，不显示驳回原因（内部控制）

 */

@property(nonatomic) NSInteger type;

@end
