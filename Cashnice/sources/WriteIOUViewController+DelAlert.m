//
//  WriteIOUViewController+DelAlert.m
//  Cashnice
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "WriteIOUViewController+DelAlert.h"
#import "IOU.h"

@implementation WriteIOUViewController(DelAlert)

-(void)popDelAlert{

    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:IOU_DEL_ALERT delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alertview show];
    alertview.tag=300;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 300 && buttonIndex==0) {
        [self delActi];
    }
}

-(void)delActi{

    WS(weakSelf)
    
    NSMutableDictionary *parmas = @{}.mutableCopy;
    parmas[@"action"]= @(0);
    parmas[@"ui_id"] = @(self.iouid);
    parmas[@"userid"]=[ZAPP.myuser getUserID];
    
    
    [self.d_engine actionIOU:parmas success:^() {
        POST_IOULISTFRESH_NOTI;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        
    }];

}

@end
