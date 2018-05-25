//
//  PhotoView.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView ()

@property (weak, nonatomic) IBOutlet UILabel *filename;
@property (weak, nonatomic) IBOutlet UIView *imgbgview;
@property (strong, nonatomic) NSDictionary *dataDict;
@end

@implementation PhotoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.filename.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.filename.font  = [UIFont systemFontOfSize:[ZAPP.zdevice getDesignScale:10]];
    
    self.imgbgview.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPhotoDict:(NSDictionary *)dict{
self.dataDict = dict;
    [self ui];
}

- (void)ui {
    if (self.dataDict != nil) {
        NSString *str1 = [self.dataDict objectForKey:NET_KEY_ORGFILENAME];
        if ([str1 notEmpty]) {
            self.filename.text = str1;
        }
        else {
            self.filename.text = [self.dataDict objectForKey:NET_KEY_NAME];
            
        }
        self.filename.hidden = YES;
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:[self.dataDict objectForKey:NET_KEY_URL]] placeholderImage:[Util imagePlaceholderAttachment]];

    }
    else {
        self.imageview.image = [Util imagePlaceholderAttachment];
    }
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [self.delegate photoButtonPressed:self.buttontag];
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
