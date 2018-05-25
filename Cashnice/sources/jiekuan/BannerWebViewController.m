//
//  BannerWebViewController.m
//  Cashnice
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 l. All rights reserved.
//

#import "BannerWebViewController.h"
#import "WebShareView.h"
#import "CouponGiftViewController.h"
#import "RedMoneyListViewController.h"
#import "CouponJSHandle.h"

@interface BannerWebViewController ()
{
    UIView *_naviBar;
    UILabel *_titleLabel;
    UIButton *_backButton;
//    UIButton *_rightButton;

}
@property (nonatomic, strong) WebShareView *shareView;

@end

@implementation BannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self configCustomNaviBar];
    [self setNavRightBtn];
    
    [self loadRequest];

    //share 等于0不显示
    if([self.urlStr rangeOfString:@"share=0"].location != NSNotFound){
        self.rightNavBtn.hidden = YES;
    }else{
        self.rightNavBtn.hidden = NO;
    }
}
-(void)setNavRightBtn{
    [super setNavRightBtn];
    [self.rightNavBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    self.rightNavBtn.layer.borderWidth = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [MobClick beginLogPageView:@"新浪收银台"];
    
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
-(void)loadRequest{
    
    [self removeNoNetwork];
    
    NSURL *url = [NSURL URLWithString:[self urlAddAppTag:self.urlStr]];
    [self.webVIew loadRequest:[NSURLRequest requestWithURL:url]];
    
    NSLog(@"url = %@", url);
}
-(NSString *)urlAddAppTag:(NSString *)url{
    
    if([url rangeOfString:@"?"].location != NSNotFound){
        return [url stringByAppendingString:@"&app=1"];
    }else{
        return [url stringByAppendingString:@"?app=1"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 - (void)rightNavItemAction{
    [self.shareView trigger];
 }
- (WebShareView *)shareView{
    
    if (! _shareView) {

        _shareView = [[WebShareView alloc] initWithParentVC:self];
        _shareView.dest = self.urlStr;
        _shareView.title = self.atitle;
        _shareView.desc = self.desc;

    }
    return _shareView;
}


- (void)couponJSHandleClose{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)activityView:(id)view willGoWeb:(NSString *)webUrl title:(NSString *)title{
    
    
    CouponGiftViewController *wvc = [[CouponGiftViewController alloc]init];
    wvc.urlStr = webUrl;
    if ([title length] > 0) {
        wvc.atitle = title;
    }else{
        wvc.atitle = @"转赠";
    }
    wvc.parameterizedTitle = YES;
    
    
    [ZAPP.tabViewCtrl.selectedViewController pushViewController:wvc animated:YES];
    if ([view respondsToSelector:@selector(close)]) {
        [view performSelector:@selector(close)];
    }
}
- (void)couponJSHandleGoWeb:(id)object{
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *type = (NSNumber *)object;
        if ([self respondsToSelector:@selector(activityView:willGoWeb:)]) {
            [self activityView:self willGoNative:[type integerValue]];
        }
    }
}
- (void)couponJSHandleGoWeb:(NSString *)url title:(NSString *)title{
    if(url) {
        if ([self respondsToSelector:@selector(activityView:willGoWeb:title:)]) {
            [self activityView:self willGoWeb:url title:title];
        }
    }
}
- (void)couponJSHandleGoNative:(id)object{
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *type = (NSNumber *)object;
        if ([self respondsToSelector:@selector(activityView:willGoNative:)]) {
            [self activityView:self willGoNative:[type integerValue]];
        }
    }
}
- (void)activityView:(id)view willGoNative:(NSInteger)native {
    
    //goNative(1) 我的红包
    //goNative(2) 加息券
    if (1 == native) {
        //NSLog(@"我的红包");
        [self seeRedPacket];
    }else if(2 == native){
        //NSLog(@"加息券");
        [self seeRedInterest];
    }
    if ([view respondsToSelector:@selector(close)]) {
        [view performSelector:@selector(close)];
    }
}
- (void)activityView:(id)view willGoWeb:(NSInteger)native {
    
    //goNative(1) 我的红包
    //goNative(2) 加息券
    if (1 == native) {
        //NSLog(@"我的红包");
        [self seeRedPacket];
    }else if(2 == native){
        //NSLog(@"加息券");
        [self seeRedInterest];
    }
    if ([view respondsToSelector:@selector(close)]) {
        [view performSelector:@selector(close)];
    }
}
//红包
- (void)seeRedPacket{
    
    RedMoneyListViewController *vc = REDSTORY(@"RedMoneyListViewController");
    [vc setValue:@(REDMONEY_TYPE_CASH) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}
//优惠券
- (void)seeRedInterest{
    
    RedMoneyListViewController *vc = REDSTORY(@"RedMoneyListViewController");
    [vc setValue:@(REDMONEY_TYPE_ALLINTEREST) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)continueInvest{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
