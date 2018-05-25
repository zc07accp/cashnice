//
//  IDCardUploadViewController.m
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LicenseUploadViewController.h"
#import "IDUploadAddPhotoCell.h"
#import "IDUploadTipCell.h"
#import "IDUploadBtnCell.h"
#import "CameraEngine.h"
#import "IDCardIdentifyMgr.h"
#import "CardVideoViewController.h"
#import "PersonInfoAPIEngine.h"

@interface LicenseUploadViewController ()<CameraEngineDelegate,UIActionSheetDelegate,CardVideoViewControllerDelegate>
{
    NSInteger cardType;
}
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) CameraEngine *cameraEngine;
@property (nonatomic,assign) BOOL actonAvailable;
@property (nonatomic,strong) UIImage *succDectImage;

@property (nonatomic,weak) IBOutlet UIImageView *imgView;
@property (nonatomic,weak) IBOutlet UIView *view1;
@property (nonatomic,weak) IBOutlet UIView *pushView;
@property (nonatomic,weak) IBOutlet UIButton *actionButton;

@property (nonatomic,weak) IBOutlet UILabel *requirementLabel;
@property (nonatomic,weak) IBOutlet UILabel *infoLabel;
@property (nonatomic,weak) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerLabelHeight;


@end

@implementation LicenseUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cardType = 2;
    
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    self.view1.backgroundColor = ZCOLOR(COLOR_BUTTON_BLUE);
    self.actonAvailable = NO;
    
    self.title = @"营业执照";
    [self setNavButton];
    
    self.actionButton.layer.cornerRadius = 3;
    
    self.requirementLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.requirementLabel.font = CNFont_26px;
    
    self.headerLabel.font = CNFont_26px;
    
    [self setupInfoContext];
    
    progress_show
}

- (void)getLicenseInfo{
    
    [[PersonInfoAPIEngine sharedInstance] getLicenseDetailSuccess:^(NSDictionary *licenseDict) {
        progress_hide
        [self setupUIwithLicenseInfo:licenseDict];
    } failure:^(NSString *error) {
        progress_hide;
    }];
}

- (void)setupUIwithLicenseInfo:(NSDictionary *)licenseInfo{
    NSInteger status = [licenseInfo[@"status"] integerValue];
    NSString *fileName = licenseInfo[@"fileName"];
    
    if (status < 0) {
        //未传
        self.headerLabel.text = @"";
        self.headerLabelHeight.constant = [ZAPP.zdevice getDesignScale:10.0f];
    }else{
        self.headerLabelHeight.constant = [ZAPP.zdevice getDesignScale:31.0f];
        if (status == 1) {
            //认证成功
            self.headerLabel.text = @"营业执照-已认证";
        }else{
            self.headerLabel.text = @"营业执照-未认证";
        }
    }
    
    if (fileName.length > 1 && !self.succDectImage) {
        [self.imgView setImageFromURL:[NSURL URLWithString:fileName]];
        self.pushView.hidden = YES;
    }
}

- (NSUInteger)authStatus{
    return [ZAPP.myuser hasBusinessLicense];
}

