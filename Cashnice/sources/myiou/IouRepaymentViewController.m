//
//  iouRepaymentViewController.m
//  Cashnice
//
//  Created by a on 16/7/29.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IouRepaymentViewController.h"
#import "RepayTypeTableViewCell.h"
#import "CertificateView.h"
#import "CertificateAdapterView.h"
#import "MyIouTableViewController.h"
#import "IOU.h"

@interface IouRepaymentViewController ()< UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate>
{
    CGFloat tableCellHeight;
    CGFloat tableHeaderHeight;
}

@property (strong, nonatomic) MKNetworkOperation *operation;
@property (strong, nonatomic) NSArray *iouRepayTypeList;
@property (strong, nonatomic) CertificateAdapterView *certifacateView;

@property (nonatomic) NSUInteger selectedRepayTypeIndexRow;
@property (nonatomic) NSUInteger selectedRepayTypeId;


@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *yuanPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountPromptLabel;
@property (nonatomic, weak) IBOutlet UITableView *repayTypeTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repayTypeTableHeight;
@property (weak, nonatomic) IBOutlet UIView *certificatesContainer;

@end

@implementation IouRepaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavButton];
    [self setupUI];
    
    [self tapBackground];
    [self connectToServer];
    
}

- (void)setupUI{
    self.title = @"还款";
    
    tableCellHeight = [ZAPP.zdevice getDesignScale:50.0];
    tableHeaderHeight = [ZAPP.zdevice getDesignScale:40.0];
    
    self.repayTypeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.repayTypeTable.bounces = NO;
    
    self.yuanPromptLabel.font = self.amountPromptLabel.font = [UtilFont systemLargeNormal];
    self.amountTextField.font = [UtilFont systemLargeNormal];
    self.actionButton.titleLabel.font = [UtilFont systemButtonTitle];
    
    //[self.actionButton setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
    //self.actionButton.enabled = NO;
    
    self.amountTextField.placeholder = [NSString stringWithFormat:@"请输入还款金额,应还款为%@", [Util formatRMBWithoutUnit:@(self.totalAmount)]];
    
    _certifacateView = [[CertificateAdapterView alloc] init];
    _certifacateView.target = self;
    _certifacateView.title = @"还款凭证";
    _certifacateView.userPerationEnabled = YES;
    //[_certifacateView addPreviewImageURLs:@[@"", @"", @"", @""]];
    
    [_certificatesContainer addSubview:_certifacateView];
    
    [_certifacateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_certificatesContainer);
        make.left.equalTo(_certificatesContainer);
        make.width.equalTo(_certificatesContainer);
        make.height.equalTo(_certificatesContainer);
    }];
}

- (IBAction)repaymentAction:(id)sender {
    self.amountTextField.text = [Util cutMoney:self.amountTextField.text];
    CGFloat amountValue = [self.amountTextField.text doubleValue];
    if (amountValue <= 0) {
        [Util toast:@"请输入还款金额"];
        return;
    }
    
    if (amountValue < self.totalAmount) {
        [Util toast:@"请确认还款金额是否正确"];
        return;
    }
    
    //先上传凭证
    __weak typeof(self) weakSelf = self;
    if (_certifacateView.certificates.count > 0) {
        
        progress_show
        [ZAPP.netEngine uploadIOUImages:_certifacateView.certificates completionHandler:^(id object) {
            ZAPP.myuser.uploadResponse = object;
            [weakSelf doRepay];
        } errorHandler:^{
            progress_hide
        }];
    }else{
        [self doRepay];
    }
}

- (void)doRepay{
    //发起还款
    __weak typeof(self) weakSelf = self;
    NSString *uiId = [NSString stringWithFormat:@"%zd", weakSelf.iouId];
    double amountValue = [weakSelf.amountTextField.text doubleValue];
    
    NSArray *uploadedFiles = ZAPP.myuser.uploadResponse[@"files"];
    NSMutableArray *attachments = [[NSMutableArray alloc] initWithCapacity:uploadedFiles.count];
    for (NSDictionary *file in uploadedFiles) {
        NSMutableDictionary *fileParam = [[NSMutableDictionary alloc] init];
        [fileParam setObject:file[@"url"] forKey:@"url"];
        [fileParam setObject:file[@"type"] forKey:@"type"];
        [fileParam setObject:file[@"name"] forKey:@"orgfilename"];
        
        [attachments addObject:fileParam];
    }
    
    [ZAPP.netEngine iouRepayActionWithUiId:uiId amount:amountValue repayType:weakSelf.selectedRepayTypeId attachments:attachments Compelte:^{
        progress_hide
        [Util toastStringOfLocalizedKey:@"tip.iou.repayment.success"];
        [self popViewController];
    } error:^{
        progress_hide
    }];
}

