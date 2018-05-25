//
//  SmartBidViewController.m
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "SmartBidViewController.h"
#import "CNTableViewCell.h"
#import "SBRightInputCell.h"
#import "SBRightSwithCell.h"
#import "SBBidTypeCell.h"
#import "SBSingleInvestCell.h"
#import "CNBlueBtn.h"
#import "SmartBidEngine.h"
#import <MJExtension.h>
#import "CustomIOSAlertView.h"
#import "CustomSaveAlertView.h"
#import "AuthWebViewController.h"
#import "SinaCashierWebViewController.h"

@interface SmartBidViewController ()<UITableViewDelegate, UITableViewDataSource, CustomIOSAlertViewDelegate, HandleCompletetExport>
{
    BOOL stretch;
    
    NSNumber* bidMoneyTotal;//智能投标总额
    
    BOOL commonBidSel; //普通标是否选中
    BOOL pledgeBidSel; //抵押标是否选中
    
    NSInteger bidGuaranPersonCount;//标的担保人数

    NSNumber* minMoneyCount;//单笔投资总额最小
    NSNumber* maxMoneyCount;//单笔投资总额最大

    
    UILabel *footerTipLabel;
    CGFloat footerHeight;
 
    CNBlueBtn *saveBtn;
    
    BOOL changeAnythingAndNeedSave; //修改了界面数据，并且需要保存，但是还没有保存
    
    NSString *smartBidUpperPlaceholder;
    NSString *smartBidLowerPlaceholder;
    
//    NSDictionary *tempDic;         //临时的字典
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *titlesArr;
@property (nonatomic) BOOL saveBtnEnabled;
@property (strong,nonatomic) SmartBidEngine *engine;


@end

@implementation SmartBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    
    [self setNavButton];

    [self.view addSubview:self.tableView];
    UIView *superView = self.view;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        
    }];
  
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    self.title = @"智能投标";
    
    //-1表示没有输入过
    bidGuaranPersonCount = -1;
 
    
    [self initFooterLabel];
 
    //save btn
    saveBtn = [[CNBlueBtn alloc]init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.left = MainScreenWidth - 115;
    saveBtn.top = 20;
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    smartBidUpperPlaceholder = [NSString stringWithFormat:@"最大%@",[Util formatRMBWithoutUnit:@([ZAPP.myuser getSmartBidSingUpper])]];
    
    smartBidLowerPlaceholder = [NSString stringWithFormat:@"最小%@",[Util formatRMBWithoutUnit:@([ZAPP.myuser getSmartBidSingLower])]];
    
    bugeili_net_new
    
    progress_show
    [self requestDetailData];

 }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)initFooterLabel{
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:CNLocalizedString(@"tip.smartbid.tip",nil)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [CNLocalizedString(@"tip.smartbid.tip",nil) length])];
    
    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]  range:NSMakeRange(0, CNLocalizedString(@"tip.smartbid.tip",nil).length)];
    
    [attributedString1 addAttribute:NSForegroundColorAttributeName value: ZCOLOR(COLOR_TEXT_GRAY) range:NSMakeRange(0, CNLocalizedString(@"tip.smartbid.tip",nil).length)];

    footerTipLabel  = [[UILabel alloc]initWithFrame:CGRectMake(30, 95, MainScreenWidth-60, 20)];
//    footerTipLabel.textColor = CN_TEXT_GRAY;
//    footerTipLabel.font = [UIFont systemFontOfSize:13];
    footerTipLabel.numberOfLines = 0;
    footerTipLabel.attributedText = attributedString1;
//    footerTipLabel.text = ;
    CGSize newSize = [footerTipLabel sizeThatFits:CGSizeMake( MainScreenWidth-30*2, MAXFLOAT)];
    footerHeight = newSize.height+20;
    
    footerTipLabel.height = footerHeight;

}

-(UITableView *)tableView{
    
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSArray *)titlesArr{
    
    if(!_titlesArr){
        _titlesArr = @[@"智能投标",@"单日智能投标总额",@"标的种类",@"标的担保人数",@"单笔投资金额"];
    }
    return _titlesArr;

}

