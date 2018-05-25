
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "UnlockManager.h"
#import "LocalAuthen.h"
#import "LocalViewGuide.h"

@interface GestureViewController ()<CircleViewDelegate>{
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UILabel *_titleLabel;
}

/**
 *  底部按钮
 */
@property (nonatomic, strong) UIButton *bottomBtn;

/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

//连续验证错误次数
@property (nonatomic) NSInteger currentErrorCount;

@end

@implementation GestureViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"手势密码"];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        

        WS(weakSelf)
        
        if ([[LocalAuthen sharedInstance] touchIDDeviceExisted] &&
            [[LocalAuthen sharedInstance] touchIDAvailble] &&
            [[LocalAuthen sharedInstance] isTouchIDOpened]) {
            
            [[LocalAuthen sharedInstance] evaluate:^(BOOL suc) {
                if (suc) {
                    [weakSelf vierifySuccess];
                }
            }];
        }
    }
    
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"手势密码"];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:CircleViewBackgroundColor];
    
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
}

- (void)configCustomNaviBar {
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _naviBar.backgroundColor = CircleViewBackgroundColor;
    //_naviBar.alpha = 0.7;
    
    _backButton = [[UIButton alloc]init];
    _backButton.titleLabel.font = [UtilFont systemLargeNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setTitle:@"取消" forState:UIControlStateNormal];
    _backButton.backgroundColor = [UIColor clearColor];;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UtilFont systemNormal:20];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"手势密码";
    [_titleLabel sizeToFit];
    //    _titleLabel.backgroundColor = [UIColor redColor];
    
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = HexRGB(0x3366cc);
    
    UIView *shadowLine = [[UIView alloc] init];
    shadowLine.backgroundColor = HexRGB(0x5aa6f3);
    
    [_naviBar addSubview:shadowLine];
    [_naviBar addSubview:sepLine];
    [_naviBar addSubview:_titleLabel];
    [_naviBar addSubview:_backButton];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_naviBar);
        make.top.equalTo(_naviBar).mas_offset(20);
        make.bottom.equalTo(_naviBar);
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_naviBar).mas_offset(-20);
        make.top.equalTo(_naviBar).mas_offset(20);
        make.bottom.equalTo(_naviBar);
    }];
    [shadowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_naviBar);
        make.right.equalTo(_naviBar);
        make.bottom.equalTo(_naviBar);
        make.height.mas_equalTo(1);
    }];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_naviBar);
        make.right.equalTo(_naviBar);
        make.bottom.equalTo(shadowLine.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:_naviBar];
}

- (void)dismiss{
    if ([UnlockManager needResetUnlockGesture]){
        [Util toast:@"您可在“设置”页开启手势密码"];
        //设置中关闭手势功能
        [[LocalAuthen sharedInstance] setGesturePasswd:NO];
        [UnlockManager clearNeedResetUnlockGesture];
    }
    
    //发送通知更新手势设置
    [UnlockManager dispachGestureSettingNotification];
    
    [UnlockManager dismissGestureView];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 ;
                             }];
}

#pragma mark - 创建UIBarButtonItem

- (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {100, 20}};
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.tag = tag;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setHidden:YES];
    self.resetBtn = button;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 界面不同部分生成器

- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    // 创建导航栏右边按钮
    //self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"重设" target:self action:@selector(didClickBtn:) tag:buttonTagReset];
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    //msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.lockView.mas_top).mas_offset(-15);
    }];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    _titleLabel.text = @"手势密码";
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    [self.bottomBtn setTitle:@"手势密码设置后将默认开启" forState:UIControlStateNormal];
    
    //self.bottomBtn.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    [self.bottomBtn sizeToFit];
    //self.bottomBtn.center = CGPointMake(kScreenW/2, kScreenH - 60);
    
    //NSLog(@"%.2f", self.view.frame.size.height);
    
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        //make.top.equalTo(self.view).mas_offset(64+[ZAPP.zdevice scaledValue:100]);
        make.width.mas_equalTo(self.lockView.width);
        make.height.mas_equalTo(self.lockView.height);
    }];
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.lockView.mas_top).mas_offset([ZAPP.zdevice scaledValue:0]);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.lockView.mas_bottom).mas_offset([ZAPP.zdevice scaledValue:20]);
    }];
    
    /*
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
    */
    
    [self configCustomNaviBar];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    //self.currentErrorCount = 0;
    
    [self.lockView setType:CircleViewTypeLogin];
    
    // 头像
    HeadImageView  *imageView = [[HeadImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, [ZAPP.zdevice scaledValue:65], [ZAPP.zdevice scaledValue:65]);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/8);
    //[imageView setHeadImgeUrlStr:];
    NSString *headImgUrl = [Util getSavedHeadImgUrl];
    if (headImgUrl.length < 1) {
        headImgUrl = [ZAPP.zlogin getSavedHeadImage];
    }
    
    [imageView setHeadImgeUrlStr:headImgUrl];
    
    [self.view addSubview:imageView];
    
    if (self.currentErrorCount > 0) {
        [self.msgLabel showWarnMsg:[NSString stringWithFormat:@"密码错误，您还可以再输入%zd次", gestureVerifyErrorCount-self.currentErrorCount]];
    }
    
    //欢迎
    UILabel *wel = [[UILabel alloc] init];
    wel.font = CNFont_30px;
    wel.text = [NSString stringWithFormat:@"您好，%@", [ZAPP.myuser getMaskedPhone: [ZAPP.zlogin getSavedPhone]]];
    
    wel.textColor = [UIColor whiteColor];
    [wel sizeToFit];
    [self.view addSubview:wel];
    
    CGFloat offset = [ZAPP.zdevice scaledValue:10];
    
    [wel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom).mas_offset(offset);
    }];
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(wel.mas_bottom).mas_offset(offset);
    }];
    
    
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(wel.mas_bottom).mas_offset(offset *5);
        make.width.mas_equalTo(self.lockView.width);
        make.height.mas_equalTo(self.lockView.height);
    }];
    
    // 忘记手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, self.lockView.bottom+20, kScreenW/2, 20) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
    
    // Touch ID指纹解锁
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, self.lockView.bottom+20, kScreenW/2, 20) title:@"Touch ID指纹解锁" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
    
    
    if ([[LocalAuthen sharedInstance] touchIDDeviceExisted]) {
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lockView).mas_offset(0);
            make.top.equalTo(self.lockView.mas_bottom).mas_offset(offset);
        }];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.lockView).mas_offset(0);
            make.top.equalTo(self.lockView.mas_bottom).mas_offset(offset);
        }];
    }else{
        rightBtn.hidden = YES;
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.lockView);
            make.top.equalTo(self.lockView.mas_bottom).mas_offset(offset);
        }];
    }
    
    
}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (UIButton *)bottomBtn{
    if (! _bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.titleLabel.font = CNFont_28px;
        _bottomBtn.tag = buttonTagReset;
        [_bottomBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtn setTintColor:[UIColor whiteColor]];
        [self.view addSubview:_bottomBtn];
    }
    return _bottomBtn;
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    //DLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagReset:
        {
            DLog(@"点击了重设按钮");
            
            if (! [sender.currentTitle hasPrefix:@"重新设置"]) {
                return;
            }
            
            [self.bottomBtn setTitle:@"手势密码设置后将默认开启" forState:UIControlStateNormal];
            
            // 1.隐藏按钮
            [self.resetBtn setHidden:YES];
            
            // 2.infoView取消选中
            [self infoViewDeselectedSubviews];
            
            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];
            
            // 4.清除之前存储的密码
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
        }
            break;
        case buttonTagManager:
        {
            DLog(@"点击了  忘记  手势密码按钮");
            //清除当前用户手势密码
            [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
            
            //设置中关闭手势功能
            [[LocalAuthen sharedInstance] setGesturePasswd:NO];
            
            ////// Fix bug :  关闭提示引导页
            [ZAPP.lvg clearAll];
            
            
            [self vierifyFaild];
        }
            break;
        case buttonTagForget:
            DLog(@"点击了  Touch ID指纹解锁 按钮");
            if ([[LocalAuthen sharedInstance] touchIDDeviceExisted]) {
                
                if ([[LocalAuthen sharedInstance] touchIDAvailble]){
                    
                    if ([[LocalAuthen sharedInstance]isTouchIDOpened]) {
                        [[LocalAuthen sharedInstance] evaluate:^(BOOL suc) {
                            if (suc) {
                                [self vierifySuccess];
                            }
                        }];
                    }else{
                        [Util toast:touchIDSettingNote];
                    }
                }else{
                    [Util toast:touchIDDeviceSettingNote];
                }
            }
            break;
        default:
            break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        DLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    DLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
    
    [self.bottomBtn setTitle:@"重新设置手势密码" forState:UIControlStateNormal];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    DLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        DLog(@"两次手势匹配！可以进行本地化保存了");
        
        [UnlockManager clearNeedResetUnlockGesture];
        //设置中打开手势功能
        [[LocalAuthen sharedInstance] setGesturePasswd:YES];
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [Util toast:gestureTextSetSuccess];
        [self performSelector:@selector(dismssSelfSettingView) withObject:nil afterDelay:1];
        
        //发送通知更新手势设置
        [UnlockManager dispachGestureSettingNotification];
    } else {
        DLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

- (void)dismssSelfSettingView{
    [UnlockManager dismissGestureView];
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)dismssSelfSettingViewWithDelay{
    [self performSelector:@selector(dismssSelf) withObject:nil afterDelay:1];
}

- (void)dismssSelf{
    [UnlockManager dismissGestureView];
//    [self dismissViewControllerAnimated:YES completion:^{
//        ;
//    }];
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            DLog(@"登陆成功！");
            self.currentErrorCount = 0;
            [self vierifySuccess];
        } else {
            DLog(@"密码错误！");
            self.currentErrorCount = self.currentErrorCount + 1;
            if (self.currentErrorCount >= gestureVerifyErrorCount) {
                [self.msgLabel showWarnMsgAndShake:@"请重新登录"];
                [self vierifyFaild];
            }else{
                [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误，您还可以再输入%zd次", gestureVerifyErrorCount-self.currentErrorCount]];
            }
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            DLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            DLog(@"原手势密码输入错误！");
            
        }
    }
}

