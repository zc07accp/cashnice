//
//  FujianViewController.h
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"

#import "PhotoView.h"
@interface FujianViewController : CustomViewController <PhotoButtonDelegate>

- (void)setFujianDict:(NSDictionary *)dict;
@end
