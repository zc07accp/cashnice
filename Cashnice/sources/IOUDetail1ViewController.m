//
//  IOUWSPayDetailViewController.m
//  Cashnice
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetail1ViewController.h"
#import "CustomViewController+PickDate.h"
#import "WriteIOUNetEngine.h"
#import "WriteUseageViewController.h"
#import "WebViewController.h"

@interface IOUDetail1ViewController ()
{
    NSString *selIndexPathTitle;
    NSArray *imagesArr; //借款人凭证图片数组
    
    WriteUseageViewController *useageViewController;

}

@end

@implementation IOUDetail1ViewController
@synthesize typeNameArr = _typeNameArr;
@synthesize protocol = _protocol;

- (void)viewDidLoad {
    [super viewDidLoad];

    bugeili_net_new

    progress_show
    [self getDetail];


    
    WS(weakSelf);
    [self.w_engine getLoanRateSuccess:^(NSArray *arr) {
        weakSelf.rateArr  = arr;
    } failure:^(NSString *error) {
        
    }];

    [self.w_engine getUseageList];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavRightBtn];
}


-(void)setNavRightBtn{
    
    [super setNavRightBtn];
    
    [self.rightNavBtn setTitle:@"删除" forState:UIControlStateNormal];
}

-(void)rightNavItemAction{
    
//    if ([IOUConfigure inBlackIOULimited]) {
//        return ;
//    }
    
    [self popDelAlert];
}


//子类重写
-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:@{@"hh":@[@"hh"]}];
        [tempArr addObject:@{@"bb":[IOUConfigure detail1:self.type]}];
        [tempArr addObject:@{@"btn":@[@"btn"]}];
        
        _typeNameArr = tempArr;
    }
    
    return _typeNameArr;
}

-(NSString *)protocol{
    
    if (!_protocol) {
        
        //被驳回
        if(self.type == 1 || self.type == 3){
            _protocol = [IOUConfigure makeEditProtol:detailUnit];
        }else{
            _protocol = [IOUConfigure makeNOEditProtol:detailUnit.ui_id];
        }
        

    }
    
    return _protocol;
}

-(NSString *)contentForIndexPath:(NSIndexPath *)path{
    return @"3333";
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView
        viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return [ZAPP.zdevice getDesignScale:ROW_HEIGHT_0];
    } else if (indexPath.section == 1) {
        return [ZAPP.zdevice getDesignScale:ROW_HEIGHT_1];
    } else if (indexPath.section == 2) {
//        return [ZAPP.zdevice getDesignScale:ROW_HEIGHT_BTN];
        return 75;
    }
    
    return 0;
}

//子类根据情况重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [self cellForTopRelation:tableView indexPath:indexPath];
    }else if (indexPath.section == 1) {
        return [self cellForDetail:tableView indexPath:indexPath];
    }else if (indexPath.section == 2) {
        return [self cellForBtn:tableView indexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        NSDictionary*dic  = self.typeNameArr[1];
        NSArray *arr = [[dic allValues] objectAtIndex:0];
        if ([arr count]) {
            
            selIndexPathTitle = [arr objectAtIndex:indexPath.row];
            
            if ([selIndexPathTitle isEqualToString:@"借条协议"]){
                [self openProtocal:self.protocol];
                return;
            }
            
            if ([selIndexPathTitle isEqualToString:@"借款用途及凭证"]){
                [self openDetailUseage];
                return;
            }
            
            
            if (self.type == 1 || self.type == 3) {
                //被驳回的
                if ([selIndexPathTitle isEqualToString:@"借款日期"]){
                    
                        [self openDatePicker:[Util dateMDByString:detailUnit.ui_loan_start_date]];
                }else if ([selIndexPathTitle isEqualToString:@"还款日期"]){
                    [self openDatePicker:[Util dateMDByString:detailUnit.ui_loan_end_date]];
                    [self setMinSelDate:[UtilDate getLaterEndDate:[Util dateMDByString:detailUnit.ui_loan_start_date] orgiEndDate:nil]];

                }else if ([selIndexPathTitle rangeOfString:@"年化利率"].location != NSNotFound){
  
                    [self openArrayPicker:[self makeRateArr] selectIndex:[self indexInRateArr]];

                }
            }

            
        }
        
    }
}


-(NSString *)cellDetail:(NSIndexPath *)indexPath title:(NSString *)title{
    
//    if(indexPath.section == 1 && [title isEqualToString:@"状态"]){
//        return @"等待对方确认";
//    }
//    else if(indexPath.section == 1 && [title isEqualToString:@"驳回原因"]){
//        return @"等待对方确认";
//    }
    
 
    return  [super cellDetail:indexPath title:title];
    
}

-(NSString *)bottomBtnName{
    return @"再次发送";
}

