//
//  RedMoneyListViewController.m
//  Cashnice
//
//  Created by apple on 2017/2/13.
//  Copyright © 2017年 l. All rights reserved.
//

#import "RedMoneyListViewController.h"
#import "FilterRedMoneyViewController.h"
#import "BLSelView.h"
#import "RedMoneyCell.h"
#import "RaiseIntereCell.h"
#import "CustomTitledAlertView.h"
#import "CouponNetEngine.h"
#import "WebViewController.h"
#import "CouponGiftViewController.h"

@interface RedMoneyListViewController ()<FilterRedMoneyControllerDelegate>
{
    NSInteger querytype;
    
    BOOL firstRequestData;
    
    int curPage;

    
}
@property (strong, nonatomic) FilterRedMoneyViewController  *filervc;
@property (strong, nonatomic) UIView *containView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *illustrateBkView;

@property (weak, nonatomic) IBOutlet UILabel *illustrateLabel;


@property (weak, nonatomic) IBOutlet UIView *emptyBkView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImgView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;


@property (weak, nonatomic) IBOutlet UILabel *selLabel; //选择

@property (strong,nonatomic) CouponNetEngine *c_engine;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel; //总金额
@property (weak, nonatomic) IBOutlet UILabel *availLabel; //可用金额
@property (weak, nonatomic) IBOutlet UILabel *useLabel;   //生效金额
@end

@implementation RedMoneyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];
    
    querytype = 0;
    self.title = self.type == REDMONEY_TYPE_CASH? @"我的红包":@"我的优惠券";
//    if ( self.type == REDMONEY_TYPE_CASH) {
//        self.tableView.rowHeight = 93;
//    }else{
        self.tableView.estimatedRowHeight = 93;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
//    }
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xF0F0F0);

    self.emptyBkView.hidden = YES;
    
    [self adjustIllustrateBkView];
    
    

    [Util setScrollHeader:self.tableView target:self header:@selector(requestList) dateKey:[Util getDateKey:self]];
    
    [Util setScrollFooter:self.tableView target:self footer:@selector(requestListMore)];

    
    self.tableView.header.backgroundColor = HexRGB(0xF0F0F0);

    
    [self requestList];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestList) name:@"redmoneyfresh" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(UIView *)containView{
    
    if (!_containView) {
        _containView = [UIView new];
        _containView.backgroundColor = [UIColor clearColor];
    }
    
    return _containView;
}

-(CouponNetEngine *)c_engine{
    
    if(!_c_engine){
        _c_engine = [[CouponNetEngine alloc]init];
    }
    
    return _c_engine;
}


-(FilterRedMoneyViewController *)filervc{
    
    if (!_filervc) {
//        _filervc = FILTERREDSTORY(@"FilterRedMoneyViewController");
        _filervc = [[FilterRedMoneyViewController alloc] init];
        [self addChildViewController:_filervc];
        [self.containView addSubview:_filervc.view];
        _filervc.view.frame = self.containView.bounds;
        _filervc.delegate = self;
        [_filervc didMoveToParentViewController:self];
        
    }
    
    return _filervc;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(void)adjustIllustrateBkView{
  
    //调整
    if (self.type != REDMONEY_TYPE_CASH) {
        [self.illustrateBkView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        self.illustrateBkView.backgroundColor = [UIColor clearColor];
        //为了布局做的
        for (UIView *view in self.illustrateBkView.subviews) {
            view.hidden = (view.tag == 200 || view.tag == 201?NO:YES);
        }

    }
    
    UIView *line = [[UIView alloc]init];
    [self.illustrateBkView addSubview:line];
    
    [line setBackgroundColor:CN_SEPLINE_GRAY];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(self.illustrateBkView.mas_right);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.illustrateBkView.mas_bottom);
    }];
    
}

