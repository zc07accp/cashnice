//
//  WIOU_ServeCell.m
//  Cashnice
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "WIOU_ServeCell.h"
#import "WebViewController.h"
#import "IOU.h"

@interface WIOU_ServeCell()
@property (nonatomic,strong)NSMutableDictionary *textSizeDic;
@end

@implementation WIOU_ServeCell

-(NSMutableDictionary *)textSizeDic{
    if (!_textSizeDic) {
        _textSizeDic = [NSMutableDictionary dictionary];
    }
    return _textSizeDic;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self updateLeftConstrains];
}

-(void)updateLeftConstrains{
    
    CGFloat width ;
    
    if([self.textSizeDic objectForKey:self.textLabel.text]){
        width = [[self.textSizeDic objectForKey:self.textLabel.text] doubleValue];
    }else{
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:15];
        label.text = self.textLabel.text ;
        CGSize contentSize =  [label sizeThatFits:CGSizeMake(MAXFLOAT, self.textLabel.frame.size.height)];
        width = contentSize.width;
        
        if ([self.textLabel.text length]) {
            [self.textSizeDic setObject:@(width) forKey:self.textLabel.text];
        }
    }
     self.btn.left = self.textLabel.left + width+ 6;
 
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.btn = [[UIButton alloc]init];
    [self.btn addTarget:self action:@selector(seeProtocal) forControlEvents:UIControlEventTouchUpInside];
    [self.btn setImage:[UIImage imageNamed:@"cardholder_hint"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btn];
    self.btn.frame = CGRectMake(self.textLabel.left + 6, ([ZAPP.zdevice getDesignScale:ROW_HEIGHT_1] - 16)/2, 16, 16);

    return self;
}

-(void)seeProtocal{

    WebViewController *wvc = [[WebViewController alloc]init];
    wvc.urlStr = IOU_PLATSERVE_ABOUT;
    wvc.atitle = @"平台服务费";
    [ZAPP.tabViewCtrl.selectedViewController pushViewController:wvc animated:YES];
}

-(void)setCounterfee:(CGFloat)counterfee{

    self.textLabel.text = [NSString stringWithFormat:@"平台服务费(%@)元",
                           [Util formatRMBWithoutUnit:@(counterfee)]
                           ];
    
    [self setNeedsLayout];
    
}

-(void)setIsPayed:(BOOL)isPayed{
    self.detailTextLabel.text = isPayed?@"已支付":@"未支付";
}

@end
