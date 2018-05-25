//
//  NonRotateImgPicker.m
//  D3
//
//  Created by Tao Liu on 13-11-6.
//  Copyright (c) 2013年 D-Haus Technology Co.,Ltd. All rights reserved.
//

#import "NonRotateImgPicker.h"

@interface NonRotateImgPicker ()

@end

@implementation NonRotateImgPicker

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
