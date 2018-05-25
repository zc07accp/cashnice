//
//  TransferCashViewController.m
//  Cashnice
//
//  Created by apple on 2017/1/16.
//  Copyright © 2017年 l. All rights reserved.
//

#import "TransferCashViewController.h"
#import "SendLoanEngine.h"
#import <KVOController/KVOController.h>
#import "CNBlueBtn.h"
#import "WebViewController.h"

@interface TransferCashViewController (){
    NSString* mayturninfo;//可转让提现本息说明


}
@property (weak, nonatomic) IBOutlet UILabel *principalLabel; //本金
@property (weak, nonatomic) IBOutlet UILabel *rateLabel; //年利率

@property (weak, nonatomic) IBOutlet UILabel *investDayLabel; //投资日
@property (weak, nonatomic) IBOutlet UILabel *backDayLabel; //收回日


@property (weak, nonatomic) IBOutlet UILabel *hasBorrowedDaysLabel; //已借出日期
@property (weak, nonatomic) IBOutlet UILabel *expireDaysLabel; //收回日期

@property (weak, nonatomic) IBOutlet UILabel *mainandinterestLabel;//迄今本息

@property (weak, nonatomic) IBOutlet UILabel *mayturnvalLabel;//可转让提现本息

@property (weak, nonatomic) IBOutlet UILabel *turnobjectLabel;//可转让对象

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet CNBlueBtn *sureButton;

@property (strong,nonatomic) SendLoanEngine *engine;
@property (strong,nonatomic) FBKVOController *kvoController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLeftMar;

@end

@implementation TransferCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];
    
    for (UILabel *lb in self.daysLabelColl) {
        lb.left = ScreenWidth320?self.investDayLabel.right+26:MainScreenWidth/2;
    }
    if(ScreenWidth320){
        self.tipLeftMar.constant = 0;
    }
    
 
    progress_show
    

    
    [self requestDetail];
    
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.kvoController = KVOController;
    
    [self.kvoController observe:self.agreeButton keyPath:@"selected" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        BOOL newvalue = [change[NSKeyValueChangeNewKey] boolValue];
        [self setSureBtn:newvalue];
 
    }];
    
}

-(void)dealloc{
    [self.kvoController unobserveAll];
}

-(void)setSureBtn:(BOOL)enable{
    self.sureButton.enabled = enable;
}

-(void)requestDetail{
    
    WS(weakSelf)
    
    
    [self.engine getBetTurnDetail:self.betId success:^(NSDictionary *dic) {
        progress_hide
        [weakSelf updateUI:dic];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

-(void)updateUI:(NSDictionary *)dic{
    
    self.title = EMPTYSTRING_HANDLE( dic[@"loantitle"]);
    self.principalLabel.text = [Util formatRMB:EMPTYOBJ_HANDLE( dic[@"betval"])];
    self.rateLabel.text = [NSString stringWithFormat:@"%@%%",EMPTYOBJ_HANDLE( dic[@"loanrate"])];
    
    
    self.investDayLabel.text = EMPTYSTRING_HANDLE( dic[@"ubtime"]);
    self.backDayLabel.text = EMPTYSTRING_HANDLE( dic[@"repayendtime"]);
    self.hasBorrowedDaysLabel.text = EMPTYSTRING_HANDLE( dic[@"betdays"]);
    self.expireDaysLabel.text = EMPTYSTRING_HANDLE( dic[@"lastdays"]);
 
    
    self.mainandinterestLabel.text = [Util formatRMB:EMPTYOBJ_HANDLE( dic[@"mainandinterest"])];
    self.mayturnvalLabel.text = [Util formatRMB:EMPTYOBJ_HANDLE( dic[@"mayturnval"])];

    self.turnobjectLabel.text = EMPTYSTRING_HANDLE( dic[@"turnobject"]);
    mayturninfo = EMPTYSTRING_HANDLE( dic[@"mayturninfo"]);
    
}


- (IBAction)action:(id)sender {

    [self popAlert];

}


- (IBAction)agreeAction:(id)sender {
    
    _agreeButton.selected =!_agreeButton.selected;
    
}

- (IBAction)seeAgree:(id)sender {
    
    WebViewController *wvc = [[WebViewController alloc]init];
    
    NSString *httpPrefix = @"";
    if (USESSL) {
        httpPrefix = @"https://";
    }else{
        httpPrefix = @"http://";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", [YQS_SERVER_URL rangeOfString:httpPrefix].location == NSNotFound?httpPrefix:@"", YQS_SERVER_URL, @"Turnbets/index"];
    
    wvc.urlStr = url;
    wvc.atitle = @"债权转让协议";
    [self.navigationController pushViewController:wvc animated:YES];
    
}

- (IBAction)tixianTip:(id)sender {
    
    if([mayturninfo length]){
        [Util toast:mayturninfo];
    }
    
}

-(SendLoanEngine *)engine{
    
    if(!_engine){
        _engine = [[SendLoanEngine alloc]init];
    }
    return _engine;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)popAlert{

    if (!_agreeButton.isSelected) {
//        [Util toast:@"zzz"];
        return;
    }
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"是否转让" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    [alertview show];
    alertview.tag=500;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500 && buttonIndex==1) {
        
        WS(weakSelf)
        
        progress_show

        [self.engine investTransfer:self.betId success:^{
            progress_hide
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error) {
            progress_hide
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
