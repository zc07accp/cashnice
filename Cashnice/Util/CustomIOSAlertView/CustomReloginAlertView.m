//
//  CustomReloginAlertView.m
//  Cashnice
//
//  Created by a on 16/6/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomReloginAlertView.h"

@implementation CustomReloginAlertView

- (void)createAlertViewWithMessage : (NSString *)message  {
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 140)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 120)];
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.font = [UtilFont systemNormal:15.0f];
    

    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [message length])];
    [label setAttributedText:attributedString1];
    
    
    [demoView addSubview:label];
    
    [self setContainerView:demoView];
}

@end
