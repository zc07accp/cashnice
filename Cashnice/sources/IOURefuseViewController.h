//
//  IOURefuseViewController.h
//  Cashnice
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@protocol  IOURefuseDelegate<NSObject>
-(void)refuseDidSelected:(NSDictionary *)reasonDic;
@end

@interface IOURefuseViewController : CustomViewController

@property (nonatomic) NSArray *refuse_arr;
@property(nonatomic,weak)id<IOURefuseDelegate>delegate;

-(void)showDia;
-(void)dismisDia;
@end

