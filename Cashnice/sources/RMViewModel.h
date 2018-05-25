//
//  RMViewModel.h
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, REDMONEY_TYPE) {
    REDMONEY_TYPE_CASH,//红包
    REDMONEY_TYPE_RAISEINTEREST, //加息券（优惠券的接口都是一个）
    REDMONEY_TYPE_DECREASEINTEREST, //降息券
    REDMONEY_TYPE_ALLINTEREST  //所有的优惠券

} ;

@interface RMViewModel : NSObject
{
    BOOL _available;
}
@property(nonatomic, strong, readonly) NSString *money;
@property(nonatomic, strong, readonly) NSString *use;

@property(nonatomic, strong, readonly) NSString *title;
@property(nonatomic, strong, readonly) NSString *range;
@property(nonatomic, strong, readonly) NSString *limit;

@property(nonatomic, readonly) UIColor *leftColor;
@property(nonatomic, readonly) UIColor *rightTopColor;
@property(nonatomic, readonly) UIColor *rightBottomColor;

@property(nonatomic, readonly) UIColor *borderColor;

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
