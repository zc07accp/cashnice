//
//  SettingViewController.m
//  YQS
//
//  Created by a on 16/1/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "WebDetail.h"
#import "NewInstruction.h"
#import "NotificationSettingViewController.h"
#import "TMCache.h"
#import "SinaCashierWebViewController.h"
#import "SinaCashierModel.h"
#import "LocalAuthen.h"
#import "UnlockManager.h"
#import "SystemOptionsEngine.h"
#import "SettingEngine.h"
#import "WebViewController.h"
#import "CouponJSHandle.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, CouponJSHandleExport>{
    NSString *_selectedTitle;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *rowNameArray;
@property (strong, nonatomic) SystemOptionsEngine *engine;
@property (strong, nonatomic) SettingEngine *settingEngine;

@property (strong, nonatomic) NSString *investorTestResult;
@property (strong, nonatomic) NSString *investorTestUrl;

@end

@implementation SettingViewController

#pragma mark - life cycle method
BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);
    self.tableView.backgroundColor = [UIColor clearColor];
    [self setNavButton];
}


-(SystemOptionsEngine *)engine{
    
    if(!_engine){
        _engine = [[SystemOptionsEngine alloc]init];
    }
    return _engine;
}

- (SettingEngine *)settingEngine{
    if (! _settingEngine) {
        _settingEngine = [[SettingEngine alloc] init];
    }
    return _settingEngine;
}

//查询是否设置密码
- (void)querySetPayPassword{
    if (0 == _rowNameArray.count) {
        progress_show
    }
    
    [[[SinaCashierModel alloc] init] queryIsSetPayPasswordWithsuccess:^(BOOL isSetPayPassword) {
        
        if(isSetPayPassword){
            _rowNameArray = @[
                              @[@"修改支付密码", @"找回支付密码", @"修改新浪支付手机号码", @"找回新浪支付手机号码"],
                              @[@"风险评估"],
                              @[[[LocalAuthen sharedInstance] touchIDDeviceExisted] ? @"指纹、手势密码":@"手势密码"],
                              @[@"消息通知", @"清除缓存"],
                              @[@"借款协议", @"服务协议", @"用户指南", @"版本号",],
                              @[@"安全退出"]];
        }
        else{
            _rowNameArray = @[@[@"设置支付密码"],
                              @[@"风险评估"],
                              @[[[LocalAuthen sharedInstance] touchIDDeviceExisted] ? @"指纹、手势密码":@"手势密码"],
                              @[@"消息通知", @"清除缓存"], @[@"借款协议", @"服务协议", @"用户指南", @"版本号",], @[ @"安全退出"]];
        }
        [self getInvestorTest];
    } failure:^(NSString *error) {
        
        _rowNameArray = @[@[@"风险评估"],
                          @[[[LocalAuthen sharedInstance] touchIDDeviceExisted] ? @"指纹、手势密码":@"手势密码"],
                          @[@"消息通知", @"清除缓存"],
                          @[@"借款协议", @"服务协议", @"用户指南", @"版本号",], @[@"安全退出"]];
        [self getInvestorTest];
    }];
}

