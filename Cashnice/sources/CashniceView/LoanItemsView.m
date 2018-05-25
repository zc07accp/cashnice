//
//  LoanItemsView.m
//  Cashnice
//
//  Created by a on 16/2/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanItemsView.h"

@interface LoanItemsView ()

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSMutableArray *containerViewArray;
@property (nonatomic, strong) NSMutableArray *titleLabelArray;
@property (nonatomic, strong) NSMutableArray *dataLabelArray;
@property (nonatomic, strong) NSMutableArray *sepViewArray;

@property (nonatomic, strong) UIButton *guarBtn;
@property (nonatomic, strong) UIImageView *prompt;
@property (nonatomic, strong) UIImageView *insurePromptRowImageView;
@property (nonatomic, strong) UIButton *insureButton;
@end

@implementation LoanItemsView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)presentPrivilegedUser {
    
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    
    self.insureButton.enabled = self.loanItemsViewType == LoanItemsViewTypePrivilege;
    self.insurePromptRowImageView.hidden = self.loanItemsViewType != LoanItemsViewTypePrivilege;
    
    for (int i = 0; i<self.titleArray.count; i++) {
        UIView *container = _containerViewArray[i];
        UILabel *titleLabel = _titleLabelArray[i];
        UILabel *dataLabel = _dataLabelArray[i];

        if (i == 2 && self.loanItemsViewType == LoanItemsViewTypePrivilege) {
            titleLabel.text = @"抵押";
            dataLabel.text = @"用户";
            dataLabel.textColor = [UIColor blackColor];
            titleLabel.font = [UtilFont systemLarge];
            dataLabel.font = [UtilFont systemLarge];
            
//            dataLabel.text = self.dataArray[i];

        }else if (i == 0 && self.loanItemsViewType == LoanItemsViewTypePrivilege) {
//            titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.titleArray[i], self.dataArray[i]];
            
            titleLabel.attributedText = [self getAttri:self.titleArray[i] second:self.dataArray[i]];
            
            dataLabel.text = @"附本金";      //附本金保险
            dataLabel.textColor = CN_UNI_RED;
//            titleLabel.font = [UtilFont systemLarge];
            dataLabel.font = [UtilFont systemLarge];
            
        }else{
            titleLabel.text = self.titleArray[i];
            
            if( i == 0 ){
//                dataLabel.textColor = [UIColor blueColor];
                dataLabel.attributedText = [self getAttri:self.dataArray[i]];
//                dataLabel.text = self.dataArray[i];

            }else{
                 dataLabel.textColor = [UIColor blackColor];
                dataLabel.text = self.dataArray[i];
                dataLabel.font = [UtilFont systemLargeNormal];

            }
                

            titleLabel.font = [UtilFont systemLarge];
        }
        
        CGFloat containerWidth = (self.width - self.titleArray.count )/self.titleArray.count;
        container.frame = CGRectMake((containerWidth+1) * i,
                                     0,
                                     containerWidth,
                                     self.height);
        
        container.backgroundColor = [UIColor whiteColor];
        
        
        [titleLabel sizeToFit];
        titleLabel.left = (container.width - titleLabel.width)/2;
        titleLabel.top = 0;
        
        
        [dataLabel sizeToFit];
        dataLabel.left = (container.width - dataLabel.width)/2;
        dataLabel.bottom = container.height;
        
        if (i>0) {
            UIView *sep = _sepViewArray[i-1];
            sep.frame = CGRectMake(container.left-1, 0, 1, container.height);
            NSLog(@"");
        }
        if (i == 2) {
            _prompt.frame = CGRectMake(titleLabel.right, 0, container.width-titleLabel.right, container.height);
        }
        if (i == 0 && self.loanItemsViewType == LoanItemsViewTypePrivilege) {
            
            [self.insurePromptRowImageView sizeToFit];
            _insurePromptRowImageView.hidden = NO;
            //_insurePromptRowImageView.backgroundColor = [UIColor redColor];
            
            
            titleLabel.left =(container.width - titleLabel.width)/2 - self.insurePromptRowImageView.width;
            dataLabel.left -= self.insurePromptRowImageView.width;
            
            CGFloat rowLeft = (container.width - _insurePromptRowImageView.width ) /2  + MAX(titleLabel.right, dataLabel.right)/2;
            
            _insurePromptRowImageView.frame = CGRectMake( rowLeft , 0, _insurePromptRowImageView.width, container.height);
            
        }
    }
    _guarBtn.frame = _guarBtn.superview.bounds;
    _insureButton.frame = _insureButton.superview.bounds;
}