- (void)vierifyFaild {
    [UnlockManager setNeedResetUnlockGesture];
    
    //清除错误计数
    self.currentErrorCount = 0;
    [ZAPP loginout];
    
    [self performSelectorOnMainThread:@selector(dismssSelf) withObject:nil waitUntilDone:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        //[UnlockManager cleanCurrentGestureVC];
        
    }];
}

- (void)vierifySuccess{
    //清除错误计数
    self.currentErrorCount = 0;
    
    [self.msgLabel showWarnMsg:gestureTextLoginSuccess];
    
    [self performSelectorOnMainThread:@selector(dismssSelf) withObject:nil waitUntilDone:YES];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [UnlockManager cleanCurrentGestureVC];;
//    }];
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews
{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}
- (NSInteger)currentErrorCount{
    NSString *countStr  = [PCCircleViewConst getGestureWithKey:gestureCurrentErrorCountSaveKey];
    if ([countStr isKindOfClass:[NSString class]]) {
        return [countStr integerValue];
    }
    return 0;
}

- (void)setCurrentErrorCount:(NSInteger)currentErrorCount{
    [PCCircleViewConst saveGesture:[NSString stringWithFormat:@"%zd", currentErrorCount] Key:gestureCurrentErrorCountSaveKey];
}

@end
