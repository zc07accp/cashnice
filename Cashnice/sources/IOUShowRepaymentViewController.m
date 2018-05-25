//
//  IOUWaitSurePaymentViewController.m
//  Cashnice
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUShowRepaymentViewController.h"
#import "IOUDetail1ViewController.h"
#import "MoneyFormatViewModel.h"
#import "HeadImageView.h"
#import "IOURefuseViewController.h"
#import "IOUDetailEngine.h"
#import "MyIOUDetailViewController.h"
#import "IOURejectInstance.h"
#import "IouRepaymentViewController.h"

@interface IOUShowRepaymentViewController ()
{
    IOURejectInstance *rejectInstance;
    NSArray *rejectArr;
    
    NSDictionary *rejectDic; //选中的驳回原因
    
    
    IOUDetailUnit *detailUnit;

}
@property (weak, nonatomic) IBOutlet HeadImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *oriMoneyLabel; //本金
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *countPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPromptLabel;

@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;//驳回理由

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong,nonatomic) IOUDetailEngine *engine;

@property (weak, nonatomic) IBOutlet UIView *cv1;
@property (weak, nonatomic) IBOutlet UIView *cv2;
@property (weak, nonatomic) IBOutlet UIView *cv3;
@property (weak, nonatomic) IBOutlet UIView *cv2Center;

@property (weak, nonatomic) IBOutlet UILabel *srcLabel;
@property (weak, nonatomic) IBOutlet UILabel *destLabel;

@property (weak, nonatomic) IBOutlet UIView *shortLineView;

@end

@implementation IOUShowRepaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];
    [self setNavRightBtn];

    [self getDetail];
    
    [self updateUI];
    
    self.sureBtn.left = self.view.width - 19 - BLUESURE_WIDTH;

    
    [self.engine getRejectReasonList];
    
 
    //调整下间距
    
    if (ScreenInch4s) {
        
        CGPoint p1 = self.cv1.origin;
        p1.y -= 20;
        [self.cv1 setOrigin:p1];
        
        CGPoint p2 = self.cv2.origin;
        p2.y -= 45;
        [self.cv2 setOrigin:p2];
        
        CGPoint p3 = self.cv3.origin;
        p3.y -= 45;
        [self.cv3 setOrigin:p3];
        
        CGPoint p4 = self.sureBtn.origin;
        p4.y = self.cv3.bottom+20;
        [self.sureBtn setOrigin:p4];
        
    }
    
    
    rejectInstance  = [IOURejectInstance shareInstance];
    [rejectInstance getRejectReasonList:10 success:^(NSArray *arr) {
        rejectArr = arr;
    } failure:^(NSString *error) {
        
    }];
    
    
    CGFloat space = [ZAPP.zdevice getDesignScale:10];
    
    [self.cv2Center mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cv2);
        make.left.equalTo(self.cv2);
        make.right.equalTo(self.cv2);
    }];
    
    [self.countPromptLabel sizeToFit];
    [self.countPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cv2);
        make.bottom.equalTo(self.cv2Center);
        make.left.equalTo(self.cv2).mas_offset(space);
    }];
    
    [self.ratePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cv2);
        make.bottom.equalTo(self.cv2Center);
        make.left.equalTo(self.cv2.mas_centerX);
    }];
    
    [self.srcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cv2Center);
        make.bottom.equalTo(self.cv2);
        make.left.equalTo(self.countPromptLabel);
    }];
    
    [self.destLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cv2Center);
        make.bottom.equalTo(self.cv2);
        make.left.equalTo(self.ratePromptLabel);
    }];
    
    [self.startDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.srcLabel);
        make.left.equalTo(self.srcLabel.mas_right).mas_offset(space);
    }];
    
    [self.oriMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countPromptLabel);
        make.left.equalTo(self.startDateLabel);
    }];
    
    [self.endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.destLabel);
        make.left.equalTo(self.destLabel.mas_right).mas_offset(space);
    }];
    
    [self.rateDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ratePromptLabel);
        make.left.equalTo(self.endDateLabel);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSRange rang = [self.iou_title rangeOfString:@"借条"];
//    NSString*navTitle = rang.location==NSNotFound?[NSString stringWithFormat:@"借条%@", self.iou_title]:self.iou_title;
    
    self.title = self.iou_title;
//    navTitle?navTitle : @"借条详情";
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.shortLineView.left = SEPERATOR_LINELEFT_OFFSET;
    self.shortLineView.width = MainScreenWidth - 2*self.shortLineView.left;
}


