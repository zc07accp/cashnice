//
//  HandleComplete.m
//  Cashnice
//
//  Created by a on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CouponJSHandle.h"

@implementation CouponJSHandle


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if([message.name isEqualToString:@"closePopUp"]){
        [self performSelectorOnMainThread:@selector(closeHandle) withObject:nil waitUntilDone:NO];
    }else if([message.name isEqualToString:@"goWeb"]){
        [self performSelectorOnMainThread:@selector(goWeb:) withObject:message.body waitUntilDone:NO];
    }else if([message.name isEqualToString:@"goNative"]){
        [self performSelectorOnMainThread:@selector(goNative:) withObject:message.body waitUntilDone:NO];
    }else if([message.name isEqualToString:@"success"]){
        [self performSelectorOnMainThread:@selector(coupongiftsuc) withObject:nil waitUntilDone:NO];
    }else if([message.name isEqualToString:@"share"]){
        [self performSelectorOnMainThread:@selector(shareHandle:) withObject:message.body waitUntilDone:NO];
    }else if([message.name isEqualToString:@"continueInvest"]){
        [self performSelectorOnMainThread:@selector(continueInvest) withObject:nil waitUntilDone:NO];
    }
    
    

}

- (void)goNative:(id)body {
    
    if ([self.chainedHandle respondsToSelector:@selector(couponJSHandleGoNative:)]) {
        [self.chainedHandle couponJSHandleGoNative:body];
        
        return;
    }
}

- (void)goWeb:(id)body {
    
    
    NSString *url = @"";
    NSString *title = @"";
    
    if ([body isKindOfClass:[NSArray class]]) {
        NSArray *para = (NSArray *)body;
        if (para && para.count > 0) {
            url = para[0];
        }
        if (para && para.count > 1) {
            title = para[1];
        }
    }else if ([body isKindOfClass:[NSString class]]){
        url = (NSString *)body;
    }

    if ([self.chainedHandle respondsToSelector:@selector(couponJSHandleGoWeb:title:)]) {
        [self.chainedHandle couponJSHandleGoWeb:url title:title];
        
        return;
    }
    
    
    if ([self.chainedHandle respondsToSelector:@selector(couponJSHandleGoWeb:)]) {
        [self.chainedHandle couponJSHandleGoWeb:body];
        return;
    }

}
- (void)closeHandle {
    
    if ([self.chainedHandle respondsToSelector:@selector(couponJSHandleClose)]) {
       
        [self.chainedHandle couponJSHandleClose];
        
        return;
    }
   }


- (void)coupongiftsuc {
    
    if ([self.chainedHandle respondsToSelector:@selector(couponJSHandleGiftSuc)]) {
        [self.chainedHandle couponJSHandleGiftSuc];
        
        return;
    }
}
- (void)shareHandle:(id)body {
    
    
    if ([self.chainedHandle respondsToSelector:@selector(shareWithObject:)]) {
    
        [self.chainedHandle shareWithObject:body];
        
        return;
    }

}



-(void)continueInvest{
    
    if ([self.chainedHandle respondsToSelector:@selector(continueInvest)]) {
        
        [self.chainedHandle continueInvest];
        
        
        return;
    }
}


@end
