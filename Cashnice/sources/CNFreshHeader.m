//
//  CNFreshHeader.m
//  Cashnice
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNFreshHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"


@interface CNFreshHeader()
@property (nonatomic, weak) UIImageView *arrowImage;
@end

@implementation CNFreshHeader

- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fresh_logo"]];
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 箭头
    CGFloat arrowX = (self.stateHidden && self.updatedTimeHidden) ? self.mj_w * 0.5 : (self.mj_w * 0.5 - 100);
    self.arrowImage.width = 27;
    self.arrowImage.height = 27;
    self.arrowImage.center = CGPointMake(arrowX, self.mj_h-(MJRefreshFooterHeight * 0.5)-10);

    
    // 指示器
}


-(void)addCoreAnimationOnView{
    
    [self removeCoreAnimationOnView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.arrowImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)removeCoreAnimationOnView{
    [self.arrowImage.layer removeAnimationForKey:@"rotationAnimation"];
}


#pragma mark - 公共方法
#pragma mark 设置状态

-(void)restoreInitalStateDidComplete{
    self.arrowImage.image = [UIImage imageNamed:@"fresh_logo"];
}

- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            
            [self removeCoreAnimationOnView];

            if (oldState == MJRefreshHeaderStateRefreshing) {
                self.arrowImage.image = [UIImage imageNamed:@"fresh_cg"];
            } else {
                self.arrowImage.image = [UIImage imageNamed:@"fresh_logo"];
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
//            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
//            }];
            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
            [self addCoreAnimationOnView];
//            [self.activityView startAnimating];
//            self.arrowImage.alpha = 0.0;
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
