//
//  TZPhotoPickerController.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "TZPhotoPickerController.h"
#import "TZImagePickerController.h"
#import "TZPhotoPreviewController.h"
#import "TZAssetCell.h"
#import "TZAssetModel.h"
#import "UIView+Layout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "CameraEngine.h"

@interface TZPhotoPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,CardVideoViewControllerDelegate> {
    NSMutableArray *_models;
    
    UIButton *_previewButton;
    UIButton *_okButton;
    UIImageView *_numberImageView;
    UILabel *_numberLable;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLable;
    UILabel *_titleLable;
    UIImageView *_arrow;
    
    UIView *_bottomToolBar;
    
    BOOL _shouldScrollToBottom;
    BOOL _showTakePhotoBtn;
}
@property CGRect previousPreheatRect;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSMutableArray<UIButton *> *previewViews;
@property (nonatomic, strong) UIControl *backgroundView;
@end

static CGSize AssetGridThumbnailSize;

@implementation TZPhotoPickerController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    _isSelectOriginalPhoto = tzImagePickerVc.isSelectOriginalPhoto;
    _shouldScrollToBottom = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitleView:[self titleView]];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    //Right
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 9, 45, 22)];
    editBtn.titleLabel.font = [UtilFont systemLargeNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"取消" forState:UIControlStateNormal];
    editBtn.backgroundColor = [UIColor clearColor];
//    editBtn.layer.borderWidth = 1;
//    editBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    editBtn.layer.cornerRadius = 5;
//    editBtn.layer.masksToBounds = YES;
    UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, KNAV_SUBVIEW_MAXHEIGHT)];
    [containerView1 addSubview:editBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:containerView1];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    _showTakePhotoBtn = (([_model.name isEqualToString:@"相机胶卷"] || [_model.name isEqualToString:@"Camera Roll"] ||  [_model.name isEqualToString:@"所有照片"] || [_model.name isEqualToString:@"All Photos"]) && tzImagePickerVc.allowTakePicture);
    
    if (!tzImagePickerVc.sortAscendingByModificationDate && _isFirstAppear && iOS8Later) {
        [[TZImageManager manager] getCameraRollAlbum:tzImagePickerVc.allowPickingVideo allowPickingImage:tzImagePickerVc.allowPickingImage completion:^(TZAlbumModel *model) {
            _model = model;
            _models = [NSMutableArray arrayWithArray:_model.models];
            [self initSubviews];
        }];
    } else {
        if (_showTakePhotoBtn || !iOS8Later || _isFirstAppear) {
            [[TZImageManager manager] getAssetsFromFetchResult:_model.result allowPickingVideo:tzImagePickerVc.allowPickingVideo allowPickingImage:tzImagePickerVc.allowPickingImage completion:^(NSArray<TZAssetModel *> *models) {
                _models = [NSMutableArray arrayWithArray:models];
                [self initSubviews];
            }];
        } else {
            _models = [NSMutableArray arrayWithArray:_model.models];
            [self initSubviews];
        }
    }
    // [self resetCachedAssets];
    
    [self testView];
}

- (UIView *)titleView{
    UIView *titleiew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, KNAV_SUBVIEW_MAXHEIGHT)];
    UIView *contentView = [UIView new];
    [titleiew addSubview:contentView];
    
    _titleLable = [UILabel new];
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.font = [UIFont systemFontOfSize:20];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.text = _model.name;
    [_titleLable sizeToFit];
    [contentView addSubview:_titleLable];
    
    _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamedFromMyBundle:@"row_white_up.png"]];
    _arrow.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:_arrow];
    
    UIButton *actionButton = [UIButton new];
    [actionButton addTarget:self action:@selector(showAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    
    [titleiew addSubview:actionButton];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleiew);
        make.centerX.equalTo(titleiew);
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLable.mas_right).with.offset(8);
        make.right.equalTo(contentView.mas_right);
        make.centerY.equalTo(_titleLable.mas_centerY);
    }];
    
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView).with.offset(-20);
        make.right.equalTo(contentView).with.offset(20);
        make.height.equalTo(contentView).with.offset(20);
    }];
    
    return titleiew;
}

TZAlbumPickerView *v;
bool isShow;
- (void)testView{
    
    //TZAlbumPickerController *albumPickerVc = [[TZAlbumPickerController alloc] init];
    //[self addChildViewController:albumPickerVc];
//    self.backgroundView;
    [self backgroundView];
    
    v = [[TZAlbumPickerView alloc] init];
    v.target = self;
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    [self.view bringSubviewToFront:v];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@0);
    }];
}

