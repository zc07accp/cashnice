//
//  TopTapLayout.m
//  Cashnice
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import "TopTapLayout.h"


@implementation TopTapLayout{
    
    UIView *coverView;
    UIView *bottomline;
}

-(void)layout:(UIView *)superView{
    
    coverView = superView;
    
    for (UIView *view in superView.subviews) {
        [view removeFromSuperview];
    }
    
    if(self.itemsArr.count == 0)return;
    
    CGFloat width = MainScreenWidth/self.itemsArr.count;
    CGFloat height = 35;
    
    for(NSInteger i=0; i<self.itemsArr.count; i++){
        
        UIButton *btn = [self tapButton:i];
        [superView addSubview:btn];
        btn.frame = CGRectMake( i*width, 0, width, height);
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = 100+i;
        if (i!=0) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake( i*width,(height-15)/2, 1, 15)];
            [superView addSubview:line];
            [line setBackgroundColor:CN_SEPLINE_GRAY];
        }

    }
    
    UIButton *btn = [coverView viewWithTag:100+0];
    btn.selected = YES;

    //bottom line
    
    UIView *longBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 34, MainScreenWidth, 1)];
    [superView addSubview:longBottomLine];
    longBottomLine.backgroundColor = CN_COLOR_DD_GRAY;

    
    bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, 34, btn.width, 1)];
    [superView addSubview:bottomline];
    bottomline.backgroundColor = HexRGB(0x1c3681);
    
    
}

-(void)setSelIndex:(NSInteger)selIndex{
    
    _selIndex = selIndex;
    
    for(NSInteger i=0; i<self.itemsArr.count; i++){
        UIButton *btn = [coverView viewWithTag:100+i];
        btn.selected = NO;
    }
    UIButton *btn = [coverView viewWithTag:100+selIndex];
    btn.selected = YES;
    
    [UIView animateWithDuration:0.0 animations:^{
        bottomline.left = btn.left;
    }];
}

-(void)clickAction:(UIButton *)sender{
    
    for(NSInteger i=0; i<self.itemsArr.count; i++){
        UIButton *btn = [coverView viewWithTag:100+i];
        btn.selected = NO;
    }
    
    sender.selected = YES;
    
    [UIView animateWithDuration:0.0 animations:^{
        bottomline.left = sender.left;
    }];
    
    if(self.SelItemFresh){
        self.SelItemFresh(sender.tag - 100);
    }
}


-(UIButton *)tapButton:(NSInteger )index{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:self.itemsArr[index] forState:UIControlStateNormal];
    [button setTitleColor:CN_TEXT_GRAY forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x1c3681) forState:UIControlStateSelected];
    button.titleLabel.font = CNFont(22);
    return button;
    
    
}

@end
