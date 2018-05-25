//
//  GestureUnlockContainerView.m
//  Cashnice
//
//  Created by a on 2016/11/29.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GestureUnlockContainerView.h"
#import "GestureViewController.h"
#import "CustomIOSAlertView.h"

@interface GestureUnlockContainerView ()
@property (nonatomic, strong) GestureViewController* gestureVc;
@property (nonatomic, strong) GestureViewController* gestureSetter;
@property (nonatomic, strong) UIWindow *overlayWindow;

@end

@implementation GestureUnlockContainerView


- (void)show{
    [self.overlayWindow setRootViewController:self.gestureVc];
    [self.overlayWindow makeKeyAndVisible];
    
    self.overlayWindow.top = 0;
}

- (void)showGestureSetter{
    [self.overlayWindow setRootViewController:self.gestureSetter];
    [self.overlayWindow makeKeyAndVisible];
    
    self.overlayWindow.top = 0;
}

- (void)close
{
//    CATransform3D currentTransform = dialogView.layer.transform;
//    
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
//        CGFloat startRotation = [[dialogView valueForKeyPath:@"layer.transform.rotation.z"] doubleValue];
//        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
//        
//        dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
//    }
//    
//    dialogView.layer.opacity = 1.0f;
    
    
//    {
//        NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
//        [windows removeObject:_overlayWindow];
//        _overlayWindow = nil;
//        
//        [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
//            if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
//                [window makeKeyWindow];
//                *stop = YES;
//            }
//        }];
//    }
    
    
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
    
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
        if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
            //if (! window.rootViewController) {
            
            if (window.tag == 10111) {
                
                for (UIView *view in window.subviews) {
                    if ([view isKindOfClass:[CustomIOSAlertView class]]) {
                        CustomIOSAlertView *alert = (CustomIOSAlertView *)view;
                        
                        if ([ZAPP.zlogin isLogined]) {
                            *stop = YES;
                            break;
                        }
                        for (NSString *buttonTitle in alert.buttonTitles) {
                            if ([buttonTitle hasPrefix:@"去绑定"]) {
                                [alert closeWithoutAnimation];
                                
                                [windows removeObject:window];
                                
                                break;
                                
                                *stop = YES;
                            }
                        }
                        
                        /*
                        if ([alert.delegate isKindOfClass:[UIViewController class]]) {
                            UIViewController *vc = (UIViewController *)alert.delegate;
                            if (! vc.parentViewController) {
                                [alert closeWithoutAnimation];
                                
                                [windows removeObject:window];
                                
                                *stop = YES;
                            }
                        }
                        
                        if (! alert.delegate ||
                            ![alert.delegate respondsToSelector:@selector(customIOS7dialogButtonTouchUpInside:clickedButtonAtIndex:)]) {
                            
                            [alert closeWithoutAnimation];
                            
                            [windows removeObject:window];
                            
                            *stop = YES;
                        }
                        */
                    }
                }
            }
        }
    }];
    
    [UIWindow animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        self.overlayWindow.top = MainScreenHeight;
        //[self.overlayWindow layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        
        [windows removeObject:_overlayWindow];
        _overlayWindow = nil;
        [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
            if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                [window makeKeyWindow];
                *stop = YES;
            }
        }];
    }];
}
- (UIWindow *)overlayWindow {
    if(! _overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.windowLevel = UIWindowLevelAlert+1000;
    }
    return _overlayWindow;
}

- (GestureViewController *)gestureVc{
    if (! _gestureVc) {
        _gestureVc = [[GestureViewController alloc] init];
        [_gestureVc setType:GestureViewControllerTypeLogin];
    }
    return _gestureVc;
}

- (GestureViewController *)gestureSetter{
    if (! _gestureSetter) {
        _gestureSetter = [[GestureViewController alloc] init];
        [_gestureSetter setType:GestureViewControllerTypeSetting];
    }
    return _gestureSetter;
}

@end
