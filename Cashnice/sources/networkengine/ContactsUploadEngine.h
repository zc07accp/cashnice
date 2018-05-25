//
//  ContactsUploadEngine.h
//  Cashnice
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface ContactsUploadEngine : CNNetworkEngine

/**
 *  上传通讯录联系人
 *
 *  @param contacts 联系人字符串
 *  @param userid   用户id
 *  @param success  成功
 *  @param failure  失败
 */
-(void)uploadContacts:(NSString *)contacts
               userid:(NSInteger)userid
              success:(void (^)())success
              failure:(void (^)(NSString *error))failure;

@end
