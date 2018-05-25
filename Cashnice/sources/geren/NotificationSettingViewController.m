//
//  NotificationSettingViewController.m
//  YQS
//
//  Created by a on 16/1/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NotificationSettingViewController.h"

@interface NotificationSettingViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *indicationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;

@property (assign, nonatomic) BOOL systemNotificationEnable;

@end

@implementation NotificationSettingViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"消息通知";
    
    [Util setScrollHeader:self.scroll target:self header:@selector(rhManual) dateKey:[Util getDateKey:self]];
    
    [self setNavButton];
    [self loadSetting];
}

- (void)rhManual{
    [self loadSetting];
    [self.scroll.header endRefreshing];
}

- (IBAction)settingChangedAction:(id)sender {
    BOOL settingOn = self.settingSwitch.on;
    [self synchronizeNotificationSetting:settingOn];
    [self setNotificationOn:settingOn];
}

- (void)loadSetting {
    
    [self updateIndicationOn:self.systemNotificationEnable];
    
    self.settingSwitch.userInteractionEnabled = self.systemNotificationEnable;
    
    if (self.systemNotificationEnable) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL synchronizedNotificationOff = [[userDefaults valueForKey:kSynchronizedNotificationOffKey ] boolValue];
        if(synchronizedNotificationOff){
            [self setNotificationOn:NO];
            [self updateSwitchOn:NO];
        }else{
            [self setNotificationOn:YES];
            [self updateSwitchOn:YES];
        }
    }else{
        [self updateSwitchOn:NO];
    }
}

- (void)setNotificationOn :(BOOL)on{
    if (on) {
        [ZAPP registerUMessagePush];
        
        [ZAPP.netEngine getUserInfoWithComplete:NULL error:nil];
    }else{
        [ZAPP unRegisterUMessagePush];
    }
}

- (void)updateIndicationOn :(BOOL)on {
    self.indicationLabel.text = on?@"已开启":@"已关闭";
}
- (void)updateSwitchOn :(BOOL)on {
    self.settingSwitch.on = on;
}
- (void)synchronizeNotificationSetting : (BOOL)on{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(!on) forKey:kSynchronizedNotificationOffKey];
    [userDefaults synchronize];
}

- (BOOL)systemNotificationEnable{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            return NO;//NSLog(@"推送关闭");
        }else{
            return YES;//NSLog(@"推送打开");
        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            return NO; //NSLog(@"推送关闭");
        }else{
            return YES;//NSLog(@"推送打开");
        }
    }
}

@end