-(void)adjustEmptyView{
    
    self.emptyImgView.image = [UIImage imageNamed:self.type == REDMONEY_TYPE_CASH?@"packet_no":@"ticket_no"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openIllustrate:(id)sender {
    
    CustomTitledAlertView *alertView = [[CustomTitledAlertView alloc] initWithTitle: @"使用说明" andInfo:CNLocalizedString( self.type == REDMONEY_TYPE_CASH? @"tip.redmoney.packet.tip": @"tip.redmoney.myinterest.tip", nil)];
    alertView.tag = 0;
    [alertView show];
    [alertView formatAlertButton];
    alertView.bkColor = [UIColor whiteColor];
    alertView.messageTextColor = CN_TEXT_GRAY;
    
}

#pragma mark - BLSelViewDelegate
-(IBAction)filterAction{
    
    if (!_containView) {
        
//        self.blSelView.opened = YES;
        [self setArrowOpened:YES];
        
        [self.view addSubview:self.containView];
        
        UIView *superView = self.view;
        [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(50);
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        }];
        
        
        [self filervc];
        
    }else{
        
        if (self.containView.hidden) {
            self.containView.hidden = NO;
//            self.blSelView.opened = YES;
            [self setArrowOpened:YES];

        }else{
//            self.blSelView.opened = NO;
            [self setArrowOpened:NO];
            self.containView.hidden = YES;
        }
        
    }
    
}

-(void)filterRedMoneyDidSelected:(NSString *)fiterTitle tag:(NSInteger)tag{
    DDLogDebug(@"fiterTitle = %@", fiterTitle);
 
    self.selLabel.text = fiterTitle;
    [self setArrowOpened:NO];
    self.containView.hidden = YES;
    
    querytype = tag;
    
    //clear the ui data currently.
//    if(self.dataArray.count){
//        self.dataArray = nil;
//        [self.tableView reloadData];
//    }
    
    
    
    [self requestList];
    
}

-(void)filterRedMoneDidTapClose{
    
    [self setArrowOpened:NO];
    self.containView.hidden = YES;
    
}

-(void)setArrowOpened:(BOOL)opened{
    
//    _opened = opened;
    
    double rads = DEGREES_TO_RADIANS(opened?180:360);
    
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
    
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:0
                     animations:^{
                         self.arrowBtn.transform = transform;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (self.type == REDMONEY_TYPE_CASH) {
    
        RedMoneyCell *cell =  [RedMoneyCell cellWithNib:tableView];
        cell.model = self.dataArray[indexPath.row];
        return cell;
        
    }else{
        RaiseIntereCell *cell =  [RaiseIntereCell cellWithNib:tableView];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }

}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {

    id model = self.dataArray[indexPath.row];
    if ([model respondsToSelector:@selector(url)] && [[model valueForKey:@"_url"] length]) {
        NSString *url = [model valueForKey:@"_url"];
        
        CouponGiftViewController *wvc = [[CouponGiftViewController alloc]init];
        wvc.urlStr = url;
        wvc.atitle = @"转赠";
        
        [self.navigationController pushViewController:wvc animated:YES];
    }

    
}


-(void)requestList{
    
    curPage=0;

    [self postRequest];
}

-(void)postRequest{
    WS(ws);

    //    //只在第一次进入此界面加载缓存
    if (!firstRequestData) {
        firstRequestData = YES;
        self.c_engine.closeAutoCache = NO;
    }else{
        self.c_engine.closeAutoCache = YES;
    }
    
    
    [self.c_engine getCouponList:querytype
                         redType:self.type
                   queryFromList:YES
                            page:curPage
                      coupontype:nil
                      startmoney:0 success:^(NSDictionary*totolDic, NSArray *arr) {
                          [ws endFreshing];
                          
                          [ws updateUI:arr total:totolDic];
                      } failure:^(NSString *error) {
                          [ws endFreshing];
                          
                      }];
}

-(void)requestListMore{
    curPage++;
    [self postRequest];

}

-(void)updateUI:(NSArray *)arr total:(NSDictionary *)totalDic{
    
    DLog();
    
    NSInteger pageCount =  [[totalDic objectForKey:NET_KEY_PAGECOUNT] intValue];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    if ([arr count]) {
        [self.dataArray insertPage:curPage objects:arr];
    }


    
    if(arr.count){
        self.emptyBkView.hidden = YES;

    }else{
        self.emptyBkView.hidden = NO;
        
        
        NSString *tipStr = nil;
        switch (self.type) {
            case REDMONEY_TYPE_CASH:
                tipStr = @"红包";
                break;
                
            case REDMONEY_TYPE_RAISEINTEREST:
                //                self.title = @"选择加息券";
                tipStr = @"加息券";
                
                break;
                
            case REDMONEY_TYPE_ALLINTEREST:
                //                self.title = @"选择优惠券";
                tipStr = @"优惠券";
                
                break;
                
            default:
                break;
        }
        

        
        _emptyLabel.text = [NSString stringWithFormat:@"暂无“%@”的%@", self.selLabel.text,tipStr];
        [self adjustEmptyView];

    }
    
    [self.tableView reloadData];

    if(totalDic){
        
        _totalLabel.text = [Util formatRMBWithoutUnit:totalDic[@"total"]];
        _availLabel.text = [Util formatRMBWithoutUnit:totalDic[@"available"]];
        _useLabel.text = [Util formatRMBWithoutUnit:totalDic[@"used"]];
        _numLabel.text = [NSString stringWithFormat:@"%@个", totalDic[@"totalcount"] ];

    }

    
    self.tableView.footer.hidden = ((curPage + 1) >= pageCount);


}


-(void)endFreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];

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
