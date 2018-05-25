//
//  SliderPercentViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "SliderPercentViewController.h"

@interface SliderPercentViewController () {
    CGFloat percent;
}

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_Width;
@property (weak, nonatomic) IBOutlet UIView *fgView;
@end

@implementation SliderPercentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.fgView.backgroundColor = [DefColor bgGreenColor];
    self.view.layer.cornerRadius = [ZAPP.zdevice getDesignScale:2];
    self.fgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:2];
    
    self.percentLabel.font = [UtilFont systemSmall];
    self.percentLabel.textColor = [UIColor whiteColor];
    
    [self ui];
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

- (void)ui {
    self.con_Width.constant = CGRectGetWidth(self.view.frame) * percent /  100.0;
//    int t = round(percent * 100);
    self.percentLabel.text = [Util percentProgress:percent];
}

- (void)setPercentFloat:(CGFloat)fv {
    percent = fv;
    [self ui];
}

- (void)setPercentInt:(int)iv {
    percent = iv/100.0f;
    [self ui];
}

@end
