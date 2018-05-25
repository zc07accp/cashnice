//
//  BasePageControlViewController.h
//  bzyyuanzhang
//
//  Created by bzy008 on 16/7/18.
//  Copyright © 2016年 xujiajia. All rights reserved.
//

#import "CustomViewController.h"

@interface BasePageControlViewController : CustomViewController
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger willToIndex;
@end
