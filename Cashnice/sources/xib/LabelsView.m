//
//  LabelsView.m
//  YQS
//
//  Created by l on 4/2/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "LabelsView.h"

@interface LabelsView ()

@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *labels;

@end

@implementation LabelsView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

- (void)setAllColor:(UIColor *)color font:(UIFont *)font {
	for (UILabel *l in self.labels) {
		l.font      = font;
		l.textColor = color;
	}
}

- (void)setIndexColor:(UIColor *)color index:(NSArray *)array {
	for (id n in array) {
		if ([n isKindOfClass:[NSNumber class]]) {
			NSInteger idx = [(NSNumber *)n integerValue];
			if (idx >= 0 && idx < [self.labels count]) {
                UILabel *l = [self.labels objectAtIndex:idx];
                l.textColor = color;
			}
		}

	}
}

- (void)setTexts:(NSArray *)strArray {
    for (int i = 0; i < [strArray count]; i++) {
        ((UILabel *)[self.labels objectAtIndex:i]).text = [strArray objectAtIndex:i];
    }
}

- (void)setText:(NSString *)str atIndex:(NSInteger)idx {
    ((UILabel *)[self.labels objectAtIndex:idx]).text = str;
}

- (void)setColor:(UIColor *)color atIndex:(NSInteger)idx {
    ((UILabel *)[self.labels objectAtIndex:idx]).textColor = color;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];

    [Util setUILabelLargeGray:self.labels];
}

@end
