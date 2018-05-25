//
//  ListCountTip.h
//  Cashnice
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListCountTip : NSObject<UIScrollViewDelegate>
{
    BOOL isAnimating;
}


+(instancetype)tipSuperView:(UIView *)superView  bottomLayout:(MASViewAttribute*)att;

-(id)initWithTipSuperView:(UIView *)superView bottomLayout:(MASViewAttribute*)att;

- (void)showPromptView;
- (void)hidePromptView;
- (void)adjustFrame;

@property(strong,nonatomic)NSString *tip;

@end
