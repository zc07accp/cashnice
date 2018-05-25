//
//  TopTapView.h
//  Cashnice
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  TopTapDelegate<NSObject>
-(void)topTap:(NSInteger)index;
@end

@interface TopTapView : UIView

@property (weak, nonatomic) IBOutlet UILabel *topLabel1;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel1;
@property (weak, nonatomic) IBOutlet UILabel *redDot1;
@property (weak, nonatomic) IBOutlet UIButton *arrow1;

@property (weak, nonatomic) IBOutlet UILabel *topLabel2;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel2;
@property (weak, nonatomic) IBOutlet UILabel *redDot2;
@property (weak, nonatomic) IBOutlet UIButton *arrow2;

@property (weak, nonatomic) IBOutlet UILabel *yuanLabel1;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel2;

@property (weak, nonatomic) id<TopTapDelegate> delegate;

- (IBAction)tap:(id)sender;

-(void)setRed1Count:(NSInteger)count;
-(void)setRed2Count:(NSInteger)count;

@end
