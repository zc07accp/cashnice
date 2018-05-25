//
//  CNCellTableViewCell.h
//  Cashnice
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizonLine.h"

@interface CNTableViewCell : UITableViewCell
{
    UIView *line;
}

@property (nonatomic) BOOL bottomLineHidden;

@property (nonatomic) BOOL leftSpace;

/**
 *  通过xib方式初始化cell
 *
 *  @param tableView
 *
 *  @return cell
 */
+(instancetype)cellWithNib:(UITableView *)tableView;

/**
 *  通过init方式初始化cell
 *
 *  @param tableView
 *
 *  @return cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
