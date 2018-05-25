//内部调节自动滚动
//ivan zeng

#import <UIKit/UIKit.h>
#import "ShowUnit.h"
#import <QuartzCore/QuartzCore.h>

@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
-(void)startTimer;
-(void)endTimer;
@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
	CGRect viewSize;
	UIScrollView *scrollView;
    UIPageControl *pageControl;
    id<EScrollerViewDelegate> delegate;
    int currentPageIndex;
    UILabel *noteTitle;
    
     NSArray *focusarray;
    
    NSArray *dataArray;
//     NSArray *imageArray;
//     NSArray *titleArray;
    
    NSTimer *timer;
    
}


@property(nonatomic,retain)id<EScrollerViewDelegate> delegate;

-(void)goToNextPage;
-(void)reloadData:(NSArray *)data;
-(void)goToOriginal;

-(void)startRoll:(CGFloat)delay;
-(void)stopRoll;

@end
