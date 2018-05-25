//
//  ListCountTip.m
//  Cashnice
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ListCountTip.h"

@interface ListCountTip()
@property(nonatomic,strong) UILabel *promptView;

@end

@implementation ListCountTip


+(instancetype)tipSuperView:(UIView *)superView  bottomLayout:(MASViewAttribute*)att{
   return [[[self class]alloc] initWithTipSuperView:superView bottomLayout:att];
}

-(id)initWithTipSuperView:(UIView *)superView bottomLayout:(MASViewAttribute*)att{
   
    self =  [super init];
    [self addWithSuperView:superView];

    [_promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(att).mas_offset(-20);
        make.centerX.equalTo(superView);
        make.height.equalTo(@([ZAPP.zdevice getDesignScale:30]));
    }];
    return self;
    
}

- (UILabel *)promptView{
    if (!_promptView) {
        _promptView = [[UILabel alloc] init];
        _promptView.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
        _promptView.textAlignment = NSTextAlignmentCenter;
        _promptView.preferredMaxLayoutWidth =MainScreenWidth - 30;
        _promptView.numberOfLines = 0;

        CGFloat cornerRadius = [ZAPP.zdevice getDesignScale:15];
        _promptView.layer.cornerRadius = cornerRadius;
        _promptView.layer.masksToBounds = YES;
        _promptView.hidden = YES;
        
        _promptView.font = [UtilFont systemLargeNormal];
        _promptView.textColor = ZCOLOR(COLOR_TEXT_GRAY);



    }
    return _promptView;
}

-(void)addWithSuperView:(UIView *)superView{
    
    [superView addSubview:self.promptView];
}


- (void)showPromptView{
//    
    if (isAnimating && _promptView.text.length == 0) {
        return;
    }

//    DLog();
    
    //[self.promptView setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [self.promptView setAlpha:1];
        
        isAnimating = YES;
        
    } completion:^(BOOL finished) {
        self.promptView.hidden = NO;
        
        isAnimating = NO;
    }];
}
- (void)hidePromptView{
//    
    if (isAnimating) {
        return;
    }
    
    DLog();
    
    [self.promptView setAlpha:1];
    [UIView animateWithDuration:0.5 animations:^{
        [self.promptView setAlpha:0];
        isAnimating = YES;

    } completion:^(BOOL finished) {
        self.promptView.hidden = YES;
        isAnimating = NO;

    }];
}

-(void)setTip:(NSString *)tip{
    
    if (tip && tip.length) {
        _promptView.text =tip;
    }

}

- (void)adjustFrame{
    self.promptView.width += ([ZAPP.zdevice getDesignScale:30]);
    self.promptView.left = (self.promptView.superview.frame.size.width - self.promptView.width)/2;
    
}


@end
