//
//  BLSelView.m
//  Cashnice
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BLSelView.h"



@implementation BLSelView

- (IBAction)tap:(id)sender {
 
    if (self.delegate) {
        [self.delegate arrawStateDidChanged:self];
    }
    
}


-(void)setOpened:(BOOL)opened{
    
    _opened = opened;
    
    double rads = DEGREES_TO_RADIANS(opened?180:360);

    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
    
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:0
                     animations:^{
                         self.arrowBtn.transform = transform;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}




@end
