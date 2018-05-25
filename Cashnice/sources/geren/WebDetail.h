//
//  NewBorrowViewController.h
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 

@interface WebDetail : CustomViewController  

@property (nonatomic, assign) WebDetailType webType;
@property (nonatomic, strong) NSDictionary *userAssistantPath;

@property (nonatomic, strong) NSString *absolutePath;



@end
