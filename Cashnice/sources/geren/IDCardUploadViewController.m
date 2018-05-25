//
//  IDCardUploadViewController.m
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IDCardUploadViewController.h"
#import "IDUploadAddPhotoCell.h"
#import "IDUploadTipCell.h"
#import "IDUploadBtnCell.h"
#import "CameraEngine.h"
#import "IDCardIdentifyMgr.h"
#import "CardVideoViewController.h"
#import "PersonInfoAPIEngine.h"

@interface IDCardUploadViewController ()<CameraEngineDelegate,UIActionSheetDelegate,CardVideoViewControllerDelegate>
{
    NSInteger cardType; //0正面     1反面
    
    NSMutableDictionary *succDectCardPic; //成功检测过得照片image
    
    CGFloat firstCellHeight;
    
    UIImage *zSuccDectImage;
    UIImage *fSuccDectImage;
    
    NSString *IDCardName; //身份证姓名
    NSString *IDCardNumber; //身份证号
    NSString *IDCardValidateNum;//身份证有效期

}
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) CameraEngine *cameraEngine;

@end

@implementation IDCardUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    self.title = @"上传身份证";
    [self setNavButton];
    
    
    succDectCardPic = @{}.mutableCopy;
    
    firstCellHeight = 37+ ((MainScreenWidth - 12*2)/1.6 +10)*2+20;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];

}

-(CameraEngine *)cameraEngine{
    
    if(!_cameraEngine){
        
        _cameraEngine = [[CameraEngine alloc] init];
        _cameraEngine.delegate = self;
        _cameraEngine.avoidCompressIMGQuailty = YES;
    }
    
    return _cameraEngine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return firstCellHeight;
    }else if(indexPath.row == 1){
        return 146;
    }else if(indexPath.row == 2){
        return 70;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WS(weakSelf)
        
        IDUploadAddPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDUploadAddPhotoCell_id"];
        cell.tapSelPhoto1=^{
            [weakSelf tapSelPhoto1];
        };
        
        cell.tapSelPhoto2=^{
            [weakSelf tapSelPhoto2];
        };
        
        cell.hasDetectCard1Succ = [succDectCardPic[@(0)] boolValue];
        cell.hasDetectCard2Succ =  [succDectCardPic[@(1)] boolValue];
        
        cell.imgView1.image = zSuccDectImage;
        cell.imgView2.image = fSuccDectImage;
        
        return cell;
    }if (indexPath.row == 1) {
        
        IDUploadTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDUploadTipCell_id"];
        return cell;
    }if (indexPath.row == 2) {
        
        IDUploadBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDUploadBtnCell_id"];
        
        if([succDectCardPic[@(0)] boolValue] && [succDectCardPic[@(1)] boolValue]){
            cell.available = YES;
        }else{
            cell.available = NO;
        }
        
        WS(weakSelf)
        cell.uploadIDCardAction = ^{
            
            [weakSelf uploadAction];
            
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

//- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        
////        [succDectCardPic setObject:@(YES) forKey:@(cardType)];
////        NSLog(@"%d",  [succDectCardPic[@(0)] boolValue]);
////
////        [self.tableView reloadData];
////        return;
//
//        
//        [self.navigationController pushViewController:[MeRouter cardIDTakeViewController:cardType delegate:self] animated:YES];
//    }else{
//        
////        [self.cameraEngine openPhotoAlbum:self editable:YES];
////        [];
//
//    }
//    
//}

#pragma mark CameraEngineDelegate -

-(void)CameraDidChoseMultiplePhotosFromAlbum:(NSArray *)_imgs{
    
    if (_imgs.count) {
        
        UIImage *image = _imgs[0];
        [self certifyIDCard:image];
    }
    
}


-(void)CameraFailed:(int)_code Err:(NSString *)errormsg{
}


-(void)tapSelPhoto1{
    //正面
    cardType = 0;
    [self pickPhoto];
}

-(void)tapSelPhoto2{
    //反面
    cardType = 1;
    [self pickPhoto];
}

#pragma mark -  CERTIFY

-(void)certifyIDCard:(UIImage *)_img{
    
    progress_show
    
    [IDCardIdentifyMgr identify:_img cardType:cardType success:^(BOOL resultCode,NSDictionary*detail) {
        progress_hide

        if (resultCode) {
            
            [succDectCardPic setObject:@(YES) forKey:@(cardType)];
            //正面
            if (cardType == 0) {
                IDCardName = detail[@"name"];
                IDCardNumber = detail[@"id"];
                zSuccDectImage = _img;
                
            }else{
                fSuccDectImage = _img;
                IDCardValidateNum = detail[@"valid_date"];
            }
            
            
            [self.tableView reloadData];
            
        }else{
//            [Util toast:@"tip.idcardauthen.failed"];
//            [Util toast:@"++++++++++++++++++++++"];
        }
        
    }];
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


#pragma mark - UPLOAD

-(void)uploadAction{
    
    WS(weakSelf)
    
    progress_show
    
    [[PersonInfoAPIEngine sharedInstance] uploadCardID:zSuccDectImage fimage:fSuccDectImage success:^{
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(IDCardCertifiedUploaded:cardNumber:)]) {
        [self.delegate IDCardCertifiedUploaded:IDCardName cardNumber:IDCardNumber];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
