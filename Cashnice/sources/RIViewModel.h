//
//  RIViewModel.h
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIViewModel : NSObject
{
    BOOL _available;

}
@property(nonatomic, strong, readonly) NSAttributedString *interest;
@property(nonatomic, strong, readonly) NSString *use;

@property(nonatomic, strong, readonly) NSString *title;
@property(nonatomic, strong, readonly) NSString *range;
@property(nonatomic, strong, readonly) NSString *limit;

@property(nonatomic, readonly) UIColor *interestColor;

@property(nonatomic, readonly) UIColor *titleColor;
@property(nonatomic, readonly) UIColor *detailColor;
@property(nonatomic, readonly) UIImage *bkImage;

//查询条件
@property(nonatomic,readwrite) NSInteger querytype;

//YES从红包列表进来的，NO选择红包进来的
@property(nonatomic,assign) BOOL queryFromList;
@property(nonatomic, strong, readwrite) NSDictionary *dic;

@property(nonatomic) NSInteger  give; //是否可转赠
@property(nonatomic, strong, readonly) NSString *url;

@property (nonatomic) NSString *giveImage;

@end
