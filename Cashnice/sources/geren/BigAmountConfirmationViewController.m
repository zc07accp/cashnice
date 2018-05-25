//
//  BigAmountConfirmationViewController.m
//  Cashnice
//
//  Created by a on 16/8/30.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BigAmountConfirmationViewController.h"
#import "CNActionButton.h"

@interface BigAmountConfirmationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet CNActionButton *loginButton;
@property (weak, nonatomic) IBOutlet CNActionButton *cancelButton;

@end

@implementation BigAmountConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.promptLabel.font = [UtilFont systemLargeNormal];
    self.loginButton.enabled = YES;
    self.cancelButton.enabled = YES;
    self.cancelButton.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (IBAction)loginAction:(id)sender {
    
    progress_show
    
    WS(ws);

    [ZAPP.netEngine postQrCode:self.qrCode step:@"2" complete:^{
        
        progress_hide;
        
        NSDictionary *qrcodeReps = ZAPP.myuser.qrcodePostRespondDict;
        NSInteger result = [qrcodeReps[@"result"] integerValue];
        if (1 != result) {
            NSString *msg = qrcodeReps[@"msg"];
            [Util toast:msg];
        }else{
            [Util toastStringOfLocalizedKey:@"alert.message.qrScanLogined"];
        }
        
        [ws dismissView];
        
    } error:^{
        progress_hide;
    }];
    
}

- (IBAction)cancleAction:(id)sender {
    [self dismissView];
}

- (IBAction)closeAction:(id)sender {
    [self dismissView];
}

- (void)dismissView{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end