-(void)buttonAction:(id)sender{
    
    if ([IOUConfigure inBlackIOULimited]) {
        return ;
    }

    WITHOUT_EMAIL_PUSH;
    
    NSDate *end_date = [Util dateMDByString:detailUnit.ui_loan_end_date];
    if (![UtilDate endDateAvailable:end_date]) {
        [Util toast:IOUWARN_DATE];
        return;
    }
    
    
    //被驳回,重新发送
    if (self.type == 1 || self.type == 3) {
        
        
        
        WS(ws);


        
        NSMutableDictionary *parmas  = [NSMutableDictionary dictionary];
        parmas[@"userid"]=[ZAPP.myuser getUserID];
        parmas[@"ui_id"]=@(self.iouid);
        parmas[@"ui_status"]= @(12);
        parmas[@"ui_loan_rate"]= @(detailUnit.ui_loan_rate);
        parmas[@"ui_loan_start_date"]= detailUnit.ui_loan_start_date;
        parmas[@"ui_loan_end_date"]= detailUnit.ui_loan_end_date;;
        parmas[@"ui_loan_usage"]=@(detailUnit.ui_loan_usage);
        
        progress_show
        
        [self.w_engine updateIOU:parmas images:imagesArr success:^(NSInteger iouid, NSArray*arr) {
            
            if(![NSThread isMainThread]){
                NSLog(@"is not MainThread");
            }
            
            progress_hide
            [ws popMsgSend];
        } failure:^(NSString *error) {
            progress_hide
        }];
    }else{
        UIButton *btn = sender;
        if ([btn.titleLabel.text isEqualToString:@"再次发送"]) {
            
            WS(ws);

            [self sendAgain:^(BOOL suc) {
                if(suc){
                    POST_IOULISTFRESH_NOTI;
                    [ws popMsgSend];
                }else{
                    NSLog(@"sendAgain wrong");
                }
                
                
            }];
            
        }
    }
    

}

#pragma mark - 更改对应的操作
//确定操作，子类重写
-(void)datePickerDidSure{
    
    if ([selIndexPathTitle isEqualToString:@"借款日期"]){
        detailUnit.ui_loan_start_date = [Util stringByDateMD:self.showDate];
        
        NSDate *nowEndDate =  [Util dateMDByString:detailUnit.ui_loan_end_date];

        NSDate *newEndDate = [UtilDate getLaterEndDate:self.showDate orgiEndDate:nowEndDate];
        detailUnit.ui_loan_end_date = [Util stringByDateMD:newEndDate];
        
    }else if ([selIndexPathTitle isEqualToString:@"还款日期"]){
        detailUnit.ui_loan_end_date = [Util stringByDateMD:self.showDate];
    }

    
    [self.tableView reloadData];
    
    [self calculateTotalFee];
}

-(void)arrayPickDidSelIndex:(NSInteger)index{
    
    detailUnit.ui_loan_rate = [[self.rateArr[index] objectForKey:@"rateValue"] floatValue];

    [self.tableView reloadData];
    
    //重新计算费用
    [self calculateTotalFee];

}


-(void)openDetailUseage{

    //再次发送的，不能改. 驳回的，能改
    
    if (self.type == 0|| self.type==2 ) {
        //再次发送
        NSDictionary *dic = @{@"title":self.type==0||self.type==1?@"出借人凭证":@"借款人凭证",
                              @"action":@(NO)};
        [self openVoucher:@[dic]];
    }else{
        //驳回
        if (!useageViewController) {
            useageViewController = ZWIOU(@"WriteUseageViewController");
            
            //只有第一次打开用途界面的时候需要把获取到的url扔进去tongzhi
            NSArray *nowArr = self.type==0||self.type==1?detailUnit.voucherLoanSrc:detailUnit.voucherLoanDest;
            if(nowArr && nowArr.count){
                useageViewController.existedUrlsArr = nowArr;
            }
            
            if([detailUnit.iouUsage length]){
                useageViewController.selReasonDic = @{@"itemname":detailUnit.iouUsage,@"itemvalue":@( detailUnit.ui_loan_usage)};
            }
            
            useageViewController.deleagte = self;
            useageViewController.selId = self.type==0||self.type==1?0:1;
        }
        
        [self.navigationController pushViewController:useageViewController animated:YES];
    }
 
}

-(void)didSelectedUseage:(NSDictionary *)selReasonDic picsArr:(NSArray *)picsArr{
    
    detailUnit.ui_loan_usage = [selReasonDic[@"itemvalue"]integerValue];
    detailUnit.iouUsage = selReasonDic[@"itemname"] ;
    [self.tableView reloadData];
    imagesArr = picsArr;
    
    
}

-(void)updateUI:(IOUDetailUnit *)unit{
    [super updateUI:unit];
    

    //如果还款日期不合适自动修改
    if (![UtilDate endDateAvailable:[Util dateMDByString:detailUnit.ui_loan_end_date] ]) {
        NSDate *newDate =[UtilDate getLaterEndDate:[Util dateMDByString:detailUnit.ui_loan_start_date] orgiEndDate:nil];
        detailUnit.ui_loan_end_date = [Util stringByDateMD:newDate];
    }
    
    
    if ((self.type == 1 || self.type == 3) && (!unit.backReason||[unit.backReason length]==0)) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:@{@"hh":@[@"hh"]}];
        [tempArr addObject:@{@"bb":[IOUConfigure detail1:4]}];
        [tempArr addObject:@{@"btn":@[@"btn"]}];
        
        _typeNameArr = tempArr;
        [self.tableView reloadData];
        
    }
}


@end
