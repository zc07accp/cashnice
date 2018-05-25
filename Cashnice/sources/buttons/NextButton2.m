//
//  NextButtonViewController.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NextButton2.h"

@interface NextButton2 ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation NextButton2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.button setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
    self.button.titleLabel.font = [UtilFont systemLarge];
    self.button.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
    
    if (self.titleString.length > 0) {
        [self.button setTitle:self.titleString forState:UIControlStateNormal];
    }
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
    [self.delegate nextButton2Pressed];
}

- (void)setTheTitleString:(NSString *)t {
    self.titleString = t;
    if (self.titleString.length > 0) {
        [self.button setTitle:self.titleString forState:UIControlStateNormal];
    }
}

- (void)setTheEnabled:(BOOL)en {
    self.button.enabled = en;
    [self.button setBackgroundColor:en ? ZCOLOR(COLOR_BUTTON_RED): ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
    
}

- (void)setTheGray {
    [self.button setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
}
@end
