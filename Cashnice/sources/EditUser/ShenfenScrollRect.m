//
//  ShenfenScrollRect.m
//  YQS
//
//  Created by l on 7/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ShenfenScrollRect.h"

@interface ShenfenScrollRect ()

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel* topLabel;
@property (strong, nonatomic) IBOutlet UILabel* middleLabel;
@property (strong, nonatomic) IBOutlet UIImageView * centerImage;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_w;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_h;


@end

@implementation ShenfenScrollRect

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.con_w.constant = [ZAPP.zdevice getDesignScale:285];
    self.con_h.constant = [ZAPP.zdevice getDesignScale:345];
    
    self.button.titleLabel.font = [UtilFont systemLarge];
    [self.button setBackgroundColor:[DefColor colorParseString:@"#56abe4"]];
    self.button.layer.cornerRadius = [Util getCornerRadiusLarge];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.topLabel.font = [UtilFont systemLarge];
    self.middleLabel.font = [UtilFont systemSmall];
    self.topLabel.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
    self.middleLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    
    if (self.idx == 0) {
        self.topLabel.text = @"手机号";
        self.middleLabel.text = @"怎么联系到您";
        self.centerImage.image = [UIImage imageNamed:@"big_phone.png"];
        [self.button setTitle:@"修改手机号" forState:UIControlStateNormal];
    }
    else if (self.idx == 1) {
        self.topLabel.text = @"身份信息";
        self.middleLabel.text = @"请留下最真实的自己";
        self.centerImage.image = [UIImage imageNamed:@"card.png"];
        [self.button setTitle:@"查看身份信息" forState:UIControlStateNormal];
    }
    else if (self.idx == 2) {
        self.topLabel.text = @"公司社会职务";
        self.middleLabel.text = @"VIP可获得更多的信用额度";
        self.centerImage.image = [UIImage imageNamed:@"big_star.png"];
        [self.button setTitle:@"修改公司和社会职务" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLabelStrings:(NSString *)str {
    [self.button setTitle:str forState:UIControlStateNormal];
}

- (IBAction)buttonPressed:(id)sender {
    [self.delegate rectbuttonPressed:self.idx];
}

- (void)setTheButtonDisabled:(BOOL)disabled {
    self.button.enabled = !disabled;
   // [self.button setBackgroundColor:disabled ? ZCOLOR(COLOR_BG_GRAY) : ZCOLOR(@"#56abe4")];
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
