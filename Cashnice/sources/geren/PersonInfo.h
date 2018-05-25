//
//  YQS
//
//  Created by l on 3/18/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"

/**
 *  个人信息区块（头像、名称，等等），个人主页（他人）和个人中心（自己）
 */
@interface PersonInfo: CustomViewController

- (void)setIsNotMe:(BOOL)notme;
- (void)setTheInfoDict:(NSDictionary *)dict;

@end
