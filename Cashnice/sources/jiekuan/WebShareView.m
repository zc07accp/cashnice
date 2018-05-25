//
//  WebShareView.m
//  Cashnice
//
//  Created by a on 2017/1/11.
//  Copyright © 2017年 l. All rights reserved.
//

#import "WebShareView.h"

@interface WebShareView() {
    
    UIViewController *_parentVC;
    UIView           *_parentView;
    
    UIControl           *_bkView;
    UIView              *_contentView;
    
//    CGFloat          _selfHeight;
    CGFloat          _bottomOffset;
    
    CGFloat          _split;

    BOOL                _isShow;
    
    
    UIView              *_contV;
    UIView              *_cancV;
    UIView              *_titleV;
}

@end

@implementation WebShareView


- (instancetype)initWithParentVC:(UIViewController *)parentVC{
    self = [super initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    if (self) {
        _parentVC = parentVC;
        _parentView = parentVC.view;
        
        _bkView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        [_bkView addTarget:self action:@selector(trigger) forControlEvents:UIControlEventTouchDown];
        _bkView.backgroundColor = [UIColor blackColor];
        _bkView.alpha = 0.3;
        
        [self addSubview:_bkView];
        
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, 0, 0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        [parentVC.navigationController.view addSubview:self];
        //[_parentView addSubview:self];
        
        self.backgroundColor = [UIColor clearColor];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //make.height.mas_equalTo(_selfHeight);
            
            make.left.equalTo(self);
            make.right.equalTo(self).mas_offset(0);
            
            
            make.bottom.mas_equalTo(MainScreenHeight);
            
        }];
//        
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            //make.height.mas_equalTo(_selfHeight);
//            
//            make.left.equalTo(_parentView);
//            make.right.equalTo(_parentView).mas_offset(0);
//            
//            
//            make.bottom.mas_equalTo(MainScreenHeight);
//            
//        }];
        
        
        [self setSubViews];
        
        _isShow = NO;
        
    }
    return self;
}

- (void)trigger{
    
    _isShow = !_isShow;
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_isShow ? 0 : MainScreenHeight);
    }];
    
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [_parentView layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        self.hidden = !_isShow;
    }];
}

- (void)setSubViews{
    
    _contV = [self setShareButtons];
    
    _cancV = [self setShareCancel];
    
    //[self setShareTitle];
}

- (void)cancel{
    [self trigger];
}

- (void)didSelected:(UIButton *)button{
    
    [self trigger];
    
    if (2 == button.tag) {
        //复制到剪切板
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = self.dest;
        
        [Util toastInGray:@"复制到剪贴板成功"];
        
    }else{
        int scene = button.tag == 0 ? WXSceneSession : WXSceneTimeline;
        [self shareForWx:scene];
    }
}

- (void)shareForWx:(int)scene {
    if (! [WXApi isWXAppInstalled]) {
        [Util toastInGray:@"您的手机还没有安装微信客户端"];
        
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description = self.desc;
    [message setThumbImage:[UIImage imageNamed:@"AppIcon-180.png"]];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = self.dest;  //INDEX_PAGE_URL
    message.mediaObject = webObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
    
    //ZAPP.myuser.isSharingProcess = YES;
}

-(UIView *)setShareTitle{
    
    UILabel *lab = [[UILabel alloc] init];
    
    lab.font = CNFont_34px;
    lab.text = @"分享赢好礼";
    
    [_contentView addSubview:lab];
    _split = [ZAPP.zdevice scaledValue:25];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.bottom.equalTo(_contV.mas_top).mas_offset(-_split);
        make.top.equalTo(_contentView).mas_offset(_split);
    }];
    
    return lab;
}

-(UIView *)setShareCancel{
    
    _split = [ZAPP.zdevice scaledValue:15];
    
    UIButton *canc = [[UIButton alloc] init];
    canc.titleLabel.font = [UtilFont systemButtonTitle];
    [canc setTitleColor:CN_TEXT_GRAY forState:UIControlStateNormal];
    [canc setTitle:@"取消" forState:UIControlStateNormal];
    
    [canc addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    canc.layer.borderWidth = 1;
    canc.layer.borderColor = CN_COLOR_DD_GRAY.CGColor;
    canc.layer.cornerRadius = _split/2;
    canc.layer.masksToBounds = YES;
    
    [_contentView addSubview:canc];
    
    
    [canc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).mas_offset(_split);
        make.right.equalTo(_contentView).mas_offset(-_split);
        make.height.mas_equalTo([ZAPP.zdevice scaledValue:37]);
        make.bottom.equalTo(_contentView).mas_offset(- _split);
        make.top.equalTo(_contV.mas_bottom).mas_offset(_split);
    }];
    
    return canc;
}

-(UIView *)setShareButtons{
    
    NSArray *itemImg = @[@"wx_friend.png", @"wx_circle.png", @"copylink.png"];
    NSArray *itemLab = @[@"微信好友", @"微信朋友圈", @"复制链接"];
    
    CGFloat btnSize = [ZAPP.zdevice scaledValue:60];
    CGFloat marginWith = (MainScreenWidth - (3 * btnSize) ) / 4;
    
    UIView *cont = [[UIView alloc] init];           cont.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:cont];
    
    for (int i = 0; i < itemImg.count; i++) {
        UIView *btnView = [[UIView alloc] init];    //btnView.backgroundColor = [UIColor redColor];

        UIButton *btn = [[UIButton alloc] init];
        UIImageView *imgv = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.font = CNFont_26px;
        label.textColor = CN_TEXT_GRAY;
    
        
        btn.tag = i;
        [btn addTarget:self action:@selector(didSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        imgv.image = [UIImage imageNamed:itemImg[i]];
        label.text = itemLab[i];
        
        [cont addSubview:btnView];
        [btnView addSubview:imgv];
        [btnView addSubview:label];
        [btnView addSubview:btn];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btnView);
            make.centerX.equalTo(imgv);
        }];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(label.mas_top).mas_offset(-10);
            
            make.left.equalTo(btnView);
            make.right.equalTo(btnView);
            make.top.equalTo(btnView);
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btnView);
            make.left.equalTo(btnView);
            make.right.equalTo(btnView);
            make.top.equalTo(btnView);
        }];
        
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cont).mas_offset( i * (btnSize + marginWith) + marginWith );
            make.top.equalTo(cont);
            make.bottom.equalTo(cont);
        }];
    }
    
    [cont mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_contentView).mas_offset([ZAPP.zdevice scaledValue:20]);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        
    }];
    
    return cont;
}






//- (BOOL)isHidden{
//    return _isShow;
//}

@end
