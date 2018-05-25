//
//  HandleComplete.m
//  Cashnice
//
//  Created by a on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ScoreJSHandle.h"

@implementation ScoreJSHandle


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if([message.name isEqualToString:@"invest"]){
        [self performSelectorOnMainThread:@selector(invest) withObject:nil waitUntilDone:NO];
    }else if([message.name isEqualToString:@"loan"]){
        [self performSelectorOnMainThread:@selector(loan) withObject:message.body waitUntilDone:NO];
    }else if([message.name isEqualToString:@"recharge"]){
        [self performSelectorOnMainThread:@selector(recharge) withObject:message.body waitUntilDone:NO];
    }else if([message.name isEqualToString:@"bank"]){
        [self performSelectorOnMainThread:@selector(bank) withObject:nil waitUntilDone:NO];
    }else if([message.name isEqualToString:@"email"]){
        [self performSelectorOnMainThread:@selector(email) withObject:message.body waitUntilDone:NO];
    }else if([message.name isEqualToString:@"license"]){
        [self performSelectorOnMainThread:@selector(license) withObject:nil waitUntilDone:NO];
    }

}

- (void)license {
    if ([self.chainedHandle respondsToSelector:@selector(scoreJSHandleLicense)]) {
        [self.chainedHandle scoreJSHandleLicense];
        return;
    }
}

- (void)email {
    if ([self.chainedHandle respondsToSelector:@selector(scoreJSHandleEmail)]) {
        [self.chainedHandle scoreJSHandleEmail];
        return;
    }
}

- (void)invest {
    
    if ([self.chainedHandle respondsToSelector:@selector(scoreJSHandleInvest)]) {
        [self.chainedHandle scoreJSHandleInvest];
        
        return;
    }
}

- (void)loan {
    
    if ([self.chainedHandle respondsToSelector:@selector(scoreJSHandleLoan)]) {
        [self.chainedHandle scoreJSHandleLoan];
        
        return;
    }
    
}

- (void)bank {
    
    if ([self.chainedHandle respondsToSelector:@selector(scoreJSHandleBank)]) {
        [self.chainedHandle scoreJSHandleBank];
        
        return;
    }
    
}

- (void)recharge {
    
    if ([self.chainedHandle respondsToSelector:@selector(scoreJSHandleRecharge)]) {
        [self.chainedHandle scoreJSHandleRecharge];
        
        return;
    }

    
    /*
    if (self.targetViewController) {
        
        for (UIViewController *controller in self.targetViewController.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MyRemainMoneyInterestViewController class]]) {
                [self.targetViewController.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
        
        
        [self.targetViewController.navigationController popViewControllerAnimated:YES];
    }
    */
}


@end
