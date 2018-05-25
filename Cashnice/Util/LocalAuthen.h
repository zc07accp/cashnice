//
//  LocalAuthen.h
//  Cashnice
//
//  Created by apple on 2016/11/15.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LocalAuthen : NSObject

+ (instancetype)sharedInstance;

//读取配置
-(void)readSetting;


//当前设备是否拥有touch id功能
-(BOOL)touchIDDeviceExisted;

/**
 当前设备touch id在系统设置是否开启
 @return 是否可以
 */
-(BOOL)touchIDAvailble;


/**
 调用touch id验证
 */
-(void)evaluate:(void(^)(BOOL suc))result;

// 设置手势开关
@property(nonatomic,getter=isGesturePasswdOpened) BOOL gesturePasswd;


//允许touch id
@property(nonatomic,getter=isTouchIDOpened) BOOL touchIDOpened;



/**
 是否第一次设置手势密码

 @return
 */
-(BOOL)didSetGesturePasswdFirstTime;




@end
