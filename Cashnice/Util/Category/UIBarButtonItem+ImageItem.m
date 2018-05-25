//
//  UIBarButtonItem+ImageItem.m
//  UIKitConvenience
//
//  Created by Eric Goldberg on 6/8/12.
//  Copyright (c) 2012 Eric Goldberg. All rights reserved.
//

#import "UIBarButtonItem+ImageItem.h"

@implementation UIBarButtonItem (ImageItem)

+(UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
//    button.backgroundColor = [UIColor blackColor];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem* item = [[self alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)spacer {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;
    return negativeSpacer;
}

@end
