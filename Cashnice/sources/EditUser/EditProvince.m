//
//  RenmaiHeadTableViewController.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "EditProvince.h"
#import "EditCity.h"
#import "GeRenTableViewCell.h"

@interface EditProvince ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) EditCity *city;
@end

@implementation EditProvince

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EditCity *)city {
    if (_city == nil) {
        _city = ZEdit(@"EditCity");
        _city.delegate = self;
    }
    return _city;
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
[self setNavButton];
    [self setTitle:@"常居地"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZAPP.zprovince getProvinceCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:TABLE_TEXT_ROW_HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:20];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:20];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (BOOL)lastRow:(NSInteger)row {
    return row == ([ZAPP.zprovince getProvinceCount] - 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeRenTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.sepLine.hidden = [self lastRow:indexPath.row];
    
    cell.biaoti.text = [ZAPP.zprovince getProvinceName:indexPath.row];
    
    cell.detail.hidden = YES;
    
    cell.arrow.hidden = NO;
    
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    self.city.province = indexPath.row;
    [self.navigationController pushViewController:self.city animated:YES];
}

- (void)selecteWith:(int)province city:(int)city {
    [self.delegate selecteWith:province city:city];
}


@end