-(SmartBidEngine *)engine{
    
    if(!_engine){
        _engine = [[SmartBidEngine alloc]init];
    }
    
    return _engine;
}

-(void)setSaveBtnEnabled:(BOOL)saveBtnEnabled{
    
    _saveBtnEnabled = saveBtnEnabled;
    saveBtn.enabled = _saveBtnEnabled;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return indexPath.row == self.titlesArr.count ? footerHeight+75+20 : 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return stretch ? self.titlesArr.count +1: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNTableViewCell*cell = nil;

    __weak __typeof__(self) weakSelf = self;

    if(indexPath.row == 0){
        cell = [SBRightSwithCell cellWithNib:tableView];
        ((SBRightSwithCell *)cell).rightSwitch.on = stretch;
        [(SBRightSwithCell *)cell setSwitch:^(BOOL on) {
            [weakSelf handleStretch:on];
        }];
    }else if(indexPath.row == 2){
        cell = [SBBidTypeCell cellWithNib:tableView];
        
        [(SBBidTypeCell *)cell setBtn1Sel:commonBidSel];
        [(SBBidTypeCell *)cell setBtn2Sel:pledgeBidSel];

        WS(weakSelf)
        [(SBBidTypeCell *)cell setSBTypeChaned:^(BOOL btn1Sel, BOOL btn2Sel) {
            [weakSelf recordBidTypeSel:btn1Sel pledgeSel:btn2Sel];
        }];
    }else if(indexPath.row == 4){
        cell = [SBSingleInvestCell cellWithNib:tableView];
        [(SBSingleInvestCell*)cell configureField1Placeholder:smartBidLowerPlaceholder  field2:smartBidUpperPlaceholder];
        WS(weakSelf)
        [(SBSingleInvestCell *)cell setSingleInvestInputTextEditDone:^(NSString*text1, NSString*text2) {

            [weakSelf resolveSingleInvesInput:text1 textfield:text2];
        }];
        
        [(SBSingleInvestCell *)cell setSingleInvestInputTextEditBegin:^() {
            
            [weakSelf resolveSingleInvesInputBegin];
        }];
        
        [(SBSingleInvestCell *)cell setSingleInvestInputChanged:^(NSString*text1, NSString*text2) {

            [weakSelf resolveSingleInvesChanged:text1 textfield:text2];
        }];
        
        [self setSingleInvestInput:((SBSingleInvestCell *)cell).textfield1 textfield:((SBSingleInvestCell *)cell).textfield2];
        
    }
    else if(indexPath.row == self.titlesArr.count){
        NSString *const cell_id = @"footer_id";
        cell =  [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[CNTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel*footerTitleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, MainScreenWidth-60, 20)];
            footerTitleLabel.textColor = CN_TEXT_GRAY;
            footerTitleLabel.font = [UIFont systemFontOfSize:14];
            footerTitleLabel.numberOfLines = 0;
            footerTitleLabel.text = @"温馨提示：";
            [cell.contentView addSubview: footerTitleLabel];
            
            if(!footerTipLabel.superview){
                [cell.contentView addSubview: footerTipLabel];
            }
            
            if(![saveBtn superview]){
                [cell.contentView addSubview:saveBtn];
            }
            
            
        }
//        cell.bottomLineHidden = YES;
        saveBtn.enabled = _saveBtnEnabled;
        
    }
    else{
        
        WS(weakSelf)
        
        cell = [SBRightInputCell cellWithNib:tableView];
        [(SBRightInputCell *)cell setAccText:[self accText:indexPath]];
//        ((SBRightInputCell *)cell).textField.tag = indexPath.row;
        [(SBRightInputCell *)cell setInputText:^(NSString *text) {
//            NSLog(@"tag %d...%@",  text);
            [weakSelf resolveInput:indexPath text:text];
            
        }];
       
        //担保人数输入框,抵押标选中
        if (indexPath.row == 3 && (pledgeBidSel && !commonBidSel)) {
            ((SBRightInputCell *)cell).textField.text = @"";
            ((SBRightInputCell *)cell).textField.userInteractionEnabled = NO;
        }else{
            ((SBRightInputCell *)cell).textField.userInteractionEnabled = YES;
        }
        
        [self setInputText:indexPath textfield:((SBRightInputCell *)cell).textField];
        
        [(SBRightInputCell *)cell setInputTextChanged:^(NSString *text) {
            [self resolveInputChanged:indexPath text:text];
        }];
        
    }
    
    if (indexPath.row < self.titlesArr.count) {
        cell.textLabel.text = self.titlesArr[indexPath.row];
        cell.leftSpace = YES;
    }else{
        cell.textLabel.text = @"";
        cell.leftSpace = NO;
    }
    
    if (indexPath.row < 5) {
        cell.bottomLineHidden = NO;
        cell.bottomLineHidden = (indexPath.row == (stretch ? self.titlesArr.count-1: 0));

    }else{

        cell.bottomLineHidden = YES;

    }
    
    return cell;

}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return footerHeight;
//}

