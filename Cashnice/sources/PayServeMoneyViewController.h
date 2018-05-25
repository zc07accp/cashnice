//
//  PayServeMoneyViewController.h
//  Cashnice
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface PayServeMoneyViewController : CustomViewController

/**
 *  借条参数
 */
@property (nonatomic) NSDictionary* iou_params;
@property (nonatomic,readonly) NSInteger newID;
//@property (nonatomic,readonly) NSArray *uploadedImagesArr;
//@property (nonatomic) NSArray *imagesArr;


@property (strong,nonatomic) void (^PaySuccess) ();

- (IBAction)openAbout:(id)sender;

@end
