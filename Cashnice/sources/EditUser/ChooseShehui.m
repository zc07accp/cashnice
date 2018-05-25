//
//  RenmaiHeadTableViewController.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ChooseShehui.h"
#import "GeRenTableViewCell.h"

@interface ChooseShehui ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *optArr;
@end

@implementation ChooseShehui

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
- (NSArray *)optArr {
    if (_optArr == nil) {
        _optArr = [NSArray arrayWithArray:[ZAPP.myuser getShehuiOptions]];
    }
    return _optArr;
}

BLOCK_NAV_BACK_BUTTON
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"选择社会职务"];
[self setNavButton];
    [self setTitle:@"选择社会职务"];
    
    [self.table reloadData];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"选择社会职务"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optArr count];
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
    return row == (self.optArr.count - 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeRenTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.sepLine.hidden = [self lastRow:indexPath.row];
    
    cell.biaoti.text = [self.optArr objectAtIndex:indexPath.row];
    
    cell.detail.hidden = YES;
    
    cell.arrow.hidden = NO;
    
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self.delegate selecteWith:[self.optArr objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
