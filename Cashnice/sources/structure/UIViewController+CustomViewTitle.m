//
//  UIViewController+CustomViewTitle.m
//  Cashnice
//
//  Created by a on 16/2/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "UIViewController+CustomViewTitle.h"

@implementation UITabBarController (CustomViewTitle)


- (void)setTitle:(NSString *)title{
    
    UIView *titleView = self.navigationItem.titleView;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    
}
@end