- (void)showAlbumAction{
    
    v.target = self;
    
    CGFloat contentHeight = v.contentSize.height;
    if (contentHeight > self.view.height) {
        contentHeight = self.view.height;
    }
    
    [v mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(isShow?@0:@(contentHeight));
    }];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.5 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        [self.view layoutIfNeeded] ;
        [_arrow.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        isShow = !isShow;;
    }];
    
    // 旋转箭头
    float angle = isShow ? 0.0f : M_PI;
    [UIView animateWithDuration:0.2f animations:^{
        _arrow.transform = CGAffineTransformMakeRotation(angle);
    }];

    
    self.backgroundView.hidden = isShow;
}

- (UIControl *)backgroundView{
    if (! _backgroundView) {
        _backgroundView = [UIControl new];
    
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backgroundView.hidden = YES;
        
        [_backgroundView addTarget:self action:@selector(backTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backgroundView];
        
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _backgroundView;
}

- (void)backTouched{
    [self showAlbumAction];
}

- (void)initSubviews {
    [self checkSelectedModels];
    [self configCollectionView];
    [self configBottomToolBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    tzImagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (self.backButtonClickHandle) {
        self.backButtonClickHandle(_model);
    }
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (self.view.tz_width - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    CGFloat top = margin;
    //if (iOS7Later) top += 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, top, self.view.tz_width - 2 * margin, self.view.tz_height - 50 - top) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(margin);
        make.top.equalTo(self.view).with.offset(top);
        make.width.equalTo(self.view).with.offset(- 2 * margin);
        make.bottom.equalTo(self.view.mas_bottomMargin).with.offset(-50-top);
    }];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    if (iOS7Later) _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (_showTakePhotoBtn && tzImagePickerVc.allowTakePicture ) {
        _collectionView.contentSize = CGSizeMake(self.view.tz_width, ((_model.count + 4) / 4) * self.view.tz_width);
    } else {
        _collectionView.contentSize = CGSizeMake(self.view.tz_width, ((_model.count + 3) / 4) * self.view.tz_width);
    }
    [_collectionView registerClass:[TZAssetCell class] forCellWithReuseIdentifier:@"TZAssetCell"];
    [_collectionView registerClass:[TZAssetCameraCell class] forCellWithReuseIdentifier:@"TZAssetCameraCell"];
}

- (void)setModel:(TZAlbumModel *)model{
    _model = model;
    _models = [NSMutableArray arrayWithArray:_model.models];;
    _titleLable.text = model.name;
    
    [self checkSelectedModels];
    [_collectionView reloadData];
    
    _shouldScrollToBottom = YES;
    [self scrollCollectionViewToBottom];
    
//    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollCollectionViewToBottom];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = 2.0;
    if ([UIScreen mainScreen].bounds.size.width > 600) {
        scale = 1.0;
    }
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (iOS8Later) {
        // [self updateCachedAssets];
    }
}

- (void)configBottomToolBar {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    _bottomToolBar = [[UIView alloc] init];
    _bottomToolBar.backgroundColor =  ZCOLOR(@"#c5c6c7");
    [self.view addSubview:_bottomToolBar];
    
    [_bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@50);
    }];
    
    /*
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.frame = CGRectMake(10, 3, 44, 44);
    [_previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [_previewButton setTitle:@"预览" forState:UIControlStateDisabled];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.enabled = tzImagePickerVc.selectedModels.count;
     */
    
    if (tzImagePickerVc.allowPickingOriginalPhoto) {
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalPhotoButton.frame = CGRectMake(50, self.view.tz_height - 50, 130, 50);
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _originalPhotoButton.contentEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 0);
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_originalPhotoButton setTitle:@"原图" forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:@"原图" forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:@"photo_original_def.png"] forState:UIControlStateNormal];
        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:@"photo_original_sel.png"] forState:UIControlStateSelected];
        _originalPhotoButton.selected = _isSelectOriginalPhoto;
        _originalPhotoButton.enabled = tzImagePickerVc.selectedModels.count > 0;
        
        _originalPhotoLable = [[UILabel alloc] init];
        _originalPhotoLable.frame = CGRectMake(70, 0, 60, 50);
        _originalPhotoLable.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLable.font = [UIFont systemFontOfSize:16];
        _originalPhotoLable.textColor = [UIColor blackColor];
        if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
    }
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.frame = CGRectMake(self.view.tz_width - 90 - 12, 8, 90, 34);
    _okButton.layer.cornerRadius = 4;
    _okButton.layer.masksToBounds = YES;
    _okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *buttonTitle = [NSString stringWithFormat:@"完成(%zd/%zd)",tzImagePickerVc.selectedModels.count, tzImagePickerVc.maxImagesCount];
    [_okButton setTitle:buttonTitle forState:UIControlStateNormal];
    [_okButton setTitle:buttonTitle forState:UIControlStateDisabled];
    [_okButton setBackgroundColor:ZCOLOR(COLOR_NAV_BG_RED)];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//    _okButton.enabled = tzImagePickerVc.selectedModels.count;
    
    _numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedFromMyBundle:@"photo_number_icon.png"]];
    _numberImageView.frame = CGRectMake(self.view.tz_width - 56 - 24, 12, 26, 26);
    _numberImageView.hidden = tzImagePickerVc.selectedModels.count <= 0;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLable = [[UILabel alloc] init];
    _numberLable.frame = _numberImageView.frame;
    _numberLable.font = [UIFont systemFontOfSize:16];
    _numberLable.textColor = [UIColor whiteColor];
    _numberLable.textAlignment = NSTextAlignmentCenter;
    _numberLable.text = [NSString stringWithFormat:@"%zd",tzImagePickerVc.selectedModels.count];
    _numberLable.hidden = tzImagePickerVc.selectedModels.count <= 0;
    _numberLable.backgroundColor = [UIColor clearColor];
    
    UIView *divide = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    divide.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    divide.frame = CGRectMake(0, 0, self.view.tz_width, 1);

    [_bottomToolBar addSubview:divide];
    //[_bottomToolBar addSubview:_previewButton];
    //[_bottomToolBar addSubview:_numberImageView];
    //[_bottomToolBar addSubview:_numberLable];
    //[self.view addSubview:_originalPhotoButton];
    //[_originalPhotoButton addSubview:_originalPhotoLable];
    
    [_bottomToolBar addSubview:_okButton];
    [self refreshBottomToolBarStatus];
}

