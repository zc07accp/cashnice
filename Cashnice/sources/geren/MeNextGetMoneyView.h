//
//  MeNextGetMoneyView.h
//  Cashnice
//
//  Created by apple on 2017/3/9.
//  Copyright © 2017年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeNextGetMoneyView : UIView

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (nonatomic, strong) NSString *fullDateStr;

@end
