//
//  BilProgressCell.h
//  Cashnice
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface BillProgressCell : CNTableViewCell{

}
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic, strong) CAShapeLayer *progressLayer;


@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;

@property (nonatomic) BOOL continuing;//进行中

@property(nonatomic,strong) NSDictionary *resultDic;

@end
