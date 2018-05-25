//
//  PortraitViewController.m
//  YQS
//
//  Created by l on 3/19/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "PortraitViewController.h"

@interface PortraitViewController () {
    
}
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) IBOutlet UIImageView* image;
@end

@implementation PortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.layer.cornerRadius = CGRectGetWidth(self.view.frame) / 2.0f;
}


- (void)setImageUrl:(NSString *)str {
    
    if ([str isEqualToString:_imageUrl]) {
        return;
    }
    _imageUrl = str;
    [self.image setImageFromURL:[NSURL URLWithString:str] placeHolderImage:[Util imagePlaceholderPortrait]];
}
@end
