//
//  TransferCommentTextFiled.m
//  Cashnice
//
//  Created by a on 16/10/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TransferCommentTextFiled.h"

@implementation TransferCommentTextFiled


- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 1, 1);
    
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 1, 1);
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIScrollView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            CGPoint offset = view.contentOffset;
            if (offset.y != 0) {
                offset.y = 0;
                view.contentOffset = offset;
            }
            break;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
