//
//  GuaranteeOptionTableViewDelegate.m
//  YQS
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuaranteeOptionTableViewDelegate.h"
#import "OptionTableViewCell.h"

@interface GuaranteeOptionTableViewDelegate ()

@property (nonatomic, strong) NSArray *options;
@end


@implementation GuaranteeOptionTableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return [ZAPP.zdevice getDesignScale:40];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    UIImage *currentImage = [self promotImageNameWithSelected:NO row:_selectedIndex];
    [self.delegate guaranteeOptionTableViewDidSelectedIndex:_selectedIndex title:self.options[_selectedIndex] image:currentImage isInited:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    
    UIImage *currentImage = [self promotImageNameWithSelected:NO row:indexPath.row];
    [self.delegate guaranteeOptionTableViewDidSelectedIndex:self.selectedIndex title:self.options[self.selectedIndex] image:currentImage isInited:NO];
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
                     @"解冻日期从近到远",   //当前：4 历史：8
                     @"解冻日期从远到近",   //当前：3 历史：7
                     @"担保日期从近到远",   //10
                     @"担保日期从远到近",   //9
                     @"担保金额从大到小",   //11
                     @"担保金额从小到大"];  //12
    }
    return _options;
}

- (UIImage *)promotImageNameWithSelected:(BOOL)selected row:(NSUInteger)row {
    return [UIImage imageNamed:[self promotImageWithSelected:selected row:row]];
}

- (NSArray *)imageNames {
    return @[@"date_yj", @"date_jy", @"date_jy", @"date_yj", @"money_dx", @"money_xd"];
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
