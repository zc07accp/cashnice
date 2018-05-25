//
//  CardVideoViewController.h
//  WeBank
//
//  Created by doufeifei on 15/1/21.
//
//

#import <UIKit/UIKit.h>
//#import "CustomViewController.h"

@protocol CardVideoViewControllerDelegate<NSObject>
-(void)hasVerifyTakingPhotoCardSuccess:(UIImage *)takingPhoto detail:(NSDictionary *)detail cardType:(NSInteger)type;
@end

@interface CardVideoViewController : UIViewController

@property(nonatomic,assign) NSInteger currentType;//0正 1反
@property (weak,nonatomic) id<CardVideoViewControllerDelegate> delegate;

//+(UIImage*)cropCapRegionIDCard:(UIImage *)oriimgae;

@end
