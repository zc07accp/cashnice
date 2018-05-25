//
//  NPDHeaderCrediView.m
//  Cashnice
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NPDHeaderCrediView.h"

#define NPD_FRAMEVIEW_HEIGHT  15.f

@implementation NPDHeaderCrediView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImageView *)duihaoImgView{
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_duihao"]];
    imgView.width = 8;
    imgView.height = 8;
    return imgView;
}

-(UILabel *)label:(NSString *)text certified:(BOOL)cer{
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = cer?CN_TEXT_BLUE:CN_TEXT_GRAY_9;
    [label sizeToFit];
    return label;
}

-(UIView *)frameView:(BOOL)cer{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, NPD_FRAMEVIEW_HEIGHT)];
    view.layer.cornerRadius = 2;
    view.layer.borderWidth = 0.5;

    view.layer.borderColor = cer?CN_TEXT_BLUE.CGColor:CN_COLOR_DD_GRAY.CGColor;
    return view;
}

-(void)fresh:(NSArray *)arr{

    CGFloat left = 0;
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i =0;i<arr.count;i++) {
        
        NSDictionary *dic = arr[i];
        
        UIView *view = [self frameView:[dic[@"identify"] boolValue]];
        [self addSubview:view];
        
        UILabel *label = [self label:dic[@"name"] certified:[dic[@"identify"] boolValue]];
        [view addSubview:label];
        label.left = 3;
        label.top=(NPD_FRAMEVIEW_HEIGHT-label.height)/2;
        
        UIImageView *imgView = [self duihaoImgView];
        [view addSubview:imgView];
        imgView.left = label.left+label.right-3;
        imgView.top=(NPD_FRAMEVIEW_HEIGHT-imgView.height)/2;
        if ([dic[@"identify"] boolValue]) {
        }else{
            imgView.width = 0;
        }

        view.width = imgView.right + 3;

        view.left = left;
       
        
        left += view.width+3;
        
    }
}


@end
