//
//  IOUWSPayDetailViewController.h
//  Cashnice
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "IOUDetailViewController.h"

/**
 *  我创建的
 */

@interface IOUDetail1ViewController : IOUDetailViewController

//0 发出 出借人   1发出 出借人 被驳回
//2发出 借款人 3借款人被驳回
//4 被驳回，没有驳回原因，不显示驳回原因（内部控制）

@property(nonatomic) NSInteger type;
@end
