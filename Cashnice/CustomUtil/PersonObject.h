//
//  PersonObject.h
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonObject : NSObject

@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *headimg;
@property (nonatomic,strong) NSString *userrealname;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) UIImage  *headImage;
@property (nonatomic) BOOL   isContact;


-(NSString *)nameShowed;

@end
