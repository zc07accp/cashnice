//
//  WriteIOUViewController.h
//  Cashnice
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "WriteIOUNetEngine.h"
#import "IOUDetailEngine.h"

@interface WriteIOUViewController : CustomViewController


@property (strong,nonatomic) WriteIOUNetEngine *engine;
@property (strong,nonatomic) IOUDetailEngine *d_engine;


//传值代表着修改借条，否则就是修建借条
@property(nonatomic) NSInteger iouid;


@end
