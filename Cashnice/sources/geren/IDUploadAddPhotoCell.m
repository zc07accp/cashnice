//
//  IDUploadAddPhotoCell.m
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IDUploadAddPhotoCell.h"

@implementation IDUploadAddPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.view1.layer.cornerRadius = 3;
    self.view1.layer.masksToBounds = YES;
    self.view2.layer.cornerRadius = 3;
    self.view2.layer.masksToBounds = YES;

    self.view1.backgroundColor = ZCOLOR(COLOR_BUTTON_BLUE);
    self.view2.backgroundColor = ZCOLOR(COLOR_BUTTON_BLUE);
 
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)uploadCardAction1:(id)sender {
    if(self.tapSelPhoto1){
        self.tapSelPhoto1();
    }
}
- (IBAction)uploadCardAction2:(id)sender{
    if(self.tapSelPhoto2){
        self.tapSelPhoto2();
    }
}

-(void)setHasDetectCard1Succ:(BOOL)hasUploadCard1Succ{
    if (hasUploadCard1Succ) {

//        self.sucUploadView1.hidden=NO;
        self.unUploadView1.hidden=YES;
    }else{
//        self.sucUploadView1.hidden=YES;
        self.unUploadView1.hidden=NO;
    }
}


-(void)setHasDetectCard2Succ:(BOOL)hasUploadCard2Succ{
    if (hasUploadCard2Succ) {
        
//        self.sucUploadView2.hidden=NO;
        self.unUploadView2.hidden=YES;
    }else{
//        self.sucUploadView2.hidden=YES;
        self.unUploadView2.hidden=NO;
    }
}

@end
