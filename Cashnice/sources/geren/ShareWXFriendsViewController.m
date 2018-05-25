//
//  ShareWXFriendsViewController.m
//  YQS
//
//  Created by a on 16/2/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ShareWXFriendsViewController.h"

@interface ShareWXFriendsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@end

@implementation ShareWXFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)cancelAction:(id)sender {
    [self hideSelfView];
}


- (void)showInView:(UIViewController *)controller {
//    [controller addChildViewController:self];
//    [controller.view addSubview:self.view];
//    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.view];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [self.view.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideSelfView
{
    self.view.hidden = YES;
//    [self.backGroundView removeFromSuperview];
    [self.view removeFromSuperview];
    //[self removeFromParentViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
