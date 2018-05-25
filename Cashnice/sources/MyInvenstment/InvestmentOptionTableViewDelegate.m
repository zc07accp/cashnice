//
//  OptionTableViewDelegate.m
//  YQS
//
//  Created by a on 16/5/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentOptionTableViewDelegate.h"
#import "OptionTableViewCell.h"

@interface InvestmentOptionTableViewDelegate ()

@end

@implementation InvestmentOptionTableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return [ZAPP.zdevice getDesignScale:40];
}

- (NSUInteger)orderForRow:(NSUInteger)row {
    NSInteger order=0;
    switch (row) {
        case 0:
        {
            order = 4;
            break;
        }
        case 1:
        {
            order = 3;
            break;
        }
        case 2:
        {
            order = 2;
            break;
        }
        case 3:
        {
            order = 1;
            break;
        }
        case 4:
        {
            order = 5;
            break;
        }
        case 5:
        {
            order = 6;
            break;
        }
        default:
            break;
    }
    return order;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    
    NSUInteger row = 0;
    for(; row < [self options].count; row++){
        if (_selectedIndex == [self orderForRow:row]) {
            break;
        }
    }
    
    UIImage *currentImage = [self promotImageNameWithSelected:NO row:row];
    [self.delegate optionTableViewDidSelectedIndex:_selectedIndex title:self.options[row] image:currentImage isInited:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger selectedRow = indexPath.row;
    _selectedIndex = [self orderForRow:selectedRow];
    
    UIImage *currentImage = [self promotImageNameWithSelected:NO row:indexPath.row];
    
    [self.delegate optionTableViewDidSelectedIndex:self.selectedIndex title:self.options[selectedRow] image:currentImage isInited:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"OptionTableViewCell";
    
    OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
    
    if ([self orderForRow:indexPath.row] == self.selectedIndex) {
        cell.optionAccessory.hidden = NO;
        cell.optionTitleLabel.textColor = ZCOLOR(@"#007aff");
        cell.promptImageView.image = [self promotImageNameWithSelected:YES row:indexPath.row];
    }else{
        cell.optionAccessory.hidden = YES;
        cell.optionTitleLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        cell.promptImageView.image = [self promotImageNameWithSelected:NO row:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.optionTitleLabel.text = self.options[indexPath.row];
    
    return cell;
}

- (NSArray *)options {
    if (! _options) {
        _options = @[
                     @"收回日期从近到远",       //4     //
                     @"收回日期从远到近",       //3
                     @"投资日期从近到远",       //2
                     @"投资日期从远到近",       //1
                     @"本金收回从大到小",       //5
                     @"本金收回从小到大"];      //6
    }
    return _options;
}

- (UIImage *)promotImageNameWithSelected:(BOOL)selected row:(NSUInteger)row {
    return [UIImage imageNamed:[self promotImageWithSelected:selected row:row]];
}

- (NSArray *)imageNames {
    return @[@"date_yj", @"date_jy", @"date_yj", @"date_jy", @"money_dx", @"money_xd"];
}

- (NSString *)promotImageWithSelected:(BOOL)selected row:(NSUInteger)row {
    NSString *normalNamePrefix = [self imageNames][row];
    NSString *imageName;
    if (selected) {
        imageName = [NSString stringWithFormat:@"%@_select.png", normalNamePrefix];
    }else{
        imageName = [NSString stringWithFormat:@"%@.png", normalNamePrefix];
    }
    return imageName;
}

@end

