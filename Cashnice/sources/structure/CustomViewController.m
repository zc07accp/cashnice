//
//  CustomViewController.m
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()
{
    NSString *titleString;
}

@property (nonatomic, strong) UIView *navtitleView;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        _isNavigationBack = NO;
    
    
    
    [self.view disableMultiTouchDfs];//when view did load, all views in IB have been loaded, then disable them in dfs way
    //in children classes, may add some view controller to view holder, the view controller must be a child of me, will also disable multi touch
    //then, only uitableviewcell left to be disabled
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self navtitleView];
    
    
}


- (UIView *)navtitleView {
    if (! _navtitleView) {
        
        for (UIView *view in self.navigationItem.titleView.subviews)
        {
            if(view)
            {
                [view removeFromSuperview];
            }
        }
        _navtitleView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth/4,0,MainScreenWidth/2,KNAV_SUBVIEW_MAXHEIGHT)];
        [self.navigationController.navigationBar addSubview:_navtitleView];
        
//        [_navtitleView setBackgroundColor:[UIColor greenColor]];
//        self.navigationItem.titleView = _navtitleView;
    }
    return _navtitleView;
}

- (void)setNavButton {
    
    if(self.navigationController.viewControllers.count>1){
        
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = nil;
        
        UIView *containerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, KNAV_SUBVIEW_MAXHEIGHT)];
        containerView2.backgroundColor = CN_NAV_BKCOLOR;
        self.leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftNavBtn addTarget:self action:@selector(customNavBackPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.leftNavBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        
        if ([[UIDevice currentDevice].systemVersion floatValue]>= 11.0) {
            self.leftNavBtn.frame = CGRectMake(-10, 0, 40, 40);
        }else{
            self.leftNavBtn.frame = CGRectMake(0, 0, 40, 40);
        }
        self.leftNavBtn.titleLabel.font = [UtilFont systemLargeNormal];
        //backBtn.backgroundColor = [UIColor greenColor];
        [containerView2 addSubview:self.leftNavBtn];
        
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width=-20.0f;
        [self.navigationItem setLeftBarButtonItems:@[space, [[UIBarButtonItem alloc] initWithCustomView:containerView2]]];
    }
    

}

- (void)customNavBackPressed {
    NSArray *vcs = self.navigationController.viewControllers;
    NSInteger __navcount = self.navigationController.viewControllers.count;
    if (__navcount >= 2) {
        CustomViewController *__navVC = (CustomViewController *)self.navigationController.viewControllers[__navcount-2];
        
        //NSLog(@"%@\n============\n", vcs);
        //NSLog(@"%@", __navVC);
        
        
        if ([__navVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabvc = (UITabBarController *)__navVC;
            NSArray *vcs = tabvc.viewControllers;
            NSInteger idx = tabvc.selectedIndex;
            CustomViewController *vc = vcs[idx];
            __navVC = vc;
        }
        __navVC.isNavigationBack = YES;
        [self.navigationController popToViewController:self.navigationController.viewControllers[__navcount-2] animated:YES];
    }
}


- (void)setTitleView:(UIView *)view{

    self.navigationItem.titleView = view;
}


- (void)setTitle:(NSString *)title{
    if ([title isEqualToString:titleString]) {
        return;
    }
    titleString = title;
    self.titleLabel .text = title;
    [self.titleLabel sizeToFit];
    
//    self.titleLabel.top = (self.navtitleView.height -self.titleLabel.height)/2;
//    self.titleLabel.left = (self.navtitleView.width -self.titleLabel.width)/2;
}

-(NSString *)title{
    return titleString;
}

- (UILabel *)titleLabel{
    if (! _titleLabel) {
        
        _titleLabel = [[UILabel alloc]init];
        
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.frame = self.navtitleView.bounds;
//$        [self.navtitleView addSubview:self.titleLabel];
        
        self.navigationItem.titleView=_titleLabel;
        self.navigationItem.title=@"";

        
    }
    return _titleLabel;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setNavRightBtn{
    
    UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, KNAV_SUBVIEW_MAXHEIGHT)];
    
    self.rightNavBtn = nil;
    self.rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNavBtn.titleLabel.font = [UtilFont systemNormal:12.0f];

    [self.rightNavBtn addTarget:self action:@selector(rightNavItemAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.rightNavBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    self.rightNavBtn.backgroundColor = [UIColor whiteColor];
    self.rightNavBtn.frame = CGRectMake(0, 10, 50, 25);
//    self.rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.rightNavBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    self.rightNavBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightNavBtn.layer.borderWidth = self.isRightNavBtnBorderHidden ? 0 : 1;
    self.rightNavBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rightNavBtn.layer.cornerRadius = 5;
    self.rightNavBtn.layer.masksToBounds = YES;

    [containerView1 addSubview:self.rightNavBtn];
    
    //被sb框架搞得无奈妥协,top vc需要指引到tabbarcontroller。
//    UIViewController *par;
//    if (self.navigationController.viewControllers.count==1) {
//        par = self.parentViewController;
//    }else{
//        par = self;
//    }
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:containerView1]];
}

