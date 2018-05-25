//
//  CustomViewController.h
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController
{
    BOOL _isNavigationBack;
}
@property (nonatomic) BOOL isNavigationBack;

@property (nonatomic, strong) UIButton *rightNavBtn;

@property (nonatomic, strong) UIButton *leftNavBtn;

@property (nonatomic) BOOL isRightNavBtnBorderHidden;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setNavButton ;

- (void)setTitleView:(UIView *)view;


- (void)customNavBackPressed;

-(void)setNavRightBtn;
-(void)rightNavItemAction;
-(void)setLeftNavLogo;
-(void)setNavRightWarnBadge:(NSInteger)num;
-(void)setNavLeftWarnBadge:(NSInteger)num;


//+(instancetype)produce:(NSString *)

@end
