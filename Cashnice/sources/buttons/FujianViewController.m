//
//  FujianViewController.m
//  YQS
//
//  Created by l on 3/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "FujianViewController.h"
#import "PhotoView.h"
#import "FujianFullView.h"

@interface FujianViewController ()
@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *largeGray;
@property (strong, nonatomic)IBOutletCollection(NSLayoutConstraint) NSArray *layoutArray;
@property (strong, nonatomic) NSDictionary *       dataDict;
@property (strong, nonatomic) NSMutableDictionary *photoDict;
@property (strong, nonatomic) NSArray *            keyArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_content_width;

@end

@implementation FujianViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	[Util setUILabelLargeGray:self.largeGray];
    self.con_content_width.constant = [ZAPP.zdevice getDesignScale:390];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setFujianDict:(NSDictionary *)dict {
	self.dataDict = dict;
	[self ui];
}
- (NSMutableDictionary *)photoDict {
	if (_photoDict == nil) {
		_photoDict = [NSMutableDictionary dictionary];
	}
	return _photoDict;
}

- (NSArray *)keyArray {
	if (_keyArray == nil) {
		_keyArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
	}
	return _keyArray;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ([[segue destinationViewController] isKindOfClass:[PhotoView class]]) {
		((PhotoView *)[segue destinationViewController]).buttontag = (int)[[segue identifier] integerValue];
		((PhotoView *)[segue destinationViewController]).delegate        = self;
		[self.photoDict setObject:[segue destinationViewController] forKey:[segue identifier]];
	}
}

- (void)photoButtonPressed:(int)idx {
	int      fujiancnt = [[self.dataDict objectForKey:NET_KEY_attachmentcount] intValue];
	NSArray *arr       = [self.dataDict objectForKey:NET_KEY_ATTACHMENTS];
	if (fujiancnt == [arr count]) {
		NSMutableArray *imgArr = [NSMutableArray array];
		for (int i = 0; i < [self.keyArray count]; i++) {
			PhotoView *v = (PhotoView *)[self.photoDict objectForKey:[self.keyArray objectAtIndex:i]];
			if (i < fujiancnt) {
				NSMutableDictionary *dic = [NSMutableDictionary dictionary];
				if (v.imageview.image != nil) {
					[dic setObject:v.imageview.image forKey:def_key_fujian_img];
				}
				else {
					[dic setObject:[UIImage imageNamed:@"fujian_placeholder"] forKey:def_key_fujian_img];
				}
				NSString *url = [[arr objectAtIndex:i] objectForKey:NET_KEY_URL];
				if ([url notEmpty]) {
					[dic setObject:url forKey:def_key_fujian_url];
				}
				else {
					[dic setObject:url forKey:def_key_fujian_url];
				}
				[imgArr addObject:dic];
			}
		}
		FujianFullView *f = ZJKDetail(@"FujianFullView");
        [f setTheDataArray:imgArr];
		f.curIndex = idx;
        f.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        ZAPP.inFullImageView = YES;
        [self presentViewController:f animated:YES completion:nil];
	}
}

- (void)ui {
	if (self.dataDict != nil) {
		int fujiancnt = [[self.dataDict objectForKey:NET_KEY_attachmentcount] intValue];

		if (fujiancnt == 0) {
			((UILabel *)[self.largeGray objectAtIndex:0]).text = @"相关附件: 未上传";
			return;
		}
		((UILabel *)[self.largeGray objectAtIndex:0]).text = @"相关附件:";
		NSArray *arr = [self.dataDict objectForKey:NET_KEY_ATTACHMENTS];
		if (fujiancnt == [arr count]) {
			for (int i = 0; i < [self.keyArray count]; i++) {
				PhotoView *         v  = (PhotoView *)[self.photoDict objectForKey:[self.keyArray objectAtIndex:i]];
				NSLayoutConstraint *la = [self.layoutArray objectAtIndex:i];
				CGFloat             co;
				if (i >= fujiancnt) {
					v.view.hidden = YES;
					co            = [ZAPP.zdevice getDesignScale:65];
				}
				else {
					v.view.hidden = NO;
					co            = [ZAPP.zdevice getDesignScale:65];
                    //if (i > 0)
					[v setPhotoDict:[arr objectAtIndex:i]];
				}
				la.constant = co;
			}
		}
	}
}

@end
