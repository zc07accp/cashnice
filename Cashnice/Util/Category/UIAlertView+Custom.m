//
//  UIAlertView+Custom.m
//  YQS
//
//  Created by l on 5/27/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UIAlertView+Custom.h"

@implementation UIAlertView (Custom)

- (void)customLayout {
    NSString *titlestr = self.title;
    NSString *msgstr = self.message;
    
    NSString *finalstr = @"";
    
    if ([titlestr notEmpty] && [msgstr notEmpty]) {
        finalstr = [NSString stringWithFormat:@"%@\n%@", titlestr, msgstr];
    }
    else if ([titlestr notEmpty]) {
        finalstr = [NSString stringWithFormat:@"%@", titlestr];
    }
    else if ([msgstr notEmpty]) {
        finalstr = [NSString stringWithFormat:@"%@", msgstr];
    }
    if ([finalstr notEmpty]) {
        finalstr = [NSString stringWithFormat:@"%@\n", finalstr];//add a space line to the end
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent          = 10;
    paragraphStyle.tailIndent = -10;
    paragraphStyle.firstLineHeadIndent = 10;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing         = 3;
    NSDictionary *attrsDictionary =
    @{ NSFontAttributeName: [UIFont systemFontOfSize:15],
       NSParagraphStyleAttributeName: paragraphStyle};
    
    UILabel *textLabel = [UILabel new];
    textLabel.textColor       = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    textLabel.numberOfLines   = 0;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:finalstr attributes:attrsDictionary];
    if ([titlestr notEmpty]) {
        [Util setAttributedString:attrStr font:[UIFont boldSystemFontOfSize:17] color:nil range:[finalstr rangeOfString:titlestr]];
    }
    
    textLabel.attributedText = attrStr;
    
    [self setValue:textLabel forKey:@"accessoryView"];
    self.title   = @"";
    self.message = @"";
}
@end
