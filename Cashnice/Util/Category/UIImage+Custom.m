//
//  UIImage+NotEmpty.m
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)

- (BOOL)notEmpty {
    return (self.size.width > 0 && self.size.height > 0);
}

- (BOOL)savePngToPath:(NSString *)path {
    BOOL suc = NO;
    if ([self notEmpty]) {
        NSData *imageData = UIImagePNGRepresentation(self); //slow
        if ([imageData notEmpty]) {
            suc = [imageData writeToFile:path atomically:YES];
        }
    }
    return suc;
}
@end
