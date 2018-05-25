//
//  ProgressIndicator.m
//  YQS
//
//  Created by l on 8/31/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ProgressIndicator.h"

@interface ProgressIndicator ()

@property (weak, nonatomic) IBOutlet UIView *progressBarGrayView;
@property (weak, nonatomic) IBOutlet UIView *progressBarBlueView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_blue_width;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray* labelArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray* indexLabelArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* indexBgViewArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_last_text_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_last_index_width;
@property (strong, nonatomic) IBOutlet UIView* last_index_view;
@property (weak, nonatomic) IBOutlet UIView *last_text_view;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_width;



//@property (nonatomic, assign) int pageSelected;
@end

@implementation ProgressIndicator

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.con_width.constant = [ZAPP.zdevice getDesignScale:414];
    
    self.progressBarGrayView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
    self.progressBarGrayView.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.progressBarBlueView.backgroundColor = ZCOLOR(COLOR_BUTTON_BLUE);
    
    [Util setUILabelSmallBlack:self.labelArray];
    [Util setUILabelSmallBlack:self.indexLabelArray];
    for (UILabel *l in self.indexLabelArray) {
        l.textColor = [UIColor whiteColor];
    }
    [self initIndexLabelBgViews];
}

- (void)initIndexLabelBgViews {
    for (UIView *v in self.indexBgViewArray) {
//        v.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
//        v.backgroundColor = [DefColor bgGreenColor];
        v.layer.cornerRadius = [ZAPP.zdevice getDesignScale:10];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setCurrentPage:(int)curPage strings:(NSArray *)strs {
    BOOL hideLast = [strs count] <= 3;
    self.last_index_view.hidden = hideLast;
    self.last_text_view.hidden = hideLast;
    self.con_last_text_width.constant = hideLast ? 1 : [ZAPP.zdevice getDesignScale:380.0/4];
    self.con_last_index_width.constant = hideLast ? 1 : [ZAPP.zdevice getDesignScale:380.0/4];
    self.con_blue_width.constant = [ZAPP.zdevice getDesignScale:380.0/strs.count * (curPage + 1 ) - 10.0];
    
    for (int i = 0; i < self.indexBgViewArray.count; i++) {
        BOOL greenBg = i <= curPage;
        [[self.indexBgViewArray objectAtIndex:i] setBackgroundColor:greenBg ? [DefColor bgGreenColor] : ZCOLOR(COLOR_BG_GRAY)];
    }
    
    for (int i = 0; i < strs.count; i++) {
        [[self.labelArray objectAtIndex:i] setText:[strs objectAtIndex:i]];
    }
}

@end
