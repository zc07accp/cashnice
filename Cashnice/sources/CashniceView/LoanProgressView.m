//
//  LoanProgressView.m
//  Cashnice
//
//  Created by a on 16/2/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanProgressView.h"

const NSInteger segment = 4;


@interface LoanProgressView ()

@property (nonatomic, strong)UIView *progressBar;

@property (nonatomic, strong)UILabel *valLabel;
@property (nonatomic, strong)NSMutableArray *renderedBarArray;
@property (nonatomic, strong)NSMutableArray *sectionArray;
@property (nonatomic, strong)NSArray *sectionColorArray;

@end


@implementation LoanProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];

    [self setupUI];
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    for (int i = 0; i < segment; i++) {
        UIView *section = _sectionArray[i];
        UIView *renderedBar = _renderedBarArray[i];
        
        section.backgroundColor = ZCOLOR(@"#CCCCCC");
        renderedBar.backgroundColor = self.sectionColorArray[i];
        
        CGFloat sectionWidth = (self.width - segment)/segment;
        CGFloat sectionHeight = [ZAPP.zdevice getDesignScale:5];
        section.left = (sectionWidth+1) * i;
        section.bottom = self.height;
        section.width = sectionWidth;
        section.height = sectionHeight;
        
        renderedBar.frame = section.bounds;
        
        /*
        if (self.progress > 0) {
            UIView *firstSection = _sectionArray[0];
            firstSection.backgroundColor = self.sectionColorArray[0];
        }
        if (self.progress > i*25) {
            section.backgroundColor = self.sectionColorArray[i];
        }
        */
        CGFloat rate = (self.progress - 25.0*i)/25.0;
        rate = rate>=0 ? rate : 0;
        renderedBar.width = ceil(section.width * rate);
        
        
        NSUInteger selectedIndex = (self.progress - 0.01)/25;
        UIView *selectedSection = _sectionArray[selectedIndex];
        
        
        _valLabel.font = [UtilFont systemLarge];
        if (self.bold) {
            _valLabel.font = [UtilFont systemLargeNormal];
        }
        _valLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        if (self.remarkable) {
            _valLabel.textColor = ZCOLOR(@"#3366CC");
        }
        if (self.status.length > 0) {
            _valLabel.text = self.status;
            [_valLabel sizeToFit];
            _valLabel.left = (((UIView *)_sectionArray[0]).center.x - _valLabel.width/2);
        }else{
            _valLabel.text = [Util percentProgress:self.progress];
            [_valLabel sizeToFit];
            _valLabel.left = (selectedSection.center.x - _valLabel.width/2);
        }
        _valLabel.top = 0;
    }
}


- (void)setupUI{
    _progressBar = [[UIView alloc]init];
    _valLabel = [[UILabel alloc] init];
    _renderedBarArray = [[NSMutableArray alloc] init];
    _sectionArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < segment; i++) {
        UIView *section = [[UIView alloc] init];
        section.clipsToBounds = YES;
        UIView *renderedBar = [[UIView alloc] init];
        
        [_sectionArray addObject:section];
        [_renderedBarArray addObject:renderedBar];
        
        [section addSubview:renderedBar];
        [self addSubview:section];
    }
    
    _valLabel = [[UILabel alloc]init];
    _valLabel.font = [UtilFont systemSmall];
    if (self.bold) {
        _valLabel.font = [UtilFont systemLargeNormal];
    }
    _valLabel.textColor = ZCOLOR(@"#CCCCCC");
    [self addSubview:_valLabel];
}

- (NSArray *)sectionColorArray{
    return @[ZCOLOR(@"#99ccff"), ZCOLOR(@"#3399ff"), ZCOLOR(@"#3366cc"), ZCOLOR(@"#1d3781")];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
