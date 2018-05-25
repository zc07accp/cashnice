//
//  FujianViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "FujianFullView.h"

@interface FujianFullView ()
@property (strong, nonatomic)IBOutletCollection(NSLayoutConstraint) NSArray *layoutArray;
@property (strong, nonatomic)IBOutletCollection(UIImageView) NSArray *imgArray;
@property (strong, nonatomic) NSArray *           dataArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@end

@implementation FujianFullView

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    


}


- (IBAction)handleSingleTap:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setTheDataArray:(NSArray *)array {
    self.dataArray = array;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self ui];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.scroll.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self uipos];
    [self.scroll setHidden:NO];
}
#pragma mark - Navigation

- (void)uipos {
    CGPoint pos = self.scroll.contentOffset;
    pos.x = self.curIndex * [ZAPP.zdevice getDesignScale:414];
    self.scroll.contentOffset = pos;
}

- (void)ui {
	if (self.dataArray != nil) {
		int  fujiancnt = (int)[self.dataArray count];
		
        if (fujiancnt != [self.dataArray count]) {
            return;
        }
        
        for (int i = 0; i < [self.imgArray count]; i++) {
            UIImageView *imgv = [self.imgArray objectAtIndex:i];
            NSLayoutConstraint *lcon = [self.layoutArray objectAtIndex:i];
            CGFloat co;
            if (i >= fujiancnt) {
                imgv.hidden = YES;
                co = [ZAPP.zdevice getDesignScale:0];
            }
            else {
                imgv.hidden = NO;
                co = [ZAPP.zdevice getDesignScale:414];
                NSDictionary *dict = [self.dataArray objectAtIndex:i];
                NSString *url = [dict objectForKey:def_key_fujian_url];
                UIImage *im = [dict objectForKey:def_key_fujian_img];
//                [imgv setImageFromURL:[NSURL URLWithString:url] placeHolderImage:im];
                [imgv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:im];
//                [imgv setImageFromURL:[NSURL URLWithString:url] placeHolderImage:im];
            }
            lcon.constant = co;
        }
	}
}

@end