- (NSMutableArray *)previewViews{
    if (! _previewViews) {
        TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
        _previewViews = [[NSMutableArray alloc] init];
        for (int i = 0; i <= tzImagePickerVc.maxImagesCount; i++) {
            UIButton *previewView = [UIButton buttonWithType:UIButtonTypeCustom];
            previewView.tag = i;
            previewView.frame = CGRectMake(54*i + 10, 3, 44, 44);
            previewView.imageView.contentMode = UIViewContentModeScaleAspectFill;

            [previewView addTarget:self action:@selector(buttonpress1:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomToolBar addSubview:previewView];
            [_previewViews addObject:previewView];
        }
    }
    return _previewViews;
}

- (void)buttonpress1:(UIButton *)button {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    NSInteger index = button.tag;
    if (tzImagePickerVc.selectedModels.count > index) {
        [tzImagePickerVc.selectedModels removeObjectAtIndex:index];
        
        [self refreshBottomToolBarStatus];
        [self checkSelectedModels];
        [_collectionView reloadData];
    }
}

#pragma mark - Click Event

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [imagePickerVc.pickerDelegate imagePickerControllerDidCancel:imagePickerVc];
    }
    if (imagePickerVc.imagePickerControllerDidCancelHandle) {
        imagePickerVc.imagePickerControllerDidCancelHandle();
    }
}

- (void)previewButtonClick {
    TZPhotoPreviewController *photoPreviewVc = [[TZPhotoPreviewController alloc] init];
    [self pushPhotoPrevireViewController:photoPreviewVc];
}

- (void)originalPhotoButtonClick {
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalPhotoLable.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
}

