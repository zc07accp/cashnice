//
//  ContactMgr.h
//  Cashnice
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ContactEntity : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIImage *headImage;

@end

@interface ContactMgr : NSObject

-(NSArray *)contactsContainingString:(NSString *)string ;
-(void)uploadContacts:(void (^)(NSString *error))completeBlock;

//请求访问通讯录的授权
+(void)requestAuthen:(void (^)(BOOL authened))complete;

//通讯录是否授权
+(BOOL)addressBookAuthened;


@end
