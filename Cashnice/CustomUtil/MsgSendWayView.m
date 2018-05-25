//
//  MsgSendWayWindow.m
//  Cashnice
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MsgSendWayView.h"
#import "MsgSendWayCell.h"
#import "MsgSendWay.h"
#import "IOU.h"

@implementation MsgSendWayView{
    
    NSArray *waysArray;
    UIButton* closeTimeButton;
    UIButton *cancelButton;
    UIButton *okButton;
    UILabel *titleLabel;
    UITableView *_tableView;
    
    NSInteger selIndex;
    
    
    MsgSendWay *msway;
}

//
+(MsgSendWayView *)shareInstance{
    
    static id instance=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
        instance = [[MsgSendWayView alloc] initWithFrame:window.bounds];
    });

    return instance;

}

-(void)setUp{
    

    selIndex = 0;
    
    if (!closeTimeButton) {
        closeTimeButton = [[UIButton alloc] initWithFrame:self.bounds];
        [closeTimeButton addTarget:self action:@selector(actionCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        closeTimeButton.backgroundColor = [UIColor blackColor];
        closeTimeButton.alpha = 0.2;
        [self addSubview:closeTimeButton];
    }
    

    if(!titleLabel){

        
        CGFloat height = 200;
        
        UIView*chooseTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-height, MainScreenWidth, height)];
        chooseTimeView.backgroundColor = [UIColor whiteColor];
        
        //背后
        UIView*bkview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 38)];
        [chooseTimeView addSubview:bkview];
        bkview.backgroundColor = CN_TEXT_VIEW_LIGHTGRAY;
        
        //标题
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, chooseTimeView.frame.size.width, 38)];
        [chooseTimeView addSubview:titleLabel];
        titleLabel.textColor = CN_TEXT_GRAY;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"选择发送方式";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //取消
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 38)];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [cancelButton setTitleColor:CN_TEXT_GRAY forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(actionCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [chooseTimeView addSubview:cancelButton];
        
        //完成
        okButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 0, 50, 38)];
        okButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [okButton setTitleColor:CN_TEXT_BLACK forState:UIControlStateNormal];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(actionOKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [chooseTimeView addSubview:okButton];
        
        [self addSubview:chooseTimeView];
        
        if (!_tableView) {
            static float pick_y = 80.;
            
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, pick_y, MainScreenWidth, chooseTimeView.bounds.size.height - pick_y) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource =self;
            _tableView.backgroundColor = [UIColor clearColor];
            _tableView.tableFooterView = [UIView new];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [chooseTimeView addSubview:_tableView];
        }
    }
 
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    [self setUp];
    return self;
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return [MsgSendWay isWXAppInstalled]?1:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MsgSendWayCell *cell = (MsgSendWayCell *)[MsgSendWayCell cellWithNib:tableView];
    cell.selBtn.selected = indexPath.section == selIndex;
    switch (indexPath.section) {

        case 0:
            cell.titleLabel.text = @"短信";
            break;
        case 1:
            cell.titleLabel.text = @"微信";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selIndex = indexPath.section;
    [tableView reloadData];
}

-(void)show{

    //先取消以前的
    [self dismiss];
    
    [self setUp];
    
    [self performSelector:@selector(showW) withObject:nil afterDelay:0.1];
    return;
}

-(void)showW{

    AppDelegate *dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UIWindow *window=dele.window;
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [dele.window addSubview:self];

}

-(void)dismiss{

    [closeTimeButton removeFromSuperview];
    closeTimeButton = nil;
    
    cancelButton = nil;
    okButton = nil;
    titleLabel = nil;

    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_tableView removeFromSuperview];
    _tableView = nil;
    
    if([self superview]){
        [self removeFromSuperview];
    }
}

-(void)actionOKButtonClicked:(id)sender{

    [self dismiss];

    
    if (!msway) {
        msway = [[MsgSendWay alloc]init];
    }
    msway.iouID = self.iouID;
    
    BOOL result = YES;
    
    if (selIndex == 0) {
        if (self.phone) {
            result = [msway sendSMS:self.phone];
        }
    }else if (selIndex == 1) {
        result = [msway sendWeixin:self.weixin];
    }

    
    
    
    self.Complete(result);
}

-(void)actionCancelButtonClicked:(id)sender{
    [self dismiss];
    self.Complete(NO);

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
