//
//  TextField.m
//  YQS
//
//  Created by l on 3/31/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "TextField.h"

@interface TextField ()

@end

@implementation TextField

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.detail.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.detail.font = [UtilFont systemLarge];
    
    self.tf.font = [UtilFont systemLarge];
    self.tf.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    
    self.sepLine.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/







@end
