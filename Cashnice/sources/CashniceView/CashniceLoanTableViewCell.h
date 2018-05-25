//
//  CashniceLoanTableViewCell.h
//  Cashnice
//
//  Created by a on 16/2/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CashniceLoanTableViewCell <NSObject>

@required
-(void)cashniceLoanGuaranteeAction:(NSIndexPath *)indexPath;
-(void)cashniceLoanInvestAction:(NSIndexPath *)indexPath;

@end



@interface CashniceLoanTableViewCell : UITableViewCell


@property (nonatomic, weak) id<CashniceLoanTableViewCell> delegate;

- (void)updateCellData:(NSDictionary *)dataDictionary;



@end