- (void)okButtonClick {
    
    
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    [tzImagePickerVc showProgressHUD];
    NSMutableArray *photos = [NSMutableArray array];
    NSMutableArray *assets = [NSMutableArray array];
    NSMutableArray *infoArr = [NSMutableArray array];
    
    if (! tzImagePickerVc.selectedModels.count) {
        if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
            [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto];
        }
        if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
            [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto infos:infoArr];
        }
        if (tzImagePickerVc.didFinishPickingPhotosHandle) {
            tzImagePickerVc.didFinishPickingPhotosHandle(photos,assets,_isSelectOriginalPhoto);
        }
        if (tzImagePickerVc.didFinishPickingPhotosWithInfosHandle) {
            tzImagePickerVc.didFinishPickingPhotosWithInfosHandle(photos,assets,_isSelectOriginalPhoto,infoArr);
        }
        [tzImagePickerVc hideProgressHUD];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        //[self cancel];
        return;
    }
    
    for (NSInteger i = 0; i < tzImagePickerVc.selectedModels.count; i++) {
        [photos addObject:@1];
        [assets addObject:@1];
        [infoArr addObject:@1];
    }
    
    [TZImageManager manager].shouldFixOrientation = YES;
    for (NSInteger i = 0; i < tzImagePickerVc.selectedModels.count; i++) {
        TZAssetModel *model = tzImagePickerVc.selectedModels[i];
        
        [[TZImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) return;
            
//            if(self.captureIDCardModel && !ScreenInch4s){
                if ( photo) {
                    photo = [self scaleImage:photo toSize:CGSizeMake(tzImagePickerVc.photoWidth, (int)(tzImagePickerVc.photoWidth * photo.size.height / photo.size.width))];
                    [photos replaceObjectAtIndex:i withObject:photo];
                }
//            }
            

            if (info)  [infoArr replaceObjectAtIndex:i withObject:info];
            [assets replaceObjectAtIndex:i withObject:model.asset];

            for (id item in photos) { if ([item isKindOfClass:[NSNumber class]]) return; }
            
            if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
                
                //单独处理身份证拍摄时候的切割问题
                if(self.captureIDCardModel && photos.count == 1 && tzImagePickerVc.needCropFromCardID){
                    UIImage *cropImage = [CameraEngine cropCapRegionIDCard:photos[0]];
                    [photos replaceObjectAtIndex:0 withObject:cropImage];

                }

                
                [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto];
            }
            if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
                [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto infos:infoArr];
            }
            if (tzImagePickerVc.didFinishPickingPhotosHandle) {
                tzImagePickerVc.didFinishPickingPhotosHandle(photos,assets,_isSelectOriginalPhoto);
            }
            if (tzImagePickerVc.didFinishPickingPhotosWithInfosHandle) {
                tzImagePickerVc.didFinishPickingPhotosWithInfosHandle(photos,assets,_isSelectOriginalPhoto,infoArr);
            }
            [tzImagePickerVc hideProgressHUD];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_showTakePhotoBtn) {
        TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
        if (tzImagePickerVc.allowPickingImage && tzImagePickerVc.allowTakePicture) {
            return _models.count + 1;
        }
    }
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // the cell lead to take a picture / 去拍照的cell
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (((tzImagePickerVc.sortAscendingByModificationDate && indexPath.row >= _models.count) || (!tzImagePickerVc.sortAscendingByModificationDate && indexPath.row == 0)) && _showTakePhotoBtn) {
        TZAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZAssetCameraCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamedFromMyBundle:@"takePicture.png"];
        return cell;
    }
    // the cell dipaly photo or video / 展示照片或视频的cell
    TZAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZAssetCell" forIndexPath:indexPath];
    TZAssetModel *model;
    if (tzImagePickerVc.sortAscendingByModificationDate || !_showTakePhotoBtn) {
        model = _models[indexPath.row];
    } else {
        model = _models[indexPath.row - 1];
    }
    cell.model = model;
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    __weak typeof(_numberImageView.layer) weakLayer = _numberImageView.layer;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)weakSelf.navigationController;
        // 1. cancel select / 取消选择
        if (isSelected) {
            weakCell.selectPhotoButton.selected = NO;
            model.isSelected = NO;
            NSArray *selectedModels = [NSArray arrayWithArray:tzImagePickerVc.selectedModels];
            for (TZAssetModel *model_item in selectedModels) {
                if ([[[TZImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[TZImageManager manager] getAssetIdentifier:model_item.asset]]) {
                    [tzImagePickerVc.selectedModels removeObject:model_item];
                    break;
                }
            }
            [weakSelf refreshBottomToolBarStatus];
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            if (tzImagePickerVc.selectedModels.count < tzImagePickerVc.maxImagesCount) {
                weakCell.selectPhotoButton.selected = YES;
                model.isSelected = YES;
                [tzImagePickerVc.selectedModels addObject:model];
                [weakSelf refreshBottomToolBarStatus];
            } else {
                [tzImagePickerVc showAlertWithTitle:[NSString stringWithFormat:@"您最多只能选择%zd张照片",tzImagePickerVc.maxImagesCount]];
            }
        }
        [UIView showOscillatoryAnimationWithLayer:weakLayer type:TZOscillatoryAnimationToSmaller];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // take a photo / 去拍照
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (((tzImagePickerVc.sortAscendingByModificationDate && indexPath.row >= _models.count) || (!tzImagePickerVc.sortAscendingByModificationDate && indexPath.row == 0)) && _showTakePhotoBtn)  {
        if (tzImagePickerVc.selectedModels.count >= tzImagePickerVc.maxImagesCount) {
            [tzImagePickerVc showAlertWithTitle:[NSString stringWithFormat:@"您最多只能选择%zd张照片",tzImagePickerVc.maxImagesCount]];
            return;
        }
        [self takePhoto]; return;
    }
    // preview phote or video / 预览照片或视频
    NSInteger index = indexPath.row;
    if (!tzImagePickerVc.sortAscendingByModificationDate && _showTakePhotoBtn) {
        index = indexPath.row - 1;
    }
    TZAssetModel *model = _models[index];
    if (model.type == TZAssetModelMediaTypeVideo) {
        if (tzImagePickerVc.selectedModels.count > 0) {
            TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
            [imagePickerVc showAlertWithTitle:@"选择照片时不能选择视频"];
        } else {
            TZVideoPlayerController *videoPlayerVc = [[TZVideoPlayerController alloc] init];
            videoPlayerVc.model = model;
            [self.navigationController pushViewController:videoPlayerVc animated:YES];
        }
    } else {
        TZPhotoPreviewController *photoPreviewVc = [[TZPhotoPreviewController alloc] init];
        photoPreviewVc.currentIndex = index;
        photoPreviewVc.models = _models;
        [self pushPhotoPrevireViewController:photoPreviewVc];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (iOS8Later) {
        // [self updateCachedAssets];
    }
}

#pragma mark - Private Method

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else { // 调用相机
        
        if (!self.captureIDCardModel) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                self.imagePickerVc.sourceType = sourceType;
                if(iOS8Later) {
                    _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                }
                [self presentViewController:_imagePickerVc animated:YES completion:nil];
            } else {
                NSLog(@"模拟器中无法打开照相机,请在真机中使用");
            }
        }else{
            
//            NSInteger cardType = 1;
            [self presentViewController:[MeRouter cardIDTakeViewController:self.cardType delegate:self] animated:YES completion:nil];
        }
        
    }
}