- (void)popViewController {
    /*  返回到借条首页
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[MyIouTableViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        };
    }
     */
    POST_IOULISTFRESH_NOTI;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)editingChanged:(id)sender {
    self.amountTextField.text = [Util cutMoney:self.amountTextField.text];

    /*
    if (amountValue > 0) {
        [self.actionButton setBackgroundColor:ZCOLOR(COLOR_NAV_BG_RED)];
        self.actionButton.enabled = YES;
    }else{
        [self.actionButton setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
        self.actionButton.enabled = NO;
    }
     */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.iouRepayTypeList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    CGFloat leftSapceWidth = [ZAPP.zdevice getDesignScale:10.0];
    
    UILabel *titlelable = [[UILabel alloc] init];
    [header addSubview:titlelable];
    
    titlelable.font = [UtilFont systemLarge];
    titlelable.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    titlelable.text = @"还款方式";
    [titlelable sizeToFit];
    [titlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header);
        make.bottom.equalTo(header);
        make.left.equalTo(@(leftSapceWidth));
    }];
    
    UIView *line = [[UIView alloc] init];
    [header addSubview:line];
    line.backgroundColor = ZCOLOR(COLOR_SEPERATOR_COLOR);
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.left.equalTo(@(leftSapceWidth));
        make.right.equalTo(header);
        make.bottom.equalTo(header);
    }];
    
    return header;
}

- (void)setSelectedRepayTypeIndexRow:(NSUInteger)selectedRepayTypeIndexRow{
    _selectedRepayTypeIndexRow = selectedRepayTypeIndexRow;
    if (self.iouRepayTypeList.count > selectedRepayTypeIndexRow) {
        NSDictionary *selectType = self.iouRepayTypeList[selectedRepayTypeIndexRow];
        self.selectedRepayTypeId = [selectType[@"id"] integerValue];
    }
}

- (void)setData{
    self.iouRepayTypeList = ZAPP.myuser.iouRepayTypeList;
    
    self.repayTypeTableHeight.constant = self.iouRepayTypeList.count * tableCellHeight + tableHeaderHeight;
    
    [self.repayTypeTable reloadData];
    if (self.iouRepayTypeList.count > 0) {
        self.selectedRepayTypeIndexRow = 0;
    }
}

- (void)loseData{
    
}

- (void)connectToServer{
    
    [self.operation cancel];
    bugeili_net
    progress_show
    __weak IouRepaymentViewController *weakSelf = self;
    self.operation = [ZAPP.netEngine getIouRepayTypesWithCompelte:^{
        IouRepaymentViewController *strongSelf = weakSelf;
        [strongSelf setData];
        progress_hide
    } error:^{
        IouRepaymentViewController *strongSelf = weakSelf;
        [strongSelf loseData];
        progress_hide
    }];
}


-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];
    [tap setNumberOfTouchesRequired:1];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.repayTypeTable] ||
        [touch.view isDescendantOfView:self.certifacateView]
        ) {
        [self tapOnce];
        return NO;
    }
    return YES;
}

-(void)tapOnce
{
    [self.view endEditing:YES];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *      CellIdentifier = @"RepayTypeTableViewCell";
    RepayTypeTableViewCell * cell       = (RepayTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *itemDict = self.iouRepayTypeList[indexPath.row];
    cell.titleLabel.text = itemDict[@"name"];
    
    NSURL *imgUrl = [NSURL URLWithString:itemDict[@"imgpath"]];
    [cell.headImageView setImageFromURL:imgUrl placeHolderImage:nil animation:NO];
    
//    [cell.headImageView setImage:[UIImage imageNamed:@"zhifubao.png"]];
    
    if (indexPath.row == self.selectedRepayTypeIndexRow) {
        cell.checkedImageView.image = [UIImage imageNamed:@"checked.png"];
    }else{
        cell.checkedImageView.image = [UIImage imageNamed:@"check.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row != self.selectedRepayTypeIndexRow) {
        self.selectedRepayTypeIndexRow = indexPath.row;
        [self.repayTypeTable reloadData];
    }
}

@end
