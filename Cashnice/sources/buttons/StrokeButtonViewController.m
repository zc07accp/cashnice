//
//  NextButtonViewController.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "StrokeButtonViewController.h"

@interface StrokeButtonViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_w;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_h;

@end

@implementation StrokeButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.con_h.constant = [ZAPP.zdevice getDesignScale:36];
    self.con_w.constant = [ZAPP.zdevice getDesignScale:390];
    
    [self.bgview setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
    
    self.button.titleLabel.font = [UtilFont systemLarge];
    [self.button setTitleColor:ZCOLOR(COLOR_TEXT_BLACK) forState:UIControlStateNormal];
    
    self.button.layer.cornerRadius = [ZAPP.zdevice getDesignScale:2];
    self.bgview.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
    
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
    [self.delegate strokeButtonPressed];
}

- (void)setTheEnabled:(BOOL)en {
    self.button.enabled = en;
    [self.button setBackgroundColor:en ? [UIColor whiteColor]: ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
    
}
@end