-(void)setLeftNavLogo{
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
#ifndef HUBEI
    
    //Left
    UIView *containerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth320?80:120, 18)];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
#else
    
    //Left
    UIView *containerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 96, 34)];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hb_logo"]];
    
#endif
    
    logo.frame = containerView2.bounds;
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [containerView2 addSubview:logo];
    containerView2.backgroundColor = [UIColor clearColor];
    
    UIViewController *par;
//    if (self.navigationController.viewControllers.count==1) {
//        par = self.parentViewController;
//    }else{
//        par = self;
//    }
    
    par = self;
    [ par.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:containerView2]];
}

-(void)setNavRightWarnBadge:(NSInteger)num{
    
    UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, KNAV_SUBVIEW_MAXHEIGHT)];

    UIButton *ntfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ntfBtn addTarget:self action:@selector(msgPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [ntfBtn setBackgroundImage:[UIImage imageNamed:@"warn"] forState:UIControlStateNormal];
    ntfBtn.frame = CGRectMake(23, 10, 22, 22);
    UIButton *badge = [[UIButton alloc]initWithFrame:CGRectMake(39, 4, 12, 12)];
    
    [badge setBackgroundImage:[UIImage imageNamed:@"dian.png"] forState:UIControlStateNormal];
    [badge setTitle:[NSString stringWithFormat:@"%zi",num] forState:UIControlStateNormal];
    badge.titleLabel.font = [UIFont systemFontOfSize:8];
    badge.hidden = num == 0;
    
    [containerView1 addSubview:ntfBtn];
    [containerView1 addSubview:badge];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:containerView1]];
    
}

-(void)setNavLeftWarnBadge:(NSInteger)num{
    
    UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, KNAV_SUBVIEW_MAXHEIGHT)];
    
    UIButton *ntfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ntfBtn addTarget:self action:@selector(msgPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [ntfBtn setBackgroundImage:[UIImage imageNamed:@"warn"] forState:UIControlStateNormal];

    ntfBtn.frame = CGRectMake(0, 10, 22, 22);
    UIButton *badge = [[UIButton alloc]initWithFrame:CGRectMake(16, 4, 12, 12)];
    
    [badge setBackgroundImage:[UIImage imageNamed:@"dian.png"] forState:UIControlStateNormal];
    [badge setTitle:[NSString stringWithFormat:@"%zi",num] forState:UIControlStateNormal];
    badge.titleLabel.font = [UIFont systemFontOfSize:8];
    badge.hidden = num == 0;
    
    [containerView1 addSubview:ntfBtn];
    [containerView1 addSubview:badge];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:containerView1]];
    
}



-(void)rightNavItemAction{
    
}


- (void)msgPressed {
    
    [ZAPP msgPressed];
    
//
//    ServiceMessageViewController *tixing = ZBill(@"ServiceMessageViewController");
//    [ZAPP.nav pushViewController:tixing animated:YES];
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