#pragma mark - CardVideoViewControllerDelegate

-(void)hasVerifyTakingPhotoCardSuccess:(UIImage *)takingPhoto detail:(NSDictionary *)detail cardType:(NSInteger)type{
    
    if (takingPhoto) {

//        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//        if ([type isEqualToString:@"public.image"]) {
            TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
            imagePickerVc.needCropFromCardID = YES;
            [imagePickerVc showProgressHUD];
//            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [[TZImageManager manager] savePhotoWithImage:takingPhoto completion:^{
                [self reloadPhotoArray];
                
                [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];

            }];
//        }

//            }
    }
}

- (void)refreshBottomToolBarStatus {
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    
    
    NSString *buttonTitle = [NSString stringWithFormat:@"完成(%zd/%zd)",imagePickerVc.selectedModels.count, imagePickerVc.maxImagesCount];
    [_okButton setTitle:buttonTitle forState:UIControlStateNormal];
    [_okButton setTitle:buttonTitle forState:UIControlStateDisabled];
    
    for (UIButton *preview in self.previewViews) {
//        [preview setBackgroundImage:nil forState:UIControlStateNormal];
        [preview setImage:nil forState:UIControlStateNormal];
    }
    
    NSUInteger index = 0;
    for (TZAssetModel *model in imagePickerVc.selectedModels) {
       
        [[TZImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//            [self.previewViews[index] setBackgroundImage:photo forState:UIControlStateNormal];
                [self.previewViews[index] setImage:photo forState:UIControlStateNormal];

        }];
        index++;
    }
    if (index < imagePickerVc.maxImagesCount) {
//        [self.previewViews[index] setBackgroundImage:[UIImage imageNamed:@"xuk.png"] forState:UIControlStateNormal];
        [self.previewViews[index] setImage:[UIImage imageNamed:@"xuk.png"] forState:UIControlStateNormal];

    }
    
    _previewButton.enabled = imagePickerVc.selectedModels.count > 0;
//    _okButton.enabled = imagePickerVc.selectedModels.count > 0;
    
    _numberImageView.hidden = imagePickerVc.selectedModels.count <= 0;
    _numberLable.hidden = imagePickerVc.selectedModels.count <= 0;
    _numberLable.text = [NSString stringWithFormat:@"%zd",imagePickerVc.selectedModels.count];
    
    _originalPhotoButton.enabled = imagePickerVc.selectedModels.count > 0;
    _originalPhotoButton.selected = (_isSelectOriginalPhoto && _originalPhotoButton.enabled);
    _originalPhotoLable.hidden = (!_originalPhotoButton.isSelected);
    if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
}