-(void)getDetail{
    
    
    NSInteger iouid = [self.dic[@"ui_id"] integerValue];

//    WS(ws);
    [self.engine getIOUDetail:@{@"iouid":@(iouid)}
                      success:^(IOUDetailUnit *result) {
                          //获取借条详情
                          detailUnit = result;
                      } failure:^(NSString *error) {
                          
                      }];
}


-(IOUDetailEngine *)engine{
    
    if(!_engine){
        _engine = [[IOUDetailEngine alloc]init];
    }
    
    return _engine;
}


-(void)rightNavItemAction{
    
    if ([self.rightNavBtn.titleLabel.text isEqualToString:@"驳回"]) {
        //
        IOURefuseViewController *irvc = ZIOU(@"IOURefuseViewController");
        irvc.refuse_arr = rejectArr;
        irvc.delegate = self;
        [self.navigationController pushViewController:irvc animated:YES];
        
    }else if ([self.rightNavBtn.titleLabel.text isEqualToString:@"详情"]) {

        [self openDetail];

    }
}

- (IBAction)seeDetail:(id)sender {

    [self openDetail];
}

-(NSString *)src{
    
    NSInteger ui_src_user_id = [self.dic[@"ui_src_user_id"] integerValue];
    if (ui_src_user_id == [[ZAPP.myuser getUserID] integerValue]) {
        //我是出借人
        return @"出借日";
    }else{
        return @"借入日";
    }
    
}

-(void)openDetail{
    //查看详情
    MyIOUDetailViewController *mivc = [[MyIOUDetailViewController alloc]init
                                       ];
    
 
    
    
    mivc.iouid = [self.dic[@"ui_id"] integerValue];
    mivc.preoccupiedTransactionNames = @[@"出借人",@"借款人",[self src],@"还款日",@"本金",@"年利率",@"应付利息",@"应还款",@"已还款",@"平台服务费",@"还款方式"];
    [self.navigationController pushViewController:mivc animated:YES];
}

- (IBAction)action:(id)sender {
    
    WITHOUT_EMAIL_PUSH
    
    NSInteger ui_src_user_id = [self.dic[@"ui_src_user_id"] integerValue];
    if (ui_src_user_id == [[ZAPP.myuser getUserID] integerValue]) {
        //我是出借人
        
        if (rejectDic) {
            //驳回
            [self rejectRepayment];
        }else{
            //同意
            [self agreeRepayment];

        }
        
        
    }else{
        //我是借款人
        
        NSInteger ui_status = [self.dic[@"ui_status"] integerValue];
        if (ui_status == 6) {
            //还款被驳回
            
            //还准确的
            IouRepaymentViewController *repayment = ZMYIOU(@"IouRepaymentViewController");
            repayment.iouId = [self.dic[@"ui_id"] integerValue];
            repayment.totalAmount = detailUnit.total_amount;
            [self.navigationController pushViewController:repayment animated:YES];
            
        }else{
            
        }
        
    }


}

-(void)uopdateBaseUI{
    
    [self.headerView setHeadImgeUrlStr:self.dic[@"ui_dest_user_header_img"]];
    
    NSString *str  = [Util formatRMB:@([self.dic[@"ui_loan_val"] doubleValue])];
    self.oriMoneyLabel.text =  str;
    
    self.rateDateLabel.text = [Util percentInt:[self.dic[@"ui_loan_rate"] intValue]];
    self.startDateLabel.text =  self.dic[@"ui_loan_start_date"];
    self.endDateLabel.text =   self.dic[@"ui_loan_end_date"];
    
}

-(void)updateUI{

    [self uopdateBaseUI];
    
    NSInteger ui_src_user_id = [self.dic[@"ui_src_user_id"] integerValue];
    NSInteger ui_status = [self.dic[@"ui_status"] integerValue];

    
    //有驳回原因
    if([EMPTYSTRING_HANDLE(self.dic[@"label_ui_back_reason"]) length]){
        self.reasonLabel.text = [NSString stringWithFormat:@"驳回原因：%@", self.dic[@"label_ui_back_reason"]];
        self.reasonLabel.hidden = NO;
    }
    
    if (ui_src_user_id == [[ZAPP.myuser getUserID] integerValue]) {
       
        //我是出借人

        NSString*str = [NSString stringWithFormat:@"请确认%@的还款，共", self.dic[@"ui_dest_user_name"]];
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:str];
        NSInteger len      =[str length];
        
        [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLACK range:NSMakeRange(0, len)];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, len)];
        
        [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLUE range:NSMakeRange(3, [self.dic[@"ui_dest_user_name"] length])];
 
        self.nameLabel.attributedText = attString;
        self.sureBtn.hidden = NO;
        
        [self.rightNavBtn setTitle:@"驳回" forState:UIControlStateNormal];

        self.srcLabel.text = @"出借日";
        self.destLabel.text = @"收回日";
        
        MoneyFormatViewModel *m = [MoneyFormatViewModel viewModelFrom:1];
        m.originalMoneyNum = @([self.dic[@"ui_repay_amount"] doubleValue]);

