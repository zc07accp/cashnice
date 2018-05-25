//
//  ADViewController.m
//  OGL
//
//  Created by ZengYuan on 14/12/15.
//  Copyright (c) 2014年 ZengYuan. All rights reserved.
//

#import "ADViewController.h"
#import "SystemOptionsEngine.h"
#import "FLAnimatedImage.h"

static NSInteger const AD_TIME = 3;

#define kadvc_last_time @"kadvc_last_time"

@interface ADViewController ()
{
    CGFloat last_time; //接口返回的图片持续时间
}
@property (strong, nonatomic) SystemOptionsEngine *engine;

@end

@implementation ADViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];

    last_time = [[NSUserDefaults standardUserDefaults]floatForKey:kadvc_last_time];
    
    logoView = [[UIImageView alloc] init];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoView];

    logoView.image = [self getLaunchImage];
  
    UIView *superview = self.view;
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview);
        make.left.equalTo(superview.mas_left);
        make.top.equalTo(superview.mas_top);
        make.bottom.equalTo(superview.mas_bottom);

    }];
    
    adImgView = [[FLAnimatedImageView alloc] init];
    adImgView.contentMode = UIViewContentModeScaleAspectFill;
    adImgView.clipsToBounds = YES;
    [self.view addSubview:adImgView];
    [adImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(IPHONE6_ORI_VALUE(-94));
     }];
    
    [self requestNewAD];

    [self performSelector:@selector(hideAd) withObject:nil afterDelay:last_time>0?last_time: AD_TIME];
    
}

-(SystemOptionsEngine *)engine{
    
    if(!_engine){
        _engine = [[SystemOptionsEngine alloc]init];
    }
    
    return _engine;
}


-(void)hideAd{
    
    self.ADComplete();
    
}

-(void)requestNewAD{
    
    WS(weakSelf)
    [self.engine getADComplete:^(NSDictionary *dic) {
        [weakSelf showAd:dic];
    }];

}
//
-(void)showAd:(NSDictionary *)dic{
    
    last_time =  [EMPTYOBJ_HANDLE(dic[@"last_time"]) doubleValue];
    [[NSUserDefaults standardUserDefaults] setFloat:last_time forKey:kadvc_last_time];
    
    
    NSString *imgurl = nil;
    if (ScreenInch4s) {
        imgurl = EMPTYSTRING_HANDLE(dic[@"small_image"]);
    }else{
        imgurl = EMPTYSTRING_HANDLE(dic[@"boot_image"]);
    }
    
    if(imgurl){
        [adImgView sd_setImageWithURL:[NSURL URLWithString:imgurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"error = %@", error);
        }];
        
//        [self loadAnimatedImageWithURL:imgurl completion:^(FLAnimatedImage *animatedImage) {
//            adImgView.animatedImage = animatedImage;
//        }];
    }
}


-(void)didNothing{
    void (^printBlock)(NSString *x);
    printBlock = ^(NSString* str)
    {
        NSLog(@"print:%@", str);
    };
    printBlock(@"hello world!");
    
    
}

-(UIImage *)getLaunchImage{
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
            break;
        }
    }
    
    return [UIImage imageNamed:launchImage];
}

- (void)loadAnimatedImageWithURL:(NSString *const)url completion:(void (^)(FLAnimatedImage *animatedImage))completion
{
    NSString *const filename = [NSString stringWithFormat:@"img_%@", url.lastPathComponent];
    NSString *const diskPath = [[self applicationDocumentsDirectory].path  stringByAppendingPathComponent:filename];
    
    NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:diskPath];
    FLAnimatedImage * __block animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
    
    if (animatedImage) {
        if (completion) {
            completion(animatedImage);
        }
    } else {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
        [data writeToFile:diskPath atomically:YES];
        
//        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            animatedImageData = data;
//            animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
//
//            if (animatedImage) {
//                if (completion) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completion(animatedImage);
//                    });
//                }
//                [data writeToFile:diskPath atomically:YES];
//            }
//        }] resume];
    }
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
@end
