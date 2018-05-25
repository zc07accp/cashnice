//
//  CheckingGuaranteeViewController.m
//  Cashnice
//
//  Created by a on 2018/4/12.
//  Copyright © 2018年 l. All rights reserved.
//

#import "CheckingGuaranteeViewController.h"
#import "CheckingGuaranteeTableViewCell.h"
#import "LoanDetailEngine.h"
#import "InviteWebViewController.h"
#import "InvitingGuaranteeViewController.h"
#import "MyLoansListViewController.h"
#import "PersonHomePage.h"

@interface CheckingGuaranteeViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger rowCount;
    int currentpage;
    int pageCount;
    int totalPageCount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton1;
@property (weak, nonatomic) IBOutlet UIButton *actionButton2;

@property (strong, nonatomic) LoanDetailEngine *loanDetailEngine;
@property (assign, nonatomic) long warrantyCount;

@property (strong, nonatomic) NSMutableArray *warrantyLists;
@property (strong, nonatomic) NSMutableArray *warrantyMetas;

@property (strong, nonatomic) NSString *confirmingText1;
@property (strong, nonatomic) NSString *confirmingText2;
@property (assign, nonatomic) double canLoan;
@end

@implementation CheckingGuaranteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"担保列表";
    
    self.actionButton1.layer.cornerRadius = 4;
    self.actionButton2.layer.cornerRadius = 4;
    self.actionButton1.layer.masksToBounds = YES;
    self.actionButton2.layer.masksToBounds = YES;
    
    rowCount       = 0;
    currentpage    = 0;
    pageCount      = 0;
    totalPageCount = 0;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rh) dateKey:[Util getDateKey:self]];
    
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.actionButton1.backgroundColor = CN_TEXT_GRAY_9;
    self.actionButton1.enabled = NO;
    [self connectToServer];
}

- (void)setupUI{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    NSString *s = [Util formatRMB:[NSNumber numberWithDouble:self.canLoan]];
    [self.actionButton1 setTitle:[NSString stringWithFormat:@"可借款%@", s] forState:UIControlStateNormal];
    
    if (self.canLoan > 0) {
        self.actionButton1.backgroundColor = CN_NAV_BKCOLOR;
        self.actionButton1.enabled = YES;
    }else{
        self.actionButton1.backgroundColor = CN_TEXT_GRAY_9;
        self.actionButton1.enabled = NO;
    }
    
    [self.tableView reloadData];
}


- (void)rh {
    currentpage = 0;
    [self connectToServer];
}

- (void)rf {
    currentpage++;
    [self connectToServer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.warrantyMetas.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [self headerViewWith:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [ZAPP.zdevice getDesignScale:28];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSMutableArray *)self.warrantyLists[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZAPP.zdevice getDesignScale:80];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSDictionary *info = self.warrantyLists[section][row];
    
    NSString *const cell_id = @"CheckingGuaranteeTableViewCell_id";
    
    CheckingGuaranteeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckingGuaranteeTableViewCell" owner:self options:nil];
        cell = nib[0];
    }
    
    cell.itemUserId = EMPTYSTRING_HANDLE(info[@"userid"]);
    
    NSString *name = EMPTYSTRING_HANDLE(info[@"userrealname"]);
    if (name.length < 1) {
        name = EMPTYSTRING_HANDLE(info[@"nickname"]);
    }
    
    [cell.headImageView setHeadImgeUrlStr:[info objectForKey:NET_KEY_HEADIMG]];
    cell.nameLabel.text = name;
    cell.positionLable.text = EMPTYSTRING_HANDLE(info[@"organizationduty"]);
    cell.orgLable.text = EMPTYSTRING_HANDLE(info[@"organizationname"]);
    
    cell.nameLabel.font = CNFont_30px;
    NSDictionary *att = @{NSFontAttributeName:CNFont_30px};
    cell.nameLableWidth.constant = [name sizeWithAttributes:att].width+4;
    double val = [info[@"warrantyval"] doubleValue];
    cell.amountLable.text = [Util formatRMB:[NSNumber numberWithDouble:val]];
    
    
    if (self.warrantyLists.count > 1) {
        if (section == 0) {
            cell.guarLabel.hidden = NO;
            cell.actionButton.hidden = YES;
        }else{
            cell.guarLabel.hidden = YES;
            cell.actionButton.hidden = NO;
        }
    }else if (self.warrantyLists.count == 1) {
        NSDictionary *meta = [self.warrantyMetas lastObject];
        NSString *type = meta[@"type"];
        //未确认
        if ([type hasPrefix:@"未确认"]) {
            cell.guarLabel.hidden = YES;
            cell.actionButton.hidden = NO;
        }
        //已确认
        if ([type hasPrefix:@"已确认"]) {
            cell.guarLabel.hidden = NO;
            cell.actionButton.hidden = YES;
        }
    }
    
    if (indexPath.row == 0) {
        cell.sepLine.hidden = YES;
    }
    
    cell.actionDelegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSDictionary *info = self.warrantyLists[section][row];
    PersonHomePage *p       = DQC(@"PersonHomePage");
    [p setTheDataDict:info];
    [self.navigationController pushViewController:p animated:YES];
}

