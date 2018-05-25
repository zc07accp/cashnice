//
//  CertificateView.m
//  Cashnice
//
//  Created by a on 16/7/30.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CertificateView.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPickerController.h"

@interface CertificateView ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
    UIViewController *_target;
    
    UILabel         *_promptView;
}

@end

@implementation CertificateView

- (instancetype)initWithTargetViewController:(UIViewController *)target{
    _target = target;
    _layout = [[LxGridViewFlowLayout alloc] init];
    
    self = [super initWithFrame:CGRectZero collectionViewLayout:_layout];
    
    if (self) {
        [self configCollectionView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame targetViewController:(UIViewController *)target{
    _target = target;
    _layout = [[LxGridViewFlowLayout alloc] init];
    
    self = [super initWithFrame:frame collectionViewLayout:_layout];
    
    if (self) {
        [self configCollectionView];
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _itemWH = self.optimumHeight;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    //_layout.minimumInteritemSpacing = _margin;
    //_layout.minimumLineSpacing = 2*_margin;
    self.collectionViewLayout = _layout;
}

- (CGFloat)optimumHeight{
    /*
    _margin = 4;
    CGFloat height_W = (self.tz_width - 3 * _margin) / 4 - 2*_margin;;
    CGFloat height_H = self.tz_height - 2*_margin;
    if (height_H < height_W) {
        //重新计算margin
        _margin = (self.tz_width - 4 * height_H) / 3;
        return height_H;
    }else{
        return height_W;
    }
    //return height_W < height_H ? height_W : height_H;
     */
    CGFloat height_W = (self.tz_width - 3 * 12) / 4;;
    CGFloat height_H = self.tz_height-24;
    return height_W < height_H ? height_W : height_H;
}

- (void)configCollectionView {
    CGFloat rgb = 1.0f;//244 / 255.0;
    self.alwaysBounceVertical = NO;
    self.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    self.contentInset = UIEdgeInsetsMake(12, 0, 12, 0);
    self.dataSource = self;
    self.delegate = self;
    
    [self registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

- (NSArray<UIImage *> *)certificates{
    return [_selectedPhotos copy];
}


- (void)setUserPerationEnabled:(BOOL)userPerationEnabled{
    if (_userPerationEnabled != userPerationEnabled) {
        _userPerationEnabled = userPerationEnabled;
        
        [self reloadData];
    }
}



- (void)addPreviewImageURLs:(NSArray *)urls{
    
    if (! _userPerationEnabled && urls.count<1) {
        _promptView = [[UILabel alloc] init];
        _promptView.textAlignment = NSTextAlignmentCenter;
        _promptView.font = [UtilFont systemLargeNormal];
        _promptView.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        _promptView.text = @"没有上传";
        [self addSubview:_promptView];
        
        [_promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    
    const char *queueName = [@"SerialQueue" UTF8String];
    dispatch_queue_t serialQueue = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
    
    dispatch_group_t group = dispatch_group_create();
    
    if (! _selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] initWithCapacity:urls.count];
        _selectedAssets = [[NSMutableArray alloc] initWithCapacity:urls.count];
    }
    BOOL _isNavigationBack = NO;
    progress_show;
    for (NSString *imgUrl in urls) {
        NSURL *imageURL = [NSURL URLWithString:imgUrl];
        dispatch_group_async(group, serialQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *img = [UIImage imageWithData:imageData ];
            if (img) {
                [_selectedPhotos addObject:img];
                [_selectedAssets addObject:img];
            }
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        progress_hide;
        [self reloadData];
    });

//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Update the UI
//            self.imageView.image = [UIImage imageWithData:imageData];
//        });
//    });
    
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.userPerationEnabled && _selectedPhotos.count < _maxImagesCount) {
        return _selectedPhotos.count + 1;
    }else{
        return _selectedPhotos.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"add_photo.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        if (_selectedAssets.count > indexPath.row) {
            cell.asset = _selectedAssets[indexPath.row];
        }
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        /*
        //不使用Sheet
        BOOL showSheet = NO;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:_target.view];
        } else {
            [self pushImagePickerController];
        }
        */
        [self pushImagePickerController];
    } else { // preview photos or video / 预览照片或者视频
        id asset ;
        if (_selectedAssets.count > indexPath.row) {
            asset = _selectedAssets[indexPath.row];
        }
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [_target presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            
            PhotoPreviewType type;
            if (self.userPerationEnabled) {
                type = PhotoPreviewTypeDelete;
            }else{
                type = PhotoPreviewTypeNone;
            }
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row photoPreviewType:type];
            
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                _layout.itemCount = _selectedPhotos.count;
                [self reloadData];
                self.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [_target presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [self reloadData];
    }
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    //_maxImagesCount = _maxImagesCount>0 ?_maxImagesCount : 2;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxImagesCount delegate:self];
    
    imagePickerVc.photoWidth = 420;
    
    // set appearance / 改变相册选择页的导航栏外观
    imagePickerVc.navigationBar.barTintColor = _target.navigationController.navigationBar.barTintColor;
    imagePickerVc.navigationBar.tintColor = _target.navigationController.navigationBar.tintColor;
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
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
//    imagePickerVc.navigationBar.barTintColor = [UIColor blueColor];
//    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
//    imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
//    for (UIView *view in imagePickerVc.parentViewController.navigationItem .titleView.subviews)
//    {
//        if(view)
//        {
//            [view removeFromSuperview];
//        }
//    }
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,90)];
//    [titleView setBackgroundColor:[UIColor clearColor]];
//    imagePickerVc.navigationItem.titleView = titleView;
    
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [_target presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        
        tzImagePickerVc.sortAscendingByModificationDate = NO;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    [_selectedAssets addObject:assetModel.asset];
                    [_selectedPhotos addObject:image];
                    [self reloadData];
                }];
            }];
        }];
    }
}


#pragma mark - TZImagePickerControllerDelegate

// cancel button
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([self.certificateDelegate respondsToSelector:@selector(certificatePickerDidCancel:)]) {
        [self.certificateDelegate certificatePickerDidCancel:self];
    }
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
//    [_selectedPhotos addObjectsFromArray:photos];
//    [_selectedAssets addObjectsFromArray:assets];
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    if (self.certificateDelegate) {
        if ([self.certificateDelegate respondsToSelector:@selector(certificateView:didFinishPickingPhotos:)]) {
            [self.certificateDelegate certificateView:self didFinishPickingPhotos:_selectedPhotos];
        }
    }
    
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    [self reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [self reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [self performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self reloadData];
    }];
}

@end