-(void)reloadTableDataByModify{
    [self.tableView reloadData];
    changeAnythingAndNeedSave = YES;
}

-(void)recordBidTypeSel:(BOOL)_commonSel pledgeSel:(BOOL)_pledgeSel{
    
    commonBidSel = _commonSel;
    pledgeBidSel = _pledgeSel;
    
    //只要普通标取消就清空人数
    if(!commonBidSel){
        bidGuaranPersonCount = -1;
    }
    
    self.saveBtnEnabled = [self calSaveBtnEnable];

    [self reloadTableDataByModify];
}

-(NSString *)accText:(NSIndexPath *)indexPath{
    
    NSString *temp = @"";
    
    switch (indexPath.row) {
        case 1:
            temp = @"元";
            break;
            
        case 3:
            temp = @"人以上";
            break;
            
        case 4:
            temp = @"次";
            break;
            
        default:
            break;
    }
    
    return temp;
}

-(void)handleStretch:(BOOL)on{
    stretch = on;
    [self.tableView reloadData];

    if (!on) {
        changeAnythingAndNeedSave = NO;
    }
    
    //
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStretchStatus)  object:nil];
    [self performSelector:@selector(changeStretchStatus) withObject:nil afterDelay:0.1];
}

// ui  text ---> model
-(void)resolveInput:(NSIndexPath *)indexPath text:(NSString *)text{
    
    if(indexPath.row == 1){
        
        if (text.length) {
            bidMoneyTotal = @([text doubleValue]);
        }else{
            bidMoneyTotal = nil;
        }

    }else if(indexPath.row == 3){
        
        if(commonBidSel  && [text length]){
            bidGuaranPersonCount = [text integerValue];
        }else{
            bidGuaranPersonCount = -1;
        }
        
        NSLog(@"bidGuaranPersonCount %lu", (unsigned long)bidGuaranPersonCount);

    }

    self.saveBtnEnabled = [self calSaveBtnEnable];
    changeAnythingAndNeedSave = YES;

}

-(void)resolveInputChanged:(NSIndexPath *)indexPath text:(NSString *)text{
    [self resolveInput:indexPath text:text];
}


//model  -----> ui text
-(void)setInputText:(NSIndexPath *)indexPath textfield:(UITextField *)field{
    
    if(indexPath.row == 1){
        field.text = [bidMoneyTotal doubleValue]>0? [NSString stringWithFormat:@"%.0f", [bidMoneyTotal doubleValue]]:@"";
     }else if(indexPath.row == 3){
         field.text = bidGuaranPersonCount>=0?[NSString stringWithFormat:@"%@", @(bidGuaranPersonCount)]:@"";
     }
}


