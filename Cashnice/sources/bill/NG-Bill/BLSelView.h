//
//  BLSelView.h
//  Cashnice
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@protocol BLSelViewDelegate;

@interface BLSelView : UIView
{
}
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (nonatomic, weak) id<BLSelViewDelegate> delegate;
@property (nonatomic, assign) BOOL opened;

- (IBAction)tap:(id)sender;


@end

@protocol  BLSelViewDelegate<NSObject>
-(void)arrawStateDidChanged:(BLSelView *)view;
@end
