//
//  HandleComplete.m
//  Cashnice
//
//  Created by a on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "HandleComplete.h"
#import "MyRemainMoneyInterestViewController.h"

@implementation HandleComplete

- (void)complete {
    
    [self performSelectorOnMainThread:@selector(completeHandle) withObject:nil waitUntilDone:NO];
    
}

- (void)cancelHandle {
    if ([self.chainedHandle respondsToSelector:@selector(cancel)]) {
        [self.chainedHandle cancel];
        return;
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if([message.name isEqualToString:@"complete"]){
        [self complete];
    }else if([message.name isEqualToString:@"share"]){
        [self performSelectorOnMainThread:@selector(shareHandle:) withObject:message.body waitUntilDone:NO];
    }else if([message.name isEqualToString:@"cancel"]){
        [self performSelectorOnMainThread:@selector(cancelHandle) withObject:message.body waitUntilDone:NO];
    }
}

- (void)shareHandle:(id)body {
    
    
    if (self.chainedHandle) {
        if (self.chainedHandle) {
            [self.chainedHandle shareWithObject:body];
            
            return;
        }
    }
}

- (void)completeHandle {
    
    
    if (self.chainedHandle) {
        if (self.chainedHandle) {
            [self.chainedHandle complete];
            
            return;
        }
    }
    
    if (self.targetViewController) {
        
        for (UIViewController *controller in self.targetViewController.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MyRemainMoneyInterestViewController class]]) {
                [self.targetViewController.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
        
        
        [self.targetViewController.navigationController popViewControllerAnimated:YES];
    }
}

@end
