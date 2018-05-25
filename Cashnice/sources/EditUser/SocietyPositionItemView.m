//
//  SocietyPositionItemView.m
//  Cashnice
//
//  Created by a on 16/5/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SocietyPositionItemView.h"

@interface SocietyPositionItemView ()

@property (nonatomic, strong) NSMutableArray *itemButtons;

@end

@implementation SocietyPositionItemView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];

    [self setupUI];
}

- (void)setupUI{
    NSArray *terms = ZAPP.myuser.systemOptionsDictShehuiZhiwu[@"items"];
    
    CGFloat currentAnchor = .0f;
    CGFloat currentLeading = .0f;
    
    int idx = 0;
    for (; idx < terms.count; idx++) {
        NSDictionary *thisData = terms[idx];
        NSString *itemname =thisData[@"itemname"];
        
        UIButton *itemButton = [UIButton new];
        itemButton.tag = idx;
        [self.itemButtons addObject:itemButton];
        [self addSubview:itemButton];
        itemButton.titleLabel.font = [UtilFont systemLarge];
        itemButton.titleLabel.textColor = [UIColor whiteColor];
        itemButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4.0f];
        itemButton.layer.masksToBounds = YES;
        [itemButton setTitle:itemname forState:UIControlStateNormal];
        [itemButton setBackgroundImage:[SocietyPositionItemView nomalImage] forState:UIControlStateNormal];
        [itemButton setBackgroundImage:[SocietyPositionItemView selectedImage] forState:UIControlStateSelected];
        
        [itemButton addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemButton sizeToFit];
        itemButton.width += 16;
        itemButton.height += 10;
        
        //计算位置
        CGFloat aspiredLeft = currentLeading + itemButton.width;
        if (aspiredLeft > self.width) {
            currentLeading = 0;
            currentAnchor += (itemButton.height + [SocietyPositionItemView spaceHeight]);
        }
        
        itemButton.left = currentLeading;
        itemButton.top = currentAnchor;
        
        currentLeading += itemButton.width + [SocietyPositionItemView spaceWidth];
        
        
        self.fitHeight = currentAnchor + itemButton.height;
    }
}

- (IBAction)itemSelected:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    NSInteger idx = sender.tag;
    NSDictionary *dict = ZAPP.myuser.systemOptionsDictShehuiZhiwu[@"items"][idx];
    
    if ([self.delegate respondsToSelector:@selector(societyPositionItem:didSelected:)]) {
        [self.delegate societyPositionItem:dict didSelected:sender.selected];
    }
    
}

- (void)setSelectedItems:(NSArray *)selectedItems{
    for (NSNumber *Id in selectedItems) {
        NSInteger selectedId = [Id integerValue];
        
        for (UIButton *btn in self.itemButtons) {
            NSInteger tag = btn.tag;
            NSDictionary *btnData = ZAPP.myuser.systemOptionsDictShehuiZhiwu[@"items"][tag];
            NSInteger btnOptionId = [btnData[@"itemvalue"] integerValue];
            //
            if (btnOptionId == selectedId) {
                btn.selected = YES;
            }
        }
    }
}

+ (CGFloat)spaceWidth {
    return [ZAPP.zdevice getDesignScale:20];
}

+ (CGFloat)spaceHeight {
    return [ZAPP.zdevice getDesignScale:10];
}

+ (UIImage *)selectedImage {
    return [SocietyPositionItemView imageWithColor:ZCOLOR(@"#3385ff")];
}

+ (UIImage *)nomalImage {
    return [SocietyPositionItemView imageWithColor:ZCOLOR(@"#bfd5ea")];
}

- (NSMutableArray *)itemButtons {
    if (! _itemButtons) {
        _itemButtons = [[NSMutableArray alloc] init];
    }
    return _itemButtons;
}

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
