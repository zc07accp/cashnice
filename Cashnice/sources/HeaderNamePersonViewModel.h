//
//  HeaderNamePersonViewModel.h
//  Cashnice
//
//  Created by apple on 2016/10/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeaderNamePersonViewModel : NSObject

@property(nonatomic,copy) NSDictionary *moreInfoDic;
@property(nonatomic,copy) NSString *headerUrl;
@property(nonatomic,copy) NSString *name;

@property(nonatomic,copy) NSString *fullPinyin;

@property(nonatomic,copy) NSString *firstLetter;
@property(nonatomic,copy) NSAttributedString*attrName;

@end
