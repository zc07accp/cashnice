//
//  CheckingGuaranteeViewController.m
//  Cashnice
//
//  Created by a on 2018/4/12.
//  Copyright © 2018年 l. All rights reserved.
//

#import "InvitingGuaranteeViewController.h"
#import "InvitingGuaranteeTableViewCell.h"
#import "LoanDetailEngine.h"
#import "InviteWebViewController.h"
#import "PersonHomePage.h"

@interface InvitingGuaranteeViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger rowCount;
    int currentpage;
    int pageCount;
    int totalPageCount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) LoanDetailEngine *loanDetailEngine;
@property (assign, nonatomic) long warrantyCount;
@property (strong, nonatomic) IBOutlet UIView *noDataView;

@property (strong, nonatomic) NSMutableArray *creditusers;

@end

@implementation InvitingGuaranteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"更换担保人";
    
    rowCount       = 0;
    currentpage    = 0;
    pageCount      = 0;
    totalPageCount = 0;
    
    [Util setScrollHeader:self.tableView target:self header:@selector(rh) dateKey:[Util getDateKey:self]];
    
    [Util setScrollFooter:self.tableView target:self footer:@selector(rf)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self connectToServer];
}

- (void)setupUI{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    [self.tableView reloadData];
    
    self.noDataView.hidden = self.creditusers.count > 0;
}

- (void)rh {
    currentpage = 0;
    [self connectToServer];
}

- (void)rf {
    currentpage++;
    [self connectToServer];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.creditusers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZAPP.zdevice getDesignScale:60];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    NSDictionary *info = self.creditusers[row];
    
    NSString *const cell_id = @"InvitingGuaranteeTableViewCell_id";
    
    InvitingGuaranteeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InvitingGuaranteeTableViewCell" owner:self options:nil];
        cell = nib[0];
    }
    
    NSString *name = EMPTYSTRING_HANDLE(info[@"userrealname"]);
    if (name.length < 1) {
        name = EMPTYSTRING_HANDLE(info[@"nickname"]);
    }
    
    [cell.headImageView setHeadImgeUrlStr:[info objectForKey:NET_KEY_HEADIMG]];
    cell.nameLabel.text = name;
    cell.positionLable.text = EMPTYSTRING_HANDLE(info[@"organizationduty"]);
    cell.orgLable.text = EMPTYSTRING_HANDLE(info[@"organization"]);
    
    cell.nameLabel.font = CNFont_30px;
    NSDictionary *att = @{NSFontAttributeName:CNFont_30px};
    cell.nameLableWidth.constant = [name sizeWithAttributes:att].width+4;
    
    cell.actionButton.enabled = YES;
    [cell.actionButton setTitleColor:CN_TEXT_BLUE forState:UIControlStateNormal]; ;
    
    if (indexPath.row == 0) {
        cell.sepLine.hidden = YES;
    }
    cell.actionDelegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    NSDictionary *info = self.creditusers[row];
    PersonHomePage *p       = DQC(@"PersonHomePage");
    [p setTheDataDict:info];
    [self.navigationController pushViewController:p animated:YES];
}

- (void)invitingAction:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    NSDictionary *info = self.creditusers[row];
    NSString *itemUserid = EMPTYSTRING_HANDLE(info[@"userid"]);
    
    [self.loanDetailEngine changeWarranty:self.loanId fromUser:self.fromUserId toUser:itemUserid success:^(NSDictionary *detail) {
        //[self connectToServer];
        [Util toast:@"更换担保成功"];
        
        InvitingGuaranteeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.actionButton.enabled = NO;
        [cell.actionButton setTitleColor:CN_TEXT_GRAY_9 forState:UIControlStateNormal];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [self connectToServer];
    }];
}

/*
- (IBAction)loanAction:(id)sender {
    NSInteger loanId = [self.loanInfo[@"loanid"] integerValue];
    
    progress_show
    [self.loanDetailEngine postConfirmLoan:loanId value:self.canLoan success:^(NSDictionary *detail) {
        [self.navigationController popViewControllerAnimated:YES];
        progress_hide
    } failure:^(NSString *error) {
        progress_hide
    }];
}
*/

- (IBAction)inviteAction:(id)sender {
    InviteWebViewController *haoyou = [[InviteWebViewController alloc]init];
    haoyou.urlStr = [NSString stringWithFormat:@"%@%@%@", WEB_DOC_URL_ROOT, NET_PAGE_INVITE_INDEX, [ZAPP.myuser getUserID]];
    [self.navigationController pushViewController:haoyou animated:YES];
}

- (void)connectToServer{
    
    [self.loanDetailEngine getWithoutWarrantyList:self.loanId fromUser:self.fromUserId pageNum:currentpage success:^(NSDictionary *detail) {
        
        if (currentpage == 0) {
            [self.creditusers removeAllObjects];
        }
        
        if (![detail[@"creditusers"] isKindOfClass:[NSNull class]] && ((NSArray *)detail[@"creditusers"]).count > 0) {
            [self.creditusers insertPage:currentpage objects:detail[@"creditusers"]];
        }
        
        rowCount = [self.creditusers count];
        
        self.tableView.footer.hidden = ((currentpage) >= pageCount);
        
        [self setupUI];
        
    } failure:^(NSString *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        self.noDataView.hidden = NO;
    }];
    
    /*
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
     */
}

- (UIView *)noDataView{
    if (! _noDataView) {
        _noDataView = [[UIView alloc] init];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wushuju.png"]];
        [_noDataView addSubview:img];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.font = CNFont_24px;
        lab.textColor = HexRGB(0x666666);
        lab.text = @"当前暂无符合条件的担保人可更换，您可以邀请新的好友加入";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.numberOfLines = 0;
        [_noDataView addSubview:lab];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.top.equalTo(_noDataView.mas_top).mas_offset([ZAPP.zdevice scaledValue:45]);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.centerX.equalTo(_noDataView).mas_offset(3);
            
            make.top.equalTo(img.mas_bottom).mas_offset([ZAPP.zdevice scaledValue:35]);
            make.left.equalTo(_noDataView).mas_offset(20);
            make.right.equalTo(_noDataView).mas_offset(-20);
        }];
        
        [self.tableView addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top).mas_offset([ZAPP.zdevice scaledValue:42]);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _noDataView.hidden = YES;
    }
    
    return _noDataView;
}


- (LoanDetailEngine *)loanDetailEngine{
    if (_loanDetailEngine == nil) {
        _loanDetailEngine = [[LoanDetailEngine alloc] init];
    }
    return _loanDetailEngine;
}

- (NSMutableArray *)creditusers{
    if (_creditusers == nil) {
        _creditusers = @[].mutableCopy;
    }
    return _creditusers;
}

@end
