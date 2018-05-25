//
//  CertificatePreviewViewController.m
//  Cashnice
//
//  Created by a on 16/8/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CertificatePreviewViewController.h"
#import "CertificateAdapterView.h"
#import "IOUDetailUnit.h"

@interface CertificatePreviewViewController () <CertificateViewDelegate> {
    UIView *_headView;
    
    NSMutableArray<CertificateAdapterView *> *_cerViews;
}

@end

@implementation CertificatePreviewViewController

@synthesize detailUnit;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavButton];
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    
    [self setupHeadView];
    [self setupCerView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.title = self.specialTitle ? self.specialTitle : @"借款用途及凭证";
}

//借款人凭证
- (NSArray *)certifacateOfBorrower{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.detailUnit.voucherLoanDest];
    [tmp addObjectsFromArray:self.detailUnit.voucherRepaymentDest];
    return [tmp copy];
}

//出借人凭证
- (NSArray *)certifacateOfCreditor{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.detailUnit.voucherLoanSrc];
    [tmp addObjectsFromArray:self.detailUnit.voucherRepaymentSrc];
    return [tmp copy];
}

- (void)certificateView:(CertificateView *)certificateView didFinishPickingPhotos:(NSArray<UIImage *> *)photos {
    NSLog(@"%@", photos);
}

- (void)setupCerView{
    CGFloat layoutOffset = .0f;
    _cerViews = [[NSMutableArray alloc] init];
    
    for (NSDictionary *model in self.models) {
        UIView *certContainer1 = [[UIView alloc] init];
        certContainer1.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:certContainer1];
        
        NSString *cerTitle = model[@"title"];
        CertificateAdapterView *cerView = [[CertificateAdapterView alloc] init];
        cerView.backgroundColor = [UIColor whiteColor];
        cerView.target = self;
        cerView.certificateViewDelegate = self.certificateViewDelegate;
        cerView.title = cerTitle;
        cerView.userPerationEnabled = [model[@"action"] boolValue];
        if ([cerTitle hasPrefix:@"借款人"]) {
            [cerView addPreviewImageURLs:self.certifacateOfBorrower];
        }else{
            [cerView addPreviewImageURLs:self.certifacateOfCreditor];
        }
        [certContainer1 addSubview:cerView];
        [_cerViews addObject:cerView];
        
        CGFloat designedSpace = [ZAPP.zdevice getDesignScale:10];
        CGFloat certContainerHeight = 15 * designedSpace;
        [cerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(certContainer1);
            make.left.equalTo(certContainer1).mas_offset(designedSpace);
            make.right.equalTo(certContainer1).mas_offset(-designedSpace);
            make.bottom.equalTo(certContainer1);
        }];
        [certContainer1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom).mas_offset((_certificateOnly?0:designedSpace) + layoutOffset);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(certContainerHeight);
        }];
        
        layoutOffset += (certContainerHeight + designedSpace);
    }
}


//// depreciated and can be used for reviewing
- (void)setupCerView_depreciated {
    
    CertificateAdapterView *_cerViewFirst;
    CertificateAdapterView *_cerViewSecond;
    
    UIView *certContainer1 = [[UIView alloc] init];
    certContainer1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:certContainer1];
    
    _cerViewFirst = [[CertificateAdapterView alloc] init];
    _cerViewFirst.backgroundColor = [UIColor whiteColor];
    _cerViewFirst.target = self;
    
    _cerViewFirst.userPerationEnabled = NO;
    [_cerViewFirst addPreviewImageURLs:self.certifacateOfBorrower];
//    [_cerViewFirst addPreviewImageURLs:@[@"http://fdfs.xmcdn.com/group17/M04/07/33/wKgJJFd8bcGzBvrNAADbAvkn-Bs399_web_meduim.jpg",@"http://fdfs.xmcdn.com/group17/M04/07/33/wKgJJFd8bcGzBvrNAADbAvkn-Bs399_web_meduim.jpg"]];
    [certContainer1 addSubview:_cerViewFirst];
    
    UIView *certContainer2 = [[UIView alloc] init];
    certContainer2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:certContainer2];
    
    _cerViewSecond = [[CertificateAdapterView alloc] init];
    _cerViewSecond.backgroundColor = [UIColor whiteColor];
    _cerViewSecond.target = self;
//    _cerViewSecond.certificateViewDelegate = self;
    
    _cerViewSecond.certificateViewDelegate = self.certificateViewDelegate;
    
    _cerViewSecond.userPerationEnabled = self.userPerationEnabled;
    [_cerViewSecond addPreviewImageURLs:self.certifacateOfCreditor];
//    [_cerViewSecond addPreviewImageURLs:@[@"http://fdfs.xmcdn.com/group17/M04/07/33/wKgJJFd8bcGzBvrNAADbAvkn-Bs399_web_meduim.jpg"]];
    [certContainer2 addSubview:_cerViewSecond];
    
    if (self.isDebter && self.userPerationEnabled) {
        _cerViewFirst.title = @"出借人凭证";
        _cerViewSecond.title = @"借款人凭证";
    }else{
        _cerViewFirst.title = @"借款人凭证";
        _cerViewSecond.title = @"出借人凭证";
    }
    
    
    CGFloat designedSpace = [ZAPP.zdevice getDesignScale:10];
    [certContainer1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom).mas_offset(designedSpace);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(15 * designedSpace);
    }];
    [certContainer2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(certContainer1.mas_bottom).mas_offset(designedSpace);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(certContainer1);
    }];
    [_cerViewFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(certContainer1);
        make.left.equalTo(certContainer1).mas_offset(designedSpace);
        make.right.equalTo(certContainer1).mas_offset(-designedSpace);
        make.bottom.equalTo(certContainer1);
    }];
    [_cerViewSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(certContainer2);
        make.left.equalTo(certContainer2).mas_offset(designedSpace);
        make.right.equalTo(certContainer2).mas_offset(-designedSpace);
        make.bottom.equalTo(certContainer2);
    }];
}

- (void)setupHeadView {
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.clipsToBounds = YES;
    [self.view addSubview:_headView];
    
    UILabel *usagePrompt = [[UILabel alloc] init];
    usagePrompt.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    usagePrompt.font = [UtilFont systemLargeNormal];
    usagePrompt.text = @"借款用途";
    usagePrompt.textAlignment = NSTextAlignmentLeft;
    [usagePrompt sizeToFit];
    [_headView addSubview:usagePrompt];
    
    
    UILabel *usageLable = [[UILabel alloc] init];
    usageLable.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
    usageLable.font = [UtilFont systemLargeNormal];
    usageLable.text = self.detailUnit.iouUsage;
    usageLable.textAlignment = NSTextAlignmentRight;
    [_headView addSubview:usageLable];
    
    CGFloat designedSpace = [ZAPP.zdevice getDesignScale:10];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(_certificateOnly ? 0 : 5 * designedSpace);
    }];
    [usagePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView).mas_offset(designedSpace);
        make.centerY.equalTo(_headView);
    }];
    [usageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usagePrompt.mas_right);
        make.right.equalTo(_headView).mas_offset(-designedSpace);
        make.centerY.equalTo(_headView);
    }];
}

-(NSArray *)finishedImageArr{
    
    if (_cerViews.count) {
        return [_cerViews lastObject].certificates;
    }
    
    return nil;
    
}

@end
