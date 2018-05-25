//
//  MyIouOptionTableViewDelegate.m
//  Cashnice
//
//  Created by a on 16/7/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyIouOptionTableViewDelegate.h"

@interface MyIouOptionTableViewDelegate ()

@property (nonatomic, strong) NSArray *debtOptionTitlesArray;
@property (nonatomic, strong) NSArray *creditorTitlesArray;

@property (nonatomic, strong) NSArray *debtOptionValuesArray;
@property (nonatomic, strong) NSArray *creditorOptionValuesArray;

@end

@implementation MyIouOptionTableViewDelegate

- (NSUInteger)orderForRow:(NSUInteger)row {
    return self.iouListPageType == IouListPageTypeDebter        ?
        [self.debtOptionValuesArray[row] unsignedIntegerValue]  :
        [self.creditorOptionValuesArray[row] unsignedIntegerValue]    ;
}

- (NSUInteger)rowFromOrder:(NSUInteger)order{
    NSUInteger row = 0;
    for (; row < [self options].count; row++) {
        if (order == [self orderForRow:row]) {
            break;
        }
    }
    return row;
}

- (NSArray *)options {
    return self.iouListPageType == IouListPageTypeDebter        ?
        self.debtOptionTitlesArray                              :
        self.creditorTitlesArray                                ;
}

- (NSArray *)debtOptionValuesArray{
    if (! _debtOptionValuesArray) {
        //借款
        if (!self.isHistorical) {
            //正在进行
            _debtOptionValuesArray = @[@(2),        //出借日远到近,ASC(出借日为过去日期)
                                       @(1),
                                       @(3),        //收回日远到近,将来日期远->近，DESC
                                       @(4),
                                       @(5),
                                       @(6)];
        }else{
            //历史
            _debtOptionValuesArray = @[@(2),        //出借日远到近,ASC(出借日为过去日期)
                                       @(1),
                                       @(4),        //收回日远到近，过去日期远->近，ASC
                                       @(3),
                                       @(5),
                                       @(6)];
        }
    }
    return _debtOptionValuesArray;
}

- (NSArray *)creditorOptionValuesArray {
    if (! _creditorOptionValuesArray) {
        //出借
        if (!self.isHistorical) {
            _creditorOptionValuesArray = @[@(2),
                                           @(1),
                                           @(3),
                                           @(4),
                                           @(5),
                                           @(6)];
        }else{
            _creditorOptionValuesArray = @[@(2),
                                           @(1),
                                           @(4),
                                           @(3),
                                           @(5),
                                           @(6)];
        }
    }
    return _creditorOptionValuesArray;
}

- (NSArray *)debtOptionTitlesArray{
    if (! _debtOptionTitlesArray) {
        _debtOptionTitlesArray = @[
                                   @"借入日期从远到近",       //1
                                   @"借入日期从近到远",       //2
                                   @"还款日期从远到近",       //3
                                   @"还款日期从近到远",       //4
                                   @"本金还款从大到小",       //5
                                   @"本金还款从小到大"];      //6
    }
    return _debtOptionTitlesArray;
}

- (NSArray *)creditorTitlesArray{
    if (! _creditorTitlesArray) {
        _creditorTitlesArray = @[
                                 @"出借日期从远到近",       //1
                                 @"出借日期从近到远",       //2
                                 @"收回日期从远到近",       //3
                                 @"收回日期从近到远",       //4
                                 @"本金收回从大到小",       //5
                                 @"本金收回从小到大"];      //6
    }
    return _creditorTitlesArray;
}

@end