//        m.originalMoneyNum = @([self.dic[@"ui_loan_val"] doubleValue] + [self.dic[@"ui_interest_val"] doubleValue]);
        self.moneyLabel.attributedText = m.reformedMoneyStr;
        
    }else{
        //我是借款人
        self.srcLabel.text = @"借入日";
        self.destLabel.text = @"还款日";

        //还款被驳回
        if (ui_status == 6) {
            
//            self.nameLabel.text =
            
            NSString *temp = [NSString stringWithFormat:@"给出借人%@的还款被驳回，金额为", self.dic[@"ui_dest_user_name"]];
            
            
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:temp];
            NSInteger len      =[temp length];
            
            [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLACK range:NSMakeRange(0, len)];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, len)];
            
            [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLUE range:NSMakeRange(4, [self.dic[@"ui_dest_user_name"] length])];
            
            self.nameLabel.attributedText = attString;

            self.sureBtn.hidden = NO;
            [self.sureBtn setTitle:@"还款给TA" forState:UIControlStateNormal];
            
            self.cv3.hidden = YES;
            
            self.sureBtn.top = self.cv2.bottom+20;
            
            [self.rightNavBtn setTitle:@"详情" forState:UIControlStateNormal];
            

            MoneyFormatViewModel *m = [MoneyFormatViewModel viewModelFrom:1];
            m.originalMoneyNum = @([self.dic[@"ui_repay_amount"] doubleValue]);
            self.moneyLabel.attributedText = m.reformedMoneyStr;
            
        }else{
            //还款确认
            
            NSString*str = [NSString stringWithFormat:@"等待出借人%@确认，本次借款共", self.dic[@"ui_dest_user_name"]];
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:str];
            NSInteger len      =[str length];
            
            [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLACK range:NSMakeRange(0, len)];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, len)];

            [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_BLUE range:NSMakeRange(5, [self.dic[@"ui_dest_user_name"] length])];

            self.nameLabel.attributedText = attString;
            
            self.sureBtn.hidden = YES;
            self.cv3.hidden = YES;
            [self.rightNavBtn setTitle:@"详情" forState:UIControlStateNormal];
            
            
            MoneyFormatViewModel *m = [MoneyFormatViewModel viewModelFrom:1];
            m.originalMoneyNum = @([self.dic[@"ui_repay_amount"] doubleValue]);
            self.moneyLabel.attributedText = m.reformedMoneyStr;
        }
        
    }
    

    
}

//同意对方的还款
-(void)agreeRepayment{
    
    WS(ws);
    
    NSDictionary *dic = @{@"ui_id":self.dic[@"ui_id"],
                          @"userid":[ZAPP.myuser getUserID],
                          @"action":@(5),
                          };
    progress_show
    
    [self.engine actionIOU:dic
                   success:^() {
                       
                       progress_hide
                       
                       POST_IOULISTFRESH_NOTI;
                       //获取借条详情
                       [ws.navigationController popViewControllerAnimated:YES];
                   } failure:^(NSString *error) {
                       NSLog(@"err = %@", error);
                       progress_hide
                       
                   }];
    
    
}


-(void)rejectRepayment{
    
    WS(ws);
    
    
    NSDictionary *dic = @{@"ui_id":self.dic[@"ui_id"],
                          @"userid":[ZAPP.myuser getUserID],
                          @"ui_back_reason":rejectDic[@"itemvalue"],
                          @"action":@(6)
                          };
    IOURefuseViewController*rvc = [self.navigationController.viewControllers lastObject];
    if ([rvc isKindOfClass:[IOURefuseViewController class]]) {
        [rvc showDia];
    }

    
    [self.engine actionIOU:dic
                   success:^() {
                       
                       if ([rvc isKindOfClass:[IOURefuseViewController class]]) {
                           [rvc dismisDia];
                           
                       }

                       POST_IOULISTFRESH_NOTI;
                       //获取借条详情
                       [ws.navigationController popToRootViewControllerAnimated:YES];
                   } failure:^(NSString *error) {

                       if ([rvc isKindOfClass:[IOURefuseViewController class]]) {
                           [rvc dismisDia];
                           
                       }
                       
                       progress_hide
                       
                   }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refuseDidSelected:(NSDictionary *)areasonDic{
    
    rejectDic = areasonDic;
    
    WITHOUT_EMAIL_PUSH
    
    [self rejectRepayment];
    
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
