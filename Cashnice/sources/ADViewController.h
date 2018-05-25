//
//  ADViewController.h
//  OGL
//
//  Created by ZengYuan on 14/12/15.
//  Copyright (c) 2014年 ZengYuan. All rights reserved.
//

#import "CustomViewController.h"
#import "FLAnimatedImageView.h"

@interface ADViewController : CustomViewController
{
    
//    NSString *imgUrl;
    FLAnimatedImageView *adImgView;
    UIImageView *logoView;

}

@property(nonatomic,strong) void(^ADComplete)();

@end
