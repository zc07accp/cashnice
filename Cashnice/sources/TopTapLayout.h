//
//  TopTapLayout.h
//  Cashnice
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopTapLayout : NSObject

@property (strong,nonatomic) NSArray *itemsArr;
@property (strong,nonatomic) void  (^SelItemFresh)(NSInteger index);
-(void)layout:(UIView *)superView;

@property(nonatomic) NSInteger selIndex;

@end
