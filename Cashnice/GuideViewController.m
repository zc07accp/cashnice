//
//  GuideViewController.m
//  DzNews
//
//  Created by zengyuan on 28/11/13.
//  Copyright (c) 2013 zengyuan. All rights reserved.
//

#import "GuideViewController.h"
//#import "FightUse.h"
@interface GuideViewController ()

@end

@implementation GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollview.delegate=self;
    scrollview.pagingEnabled=YES;
    scrollview.bounces=NO;
    
    if(ScreenInch4s){
        guides=[NSArray arrayWithObjects:@"4_1",@"4_2",@"4_3",nil];
    }else {
        guides=[NSArray arrayWithObjects:@"lead_pages1",@"lead_pages2",@"lead_pages3",nil];
    }
        
    
    
    scrollview.contentSize=CGSizeMake(guides.count * scrollview.frame.size.width, scrollview.frame.size.height);
    
    for (int i=0; i<[guides count]; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollview.frame.size.width, scrollview.frame.size.height)];
        imageView.image=[UIImage imageNamed:guides[i]];
        
             
        [scrollview addSubview:imageView];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        
        CGRect rect=imageView.frame;
        rect.origin.x=i*imageView.frame.size.width;
        imageView.frame=rect;
        
        if (i==[guides count]-1) {
            button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(40, pageCtrl.frame.origin.y-50, MainScreenWidth-40*2, 40);
            [button setBackgroundColor:HexRGB(0x3399ff)];
            button.layer.cornerRadius = 4;
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            [imageView addSubview:button];
            imageView.userInteractionEnabled=YES;
            [button addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
            
//            UIPanGestureRecognizer *panR=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGuideView:)];
//            
//            [self.view
//             addGestureRecognizer:panR];
//            
//            [scrollview.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
        }
    }
    
    // Do any additional setup after loading the view.
}

-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam{
    //    DLog(@"scrollHandlePan");
    
    if (scrollview.contentOffset.x >= guides.count * scrollview.frame.size.width - scrollview.frame.size.width) {
        [self swipeGuideView:panParam];
    }
}


-(void)swipeGuideView:(UIPanGestureRecognizer *)_pan{
    //    DLog(@"swipeGuideView");
    if (_pan.state==UIGestureRecognizerStateBegan) {
        [self exit];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    NSLog(@"page=%d",page);
    indiImgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"轮播-%d", page+1]];

    pageCtrl.currentPage = page;
    
}


-(IBAction)exit{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KSKIPGUIDE];
    
    guides = nil;
    //    [self.delegate guideDidExited];
    self.button1Block();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(BOOL)skipGuide{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KSKIPGUIDE];
}

@end
