//
//  PhotoView.h
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
@protocol PhotoButtonDelegate<NSObject>

@required
- (void)photoButtonPressed:(int)idx;

@end

@interface PhotoView : CustomViewController
@property(strong, nonatomic) id<PhotoButtonDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (nonatomic, assign) int buttontag;
- (void)setPhotoDict:(NSDictionary *)dict;
@end
