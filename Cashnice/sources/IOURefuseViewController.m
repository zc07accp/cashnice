//
//  IOURefuseViewController.m
//  Cashnice
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOURefuseViewController.h"
#import "SocietyPositionItemView.h"
#import "CNBlueBtn.h"
#import "IOU.h"
#import "IOUDetailEngine.h"

@interface IOURefuseViewController ()
{
    NSDictionary *selReasonDic;
    
}
@property (weak, nonatomic) IBOutlet UIView *reasonBkView;
@property (weak, nonatomic) IBOutlet CNBlueBtn *sureBtn;
@property (strong,nonatomic) IOUDetailEngine *engine;

@property (assign, nonatomic) NSInteger selIndex;


@end

@implementation IOURefuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];

    self.selIndex = 0;
    
//    UIView *superView = self.view;
//    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.right.equalTo(superView).offset(-15);
//        make.top.equalTo(self.reasonBkView.mas_bottom).offset(20);
////        make.width.equalTo(@64);
////        make.height.equalTo(@30);
//        
//    }];
    
    self.sureBtn.left = self.view.width - 15 - BLUESURE_WIDTH;
    self.sureBtn.top = self.reasonBkView.bottom+20;
    
    
    [self layoutBtns];
    
    self.sureBtn.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"驳回";
}

- (IBAction)sure:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(refuseDidSelected:)]) {
        [self.delegate refuseDidSelected:selReasonDic];
    }
    
}

-(void)layoutBtns{
    
    [self.reasonBkView removeAllSubviews];
    
    CGFloat fitHeight=0.f;
    
    static CGFloat BTN_LEFT = 15.f;
    static CGFloat BTN_TOP = 15.f;
    
    CGFloat currentAnchor = 15.f;
    CGFloat currentLeading = 15.f;
    
    int idx = 0;
    for (; idx < self.refuse_arr.count; idx++) {
        NSDictionary *thisData = self.refuse_arr[idx];
        NSString *itemname =thisData[@"itemname"];
        
        UIButton *itemButton = [UIButton new];
        itemButton.tag = 100+idx;
        
        [self.reasonBkView addSubview:itemButton];
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
        if (aspiredLeft > self.reasonBkView.width) {
            currentLeading = BTN_LEFT;
            currentAnchor += (itemButton.height + [SocietyPositionItemView spaceHeight]);
        }
        
        itemButton.left = currentLeading;
        itemButton.top = currentAnchor;
        
        currentLeading += itemButton.width + [SocietyPositionItemView spaceWidth];
        
        
        fitHeight = currentAnchor + itemButton.height;
    }
    
    fitHeight += currentAnchor;
    
    self.reasonBkView.height = fitHeight;
    
    self.sureBtn.top = self.reasonBkView.bottom+20;

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

-(void)setSelIndex:(NSInteger)selIndex{
    _selIndex = selIndex;
    if (_selIndex>= 0 && _selIndex<self.refuse_arr.count) {
        selReasonDic = self.refuse_arr[_selIndex];
    }
    
}

- (IBAction)itemSelected:(UIButton *)sender {
    
    //单选,取消前面选中
    if(self.selIndex >= 0){
        UIButton *btn = [self.reasonBkView viewWithTag:100+self.selIndex];
        btn.selected = NO;
    }
    
    sender.selected = YES;
    NSInteger idx = sender.tag - 100;
    self.selIndex = idx;
    
    self.sureBtn.enabled = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showDia{
    progress_show

}

-(void)dismisDia{
    progress_hide
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
