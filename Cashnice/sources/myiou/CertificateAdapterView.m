//
//  CertificateAdapterView.m
//  Cashnice
//
//  Created by a on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CertificateAdapterView.h"
#import "CertificateView.h"

@interface CertificateAdapterView () {
    CertificateView *_certificateView;
    UIView          *_titleView;
    UILabel         *_titleLable;
}

@end

@implementation CertificateAdapterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame targetViewController:(UIViewController *)target {
    if (self = [super initWithFrame:frame]) {
        self.target = target;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (NSArray<UIImage *> *)certificates {
    return _certificateView.certificates;
}

//- (CGFloat)optimumHeight{
//    
//}

- (void)setupCertificateView {
    
    _certificateView = [[CertificateView alloc] initWithTargetViewController:_target];
    _certificateView.certificateDelegate = self.certificateViewDelegate;
    _certificateView.userPerationEnabled = self.userPerationEnabled;
    _certificateView.maxImagesCount = (self.maxImagesCount > 0 ? self.maxImagesCount : 2);
    [self addSubview:_certificateView];

    _titleView = [[UIView alloc] init];
    [self addSubview:_titleView];
    
    
    [_certificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo([ZAPP.zdevice getDesignScale:40]);
    }];
    
    [self setupTitle];
 }

- (void)addPreviewImageURLs:(NSArray *)urls {
    [_certificateView addPreviewImageURLs:urls];
}

- (void)setUserPerationEnabled:(BOOL)userPerationEnabled{
    if (_userPerationEnabled != userPerationEnabled) {
        _userPerationEnabled = userPerationEnabled;
        
        [self setupCertificateView];
    }
}

- (void)setupTitle {
    _titleLable = [[UILabel alloc] init];
    _titleLable.text = self.title;
    _titleLable.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    _titleLable.font = [UtilFont systemLargeNormal];
    [_titleLable sizeToFit];
    [_titleView addSubview: _titleLable];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = ZCOLOR(COLOR_SEPERATOR_COLOR);
    [_titleView addSubview:sepLine];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView);
        make.bottom.equalTo(_titleView);
        make.left.equalTo(_titleView);
    }];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.bottom.equalTo(_titleView);
        make.left.equalTo(_titleView);
        //make.right.equalTo(_titleView);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);//分割线顶到屏幕右边
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (_titleLable)
        _titleLable.text = title;
}

- (void)setTarget:(UIViewController *)target {
    if (! _target) {
        _target = target;
        
        [self setupCertificateView];
    }
    
}

@end
