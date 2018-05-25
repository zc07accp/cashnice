//
//  BILLWebViewUtil.m
//  Cashnice
//
//  Created by a on 16/9/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BILLWebViewUtil.h"
#import "WebDetail.h"

@interface BILLWebViewUtil () {
    NSString *_indexPath;
    NSString *_rulesPaht;
}

@end

@implementation BILLWebViewUtil


+ (void)presentOverdueIndexFrom:(UIViewController *)vc{
    WebDetail *webVC = ZSTORY(@"WebDetail");
    webVC.userAssistantPath = @{@"name" : @"催收系统"};
    webVC.absolutePath = [NSString stringWithFormat:@"%@/%@",WEB_DOC_URL_ROOT, @"overdue/index"];
    [vc.navigationController pushViewController:webVC animated:YES];
}

+ (void)presentOverdueRulesFrom:(UIViewController *)vc {
    WebDetail *webVC = ZSTORY(@"WebDetail");
    webVC.userAssistantPath = @{@"name" : @"逾期后果"};
    webVC.absolutePath = [NSString stringWithFormat:@"%@/%@",WEB_DOC_URL_ROOT, @"overdue/rules"];
    [vc.navigationController pushViewController:webVC animated:YES];
}

+ (void)presentOverdueCollection:(NSUInteger)loanId vc:(UIViewController *)vc {
    WebDetail *webVC = ZSTORY(@"WebDetail");
    webVC.userAssistantPath = @{@"name" : @"催收进展"};
    webVC.absolutePath = [NSString stringWithFormat:@"%@/%@%zd",WEB_DOC_URL_ROOT, @"overdue/showcollection/", loanId];
    [vc.navigationController pushViewController:webVC animated:YES];
}

+ (void)presentPrivilegedUserWithViewController:(UIViewController *)vc {
    WebDetail *webVC = ZSTORY(@"WebDetail");
    webVC.userAssistantPath = @{@"name" : @"抵押用户"};
    webVC.absolutePath = [NSString stringWithFormat:@"%@/%@",WEB_DOC_URL_ROOT, @"mortgage/userdescription"];
    [vc.navigationController pushViewController:webVC animated:YES];
}

@end
