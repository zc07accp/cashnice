//
//  CNTitleDetailArrowCell.m
//  Cashnice
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTitleDetailArrowCell.h"

@implementation CNTitleDetailArrowCell{
    UIImageView *accView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.left = SEPERATOR_LINELEFT_OFFSET;
//    self.textLabel.textColor = CN_TEXT_BLACK;

    [accView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.and.height.equalTo(@12);
        make.right.equalTo(self.mas_right).mas_offset(-SEPERATOR_LINELEFT_OFFSET);
    }];
 
    if(self.showAcc){

        self.detailTextLabel.left = MainScreenWidth - self.detailTextLabel.width - SEPERATOR_LINELEFT_OFFSET - 22;

    }else{
         self.detailTextLabel.left = MainScreenWidth - self.detailTextLabel.width - SEPERATOR_LINELEFT_OFFSET;
    }

    
    switch (self.rightLabelType) {
        case RIGHTLABEL_ALIGNRIGHT:
            
            self.detailTextLabel.left = MainScreenWidth - self.detailTextLabel.width - SEPERATOR_LINELEFT_OFFSET ;
            accView.hidden = YES;

            break;
            
        case RIGHTLABEL_RIGHTSPACE_SHOWACC:
            self.detailTextLabel.left = MainScreenWidth - self.detailTextLabel.width - SEPERATOR_LINELEFT_OFFSET - 22;
            accView.hidden = NO;
            break;
            
        case RIGHTLABEL_RIGHTSPACE_HIDEACC:
            self.detailTextLabel.left = MainScreenWidth - self.detailTextLabel.width - SEPERATOR_LINELEFT_OFFSET -22;
            accView.hidden = YES;
            break;
        default:break;
            
    }
    
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
 
    NSString *const cell_id = [NSStringFromClass([self class]) stringByAppendingString:@"_id"];
    CNTitleDetailArrowCell *cell =  [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI{
 
    self.textLabel.textColor = CN_TEXT_BLACK ;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    
    self.detailTextLabel.textColor = CN_TEXT_BLACK ;
    self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    accView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"row_grey"]
                            ];
    accView.width = 12;
    accView.height= 12;
    [self.contentView addSubview:accView];
    accView.hidden = YES;
}

-(void)configureTitle:(NSString *)title detail:(NSString *)detail showAcc:(BOOL)ashowAcc{
    
    if (!title) {
        return;
    }
    self.textLabel.text =  title;
    self.detailTextLabel.text = detail.length?detail: @"";

   self.showAcc = ashowAcc;
 }

-(void)configureTitle:(NSString *)title detail:(NSString *)detail rightLabelType:(DETAILCELL_RIGHTLABEL_TYPE)rightLabelType{
    
    
    if (!title) {
        return;
    }
    self.textLabel.text =  title;
    self.detailTextLabel.text = detail.length?detail: @"";
    self.rightLabelType = rightLabelType;
    
}


-(void)configureTitleAtt:(NSAttributedString *)title detail:(NSString *)detail showAcc:(BOOL)ashowAcc{
    
    if (!title) {
        return;
    }
    
    
    self.textLabel.attributedText =  title;
    self.detailTextLabel.text = detail.length?detail: @"";
    
    self.showAcc = ashowAcc;
}

-(void)setShowAcc:(BOOL)showAcc{
    _showAcc = showAcc;
    accView.hidden = !showAcc;

}

@end