- (void)changeAction:(NSString *)itemUserId {
    InvitingGuaranteeViewController *i = [[InvitingGuaranteeViewController alloc] init];
    i.loanId = [self.loanInfo[@"loanid"] integerValue];
    i.fromUserId = itemUserId;
    [self.navigationController pushViewController:i animated:YES];
}

- (IBAction)loanAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认借款？"message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 102;
    [alert show];
}

- (IBAction)inviteAction:(id)sender {
    InviteWebViewController *haoyou = [[InviteWebViewController alloc]init];
    haoyou.urlStr = [NSString stringWithFormat:@"%@%@%@", WEB_DOC_URL_ROOT, NET_PAGE_INVITE_INDEX, [ZAPP.myuser getUserID]];
    [self.navigationController pushViewController:haoyou animated:YES];
}

- (void)connectToServer{
    
    NSInteger loanId = [self.loanInfo[@"loanid"] integerValue];
    
    [self.loanDetailEngine getWarrantyList:loanId pageNum:currentpage success:^(NSDictionary *detail) {
        
        currentpage    = [Util curPage:detail];
        pageCount  = [Util pageCount:detail];
        totalPageCount = [Util totalCount:detail];
        self.tableView.footer.hidden = ((currentpage) >= pageCount);
        
        self.canLoan = [detail[@"can_loan"] doubleValue];
        
        [self parseDetail:detail[@"warrantys"]];
        
        [self setupUI];
        
    } failure:^(NSString *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)parseDetail:(NSArray *)list{
    //[self.warrantyMetas removeAllObjects];
    if (currentpage <= 1) {
        [self.warrantyMetas removeAllObjects];
        [self.warrantyLists removeAllObjects];
    }
    for (NSDictionary *dict in list) {
        if (dict.count == 2) {
            //Meta
            [self.warrantyMetas addObject:dict];
            if (currentpage <= 1) {
                [self.warrantyLists addObject:[[NSMutableArray alloc] init]];
            }
        }else{
            //担保人
            [self.warrantyLists.lastObject addObject:dict];
        }
    }
    
    if (self.warrantyMetas.count > 1) {
        NSDictionary *confirming = self.warrantyMetas[1];
        self.confirmingText2 = confirming[@"type"];
    }
    if (self.warrantyMetas.count > 0) {
        NSDictionary *confirming = self.warrantyMetas[0];
        self.confirmingText1 = confirming[@"type"];
    }
}

- (UIView *)headerViewWith:(NSInteger)section{
    UIView *headerView = [UIView new];
    UILabel *lab = [UILabel new];
    lab.tag = 1001;
    lab.font = CNFont_24px;
    lab.textColor = CN_TEXT_GRAY;
    lab.textAlignment = NSTextAlignmentLeft;
    
    if (self.warrantyMetas.count > section) {
        lab.text = self.warrantyMetas[section][@"type"];
    }
    
    [headerView addSubview:lab];
    
    UIView *line = [UIView new];
    line.backgroundColor = CN_TEXT_GRAY_9;
    [headerView addSubview:line];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.top.equalTo(headerView);
        make.bottom.equalTo(headerView);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.top.equalTo(headerView);
        make.height.mas_equalTo(1);
    }];
    
    return headerView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            NSInteger loanId = [self.loanInfo[@"loanid"] integerValue];
            progress_show
            
            [Util toast:@"确认借款成功，等待后台审核"];
            
            [self.loanDetailEngine postConfirmLoan:loanId value:self.canLoan success:^(NSDictionary *detail) {
                NSArray *vcx = self.navigationController.viewControllers;
                for (UIViewController *vc in vcx) {
                    if ([vc isKindOfClass:[MyLoansListViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
                
                progress_hide
            } failure:^(NSString *error) {
                progress_hide
            }];
        }
    }
}


- (LoanDetailEngine *)loanDetailEngine{
    if (_loanDetailEngine == nil) {
        _loanDetailEngine = [[LoanDetailEngine alloc] init];
    }
    return _loanDetailEngine;
}

- (NSMutableArray *)warrantyMetas{
    if (_warrantyMetas == nil) {
        _warrantyMetas = @[].mutableCopy;
    }
    return _warrantyMetas;
}

- (NSMutableArray *)warrantyLists{
    if (_warrantyLists == nil) {
        _warrantyLists = @[].mutableCopy;
    }
    return _warrantyLists;
}

@end
