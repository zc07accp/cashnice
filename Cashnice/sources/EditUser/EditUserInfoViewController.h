//
//  EditUserInfoViewController.h
//  Cashnice
//
//  Created by a on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

typedef NS_ENUM(NSInteger, EditUserInfoType) {
    EditUserInfo_Workplace          = 0,   //   工作在
    EditUserInfo_Position           = 1,   //   职务
    EditUserInfo_Address            = 2,   //   地址
    EditUserInfo_Email              = 3,   //   邮箱
    EditUserInfo_SocietyTitle       = 4,   //   社会职务
} ;

@interface EditUserInfoViewController : CustomViewController

@property (nonatomic) EditUserInfoType editUserInfoType;
@property (nonatomic, strong) NSString *content;

@end
