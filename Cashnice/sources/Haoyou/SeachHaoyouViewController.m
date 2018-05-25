//
//  SeachHaoyouViewController.m
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "SeachHaoyouViewController.h"
#import "SearchResultCell.h"
#import "NextButtonViewController.h"
#import "YaoqingHaoyou.h"
#import "PersonHomePage.h"

@interface SeachHaoyouViewController () {
	int rowHeight;
	int rowCnt;

	int curPage;
	int pageCount;
	int totalCount;

	BOOL justIn;

	NSString *currentSearchkey;
    
    BOOL willGoToDetail;
}

@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *largeRed;
@property (weak, nonatomic) IBOutlet UILabel *    nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *    numberLabel;
@property (weak, nonatomic) IBOutlet UIView *     searchBg;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIView *     soudaoView;
@property (weak, nonatomic) IBOutlet UIView *     meiSoudao;
@property (weak, nonatomic) IBOutlet UIView *     tableView;
@property (weak, nonatomic) IBOutlet UIView *     buttonview;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *    dataArray;
@end

@implementation SeachHaoyouViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);

	[Util setUILabelLargeGray:self.largeGray];
	[Util setUILabelLargeRed:self.largeRed];

	self.searchBg.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5];

	self.textfield.textColor   = ZCOLOR(COLOR_TEXT_GRAY);
	self.textfield.font        = [UtilFont systemLarge];
	self.textfield.placeholder = @"输入姓名、昵称、手机号";
	//self.textfield.placeholder = @"请输入搜索内容";

	rowHeight = 80;
	rowCnt    = 0;

	curPage    = 0;
	pageCount  = 0;
	totalCount = 0;

	[Util setScrollFooter:self.table target:self footer:@selector(rf)];
    
    self.textfield.keyboardType = UIKeyboardTypeDefault;
    [self.textfield addTarget:self action:@selector(tfDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (NSMutableArray *)dataArray {
	if (_dataArray == nil) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

- (void)rh {
	curPage = 0;
	[self connectToServer];
}

- (void)rf {
	curPage++;
	[self connectToServer];
}

- (void)setData {
	[self.table.footer endRefreshing];

	curPage    = [Util curPage:ZAPP.myuser.searchListDict];
	pageCount  = [Util pageCount:ZAPP.myuser.searchListDict];
	totalCount = [Util totalCount:ZAPP.myuser.searchListDict];

	if (curPage == 0) {
		[self.dataArray removeAllObjects];
	}
    
    int cnt = [[ZAPP.myuser.searchListDict objectForKey:NET_KEY_USERCOUNT] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.searchListDict objectForKey:NET_KEY_USERS]];
    }

	rowCnt = (int)[self.dataArray count];

	[self ui];
}

- (void)loseData {
	[self.table.footer endRefreshing];
}

- (void)connectToServer {
	[self.op cancel];
	bugeili_net
    progress_show
    
    WS(ws);

	self.op = [ZAPP.netEngine searchWithComplete:^{[ws setData]; progress_hide} error:^{[ws loseData]; progress_hide} searchkey:currentSearchkey page:curPage pagesize:DEFAULT_PAGE_SIZE];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"添加好友"];
    [self.op cancel];
    self.op = nil;
    [self loseData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"添加好友"];
	[self setTitle:@"添加好友"];
	
	[self.view endEditing:YES];

    if (willGoToDetail) {
        willGoToDetail = NO;
        return;
    }
	justIn           = YES;
	currentSearchkey = @"";
	[self ui];
}

- (void)ui {
	if (justIn) {
		justIn                  = NO;
		self.textfield.text     = @"";
		self.soudaoView.hidden  = YES;
		self.tableView.hidden   = YES;
		self.buttonview.hidden  = YES;
		self.meiSoudao.hidden   = YES;
		return;
	}

	self.nameLabel.text   = @"";
	self.numberLabel.text = [Util intWithUnit:totalCount unit:@""];

	self.soudaoView.hidden = rowCnt == 0;
	self.tableView.hidden  = rowCnt == 0;
	self.buttonview.hidden = rowCnt != 0;
	self.meiSoudao.hidden  = rowCnt != 0;
    
    self.table.footer.hidden = ((curPage + 1) >= pageCount);
    [self.table reloadData];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	 if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate    = self;
		((NextButtonViewController *)[segue destinationViewController]).titleString = [segue identifier];
	}
}

- (void)nextButtonPressed {
	[self.view endEditing:YES];
	YaoqingHaoyou *haoyou = ZSTORY(@"YaoqingHaoyou");
	[self.navigationController pushViewController:haoyou animated:YES];
}
- (IBAction)searchPressed:(id)sender {
	[self.view endEditing:YES];
    self.textfield.text = [self.textfield.text trimmed];
	if (self.textfield.text.length > 0) {
		currentSearchkey = self.textfield.text;
		[self rh];
	}
    else {

        [Util toastStringOfLocalizedKey:@"tip.inputtingSearchContent"];
    }
}

- (void)clearSearchResult {
//        justIn = YES;
//        rowCnt = 0;
//        [self.dataArray removeAllObjects];
//        [self ui];
    
}



- (BOOL)lastRow:(NSInteger)row {
	return row == rowCnt - 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return rowCnt;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ZAPP.zdevice getDesignScale:rowHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *v = [UIView new];
	v.userInteractionEnabled = NO;
	v.backgroundColor        = [UIColor clearColor];
	return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SearchResultCell *cell;
	static NSString *            CellIdentifier = @"cell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    [cell.img setHeadImgeUrlStr:[dict objectForKey:NET_KEY_HEADIMG]];

    cell.nameLabel.text                                 = [Util getUserRealNameOrNickName:dict];//@"张楠";
	((UILabel *)[cell.labelArray objectAtIndex:0]).text = [dict objectForKey:NET_KEY_ORGANIZATIONNAME];//@"山东恒生有限公司";
    NSString *duty = [dict objectForKey:NET_KEY_ORGANIZATIONDUTY];
    ((UILabel *)[cell.labelArray objectAtIndex:1]).text =  [Util spaceWithString:duty];//@"蓝海研究院主任";

	cell.sepLine.hidden = [self lastRow:indexPath.row];

	return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[self.view endEditing:YES];
    willGoToDetail = YES;
	PersonHomePage *person = DQC(@"PersonHomePage");
    [person setTheDataDict:[self.dataArray objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:person animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self searchPressed:nil];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (void)tfDidChanged:(id)sender {
    //self.textfield.text = [self.textfield.text trimmed];
}

@end
