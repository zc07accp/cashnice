//
//  SocietyPositionItemView.h
//  Cashnice
//
//  Created by a on 16/5/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocietyPositionItemView;

@protocol SocietyPositionItemViewDeleate <NSObject>

- (void)societyPositionItem:(NSDictionary *)itemDict didSelected:(BOOL)selected;

@end

@interface SocietyPositionItemView : UIView

@property (assign) CGFloat fitHeight;

@property (strong, nonatomic) NSArray *selectedItems;

@property (weak, nonatomic) id<SocietyPositionItemViewDeleate> delegate;


+ (UIImage *)nomalImage ;

+ (UIImage *)selectedImage ;

+ (CGFloat)spaceHeight ;

+ (CGFloat)spaceWidth ;



@end
