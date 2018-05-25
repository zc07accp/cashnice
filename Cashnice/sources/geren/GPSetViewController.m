//
//  GPSetViewController.m
//  Cashnice
//
//  Created by apple on 2016/11/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GPSetViewController.h"
#import "LocalAuthen.h"
#import "GPSetCell.h"
#import "UnlockManager.h"
#import "MsgDef.h"

@interface GPSetViewController (){
    
    BOOL gpOn; //手势密码是否开启
    BOOL touchIDON;//touch id是否开启
}
@property (strong, nonatomic)NSArray *rowNameArray;
@end

@implementation GPSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = ZCOLOR(COLOR_BG_GRAY);

    // Do any additional setup after loading the view.
    [self setNavButton];
    self.title = [[LocalAuthen sharedInstance] touchIDDeviceExisted]?@"指纹与手势密码":@"手势密码";

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureRows) name:MSG_GESTUREWINDOW_CLOSED object:nil];
    
    [self configureRows];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)configureRows{
    
    gpOn = [[LocalAuthen sharedInstance] isGesturePasswdOpened];
    touchIDON = [[LocalAuthen sharedInstance] touchIDAvailble]? [[LocalAuthen sharedInstance]isTouchIDOpened]:NO;
    
    
    NSMutableArray *tempArr = @[].mutableCopy;

    if (gpOn) {
        
        [tempArr addObject:@[@"手势密码", @"重置手势密码"]];
        
        if ([[LocalAuthen sharedInstance] touchIDDeviceExisted]) {
            [tempArr addObject:@[@"Touch ID指纹解锁"]];
        }
        
    }else{
        [tempArr addObject:@[@"手势密码"]];
    }
    
    self.rowNameArray = tempArr;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rowNameArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.rowNameArray objectAtIndex:section] count];
}
- (BOOL)lastRow:(NSIndexPath *)indexPath {
    return indexPath.row == [[self.rowNameArray objectAtIndex:indexPath.section] count] - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CNCOMMON_LISTTABLEROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0;
    }else{
        return [ZAPP.zdevice getDesignScale:15];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor        = ZCOLOR(COLOR_BG_GRAY);
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *   CellIdentifier = @"GPSetCell_id";
 
    GPSetCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *rowTitle = self.rowNameArray[indexPath.section][indexPath.row];
    cell.titleLabel.text = rowTitle;
    
    if ([rowTitle isEqualToString:@"重置手势密码"]) {
        cell.arrImgView.hidden = NO;
        cell.setSwitch.hidden = YES;
    }else{
        cell.arrImgView.hidden = YES;
        cell.setSwitch.hidden = NO;
    }
    cell.leftSpace = YES;
    cell.bottomLineHidden = [self lastRow:indexPath]?YES:NO;
    
    WS(weakSelf)
    
    cell.changeBlock = ^(BOOL on){
        [weakSelf changeValue:on indexPath:indexPath];
    };
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.setSwitch.on = gpOn;
        }
    }else{
//        cell.setSwitch.on = touchIDON;
        [cell.setSwitch setOn:touchIDON animated:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [UnlockManager presentGrestureSetter];

        }
    }
}

-(void)changeValue:(BOOL)on indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            //开启设置并且以前没有设置过密码
            if (on && ![UnlockManager gestureSetted]) {
                [UnlockManager presentGrestureSetter];

            }else{
                [[LocalAuthen sharedInstance] setGesturePasswd:on];
                [self configureRows];
            }
            

        }
    }else{
        
        //开启设置并且系统设置touch id没有设置

        if (on && ![[LocalAuthen sharedInstance] touchIDAvailble]) {
            [Util toast:touchIDDeviceSettingNote];
            [[LocalAuthen sharedInstance] setTouchIDOpened:NO];
  
            [self performSelector:@selector(configureRows) withObject:nil afterDelay:0.3];

        }else{
            [[LocalAuthen sharedInstance] setTouchIDOpened:on];
            [self configureRows];
        }
        

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
