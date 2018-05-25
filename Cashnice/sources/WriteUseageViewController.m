//
//  WriteUseageViewController.m
//  Cashnice
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import "WriteUseageViewController.h"
#import "SocietyPositionItemView.h"
#import "CertificateView.h"

@interface WriteUseageViewController ()<CertificateViewDelegate>
{
    CertificateView *_certificateView;
    NSArray *selPicsArr;
    
}
@property (weak, nonatomic) IBOutlet UIView *useageContainerView;
@property (weak, nonatomic) IBOutlet UIView *picsContainerVIew;
@property (weak, nonatomic) IBOutlet UIView *picsContainerBKVIew;

@property (weak, nonatomic) IBOutlet UILabel *selIdLabel;

@property (assign, nonatomic) NSInteger selIndex;


@end

@implementation WriteUseageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    
    // Do any additional setup after loading the view.
    [self setNavButton];
    [self setNavRightBtn];
    
    self.title = @"借款用途及凭证";
    [self layoutBtns];
    [self layoutPics];
    
    self.selIdLabel.text = self.selId == 0?@"出借人凭证":@"借款人凭证";
}


-(void)setSelId:(NSInteger)selId{
    _selId = selId;
    self.selIdLabel.text = self.selId == 0?@"出借人凭证":@"借款人凭证";
}

- (void)setNavButton {

//    UIView *containerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 90)];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [backBtn addTarget:self action:@selector(customNavBackPressed) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0, 4, 50, 25);
////    backBtn.layer.borderWidth = 1;
////    backBtn.layer.borderColor = [UIColor whiteColor].CGColor;
////    backBtn.layer.cornerRadius = 5;
////    backBtn.layer.masksToBounds = YES;
//    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
//   backBtn.titleLabel.font = [UtilFont systemLargeNormal ];
//
//    [containerView2 addSubview:backBtn];
//
//    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithCustomView:containerView2]]];
    [super setNavButton];
    [self.leftNavBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftNavBtn setImage:nil forState:UIControlStateNormal];

//    self.leftNavBtn.layer
//    self.leftNavBtn
}


-(void)setNavRightBtn{
    [super setNavRightBtn];
    
    [self.rightNavBtn setTitle:@"确定" forState:UIControlStateNormal];
}

-(void)rightNavItemAction{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(didSelectedUseage:picsArr:)]) {
        
        
        
        [self.deleagte didSelectedUseage: _selIndex<ZAPP.myuser.iouUseage.count?
         ZAPP.myuser.iouUseage[_selIndex]:nil
                                 picsArr:[_certificateView.certificates count]?_certificateView.certificates:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)layoutBtns{
    
    [self.useageContainerView removeAllSubviews];
    
    CGFloat fitHeight=0.f;
    
    static CGFloat initial_y = 15.f;
    static CGFloat initial_x = 15.f;
    
    CGFloat currentAnchor = initial_y;
    CGFloat currentLeading = initial_x;
    
    int idx = 0;
    NSLog(@"ZAPP.myuser.iouUseage.count = %d", ZAPP.myuser.iouUseage.count);
    for (; idx < ZAPP.myuser.iouUseage.count; idx++) {
        NSDictionary *thisData = ZAPP.myuser.iouUseage[idx];
        NSString *itemname =thisData[@"itemname"];
        
        UIButton *itemButton = [UIButton new];
        itemButton.tag = 100+idx;
        
        
        if (self.selReasonDic && [itemname isEqualToString:self.selReasonDic[@"itemname"]]) {
            itemButton.selected = YES;
            _selIndex = idx;
        }
        
        
        [self.useageContainerView addSubview:itemButton];
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
        if (aspiredLeft > self.useageContainerView.width) {
            currentLeading = initial_x;
            currentAnchor += (itemButton.height + [SocietyPositionItemView spaceHeight]);
        }
        
        itemButton.left = currentLeading;
        itemButton.top = currentAnchor;
        
        currentLeading += itemButton.width + [SocietyPositionItemView spaceWidth];
        
        
        fitHeight = currentAnchor + itemButton.height;
    }
    
    fitHeight +=  initial_y;
    
    self.useageContainerView.height = fitHeight;
    
    self.picsContainerBKVIew.top = self.useageContainerView.height+self.useageContainerView.top;
    
}

 

- (IBAction)itemSelected:(UIButton *)sender {
    
    //单选,取消前面选中
    if(self.selIndex >= 0){
        UIButton *btn = [self.useageContainerView viewWithTag:100+self.selIndex];
        btn.selected = NO;
    }
    
    sender.selected = YES;
    NSInteger idx = sender.tag - 100;
    self.selIndex = idx;
    
//    self.sureBtn.enabled = YES;
    
}

-(void)layoutPics{
 
    _certificateView = [[CertificateView alloc] initWithTargetViewController:self];
//    _certificateView.certificateDelegate = self;
    _certificateView.userPerationEnabled = YES;
    _certificateView.maxImagesCount = 2;
    [self.picsContainerVIew addSubview:_certificateView];
  
    UIView *superView = self.picsContainerVIew;
    
    [_certificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView);
        make.bottom.equalTo(superView.mas_bottom);
        make.right.equalTo(superView);
    }];

    if (self.existedUrlsArr) {
        [_certificateView addPreviewImageURLs:self.existedUrlsArr];
    }
}


//-(void)setExistedUrlsArr:(NSArray *)existedUrlsArr{
//    [_certificateView addPreviewImageURLs:existedUrlsArr];
//}

//#pragma mark - CertificateViewDelegate
//- (void)certificateView:(CertificateView *)certificateView didFinishPickingPhotos:(NSArray<UIImage *> *)photos{
//    
//    selPicsArr = photos;
//}
//
//- (void)certificatePickerDidCancel:(CertificateView *)certificateView{
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//-(void)setExistedUrlsArr:(NSArray *)existedUrlsArr{
//    
////    _existedUrlsArr = [NSMutableArray array];
////
////    for(NSDictionary *dic in existedUrlsArr){
////        [_existedUrlsArr addObject:dic[@"url"]];
////    }
//    
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
