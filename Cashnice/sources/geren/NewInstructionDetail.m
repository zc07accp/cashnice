//
//  RenmaiHeadTableViewController.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NewInstructionDetail.h"
#import "GeRenTableViewCell.h"
 

@interface NewInstructionDetail ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_image_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_image_width;
@property (strong, nonatomic) NSArray *rowNameArray;
@property (strong, nonatomic) NSArray *rowImageArray;
@end

@implementation NewInstructionDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    [self uiImage];
    
    //self.imgView.hidden = YES;
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

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[@"ti xing" toast];
[self setNavButton];
    
    //[self setTitle:[self.rowNameArray objectAtIndex:self.rowIndex]];
    [self setTitle:@"用户指南"];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
- (void)uiImage {
    UIImage *x = [UIImage imageNamed:[self.rowImageArray objectAtIndex:self.rowIndex]];
    self.con_image_width.constant = [ZAPP.zdevice getDesignScale:414];
    self.con_image_height.constant = [ZAPP.zdevice getDesignScale:(414.0 * x.size.height / x.size.width)];
    [UtilLog size:x.size];
    self.imgView.image = x;
    self.imgView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (NSArray *)rowNameArray {
    if (_rowNameArray == nil) {
        _rowNameArray = @[@"如何成为认证用户？",@"如何成为认证VIP用户？", @"如何授信？", @"如何邀请好友？", @"如何增加借款额度？", @"如何发布借款？", @"如何投资？", @"如何还款？", @"如何充值？", @"如何提现？"];
    }
    return _rowNameArray;
}

- (NSArray *)rowImageArray{
    if (_rowImageArray== nil) {
        _rowImageArray= @[@"新手-1.jpg",@"新手-2.jpg", @"新手-3.jpg", @"新手-4.jpg", @"新手-5.jpg", @"新手-6.jpg", @"新手-7.jpg", @"新手-8.jpg", @"新手-9.jpg", @"新手-10.jpg"];
    }
    return _rowImageArray;
}



@end
