//
//  HistoryPageContainerViewController.m
//  Cashnice
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import "HistoryPageContainerViewController.h"
#import "TopTapLayout.h"

@interface HistoryPageContainerViewController ()<UIScrollViewDelegate>
{
    UIView *topTapCoverView;
//    UIView *containerCoverView;

    TopTapLayout *topLayout;
}
@end

@implementation HistoryPageContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"历史成交";
    [self setNavButton];
    
    
    topTapCoverView = [[UIView alloc] init];
    topTapCoverView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topTapCoverView];
    UIView *superview = self.view;
    [topTapCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview);
        make.left.equalTo(superview.mas_left);
        make.top.equalTo(superview.mas_top);
        make.height.equalTo(@35);
    }];
    
//    self.pageController.dataSource = nil;//屏蔽左右滑动手势

    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview);
        make.left.equalTo(superview.mas_left);
        make.top.equalTo(topTapCoverView.mas_bottom);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
            break;
        }
    }
    
//    self.pageController.doubleSided = YES;
    
    topLayout = [[TopTapLayout alloc] init];
    topLayout.itemsArr = [self topTapTitles];
    [topLayout layout:topTapCoverView];
    WS(weakSelf)
    topLayout.SelItemFresh=^(NSInteger index){
        [weakSelf changeContainerView:index];
    };
    

    UIViewController *vc1 = [MeRouter friendsTradeHistoryViewController];
    UIViewController *vc2 = [MeRouter OuterTradeHistoryViewController];

    self.viewControllers = @[vc1,vc2];

}

-(NSArray *)topTapTitles{
    return @[@"好友成交", @"周边成交"];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    } else if (self.currentIndex == self.viewControllers.count-1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.currentIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    } else if (self.currentIndex == self.viewControllers.count-1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
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
        NSLog(@"currentIndex= %d", self.currentIndex);
        topLayout.selIndex = self.currentIndex;
    }
}

-(NSInteger)indexOfViewController:(UIViewController *)viewController{
    return [self.viewControllers indexOfObject:viewController];
}

-(void)changeContainerView:(NSInteger)index{
    
    __weak typeof(self) weakSelf = self;
    
    if (self.currentIndex == 0) {
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            weakSelf.currentIndex = index;
        }];
    }else if (self.currentIndex < index){
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            weakSelf.currentIndex = index;
        }];
    }else{
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
            weakSelf.currentIndex = index;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
