//
//  LocalViewGuide.h
//  Cashnice
//
//  Created by apple on 2016/11/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalViewGuide : NSObject
{
    UIView *guideBkView;
    
    UIImageView *guideImgView;
    
    UIButton *tap_btn;

}

@property (nonatomic) CGRect reltivShow2Rect;

+(BOOL)firstPersonGuideRun;
+(BOOL)secondPersonGuideRun;


-(void)show;
-(void)show2:(CGRect)relrec;
-(void)showSmartBid:(CGRect)relrec;

-(void)clearAll;

@end
