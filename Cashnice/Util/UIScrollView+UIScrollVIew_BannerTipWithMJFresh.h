//
//  UIScrollView+UIScrollVIew_BannerTipWithMJFresh.h
//  Cashnice
//
//  Created by apple on 2016/11/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIScrollView (UIScrollVIew_BannerTipWithMJFresh)

@property(nonatomic) CGFloat scrollView_banner_height;

//@property(nonatomic) NSString *content;

-(void)adjustState:(BOOL)withBanner parent:(UIViewController *)vc;


/**
 通过外部传递view，内部只管理addsubview和removesuperview

 @param withBanner 是否展示
 @param vc 父
 @param bannerView 加载视图
 */
-(void)adjustState:(BOOL)withBanner parent:(UIViewController *)vc bannerView:(UIView *)bannerView;

@end
