//
//  DetailItemView.m
//  YQS
//
//  Created by a on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestDetailItemView.h"

@interface InvestDetailItemView () {
    CGFloat currentAnchor;
}

@end

@implementation InvestDetailItemView

static const NSUInteger kLargeFontSize = 20;

- (void)setUpView {
    self.height = [self fitHeight];
    currentAnchor = 0.0f;
    
    int idx = 0;
    for (NSDictionary *itemDict in self.itemsDataArray) {
        UILabel *title = [UILabel new];
        title.left = 0;
        title.top = currentAnchor;
        title.font  = [UtilFont systemLargeNormal];
        title.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        title.text = itemDict[@"title"];
        [title sizeToFit];
        
        if (itemDict[@"underline"]) {
            title.height = [InvestDetailItemView largeItemHeight];
        }else{
            title.height = [InvestDetailItemView itemHeight];
            
        }
        currentAnchor += title.height + [InvestDetailItemView verticalSpace];
        
        [self addSubview:title];        //title.backgroundColor = [UIColor cyanColor];
        
        UILabel *content = [UILabel new];
        //content.left = title.right + [DetailItemView horizontalSpace];
        content.height = [InvestDetailItemView itemHeight];
        content.top = title.top;
        content.textAlignment = NSTextAlignmentRight;
        
        if (itemDict[@"underline"]) {
            NSString *cnt = [Util formatRMBWithoutUnit:itemDict[@"content"]];
            content.text = cnt;
            content.font = [UtilFont systemNormal:kLargeFontSize];
            [content sizeToFit];
            
            //显示比较小的"元"
            UILabel *unit = [UILabel new];
            unit.text = @"元";
            unit.font  = [UtilFont systemLargeNormal];
            unit.textColor = ZCOLOR(COLOR_TEXT_BLACK);
            
            [unit sizeToFit];
            unit.left = content.right;
            unit.bottom = content.bottom - 1;
            
            [self addSubview:unit];
            
        }else{
            content.text = itemDict[@"content"];
            content.font  = [UtilFont systemLargeNormal];
            [content sizeToFit];
        }
        content.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        
        content.right = self.right;
        [self addSubview:content];
        //content.backgroundColor = [UIColor greenColor];
        
        idx ++;
    }
}

- (CGFloat)fitHeight {
    NSUInteger itemCnt = self.itemsDataArray.count;
    if (itemCnt > 0) {
        return  [InvestDetailItemView itemHeight] * [self normalItemCount] +
                [InvestDetailItemView largeItemHeight] * [self largeItemCount] +
                [InvestDetailItemView verticalSpace]*(itemCnt - 1);
    }
    return 0;
}

- (NSUInteger)largeItemCount {
    NSUInteger cnt = 0;
    for (NSDictionary *dict in self.itemsDataArray) {
        if (dict[@"underline"]) {
            cnt++;
        }
    }
    return cnt;
}

- (NSUInteger)normalItemCount {
    NSUInteger cnt = 0;
    for (NSDictionary *dict in self.itemsDataArray) {
        if (! dict[@"underline"]) {
            cnt++;
        }
    }
    return cnt;
}

+ (CGFloat)itemHeight {
    UILabel *tLable = [UILabel new];
    tLable.font = [UtilFont systemLargeNormal];
    tLable.text = @"Test";
    [tLable sizeToFit];
    return tLable.height;
}

+ (CGFloat)largeItemHeight {
    UILabel *tLable = [UILabel new];
    tLable.font = [UtilFont systemNormal:kLargeFontSize];
    tLable.text = @"Test";
    [tLable sizeToFit];
    return tLable.height;
}

+ (CGFloat)verticalSpace {
    return [ZAPP.zdevice getDesignScale:10];
}

+ (CGFloat)horizontalSpace {
    return [ZAPP.zdevice getDesignScale:40];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
