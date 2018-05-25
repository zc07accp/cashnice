//
//  ShowUnit.h
//  NavZe
//
//  Created by ZengYuan on 15/8/21.
//  Copyright (c) 2015年 ZengYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowUnit : NSObject

@property(nonatomic)  NSString* picurl;// 图片
@property(nonatomic)  NSString* intro ;//简介
@property(nonatomic)  NSString* atitle ;//标题

@property(nonatomic)  NSInteger type;//1 url跳转    2客户端跳转

@property(nonatomic) NSString* contentUrl;

@property(nonatomic) NSString* desc;

@end
