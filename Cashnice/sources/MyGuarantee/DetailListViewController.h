//
//  DetailListViewController.h
//  Cashnice
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "LoanDetailEngine.h"
#import "CNTitleDetailArrowCell.h"

@interface DetailListViewController : CustomViewController

@property (nonatomic, assign) NSInteger loanId; //借款项目ID
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *typeNameArr;
@property(nonatomic,strong) LoanDetailEngine *engine;
@property (nonatomic, strong) NSDictionary *detailDic;


+(instancetype)listDetailWith:(NSString *)type loanid:(NSInteger)loanid;
-(void)openWebProtocol;

//控制右侧按钮
-(DETAILCELL_RIGHTLABEL_TYPE)cellRightType:(NSIndexPath *)indexPath title:(NSString *)title;

//普通列表单元格
-(UITableViewCell *)cellForDetail:(UITableView *)tw indexPath:(NSIndexPath *)indexPath;



@end
