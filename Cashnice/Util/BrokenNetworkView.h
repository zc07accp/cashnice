//
//  BrokenNetworkView.h
//  Cashnice
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrokenNetworkView : UIView
@property (weak, nonatomic) IBOutlet UIButton *freshBtn;

- (IBAction)fresh:(id)sender;

@property(strong,nonatomic)void (^freshAction)();

@end