- (void)setupUI{
    _containerViewArray = [[NSMutableArray alloc]init];
    _titleLabelArray = [[NSMutableArray alloc]init];
    _dataLabelArray = [[NSMutableArray alloc]init];
    _sepViewArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.titleArray.count; i++) {
        UIView *container = [[UIView alloc]init];
        [_containerViewArray addObject:container];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = self.titleArray[i];
        titleLabel.font = [UtilFont systemLarge];
        UILabel *dataLabel = [[UILabel alloc]init];
        dataLabel.font = [UtilFont systemLargeNormal];
        [container addSubview:titleLabel]; [_titleLabelArray addObject:titleLabel];
        [container addSubview:dataLabel]; [_dataLabelArray addObject:dataLabel];
        if (i>0) {
            UIView *sep = [[UIView alloc] init];
            sep.backgroundColor = ZCOLOR(COLOR_SEPERATOR_COLOR);
            [self addSubview:sep];
            [_sepViewArray addObject:sep];
        }
        
        //担保人行为
        if (i == 2) {
            _prompt = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"row" ]];
            _prompt.contentMode = UIViewContentModeCenter;
            [container addSubview:_prompt];
            
            _guarBtn = [[UIButton alloc]init];
            _guarBtn.backgroundColor = [UIColor clearColor];
            [_guarBtn addTarget:self action:@selector(guarAction) forControlEvents:UIControlEventTouchUpInside];
            [container addSubview:_guarBtn];
        }
        
        //附本金保险
        if (i == 0) {
            
            [container addSubview:self.insurePromptRowImageView];
            [container addSubview:self.insureButton];
        }
        [self addSubview:container];
    }
}

- (void)guarAction{
    if (_delegate) {
        [_delegate guaranteeAction];
    }
}

- (UIImageView *)insurePromptRowImageView{
    if (! _insurePromptRowImageView) {
        _insurePromptRowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"row" ]];
        _insurePromptRowImageView.contentMode = UIViewContentModeCenter;
        _insurePromptRowImageView.hidden = YES;
    }
    return _insurePromptRowImageView;
}

- (UIButton *)insureButton {
    if (! _insureButton) {
        _insureButton = [[UIButton alloc]init];
        _insureButton.backgroundColor = [UIColor clearColor];
        [_insureButton addTarget:self action:@selector(guarAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _insureButton;
}

- (NSArray*)titleArray{
    if (! _titleArray) {
        _titleArray = @[@"年化", @"进度", @"担保", @"周期"];
    }
    return _titleArray;
}

-(NSAttributedString *)getAttri:(NSString *)oriText{
    
    if (![oriText isKindOfClass:[NSString class]] || oriText.length == 0) {
        return nil;
    }
    
    NSMutableAttributedString *muStr =[[NSMutableAttributedString alloc] initWithString:oriText];
    
    [muStr addAttribute:NSFontAttributeName value:[UtilFont systemLargeNormal] range:NSMakeRange(oriText.length-2, 1)];

    [muStr addAttribute:NSForegroundColorAttributeName value:CN_UNI_RED
                   range:NSMakeRange(0, oriText.length)];

    [muStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:NSMakeRange(0, oriText.length-1)];
 
 
    return muStr;
}

-(NSAttributedString *)getAttri:(NSString *)firstpart second:(NSString *)secondpart{
 
    if (![firstpart isKindOfClass:[NSString class]] || firstpart.length == 0) {
        return nil;
    }
    
    if (![secondpart isKindOfClass:[NSString class]] || secondpart.length == 0) {
        return nil;
    }
 
   NSString* oriText = [NSString stringWithFormat:@"%@%@",firstpart, secondpart];
    
    NSMutableAttributedString *muStr =[[NSMutableAttributedString alloc] initWithString:oriText];
    
    [muStr addAttribute:NSFontAttributeName value:[UtilFont systemLargeNormal] range:NSMakeRange(0, oriText.length)];
    
    [muStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]
                  range:NSMakeRange(0, oriText.length)];
    
    [muStr addAttribute:NSForegroundColorAttributeName value:CN_UNI_RED
                  range:NSMakeRange(firstpart.length, oriText.length - firstpart.length)];
    
    [muStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:NSMakeRange(firstpart.length, secondpart.length-1)];
    
    
    return muStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
