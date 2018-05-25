//
//  HeadImageView.m
//  YQS
//
//  Created by a on 15/12/8.
//  Copyright © 2015年 l. All rights reserved.
//

#import "HeadImageView.h"
#import "UIImageView+Radius.h"

@interface HeadImageView ()

@property (nonatomic, strong) NSString *urlStr;

@end

@implementation HeadImageView

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setHeadImgeUrlStr:(NSString *)urlStr{

    if([urlStr length]){
        [self aw_setImageWithURLString: urlStr
                           placeholder:[UIImage imageNamed:@"portrait_place.png"]];
        
    }else{
        self.image = [UIImage imageNamed:@"portrait_place.png"];
    }
    


}

@end