- (void)pushPhotoPrevireViewController:(TZPhotoPreviewController *)photoPreviewVc {
    __weak typeof(self) weakSelf = self;
    photoPreviewVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    photoPreviewVc.backButtonClickBlock = ^(BOOL isSelectOriginalPhoto) {
        weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [weakSelf.collectionView reloadData];
        [weakSelf refreshBottomToolBarStatus];
    };
    photoPreviewVc.okButtonClickBlock = ^(BOOL isSelectOriginalPhoto){
        weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [weakSelf okButtonClick];
    };
    [self.navigationController pushViewController:photoPreviewVc animated:YES];
}

- (void)getSelectedPhotoBytes {
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    [[TZImageManager manager] getPhotosBytesWithArray:imagePickerVc.selectedModels completion:^(NSString *totalBytes) {
        _originalPhotoLable.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}

/// Scale image / 缩放图片
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width < size.width) {
        return image;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)scrollCollectionViewToBottom {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (_shouldScrollToBottom && _models.count > 0 && tzImagePickerVc.sortAscendingByModificationDate) {
        NSInteger item = _models.count - 1;
        if (_showTakePhotoBtn) {
            TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
            if (tzImagePickerVc.allowPickingImage && tzImagePickerVc.allowTakePicture) {
                item += 1;
            }
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        _shouldScrollToBottom = NO;
    }
}

- (void)checkSelectedModels {
    for (TZAssetModel *model in _models) {
        model.isSelected = NO;
        NSMutableArray *selectedAssets = [NSMutableArray array];
        TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
        for (TZAssetModel *model in tzImagePickerVc.selectedModels) {
            [selectedAssets addObject:model.asset];
        }
        if ([[TZImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            model.isSelected = YES;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=Photos"]];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
        [imagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            [self reloadPhotoArray];
        }];
    }
}

- (void)reloadPhotoArray{
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    [[TZImageManager manager] getCameraRollAlbum:tzImagePickerVc.allowPickingVideo allowPickingImage:tzImagePickerVc.allowPickingImage completion:^(TZAlbumModel *model) {
        _model = model;
        
        [[TZImageManager manager] getAssetsFromFetchResult:_model.result allowPickingVideo:tzImagePickerVc.allowPickingVideo allowPickingImage:tzImagePickerVc.allowPickingImage completion:^(NSArray<TZAssetModel *> *models) {
            [tzImagePickerVc hideProgressHUD];
            
            TZAssetModel *assetModel;
            if (tzImagePickerVc.sortAscendingByModificationDate) {
                assetModel = [models lastObject];
                [_models addObject:assetModel];
            } else {
                assetModel = [models firstObject];
                [_models insertObject:assetModel atIndex:0];
            }
            if (tzImagePickerVc.selectedModels.count < tzImagePickerVc.maxImagesCount) {
                assetModel.isSelected = YES;
                [tzImagePickerVc.selectedModels addObject:assetModel];
                [self refreshBottomToolBarStatus];
            }
            [_collectionView reloadData];
            
            
            _shouldScrollToBottom = YES;
            [self scrollCollectionViewToBottom];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [[TZImageManager manager].cachingImageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = _collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(_collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [[TZImageManager manager].cachingImageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [[TZImageManager manager].cachingImageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < _models.count) {
            TZAssetModel *model = _models[indexPath.item];
            [assets addObject:model.asset];
        }
    }
    
    return assets;
}

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [_collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end
