//
//  WriteUseageViewController.h
//  Cashnice
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@protocol WriteUseageViewControllerDelegate<NSObject>

-(void)didSelectedUseage:(NSDictionary *)selReasonDic picsArr:(NSArray *)picsArr;

@end


@interface WriteUseageViewController : CustomViewController

@property(nonatomic) NSInteger selId;
@property(nonatomic,strong) NSDictionary *selReasonDic;
@property id<WriteUseageViewControllerDelegate> deleagte;

@property (strong, nonatomic) NSArray *existedUrlsArr;


@end
