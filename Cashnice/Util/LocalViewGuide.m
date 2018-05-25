//
//  LocalViewGuide.m
//  Cashnice
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LocalViewGuide.h"

static NSString *const KGuidePassGuide = @"KGuidePassGuide";
static NSString *const KGuidePassGuide2 = @"KGuidePassGuide2";
static NSString *const KSmartBidGuide_new = @"KSmartBidGuide_NEW";

@implementation LocalViewGuide


+(BOOL)firstPersonGuideRun{
        
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:KGuidePassGuide];
    
    if (!temp) {
        return YES;
    }
    
    return NO;
    
}

+(BOOL)secondPersonGuideRun{
    
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:KGuidePassGuide2];
    
    if (!temp) {
        return YES;
    }
    
    return NO;
    
}


+(BOOL)smartBidGuideRun{
    
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:KSmartBidGuide_new];
    
    if (!temp) {
        return YES;
    }
    
    return NO;
    
}


-(void)local_addFirstGuide{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    guideImgView = [[UIImageView alloc]initWithFrame:window.bounds];
    guideImgView.image = [UIImage imageNamed:!ScreenInch4s? @"code_guide":@"code_guide4"];
    [guideBkView addSubview:guideImgView];
    guideBkView.userInteractionEnabled = YES;
    
    tap_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    tap_btn.backgroundColor = [UIColor redColor];
    [guideBkView addSubview:tap_btn];
    [tap_btn setFrame:window.bounds];
    [tap_btn addTarget:self action:@selector(tapFirstGuide) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)local_addFirstGuide2:(CGRect)relatRecT{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    relatRecT.size.height=166;
    relatRecT.size.width=270;
    relatRecT.origin.x -=170;
    relatRecT.origin.y -=100;

    guideImgView = [[UIImageView alloc]initWithFrame:relatRecT];
    guideImgView.image = [UIImage imageNamed: @"interest_guide4"];
    [guideBkView addSubview:guideImgView];
    guideBkView.userInteractionEnabled = YES;

//    guideImgView.userInteractionEnabled = YES;
    
    tap_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    tap_btn.backgroundColor = [UIColor redColor];
    [guideBkView addSubview:tap_btn];
    [tap_btn setFrame:window.bounds];
    [tap_btn addTarget:self action:@selector(tapFirst2Guide) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)local_addSmartBidGuide:(CGRect)relatRecT{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    relatRecT.size.height=204;
    relatRecT.size.width=275;
    relatRecT.origin.x +=15;
    relatRecT.origin.y -=(204-70);
    
    guideImgView = [[UIImageView alloc]initWithFrame:relatRecT];
    guideImgView.image = [UIImage imageNamed: @"capacity_guide"];
    [guideBkView addSubview:guideImgView];
    guideBkView.userInteractionEnabled = YES;
    
    tap_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [guideBkView addSubview:tap_btn];
    [tap_btn setFrame:window.bounds];
    [tap_btn addTarget:self action:@selector(tapSmartBidGuide) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)addBkView{
    
    if(!guideBkView){
        AppDelegate *dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UIWindow *window=dele.window;
        
        guideBkView = [[UIView alloc]initWithFrame:window.bounds];
        [dele.window addSubview:guideBkView];
        guideBkView.backgroundColor = HexRGBAlpha(0x191b1d, 0.8);
        guideBkView.userInteractionEnabled = YES;
    }
    
}

-(void)tapFirstGuide{
    DLog();
    
    [[NSUserDefaults standardUserDefaults] setObject:KGuidePassGuide forKey:KGuidePassGuide];
    
    [self clearAll];
    
    
    [self show2:self.reltivShow2Rect];
}


-(void)tapFirst2Guide{
    DLog();
    [[NSUserDefaults standardUserDefaults] setObject:KGuidePassGuide2 forKey:KGuidePassGuide2];

    [self clearAll];
}

-(void)tapSmartBidGuide{
    
    [[NSUserDefaults standardUserDefaults] setObject:KSmartBidGuide_new forKey:KSmartBidGuide_new];
    [self clearAll];

}

-(void)clearAll{

    if(tap_btn){
        tap_btn.hidden = YES;
        [tap_btn removeFromSuperview];
        tap_btn = nil;
    }

    if(guideImgView){
        guideImgView.hidden = YES;
        [guideImgView removeFromSuperview];
        guideImgView= nil;
    }
    
    if(guideBkView){
        guideBkView.hidden = YES;
        [guideBkView removeFromSuperview];
        guideBkView = nil;
    }
}



-(void)show{
    if ([[self class] firstPersonGuideRun]) {
        
        
        [self addBkView];
        [self local_addFirstGuide];
    }else{
        [self show2:self.reltivShow2Rect];
    }
}


-(void)show2:(CGRect)relrec{
    if ([[self class] secondPersonGuideRun]) {
        
        
        [self addBkView];
        [self local_addFirstGuide2:relrec];
    }
}

-(void)showSmartBid:(CGRect)relrec{
    if ([[self class] smartBidGuideRun]) {
        
        
        [self addBkView];
        [self local_addSmartBidGuide:relrec];
    }
}



@end
