//
//  SDTabbarController.m
//  ShandongNews
//
//  Created by zengyuan on 10/3/14.
//  Copyright (c) 2014 zengyuan. All rights reserved.
//


#import "AWTabBarController.h"


@interface AWTabBarController ()

@end

@implementation AWTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    self.tabBar.tintColor=[UIColor whiteColor];
        
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
    UIImage *streImage = [[UIImage imageNamed:@"little_white"] resizableImageWithCapInsets:insets];
    [self.tabBar setSelectionIndicatorImage:streImage];
    [self.tabBar setBackgroundImage:streImage];
 }




 @end
