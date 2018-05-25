//
//  BasePageControlViewController.m
//  bzyyuanzhang
//
//  Created by bzy008 on 16/7/18.
//  Copyright © 2016年 xujiajia. All rights reserved.
//

#import "BasePageControlViewController.h"

@interface BasePageControlViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@end

@implementation BasePageControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.view.frame = self.view.bounds;
    self.pageController.dataSource = self;
    self.pageController.delegate   = self;
    
    [self.view addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];

}

- (void)setViewControllers:(NSArray *)viewControllers{
    
    if (viewControllers.count == 0 || !viewControllers) return;
    
    _viewControllers = viewControllers;
    
    [self.pageController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

-(NSInteger)indexOfViewController:(UIViewController *)viewController{
    return [self.viewControllers indexOfObject:viewController];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    index --;
    
    return self.viewControllers[index];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound || index == self.viewControllers.count - 1) {
        return nil;
    }
    index++;
    
    return self.viewControllers[index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSInteger index = [self indexOfViewController:pendingViewControllers[0]];
    self.willToIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(completed){
        NSInteger index = [self indexOfViewController:previousViewControllers[0]];
        NSInteger nextIndex = 0;
        if (index > self.willToIndex) {
            nextIndex = index - 1;
        }else if (index < self.willToIndex){
            nextIndex = index + 1;
        }
        self.currentIndex = nextIndex;
    }
}

- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
    return UIInterfaceOrientationPortrait;
}
@end
