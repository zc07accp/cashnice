//
//  GuideViewController.h
//  DzNews
//
//  Created by zengyuan on 28/11/13.
//  Copyright (c) 2013 zengyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KSKIPGUIDE @"KSKIPGUIDE"

@protocol GuideViewControllerDelegate <NSObject>
-(void)guideDidExited;
@end

typedef void (^ButtonBlock)();

@interface GuideViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollview;
    NSArray *guides;
    UIButton *button;
    IBOutlet UIPageControl* pageCtrl;
    IBOutlet UIImageView* bkImgView;
    
    IBOutlet UIImageView* indiImgView;

    float bkImgViewX;
 
}
@property(strong,nonatomic) ButtonBlock button1Block;
@property(assign,nonatomic) id<GuideViewControllerDelegate>delegate;

+(BOOL)skipGuide;

@end
