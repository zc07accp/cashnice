//
//  OptionTableViewDelegate.m
//  YQS
//
//  Created by a on 16/5/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanOptionTableViewDelegate.h"
#import "OptionTableViewCell.h"

@interface LoanOptionTableViewDelegate ()

@property (nonatomic, strong) NSArray *options;

@end

@implementation LoanOptionTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return [ZAPP.zdevice getDesignScale:40 ];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
 
    UIImage *currentImage = [self promotImageNameWithSelected:NO row:_selectedIndex];
    [self.delegate LoanOptionTableViewDidSelectedIndex:_selectedIndex title:self.options[_selectedIndex] image:currentImage isInited:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    //self.selectedIndex = [self orderForRow:selectedRow];
    
    UIImage *currentImage = [self promotImageNameWithSelected:NO row:indexPath.row];
    [self.delegate LoanOptionTableViewDidSelectedIndex:self.selectedIndex title:self.options[self.selectedIndex] image:currentImage isInited:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"OptionTableViewCell";
    
    OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.row == self.selectedIndex) {
        cell.optionAccessory.hidden = NO;
        cell.optionTitleLabel.textColor = ZCOLOR(@"#007aff");
        cell.promptImageView.image = [self promotImageNameWithSelected:YES row:indexPath.row];
    }else{
        cell.optionAccessory.hidden = YES;
        cell.optionTitleLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        cell.promptImageView.image = [self promotImageNameWithSelected:NO row:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.optionTitleLabel.font = [UtilFont systemLargeNormal];
    cell.optionTitleLabel.text = self.options[indexPath.row];
    
    return cell;
}

- (NSArray *)options {
    if (! _options) {
        _options = @[
                     @"还款日期从近到远",   //4
                     @"还款日期从远到近",   //3
                     @"本金还款从大到小",   //5
                     @"本金还款从小到大"    //6
                     ];
    }
    return _options;
}

- (UIImage *)promotImageNameWithSelected:(BOOL)selected row:(NSUInteger)row {
    return [UIImage imageNamed:[self promotImageWithSelected:selected row:row]];
}

- (NSArray *)imageNames {
    return @[@"date_yj", @"date_jy", @"money_dx", @"money_xd"];
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
