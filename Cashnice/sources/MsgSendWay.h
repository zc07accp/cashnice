//
//  MsgSendWay.h
//  Cashnice
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgSendWay : NSObject<MFMessageComposeViewControllerDelegate>

//借条id
@property(nonatomic) NSInteger iouID;

//发短信
-(BOOL)sendSMS:(NSString *)phone;

//微信发消息
- (BOOL)sendWeixin:(NSString *)desc;

+(BOOL)isWXAppInstalled;

@end
