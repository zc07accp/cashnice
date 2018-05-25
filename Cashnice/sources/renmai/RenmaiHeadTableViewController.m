//
//  RenmaiHeadTableViewController.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "RenmaiHeadTableViewController.h"
#import "GeRenTableViewCell.h"

@interface RenmaiHeadTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *rowNumInSection;
@property (strong, nonatomic) NSArray *rowNameArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLables;
@property (weak, nonatomic) IBOutlet UILabel *fullGuar;
@property (weak, nonatomic) IBOutlet UILabel *meToGuar;
@property (weak, nonatomic) IBOutlet UILabel *toMeGuar;

@property (strong, nonatomic) NSDictionary *dataDict;
@end

@implementation RenmaiHeadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ZCOLOR(COLOR_SEPERATOR_COLOR);
    
    _fullGuar.text = _meToGuar.text = _toMeGuar.text = @" ";
    _fullGuar.font = _meToGuar.font = _toMeGuar.font = [UtilFont systemBold:24];
    
    for (UILabel *l in self.titleLables) {
        l.font = [UtilFont systemLarge];
    }
}

- (void)updateUI{
    
    if(EMPTYOBJ_HANDLE(self.dataDict[NET_KEY_CREDITEACHOTHERCOUNT])){
        _fullGuar.text =  [NSString stringWithFormat:@"%@", [self.dataDict objectForKey:NET_KEY_CREDITEACHOTHERCOUNT]];
    }
    
    if(EMPTYOBJ_HANDLE(self.dataDict[NET_KEY_CREDITOTHERCOUNT])){
        _meToGuar.text = [NSString stringWithFormat:@"%@", [self.dataDict objectForKey:NET_KEY_CREDITOTHERCOUNT]];
    }
    
    if(EMPTYOBJ_HANDLE(self.dataDict[NET_KEY_CREDITMECOUNT])){
        _toMeGuar.text = [NSString stringWithFormat:@"%@", [self.dataDict objectForKey:NET_KEY_CREDITMECOUNT]];
    }
}

- (IBAction)itemAction:(UIControl *)sender {
    NSInteger index = sender.tag;
    [self.delegate renmaiheaderpressed:(int)index];
}


- (void)setTheDataDict:(NSDictionary *)dict {
    self.dataDict = dict;
    [self updateUI];
}

- (NSArray *)rowNumInSection {
    if (_rowNumInSection == nil) {
        _rowNumInSection = @[@(1), @(1), @(3)];
    }
    return _rowNumInSection;
}

- (NSArray *)rowNameArray {
    if (_rowNameArray == nil) {
        _rowNameArray = @[@[@"添加好友"], @[@"邀请好友"], @[@"没向我授信的人(我已向Ta授信)",@"已向我授信的人(我没向Ta授信)", @"已相互授信"]];
    }
    return _rowNameArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rowNumInSection.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.rowNumInSection objectAtIndex:section] integerValue];
}

- (BOOL)lastRow:(NSIndexPath *)indexPath {
    return indexPath.row == [[self.rowNumInSection objectAtIndex:indexPath.section] integerValue] - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:TABLE_TEXT_ROW_HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:section==0? 10 :10];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeRenTableViewCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.sepLine.hidden = [self lastRow:indexPath];
    
    cell.biaoti.text = [[self.rowNameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 2) {
        int num = 0;
        if (indexPath.row == 0) {
            num = [[self.dataDict objectForKey:NET_KEY_CREDITOTHERCOUNT] intValue];
        }
        else if (indexPath.row == 1) {
            num = [[self.dataDict objectForKey:NET_KEY_CREDITMECOUNT] intValue];
        }
        else {
            num = [[self.dataDict objectForKey:NET_KEY_CREDITEACHOTHERCOUNT] intValue];
        }
        cell.detail.text = [NSString stringWithFormat:@"%d", num];
    }
    else {
        cell.detail.text = @"";
    }
    cell.detail.hidden = indexPath.section != 2;
    
    cell.arrow.hidden = NO;
    
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    int idx = (int)(indexPath.section + indexPath.row);
    [self.delegate renmaiheaderpressed:idx];
}



@end
