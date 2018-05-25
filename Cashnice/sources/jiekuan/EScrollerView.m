

#import "EScrollerView.h"

#define TIME_INTERVAL 3.0f

@implementation EScrollerView
@synthesize delegate;


-(void)initBaseWork{
    self.userInteractionEnabled=YES;
    viewSize=self.frame;
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    //说明文字层
    UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-27,self.bounds.size.width,27)];
    [noteView setBackgroundColor:[UIColor clearColor]];
    

    float pagecontrolHeight=noteView.bounds.size.height;
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((noteView.bounds.size.width - 100)/2,0, 100, pagecontrolHeight)];
    pageControl.currentPage=0;
    [noteView addSubview:pageControl];
    
    
//    noteTitle=[[UILabel alloc] initWithFrame:
//               CGRectMake(5,
//                          0, kScreenWidth, noteView.bounds.size.height)];
//    [noteTitle setBackgroundColor:[UIColor clearColor]];
//    [noteView addSubview:noteTitle];
//    noteTitle.textColor = [UIColor blackColor];
//    noteTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:noteView];
//    noteTitle.hidden=YES;
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=noteView.frame;
    [self addSubview:button];
    [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    
//    timer = [NSTimer tim];
}

-(id)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        [self initBaseWork];
    }
    
    return self;

}

-(void)action:(id)sender{
    
    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [delegate EScrollerViewDidClicked:pageControl.currentPage];
    }
}

-(void)reloadData:(NSArray *)data{
    if ([data count] != 0){
 
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:data];

        [tempArray insertObject:[data objectAtIndex:([data count]-1)] atIndex:0];
        [tempArray addObject:[data objectAtIndex:0]];
        dataArray=tempArray;
        
        scrollView.contentSize = CGSizeMake(viewSize.size.width * [dataArray count], scrollView.frame.size.height);
        
        for (UIView *subv in scrollView.subviews) {
            [subv removeFromSuperview];
        }
        for (int i=0; i<[dataArray count]; i++) {
            ShowUnit *unit = dataArray[i];
            NSString *imgURL=unit.picurl;
            
            UIImageView *imgView=[[UIImageView alloc] init];
            imgView.contentMode=UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            
            if ([imgURL hasPrefix:@"http"]){
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL]
                           placeholderImage:[UIImage imageNamed:@"loading_p"]];
            }else{
                [imgView setImage:[UIImage imageNamed:imgURL]];

            }

            
            [imgView setFrame:CGRectMake(scrollView.frame.size.width*i, 0,scrollView.frame.size.width, scrollView.frame.size.height)];
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
        pageControl.numberOfPages=([dataArray count]-2);
        pageControl.pageIndicatorTintColor=CN_COLOR_DD_GRAY;
        pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
 
        ShowUnit *unit = dataArray[0];
        [noteTitle setText:unit.atitle];
 
    }
    
}


- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    
    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        
        NSInteger targetIndex = sender.view.tag-1;
        if (targetIndex == dataArray.count - 2) {
            targetIndex = 0;
        }
        [delegate EScrollerViewDidClicked:targetIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    pageControl.currentPage=(page-1);

    if (currentPageIndex==[dataArray count]) {
        pageControl.currentPage=0;
    }
    
    
    if(currentPageIndex == dataArray.count -1){
        pageControl.currentPage=0;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopRoll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    DLog();
    if (currentPageIndex==0) {
        
        [_scrollView setContentOffset:CGPointMake(([dataArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([dataArray count]-1)) {
        
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
    
    
    if(!_scrollView.isDragging){
        [self startRoll:1];
        return;
    }
    
}

-(void)goToFirstPageDelay{
//    DLog();
    [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0) animated:NO
     ];
}

-(void)goToNextPage{
    //都放完了，需要返回去加载了，实际上刚放完imageArray的倒数第二个，最后一个本身就不放了，因为已经看过了
//    if (currentPageIndex==([dataArray count]-2)) {
//        
//        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0) animated:NO
//         ];
//        
//    }
//    DLog(@"%d", currentPageIndex);

    if (currentPageIndex == [dataArray count] - 2) {
        [self performSelector:@selector(goToFirstPageDelay) withObject:nil afterDelay:0.2];
    }
    
    if (currentPageIndex==([dataArray count]-1)) {

        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0) animated:NO
         ];
        
    }
    
    else{
        
        [scrollView setContentOffset:CGPointMake((1+currentPageIndex) *viewSize.size.width, 0) animated:YES
         ];
    }
}

-(void)goToOriginal{

    [scrollView setContentOffset:CGPointMake(viewSize.size.width*currentPageIndex, 0)];
    pageControl.currentPage=currentPageIndex-1;
    [noteTitle setText:[dataArray objectAtIndex:pageControl.currentPage][@"title"]];
}

-(void)startRoll:(CGFloat)delay{
    
    if (dataArray.count <= 3) {
        return;
    }
    
    DLog(@"%d", currentPageIndex);

    
    if (!timer) {
        [self performSelector:@selector(timerDelay) withObject:nil afterDelay:delay];
    }
}

-(void)stopRoll{

    DLog(@"%d", currentPageIndex);

    if (timer) {
        DLog();
        [timer invalidate];
        timer = nil;
    }
}

-(void)timerDelay{

    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(goToNextPage) userInfo:nil repeats:YES];
    }

}

@end
