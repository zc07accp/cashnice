//
//  FilterRedMoneyViewController.m
//  Cashnice
//
//  Created by apple on 2017/2/13.
//  Copyright © 2017年 l. All rights reserved.
//

#import "FilterRedMoneyViewController.h"

@interface FilterRedMoneyViewController ()
{
    CGFloat maxH;
    
    NSInteger colNum;
}

@property (nonatomic,strong) UIView *containView;
@property (nonatomic,strong) NSArray *array;
@property (assign, nonatomic) NSInteger selIndex;


@end

@implementation FilterRedMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = RGBA(0, 0, 0, 0.4);
    
    self.array = @[@"未使用",@"已使用",@"已过期"];
    colNum = self.array.count;
    
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
    
    
    CGFloat leading = 10;

    CGFloat width  = (MainScreenWidth - leading*(colNum+1))/colNum;
    
    CGFloat height = 39.f;
 
    for (NSInteger i=0; i<self.array.count; i++) {
        
        NSString *itemname =[self.array objectAtIndex:i];
        
        UIButton *itemButton = [UIButton new];
        itemButton.tag = 100+i;
        [self.containView addSubview:itemButton];
        
        itemButton.titleLabel.font = [UtilFont systemLarge];
        [itemButton setTitleColor:CN_TEXT_GRAY forState:UIControlStateNormal];
        [itemButton setTitleColor:CN_TEXT_BLUE forState:UIControlStateSelected];
        
        itemButton.layer.cornerRadius = 3;
        itemButton.layer.masksToBounds = YES;
        [itemButton setTitle:itemname forState:UIControlStateNormal];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
        UIImage *streImage = [[UIImage imageNamed:@"box_grey_s"] resizableImageWithCapInsets:insets];
        UIImage *selStreImage = [[UIImage imageNamed:@"box_blue_s"] resizableImageWithCapInsets:insets];

        [itemButton setBackgroundImage:streImage forState:UIControlStateNormal];
        [itemButton setBackgroundImage:selStreImage forState:UIControlStateSelected];
        
        [itemButton addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.showsTouchWhenHighlighted = NO;
        itemButton.adjustsImageWhenHighlighted = NO;
        
        itemButton.frame = CGRectMake(leading + (i%colNum)*(width+leading), leading + (i/colNum)*(height+leading), width, height);
        
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


-(void)tapBK{
    if (self.delegate) {
        [self.delegate filterRedMoneDidTapClose];
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
//    
//    NSInteger tag = 0;
//    
//    //        self.array = @[@"全部",@"充值",@"提现",@"投资",@"还款",@"收回"];
//    
//    
//    if ([self.array[self.selIndex] isEqualToString:@"全部"]) {
//        tag = 0;
//    } else if ([self.array[self.selIndex] isEqualToString:@""]) {
//        tag = 1;
//    } else if ([self.array[self.selIndex] isEqualToString:@"提现"]) {
//        tag = 2;
//    } else if ([self.array[self.selIndex] isEqualToString:@"收益"]) {
//        tag = 3;
//    }  else if ([self.array[self.selIndex] isEqualToString:@"还款"]) {
//        tag = 4;
//    } else if ([self.array[self.selIndex] isEqualToString:@"收回"]) {
//        tag = 5;
//    }  else if ([self.array[self.selIndex] isEqualToString:@"投资"]) {
//        tag = 6;
//    }
//    
    
    if (self.delegate) {
        [self.delegate filterRedMoneyDidSelected:self.array[self.selIndex] tag:self.selIndex];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
