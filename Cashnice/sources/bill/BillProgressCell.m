//
//  BilProgressCell.m
//  Cashnice
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillProgressCell.h"

@implementation BillProgressCell

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];

    
    for (int i=0; i<3; i++) {
        UIView *view = [self.contentView viewWithTag:100+i];
        view.layer.cornerRadius = 5;
 
        CGFloat width = 110;
        if (MainScreenWidth<=320) {
            width = 90;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(view.center.x, view.bottom+(MainScreenWidth<=320?10:5), width, 40)];
        [self.contentView addSubview:label];
        label.tag = 200+i;
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HexRGB(0xc2c2c2);
        label.numberOfLines = 0;
        
        if (i == 0) {
            label.text = EMPTYSTRING_HANDLE(self.resultDic[@"request_time"]) ;
        }else if (i == 1) {
            label.text = EMPTYSTRING_HANDLE(self.resultDic[@"going_time"]);
        }else{
            label.text = EMPTYSTRING_HANDLE(self.resultDic[@"order_time"]);
        }

        label.left = view.center.x - label.width/2;
        if(label.left<0){
            label.left = 5;
        }
        if(label.right>MainScreenWidth){
            label.left = MainScreenWidth-label.width-5;
        }
        
    }

    [self progressDisplay];

    
}


-(void)progressDisplay{
    
    
    for (int i=0; i<2; i++) {
        
        UIView *view = [self.contentView viewWithTag:100+i];
        view.backgroundColor = CN_TEXT_BLUE;
    }
 
    UIView *view = [self.contentView viewWithTag:100+2];
    if (_continuing) {
        
        if (!_progressLayer) {
            _progressLayer = [CAShapeLayer layer];
            
            UIView *view2 = [self.contentView viewWithTag:100+2];
            UIView *view1 = [self.contentView viewWithTag:100+1];
            CGFloat width = view2.left - view1.left;
            
            CGRect rec = _progressLayer.frame;
            rec.size = CGSizeMake(self.progressView.width - width/2, self.progressView.height);
            _progressLayer.frame = rec;
            _progressLayer.backgroundColor = CN_TEXT_BLUE.CGColor;
            _progressView.backgroundColor = CN_COLOR_DD_GRAY;
            [_progressView.layer addSublayer:_progressLayer];
        }

        
        view.backgroundColor = CN_COLOR_DD_GRAY;
        self.tipLabel2.textColor = CN_TEXT_GRAY;
        self.tipLabel2.text = @"提现成功";
    }else{
        
        if (_progressLayer) {
            [_progressLayer removeFromSuperlayer];
            _progressLayer = nil;
        }
        
        _progressView.layer.backgroundColor = CN_TEXT_BLUE.CGColor;
        
        view.backgroundColor = CN_TEXT_BLUE;
        self.tipLabel2.textColor = CN_TEXT_BLUE;
        self.tipLabel2.text = @"提现成功";
    }
    
}


-(void)setContinuing:(BOOL)continuing{
    
    _continuing = continuing;
 
}


-(void)setResultDic:(NSDictionary *)resultDic{
    _resultDic = resultDic;

    
}



@end
