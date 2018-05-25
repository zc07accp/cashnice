//
//  PayServeMoneyViewController.m
//  Cashnice
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "PayServeMoneyViewController.h"
#import "WriteIOUNetEngine.h"
#import "IOU.h"
#import "WebViewController.h"
#import "WriteIOUViewController.h"
#import "BankChoose.h"
#import "SinaCashierWebViewController.h"

@interface PayServeMoneyViewController () <HandleCompletetExport>

@property (strong,nonatomic) WriteIOUNetEngine *engine;
@property (weak,nonatomic) IBOutlet UITextField *feeField;
@end

@implementation PayServeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];

    self.feeField.text = [Util formatRMB:self.iou_params[@"counterfee"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"支付平台服务费";
}

- (IBAction)payAction:(id)sender {
    
    CGFloat counterfee = [self.iou_params[@"counterfee"] floatValue];
    
    if (counterfee>[ZAPP.myuser getAccountVal]) {
//        [Util toast:IOU_MONEYLESS_ALERT];
//        BankChoose *e = ZSEC(@"BankChoose");
//        [self.navigationController pushViewController:e animated:YES];
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:IOU_MONEYLESS_ALERT delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    
    
    progress_show
    
    __weak __typeof__(self) weakSelf = self;
    
    [self.engine payforIOU:self.iou_params
                    images:nil
                success:^(NSInteger newId, NSData *contentData){
                    
                    progress_hide;
//                  progress_show_suc_text(@"支付成功");
//                  [weakSelf addNewDone:newId uploadedImages:uploadedImagesArr];
                    
                    _newID = newId;
                    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
                    web.loadData = contentData;
                    web.titleString = @"支付";
                    web.completeHandle = self;
                    [weakSelf.navigationController pushViewController:web animated:YES];

    } failure:^(NSString *error) {
        progress_hide
    }];

}

- (void)complete{
    [self addNewDone:_newID uploadedImages:nil];
}

-(void)addNewDone:(NSInteger)newID uploadedImages:(NSArray *)arr{
    
    NSLog(@"postIOU SUCC");
    
    _newID = newID;
//    _uploadedImagesArr = arr;
    
    if (self.PaySuccess) {
        self.PaySuccess();
    }
    
    NSArray *vcs = self.navigationController.viewControllers;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[WriteIOUViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(WriteIOUNetEngine *)engine{
    
    if(!_engine){
        _engine = [[WriteIOUNetEngine alloc]init];
    }
    
    return _engine;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)openAbout:(id)sender {
    
    WebViewController *wvc = [[WebViewController alloc]init];
    wvc.urlStr = IOU_PLATSERVE_ABOUT;
    wvc.atitle = @"平台服务费";
    [self.navigationController pushViewController:wvc animated:YES];
}

@end
