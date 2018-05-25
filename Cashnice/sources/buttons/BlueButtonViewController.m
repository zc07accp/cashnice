//
//  NextButtonViewController.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BlueButtonViewController.h"

@interface BlueButtonViewController () 

@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation BlueButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.button setBackgroundColor:ZCOLOR(COLOR_BUTTON_BLUE)];
    self.button.titleLabel.font = [UtilFont systemLarge];
    if (self.titleString.length > 0) {
    [self.button setTitle:self.titleString forState:UIControlStateNormal];
    }
    self.button.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
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

- (IBAction)nextButtonPressed:(id)sender {
    [self.delegate blueButtonPressed];
}
@end