- (void)getInvestorTest{
    [self.settingEngine getInvestTestWithSuccess:^(NSDictionary *dict) {
        progress_hide;
        
        self.investorTestUrl = dict[@"url"];
        self.investorTestResult = dict[@"title"];
        
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        progress_hide;
        
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self querySetPayPassword];
    [self getConfig];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

#pragma mark - delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rowNameArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.rowNameArray objectAtIndex:section] count];
}
- (BOOL)lastRow:(NSIndexPath *)indexPath {
    return indexPath.row == [[self.rowNameArray objectAtIndex:indexPath.section] count] - 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CNCOMMON_LISTTABLEROW_HEIGHT;
//    return [ZAPP.zdevice getDesignScale:TABLE_TEXT_ROW_HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0;
    }else{
        return [ZAPP.zdevice getDesignScale:15];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor        = ZCOLOR(COLOR_BG_GRAY);
    return v;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *v = [UIView new];
//    v.userInteractionEnabled = NO;
//    v.backgroundColor        = [UIColor clearColor];
//    return v;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell;
    static NSString *   CellIdentifier = @"SettingTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sepLine.hidden = [self lastRow:indexPath];
    NSString *rowTitle = self.rowNameArray[indexPath.section][indexPath.row];
    
    cell.titleLabel.text = rowTitle;
    
    
    
    if ([rowTitle hasPrefix:@"风险评估"]) {
        cell.rightLabel.text = self.investorTestResult;
        cell.rowRight.hidden =  NO;
        cell.signoutLabel.text = @"";
        
        cell.layToArrowConstraint.priority = 1000;
        cell.layToMarginConstraint.priority = 500;
        
    }else if ([rowTitle hasPrefix:@"版本号"]) {
        cell.rightLabel.text = [NSString stringWithFormat:@"V%@", [Util appVersion]];
        cell.rowRight.hidden =  YES;
        cell.signoutLabel.text = @"";
        
        cell.layToArrowConstraint.priority = 1000;
        cell.layToMarginConstraint.priority = 500;
    }else if ([rowTitle hasPrefix:@"安全退出"]) {
        cell.signoutLabel.text = rowTitle;
        cell.rowRight.hidden = YES;
        cell.titleLabel.text = @"";
        cell.rightLabel.text = @"";
        cell.layToArrowConstraint.priority = 1000;
        cell.layToMarginConstraint.priority = 500;
    }else{
        cell.signoutLabel.text = @"";
        cell.rightLabel.text = @"";
        cell.rowRight.hidden = NO;
        cell.layToArrowConstraint.priority = 1000;
        cell.layToMarginConstraint.priority = 500;
    }
    
    return cell;
}

- (NSString *)getDiskCacheCapacity {
    CGFloat diskByteCount = [TMCache sharedCache].diskByteCount;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#.##"];
    if (diskByteCount > 1024*1024) {
        CGFloat kCount = diskByteCount / 1024.0f / 1024.0f;
        NSString *kCountStr = [formatter stringFromNumber:[NSNumber numberWithDouble:kCount]];
        return [NSString stringWithFormat:@"%@M", kCountStr];
    }else{
        CGFloat kCount = diskByteCount / 1024.0f;
        NSString *kCountStr = [formatter stringFromNumber:[NSNumber numberWithDouble:kCount]];
        return [NSString stringWithFormat:@"%@K", kCountStr];
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    
    NSString *rowTitle = self.rowNameArray[indexPath.section][indexPath.row];
    _selectedTitle = rowTitle;
    
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    __weak id weakSelf = self;
    
    if ([rowTitle hasPrefix:@"设置支付密码"]) {
        progress_show
        [model setPayPasswordWithsuccess:^(NSString *URL, NSData *Content) {
            progress_hide
            [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
        } failure:^(NSString *error) {
            progress_hide;
        }];
        
    }else if ([rowTitle hasPrefix:@"修改支付密码"]){
        progress_show
        [model modifyPayPasswordWithsuccess:^(NSString *URL, NSData *Content) {
            progress_hide
            [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
        } failure:^(NSString *error) {
            progress_hide;
        }];
    }else if ([rowTitle hasPrefix:@"找回支付密码"]){
        progress_show
        [model findPayPasswordWithsuccess:^(NSString *URL, NSData *Content) {
            progress_hide
            [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
        } failure:^(NSString *error) {
            progress_hide;
        }];
    }else if ([rowTitle hasPrefix:@"修改新浪支付手机号码"]){
        progress_show
        [model modifyVerifyMobileWithsuccess:^(NSString *URL, NSData *Content) {
            progress_hide
            [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
        } failure:^(NSString *error) {
            progress_hide;
        }];
    }else if ([rowTitle hasPrefix:@"找回新浪支付手机号码"]){
        progress_show
        [model findVerifyMobileWithsuccess:^(NSString *URL, NSData *Content) {
            progress_hide
            [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
        } failure:^(NSString *error) {
            progress_hide;
        }];
    //}else if ([rowTitle hasPrefix:@"智能投标"]) {
    //    SmartBidViewController *vc = [[SmartBidViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    }else if ([rowTitle rangeOfString:@"手势密码"].location != NSNotFound){
        
        //第一次手势密码
        if([[LocalAuthen sharedInstance] didSetGesturePasswdFirstTime]){
            [UnlockManager presentGrestureSetter];
        }else{
            //设置
            UIViewController *setting = ZPERSON(@"GPSetViewController");
            [self.navigationController pushViewController:setting animated:YES];
            
        }
    }
    else if ([rowTitle hasPrefix:@"风险评估"]) {
        WebViewController *wvc = [[WebViewController alloc]init];
        
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        
        CouponJSHandle *handle = [CouponJSHandle new] ;
        handle.chainedHandle = self;
        [config.userContentController addScriptMessageHandler:handle name:@"continueInvest"];
        
        wvc.webVIewConfiguration = config;
        
        wvc.urlStr = self.investorTestUrl;
        wvc.parameterizedTitle = YES;
        [self.navigationController pushViewController:wvc animated:YES];
    }
    else if ([rowTitle hasPrefix:@"消息通知"]) {
        NotificationSettingViewController *vc = ZPERSON(@"NotificationSettingViewController");
        [self.navigationController pushViewController:vc animated:YES];
    }else if([rowTitle hasPrefix:@"清除缓存"]){
        [self refreshCache];
    }else if([rowTitle hasPrefix:@"借款协议"]){
        WebDetail *s = ZSTORY(@"WebDetail");
        s.webType = WebDetail_borrow_xuzhi;
        [self.navigationController pushViewController:s animated:YES];
    }else if([rowTitle hasPrefix:@"服务协议"]){
        WebDetail *s = ZSTORY(@"WebDetail");
        s.webType = WebDetail_service_agreement;
        [self.navigationController pushViewController:s animated:YES];
    }else if([rowTitle hasPrefix:@"用户指南"]){
        NewInstruction *x = ZSTORY(@"NewInstruction");
        [self.navigationController pushViewController:x animated:YES];
    }else if([rowTitle hasPrefix:@"联系我们"]){
        WebDetail *s = ZSTORY(@"WebDetail");
        s.webType = WebDetail_contact_us;
        [self.navigationController pushViewController:s animated:YES];
    }else if ([rowTitle hasPrefix:@"安全退出"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.seetingVC", nil) message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 9;
        [alert show];
    }
}

- (void)continueInvest{
    [ZAPP changeViewToFirstPage];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refreshCache {
    [[TMCache sharedCache] removeAllObjects];
    [self.tableView reloadData];
    
    // Clear the webview cache...
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self removeApplicationLibraryDirectoryWithDirectory:@"Caches"];
    [self removeApplicationLibraryDirectoryWithDirectory:@"WebKit"];
    // Empty the cookie jar...
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [self removeApplicationLibraryDirectoryWithDirectory:@"Cookies"];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString
                                        stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    /* iOS8.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    
    /* iOS7.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
    
    
    [Util toastStringOfLocalizedKey:@"tip.cacheHasEmpty"];
}

- (void)removeApplicationLibraryDirectoryWithDirectory:(NSString *)dirName {
    NSString *dir = [[[[NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) lastObject]stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:dirName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        [[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
    }
}


- (void)pushToSinaWebViewWithURLPath:(NSString *)URLPath orContentData:(NSData *)contentData{
    if (URLPath.length) {
        [self pushToSinaWebViewWithURLPath:URLPath];
    }else if (contentData){
        [self pushToSinaWebViewWithContentData:contentData];
    }
}

- (void)pushToSinaWebViewWithURLPath:(NSString *)URLPath{
    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
    web.URLPath = URLPath;
    web.titleString = _selectedTitle;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)pushToSinaWebViewWithContentData:(NSData *)contentData{
    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
    web.loadData = contentData;
    web.titleString = _selectedTitle;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (alertView.tag == 9) {
            [ZAPP loginout];
        }
    }
}

-(void)getConfig{
    
    [self.engine getSystemConfigSuccess:^{
        
    } failure:^(NSString *error) {
        
    }];

}



@end
