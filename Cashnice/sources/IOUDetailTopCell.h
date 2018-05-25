//
//  IOUDetailTopCell.h
//  Cashnice
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"
#import "IOUDetailUnit.h"

@interface IOUDetailTopCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet HeadImageView *leftImgView;
@property (weak, nonatomic) IBOutlet HeadImageView *rightImgView;

@property (weak, nonatomic) IBOutlet UILabel *leftNameL;
@property (weak, nonatomic) IBOutlet UILabel *rightNameL;

@property(nonatomic,strong) IOUDetailUnit *detailUnit;
@end
