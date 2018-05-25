//
//  ShareView.m
//  YQS
//
//  Created by a on 16/2/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()

@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIImage *shareImage;
@property(nonatomic, strong)UIImageView *shareImageView;
@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UIButton *shareButton;
@property(nonatomic, strong)UIImage *shareButtonImage;
@property(nonatomic, strong)UIImage *shareButtonActiveImage;

@property(nonatomic)CGFloat imageRatio;
@property(nonatomic)CGFloat shareImageRatio;

@end

const static CGFloat cancelButtonSize = 25.0f;

@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height );
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.userInteractionEnabled=YES;
        
        [self createSubViews];
    }
    return self;
}

-(void)layoutSubviews{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat imageWidth = screenWidth * 0.8;
    CGFloat imageHeight = imageWidth * self.imageRatio;
    
    self.contentView.frame = CGRectMake(0, screenHeight/8, screenWidth, imageHeight+50);
    
    self.shareImageView.frame = CGRectMake((screenWidth-imageWidth)/2, cancelButtonSize/2, imageWidth, imageHeight);
    
    if (self.newYearStyle){
        self.cancelButton.frame = CGRectMake(self.shareImageView.frame.origin.x + self.shareImageView.frame.size.width - cancelButtonSize/2, 0, cancelButtonSize, cancelButtonSize);
    }else{
        self.cancelButton.frame = CGRectMake(self.shareImageView.frame.origin.x + self.shareImageView.frame.size.width - cancelButtonSize, cancelButtonSize/2, cancelButtonSize, cancelButtonSize);
    }
    
    CGFloat shareButtonWidth = self.shareImageView.frame.size.width * 0.8;
    CGFloat shareButtonHeight = shareButtonWidth * self.shareImageRatio;
    CGFloat shareButtonY = self.shareImageView.frame.size.height+self.shareImageView.frame.origin.y - shareButtonHeight - shareButtonHeight*0.6;
    self.shareButton.frame = CGRectMake((self.contentView.frame.origin.x + self.contentView.frame.size.width - shareButtonWidth)/2, shareButtonY, shareButtonWidth, shareButtonHeight);
    
    self.contentView.backgroundColor = [UIColor clearColor];
}

-(void)createSubViews {
    [self.contentView addSubview:self.shareImageView];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.shareButton];
    [self addSubview:self.contentView];
}

- (void)shareAction{
    if (! [WXApi isWXAppInstalled]) {
        [Util toastStringOfLocalizedKey:@"tip.notInstallWeChat"];
        return;
    }
      
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"我在使用Cashnice，挺靠谱的呀！你们快点来借钱吧！";
    //message.description = @"描述描述描述描述描述描述描述描述描述描述描述";
    [message setThumbImage:[UIImage imageNamed:@"AppIcon-180.png"]];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = INDEX_PAGE_URL;
    message.mediaObject = webObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;//WXSceneSession;//;
    [WXApi sendReq:req];
    ZAPP.myuser.isSharingProcess = YES;
    
    [self hideSelfView];
}

- (void)cancelAction{
    [self hideSelfView];
}

- (void)showInView:(UIView *)view {

    if (self.superview) {
        return;
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    self.hidden = NO;
    
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
    [self.contentView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideSelfView
{
    //    [self.backGroundView removeFromSuperview];
    [self removeFromSuperview];
    self.hidden = YES;
}

- (void)setNewYearStyle:(BOOL)newYearStyle{
    _newYearStyle = newYearStyle;
    self.shareImageView.image = self.shareImage;
    [self.shareButton setImage:self.shareButtonImage forState:UIControlStateNormal];
    [self.shareButton setImage:self.shareButtonActiveImage forState:UIControlStateSelected];
}

- (CGFloat)imageRatio {
    return self.shareImage.size.height/self.shareImage.size.width;
}

- (CGFloat)shareImageRatio {
    return self.shareButtonImage.size.height/self.shareButtonImage.size.width;
}

- (UIImageView *)shareImageView {
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc]init];
//        _shareImageView.bounds = CGRectMake(0, 0, self.shareImage.size.width, self.shareImage.size.height);
        _shareImageView.image = self.shareImage;
        _shareImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _shareImageView;
}

- (UIImage *)shareImage {
//    if (! _shareImage) {
        if (self.newYearStyle) {
            _shareImage = [UIImage imageNamed:@"bj_newyear.png"];
        }else{
            _shareImage = [UIImage imageNamed:@"bj_usual.png"];
        }
//    }
    return _shareImage;
}

- (UIImage *)shareButtonImage {
//    if (! _shareButtonImage) {
        if (self.newYearStyle) {
            _shareButtonImage = [UIImage imageNamed:@"btn_newyear.png"];
        }else{
         _shareButtonImage = [UIImage imageNamed:@"btn_usual.png"];
        }
//    }
    return _shareButtonImage;
}

- (UIImage *)shareButtonActiveImage {
//    if (! _shareButtonActiveImage) {
        if (self.newYearStyle) {
            _shareButtonActiveImage = [UIImage imageNamed:@"btn_usual_active.png"];
        }else{
            _shareButtonActiveImage = [UIImage imageNamed:@"btn_newyear_active.png"];
        }
//    }
    return _shareButtonActiveImage;
}

- (UIView *)contentView{
    if (! _contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIButton *)shareButton {
    if (! _shareButton) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setImage:self.shareButtonImage forState:UIControlStateNormal];
        [_shareButton setImage:self.shareButtonActiveImage forState:UIControlStateSelected];
        [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (UIButton *)cancelButton{
    if (! _cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"share_close.png"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
