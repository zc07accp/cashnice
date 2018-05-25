//
//  MsgSendWay.m
//  Cashnice
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MsgSendWay.h"
#import "IOU.h"

@implementation MsgSendWay

-(NSString *)shareUrl{
    
    return [NSString stringWithFormat:SHAREURL_IOU, @(self.iouID), [ZAPP.myuser getUserID]];
}


-(BOOL)sendSMS:(NSString *)phone
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {

            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = self;
            picker.recipients = @[phone];
            picker.body= [[ZAPP.myuser getIOUSMS] stringByAppendingString:[self  shareUrl]];
//            IOU_SMS;
            
            [ZAPP.tabViewCtrl presentViewController:picker animated:YES completion:^{
                
            }];
            
            return YES;

            
        }
        else {
            [Util toast:@"设备没有短信功能"];
        }
    }
    else {
        [Util toast:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
    }

    
    return NO;
 }

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
//            LOG_EXPR(@”Result: SMS sending canceled”);
            break;
        case MessageComposeResultSent:
//            LOG_EXPR(@”Result: SMS sent”);
            break;
        case MessageComposeResultFailed:
//            [UIAlertView quickAlertWithTitle:@"短信发送失败" messageTitle:nil dismissTitle:@"关闭"];
            break;
        default:
//            LOG_EXPR(@”Result: SMS not sent”);
            break;
    }
    [ZAPP.tabViewCtrl dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)sendWeixin:(NSString *)desc{
    
    if (! [WXApi isWXAppInstalled]) {
        [Util toastStringOfLocalizedKey:@"tip.notInstallWeChat"];
        return NO;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    NSString *text = @"我在Cashnice打了一个借条，快来确认吧";
    message.title = text;
    message.description = desc;
    [message setThumbImage:[UIImage imageNamed:@"AppIcon-120.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = [self  shareUrl];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = WXSceneSession ;
    [WXApi sendReq:req];
    
    return YES;
}

+(BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}

@end
