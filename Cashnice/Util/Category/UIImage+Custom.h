//
//  UIImage+NotEmpty.h
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Custom)

- (BOOL) notEmpty;
- (BOOL)savePngToPath:(NSString *)path;
@end