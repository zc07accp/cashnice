//
//  WebShareView.h
//  Cashnice
//
//  Created by a on 2017/1/11.
//  Copyright © 2017年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebShareView : UIView

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *dest;


- (instancetype)initWithParentVC:(UIViewController *)parentVC;

- (void)trigger;


@end
