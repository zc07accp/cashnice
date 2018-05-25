//
//  LoanItemsView.h
//  Cashnice
//
//  Created by a on 16/2/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoanItemsViewType) {
    LoanItemsViewTypeNormal,
    LoanItemsViewTypePrivilege
} ;

@protocol LoanItemsDelegate <NSObject>

- (void)guaranteeAction;

@end


@interface LoanItemsView : UIView

@property (nonatomic, assign) LoanItemsViewType loanItemsViewType;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<LoanItemsDelegate> delegate;

- (void)presentPrivilegedUser;
@end
