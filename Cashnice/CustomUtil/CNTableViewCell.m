//
//  CNCellTableViewCell.m
//  Cashnice
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"
#import "IOU.h"

@implementation CNTableViewCell

-(void)layoutSubviews{

    [super layoutSubviews];
    self.textLabel.backgroundColor=[UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

 
    UIView *superView = self.contentView;
    [self addLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).equalTo(_leftSpace?@(SEPERATOR_LINELEFT_OFFSET):@0);
        make.width.equalTo(@(MainScreenWidth));
        make.bottom.equalTo(superView.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(1);
        
    }];

    line.hidden = _bottomLineHidden;

 }


-(void)setBottomLineHidden:(BOOL)bottomLineHidden{
    _bottomLineHidden = bottomLineHidden;
    line.hidden = _bottomLineHidden;
}

-(void)setLeftSpace:(BOOL)leftSpace{
    
    _leftSpace = leftSpace;

}

-(void)addLine{
    
    if(!line){
        line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        [line setBackgroundColor:ZCOLOR(COLOR_SEPERATOR_COLOR)];
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self addLine];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self addLine];
    return self;
}

+(instancetype)cellWithNib:(UITableView *)tableView{
    
    NSString *name = NSStringFromClass([self class]);
    if(!name){
        DLog(@"子类重写自定义");
        return nil;
    }
    
    NSString *const cell_id = [name stringByAppendingString:@"_id"];
    CNTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        cell = nib[0];
    }

    return cell;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *name = NSStringFromClass([self class]);
    if(!name){
        DLog(@"子类重写自定义");
        return nil;
    }
    
    NSString *const cell_id = [name stringByAppendingString:@"_id"];
    CNTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
     return cell;
}

@end
