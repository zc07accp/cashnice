//
//  FilterBillViewController.m
//  Cashnice
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 l. All rights reserved.
//

#import "FilterBillViewController.h"
#import "SocietyPositionItemView.h"

@interface FilterBillViewController ()
{
    CGFloat maxH;
}
@property (nonatomic,strong) UIView *containView;
@property (nonatomic,strong) NSArray *array;
@property (assign, nonatomic) NSInteger selIndex;

@end

@implementation FilterBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBA(0, 0, 0, 0.4);

    self.array = @[@"全部",@"充值",@"提现",@"投资",@"还款",@"收回"];
    
    UIButton *bkBtn = [[UIButton alloc]init];
    [self.view addSubview:bkBtn];
    [bkBtn setFrame:self.view.bounds];
    [bkBtn addTarget:self action:@selector(tapBK) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.containView];
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];
    
    CGFloat width  = (MainScreenWidth - 12*4)/3;
    CGFloat height = 39.f;
    CGFloat leading = 12;
    

    
    
    
    for (NSInteger i=0; i<self.array.count; i++) {
        
        NSString *itemname =[self.array objectAtIndex:i];
        
        UIButton *itemButton = [UIButton new];
        itemButton.tag = 100+i;
        [self.containView addSubview:itemButton];
        
        itemButton.titleLabel.font = [UtilFont systemLarge];
        [itemButton setTitleColor:CN_TEXT_GRAY forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        itemButton.layer.cornerRadius = 3;
        itemButton.layer.masksToBounds = YES;
        [itemButton setTitle:itemname forState:UIControlStateNormal];
        [itemButton setBackgroundImage:[SocietyPositionItemView nomalImage] forState:UIControlStateNormal];
        [itemButton setBackgroundImage:[SocietyPositionItemView selectedImage] forState:UIControlStateSelected];
        
        [itemButton addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.showsTouchWhenHighlighted = NO;
        itemButton.adjustsImageWhenHighlighted = NO;
        
        itemButton.frame = CGRectMake(leading + (i%3)*(width+leading), leading + (i/3)*(height+leading), width, height);
        
        if (i==self.array.count - 1) {
            maxH = itemButton.top + itemButton.height + leading;
        }
        
    }
    
    UIButton *all_btn = [self.containView viewWithTag:100];
    all_btn.selected = YES;
    
    [self show];

}

-(UIView *)containView{
    if (!_containView) {
        _containView = [UIView new];
        _containView.backgroundColor = [UIColor whiteColor];

    }
    
    return _containView;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    
}

-(void)tapBK{
    if (self.delegate) {
        [self.delegate filterBillDidTapClose];
    }
    
}

- (IBAction)itemSelected:(UIButton *)sender {
    
    //单选,取消前面选中
    if(self.selIndex >= 0){
        UIButton *btn = [self.containView viewWithTag:100+self.selIndex];
        btn.selected = NO;
    }
    
    sender.selected = YES;
    NSInteger idx = sender.tag - 100;
    self.selIndex = idx;
    
    NSInteger tag = 0;
    
    //        self.array = @[@"全部",@"充值",@"提现",@"投资",@"还款",@"收回"];

    
    if ([self.array[self.selIndex] isEqualToString:@"全部"]) {
        tag = 0;
    } else if ([self.array[self.selIndex] isEqualToString:@"充值"]) {
        tag = 1;
    } else if ([self.array[self.selIndex] isEqualToString:@"提现"]) {
        tag = 2;
    } else if ([self.array[self.selIndex] isEqualToString:@"收益"]) {
        tag = 3;
    }  else if ([self.array[self.selIndex] isEqualToString:@"还款"]) {
        tag = 4;
    } else if ([self.array[self.selIndex] isEqualToString:@"收回"]) {
        tag = 5;
    }  else if ([self.array[self.selIndex] isEqualToString:@"投资"]) {
        tag = 6;
    }
    

    if (self.delegate) {
        [self.delegate filterBillDidSelected:self.array[self.selIndex] tag:tag];
    }
    
}

-(void)show{
    
    [_containView setNeedsUpdateConstraints];
    [_containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(maxH));
    }];
    [_containView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0. delay:0.0  options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
    }];
    

}

@end
