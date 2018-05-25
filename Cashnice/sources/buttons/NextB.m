//
//  NextButtonViewController.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NextB.h"

@interface NextB()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) NSString *titleString;
@property (assign, nonatomic) int btnIdx;

@end

@implementation NextB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.button.titleLabel.font = [UtilFont systemLarge];
    self.button.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
    
    [self setTheTitleString:self.titleString];
    [self setTheButtonEnabled:YES];
    [self setTheBgRed];
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

- (IBAction)nextBPressed:(UIButton *)sender {
    [self.delegate nextBPressed:self.btnIdx];
}

- (void)setTheTitleString:(NSString *)str {
    self.titleString = str;
    if (self.titleString.length > 0) {
        [self.button setTitle:self.titleString forState:UIControlStateNormal];
    }
}

- (void)setTheButtonIndex:(int)idx {
    self.btnIdx = idx;
}

- (void)setTheButtonEnabled:(BOOL)enabled {
    self.button.enabled = enabled;
}

- (void)setTheBgRed {
    [self.button setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
}

- (void)setTheBgGray {
    [self.button setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
}
- (void)setTheBgBlue {
    [self.button setBackgroundColor:ZCOLOR(COLOR_BUTTON_BLUE)];
}
- (void)setHidden : (BOOL)hidden {
    [self.button setHidden: hidden];
}
@end
