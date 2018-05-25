//
//  UIScrollView+UIScrollVIew_BannerTipWithMJFresh.m
//  Cashnice
//
//  Created by apple on 2016/11/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "UIScrollView+UIScrollVIew_BannerTipWithMJFresh.h"
#import "UIScrollView+MJRefresh.h"
#import "UIScrollView+MJExtension.h"
#import "UIView+MJExtension.h"
#import "CNServiceWarningViewFactory.h"
#import <objc/runtime.h>

static const void *SCROLLVIEW_BANNER_HEIGHT_KEY;


@implementation UIScrollView (UIScrollVIew_BannerTipWithMJFresh)

static CGFloat const SCROLLVIEW_BANNER_HEIGHT = 45;

- (CGFloat)scrollView_banner_height {
    return [objc_getAssociatedObject(self, SCROLLVIEW_BANNER_HEIGHT_KEY) floatValue];
}

-(void)setScrollView_banner_height:(CGFloat)scrollView_banner_height{
    if (scrollView_banner_height>0) {
            objc_setAssociatedObject(self, SCROLLVIEW_BANNER_HEIGHT_KEY, @(scrollView_banner_height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else{
        objc_setAssociatedObject(self, SCROLLVIEW_BANNER_HEIGHT_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }

    
}




-(void)adjustState:(BOOL)withBanner parent:(UIViewController *)vc{
    
    if(![NSThread isMainThread]){
        NSLog(@"    if(![NSThread isMainThread]){");
        return;
    }
    
    if (withBanner) {
        
        UIView *view = [vc.view viewWithTag:19999];
        if (view) {
            return;
        }
        
        view = [CNServiceWarningViewFactory getViewWithFrame:CGRectMake(0, 0, vc.view.bounds.size.width, SCROLLVIEW_BANNER_HEIGHT)];
//#ifdef TEST_TEST_SERVER
//        view = [CNServiceWarningViewFactory getRejectionViewWithFrame:CGRectMake(0, 0, vc.view.bounds.size.width, SCROLLVIEW_BANNER_HEIGHT)];
//#endif
        
        [vc.view addSubview:view];
        view.tag = 19999;
        [vc.view bringSubviewToFront:view];
    
        
        [self setNeedsUpdateConstraints];
        
        UIView *superView = self.superview;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(superView);
            make.bottom.equalTo(vc.mas_bottomLayoutGuideTop);
            make.top.mas_equalTo(superView.mas_top).mas_offset(SCROLLVIEW_BANNER_HEIGHT);

        }];
        [self updateConstraintsIfNeeded];
        
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            [superView layoutIfNeeded] ;
        } completion:^(BOOL finished) {
        }];
        
        
    }else{

        UIView *view = [vc.view viewWithTag:19999];
        if (!view) {
            return;
        }
        if(view.superview){
            [view removeFromSuperview];
            view = nil;
        }
        

        [self setNeedsUpdateConstraints];
        
        UIView *superView = self.superview;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(superView);
            make.bottom.equalTo(vc.mas_bottomLayoutGuideTop);
            make.top.equalTo(@(0));
            
        }];
        [self updateConstraintsIfNeeded];
        
        
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            [superView layoutIfNeeded] ;
        } completion:^(BOOL finished) {
        }];
        

    }
}

-(void)adjustState:(BOOL)withBanner parent:(UIViewController *)vc bannerView:(UIView *)bannerView{
    
    if(![NSThread isMainThread]){
        NSLog(@"    if(![NSThread isMainThread]){");
        return;
    }
    
    if (withBanner) {

        if(![bannerView superview]){
            [vc.view addSubview:bannerView];
            [vc.view bringSubviewToFront:bannerView];
        }
        
        [self setNeedsUpdateConstraints];
        
        UIView *superView = self.superview;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(superView);
            make.bottom.equalTo(vc.mas_bottomLayoutGuideTop);
            make.top.mas_equalTo(superView.mas_top).mas_offset(SCROLLVIEW_BANNER_HEIGHT);
            
        }];
        [self updateConstraintsIfNeeded];
        
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            [superView layoutIfNeeded] ;
        } completion:^(BOOL finished) {
        }];
        
        
    }else{
 
        if(bannerView.superview){
            [bannerView removeFromSuperview];
         }
        
        
        [self setNeedsUpdateConstraints];
        
        UIView *superView = self.superview;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(superView);
            make.bottom.equalTo(vc.mas_bottomLayoutGuideTop);
            make.top.equalTo(@(0));
            
        }];
        [self updateConstraintsIfNeeded];
        
        
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            [superView layoutIfNeeded] ;
        } completion:^(BOOL finished) {
        }];
        
        
    }
}



@end