- (void)setupInfoContext{
    NSString *str = self.infoLabel.text;
    NSMutableAttributedString *attStr = [Util getAttributedString:str font:CNFont_24px color:HexRGB(0x888888)];
    [Util setAttributedString:attStr font:CNFont_24px color:HexRGB(0xe68525) substr:@"边框完整，字体清晰，亮度均匀" allstr:str];
    self.infoLabel.text = nil;
    self.infoLabel.attributedText = attStr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self getLicenseInfo];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)setActonAvailable:(BOOL)actonAvailable {
    
    self.actionButton.backgroundColor = actonAvailable?ZCOLOR(COLOR_NAV_BG_RED):ZCOLOR(COLOR_BUTTON_DISABLE);
    NSString*text = @"请上传营业执照";
    [self.actionButton setTitle:text forState:UIControlStateNormal];
    self.actionButton.userInteractionEnabled = actonAvailable;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadCardAction:(id)sender {
    [self pickPhoto];
}

- (void)setSuccDectImage:(UIImage *)succDectImage{
    if (succDectImage) {
        _succDectImage = succDectImage;
        self.actonAvailable = YES;
        self.pushView.hidden = YES;
    }
}

-(CameraEngine *)cameraEngine{
    
    if(!_cameraEngine){
        
        _cameraEngine = [[CameraEngine alloc] init];
        _cameraEngine.delegate = self;
        _cameraEngine.avoidCompressIMGQuailty = YES;
    }
    
    return _cameraEngine;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        
        IDUploadBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDUploadBtnCell_id"];
        
        cell.available = NO;
        cell.available = YES;
        cell.uploadIDCardAction = ^{
            
        [self uploadAction];
            
        };
        return cell;
    }
    
    return nil;
}


-(void)pickPhoto{
//    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
//    [sheet showInView:self.view];
    
    [self.cameraEngine presentTZImagePicker:YES type:cardType];
}

#pragma mark CameraEngineDelegate -

-(void)CameraDidChoseMultiplePhotosFromAlbum:(NSArray *)_imgs{
    
    if (_imgs.count) {
        
        self.succDectImage = _imgs[0];
        
        self.imgView.image = self.succDectImage;
        
        //[self uploadAction];
        
        //[self certifyIDCard:image];
    }
    
}


-(void)CameraFailed:(int)_code Err:(NSString *)errormsg{
}

//#pragma mark - CardVideoViewControllerDelegate
//
//-(void)hasVerifyTakingPhotoCardSuccess:(UIImage *)takingPhoto detail:(NSDictionary *)detail cardType:(NSInteger)type{
//
//    
//    
//    if (takingPhoto) {
//    
//        [succDectCardPic setObject:takingPhoto forKey:@(cardType)];
//        [succDectCardPic setObject:@(YES) forKey:@(cardType)];
//    
//        [self.tableView reloadData];
//    }
//}

- (IBAction)buttonAction:(id)sender {
    [self uploadAction];
}

#pragma mark - UPLOAD

-(void)uploadAction{
    
    WS(weakSelf)
    
    progress_show
    
    [[PersonInfoAPIEngine sharedInstance] uploadLicense:self.succDectImage success:^{
        NSLog(@"upload ok all");
        progress_hide

        [weakSelf uploadZFIDCardsCompletely];
    } failure:^{
        progress_hide
    }];
    
    
//    [self uploadZIDCard:^(BOOL ret) {
//        
//        if (ret) {
//            [weakSelf uploadFIDCard:^(BOOL ret) {
//                if(ret){
//                    progress_hide
//
//                    IDCardUploadViewController *sself = weakSelf;
//                    if (!sself) return;
//                    NSLog(@"upload ok all");
//                    [sself uploadZFIDCardsCompletely];
//                    
//                }else{
//                    progress_hide
//                }
//            }];
//        }else{
//            progress_hide
//        }
//        
//    }];

}
//
//-(void)uploadZIDCard:(void (^)(BOOL))complete{
//    
//    [[PersonInfoAPIEngine sharedInstance] uploadCardID:zSuccDectImage type:0 success:^{
//        complete(YES);
//    } failure:^{
//        complete(NO);
//    }];
//}
//
//-(void)uploadFIDCard:(void (^)(BOOL))complete{
//    
//    [[PersonInfoAPIEngine sharedInstance] uploadCardID:fSuccDectImage type:1 success:^{
//        complete(YES);
//    } failure:^{
//        complete(NO);
//    }];
//}

-(void)uploadZFIDCardsCompletely{
    
    [Util toast:@"营业执照上传成功，请等待审核！"];
    
    POST_USERINFOFRESH_NOTI
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LicenseUploaded)]) {
        [self.delegate LicenseUploaded];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
