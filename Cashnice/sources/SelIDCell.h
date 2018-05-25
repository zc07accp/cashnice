//
//  SelIDCell.h
//  Cashnice
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"
#import "CNTitleDetailArrowCell.h"

@interface SelIDCell : CNTitleDetailArrowCell

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (strong,nonatomic) void (^SelID) (NSInteger index);

-(void)configureSelID:(NSInteger)index buttonEnabled:(BOOL)enabled;

- (IBAction)selIDAction:(id)sender;
@end