//single invest   ui text ---->model
-(void)resolveSingleInvesInput:(NSString *)minFieldText textfield:(NSString *)maxFieldText{

    [self restoreTableAdjust4S];

    if(minFieldText.length){
        minMoneyCount = @([minFieldText doubleValue]);
    }else{
        minMoneyCount = nil;
    }
    
    if(maxFieldText.length){
        maxMoneyCount = @([maxFieldText doubleValue]);
    }else{
        maxMoneyCount = nil;
    }
    
    //NSLog(@"minMoneyCount %lf maxMoneyCount %lf", minMoneyCount, maxMoneyCount);
    
    self.saveBtnEnabled = [self calSaveBtnEnable];

    changeAnythingAndNeedSave = YES;
}

-(void)resolveSingleInvesInputBegin{
    
    [self hoistingTableAdjust4S];
}

//single invest   inspect ui text changed
-(void)resolveSingleInvesChanged:(NSString *)minFieldText textfield:(NSString *)maxFieldText{

    [self resolveSingleInvesInput:minFieldText textfield:maxFieldText];

}

-(void)setSingleInvestInput:(UITextField *)minField textfield:(UITextField *)maxField{
    
    minField.text = [minMoneyCount doubleValue]>0 ? [NSString stringWithFormat:@"%.0f", [minMoneyCount doubleValue]]:@"";
    maxField.text = [maxMoneyCount doubleValue]>0 ? [NSString stringWithFormat:@"%.0f", [maxMoneyCount doubleValue]]:@"";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save{
    
    [self.view endEditing:YES];
    
    changeAnythingAndNeedSave = NO;

    bugeili_net_new

    [self postSetting];
}



//计算保存按钮
-(BOOL)calSaveBtnEnable{
    
    if(!bidMoneyTotal){
        return NO;
    }
    
    if (!commonBidSel && !pledgeBidSel) {
        return NO;
    }
    
    //普通标，人数不能小于0
    if(commonBidSel && bidGuaranPersonCount < 0){
        return NO;
    }
    
    if ([minMoneyCount doubleValue] == 0 || [maxMoneyCount doubleValue] == 0) {
        return NO;
    }
    
    if (!minMoneyCount  || !maxMoneyCount ) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 获取数据

-(void)requestDetailData{
    
    WS(weakSelf)
    
    [self.engine getAutobiddingSetting:ZAPP.myuser.getUserID success:^(NSDictionary*dic){
        progress_hide
        [weakSelf resolvePersonSetting:dic];
    } failure:^(NSString *error) {
        progress_hide
    }];
}


-(void)resolvePersonSetting:(NSDictionary *)dic{
  
    if([self.engine canset:dic originvc:self]){
     
        
        NSInteger sethistory =  [dic[@"sethistory"] integerValue];
        if (sethistory == 1) {
            
            //
            bidMoneyTotal = @([dic[@"daylimit"] doubleValue]);
            //单笔投资最大金额
            maxMoneyCount = @([dic[@"moneyupper"] doubleValue]);
            //单笔投资最小金额
            minMoneyCount = @([dic[@"moneylower"] doubleValue]);
            //
            stretch = [dic[@"status"] boolValue];
            NSLog(@"resolvePersonSetting %d",stretch);

            //担保人数
            if(EMPTYOBJ_HANDLE(dic[@"warrcount"]) && [EMPTYOBJ_HANDLE(dic[@"warrcount"]) integerValue]>=0){
                
                bidGuaranPersonCount = [dic[@"warrcount"] integerValue];
            }
            

            NSArray* type = dic[@"type"];
            for (NSNumber *tempnum in type) {
                
                //普通标
                if ([tempnum integerValue] == 0) {
                    commonBidSel = YES;
                    continue;
                }
                
                //抵押标
                if ([tempnum integerValue] == 2) {
                    pledgeBidSel = YES;
                }
            }
            
            self.saveBtnEnabled = [self calSaveBtnEnable];

            [self.tableView reloadData];
        }
    }else{
        [self pushSina: dic[@"content"]];
    }
    
    
}


-(void)pushSina:(NSString *)url{
    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
    web.URLPath = url;
    //        web.URLPath = @"https:\/\/pay.sina.com.cn\/zjtg\/website\/view\/authorize.html?ft=3ffe6bed-ca0a-4a31-bea6-bb80922f5975" ;
    web.titleString = @"新浪收银台";
    web.completeHandle = self;
    WS(weakSelf)
    
    web.navigationBackHandler = ^{
        [weakSelf popToSetVC];
    };
    [self.navigationController pushViewController:web animated:YES];
}

//返回到个人界面
-(void)popToSetVC{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if([vc isKindOfClass:NSClassFromString(@"GeRenViewController")]){
////            [self.navigationController popViewControllerAnimated:YES];
////            [self.navigationController popToViewController:vc animated:YES];
//            break;
//        }
//    }
    
}

//授权完成
- (void)complete{
    NSLog(@"complete ... ");

     if(![self.navigationController.topViewController isKindOfClass:[SmartBidViewController class]]){
         [self.navigationController popViewControllerAnimated:YES];
     }
     
}

//授权返回
- (void)cancel{
    NSLog(@"cancel ... ");

    [self popToSetVC];

 
}



-(void)postSetting{
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    
    dic[@"status"] = @(stretch?1:0);
    dic[@"userid"] = ZAPP.myuser.getUserID;
    dic[@"moneyupper"] = maxMoneyCount;
    dic[@"moneylower"] = minMoneyCount;
    dic[@"daylimit"] = bidMoneyTotal;
    dic[@"warrcount"] = @(bidGuaranPersonCount);
 
    NSMutableArray *temparray = @[].mutableCopy;
    if(commonBidSel){
        [temparray addObject:@(0)];
    }
    
    if(pledgeBidSel){
        [temparray addObject:@(2)];
    }
    
    dic[@"type"] = temparray;
    
    progress_show
    
    WS(weakSelf)
    
    [self.engine autobiddingPost:dic success:^(NSDictionary *dic){
        
        if ([weakSelf.engine canset:dic originvc:self]) {
            NAV_POP
            progress_hide
        }else{
            [weakSelf pushSina:dic[@"content"]];
        }

    } failure:^(NSString *error) {

        progress_hide
    }];
    
}

-(void)changeStretchStatus{
    
    WS(weakSelf)
    
    [self.engine cancleAllHttpRequest];
    
    if(stretch){
        progress_show
    }
    
    [self.engine autobiddingStatusChange:stretch?1:0 userid:ZAPP.myuser.getUserID success:^{
        
        NSLog(@"----------changeStretchStatus %d",stretch);
        if (stretch) {
            [weakSelf requestDetailData];
        }
    } failure:^(NSString *error) {
        
    }];
}

-(void)customNavBackPressed{
    
    [self.view endEditing:YES];
    
    if (changeAnythingAndNeedSave && _saveBtnEnabled) {
        CustomIOSAlertView *alertView = [[CustomSaveAlertView alloc] initWithMessage:@"是否保存智能投标设置?" closeDelegate:self buttonTitles:@[@"不保存", @"保存"]];
        alertView.tag = 0;
        [alertView show];
        alertView.bkColor = [UIColor whiteColor];
    }else{
        [super customNavBackPressed];
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%zd", buttonIndex);
    [alertView close];
    
    if (buttonIndex==0) {
        [super customNavBackPressed];
    }else{
        [self save];
    }
    

}

-(void)hoistingTableAdjust4S{
    
    return;

    if(ScreenInch4s){
        [UIView animateWithDuration:.5f animations:^{
            self.tableView.top = -50;
//            [self.promptView setAlpha:1];;
        } completion:^(BOOL finished) {
//            self.promptView.hidden = NO;
        }];
    }
    

    
}

#pragma mark -

-(void)restoreTableAdjust4S{
    
    return;
    
    if(ScreenInch4s){
        [UIView animateWithDuration:.5f animations:^{
            self.tableView.top = 0;
            //            [self.promptView setAlpha:1];;
        } completion:^(BOOL finished) {
            //            self.promptView.hidden = NO;
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
