//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "FabuStep3.h"
#import "FabuStep4.h"
 
#import "FabuJiekuanTableViewCell.h"
#import "SZTextView.h"

@interface FabuStep3 () {
    BOOL willNext;
}

@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *labels;
@property (weak, nonatomic) IBOutlet SZTextView *textview;
@property (strong, nonatomic) NextButtonViewController *next;

@end

@implementation FabuStep3

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);

	for (UILabel *x in self.labels) {
		x.textColor = ZCOLOR(COLOR_TEXT_GRAY);
		x.font      = [UtilFont systemLarge];
	}

    self.textview.placeholder = @"限400个字。";
    self.textview.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.textview.font = [UtilFont systemLarge];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
    [MobClick beginLogPageView:@"发布借款(3/4)"];
	[self setTitle:@"发布借款(3/4)"];
	
    
    if (willNext) {
        willNext= NO;
    }
    else {
    self.textview.text = @"";
        [self textViewDidChange:nil];
    }
	[self.view endEditing:YES];
    
    self.textview.text = [[NSUserDefaults standardUserDefaults] objectForKey:def_key_fabu_yongtu];
    [self textViewDidChange:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"发布借款(3/4)"];
	[self.view endEditing:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.textview.text forKey:def_key_fabu_yongtu];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        self.next = (NextButtonViewController *)[segue destinationViewController];
	}
}


- (void)nextButtonPressed {
	[self.view endEditing:YES];
    
    if (self.textview.text.length > 400) {
        [Util toast:@"借款用途不能超过400个字"];
        return;
    }
    
    willNext = YES;
    [ZAPP.myuser fabuSetYongtu:self.textview.text];
    
    FabuStep4 *fabu = ZBorrow(@"FabuStep4");
    [self.navigationController pushViewController:fabu animated:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.next setTheEnabled:self.textview.text.length > 0];
}
- (IBAction)dismissKeyboard:(id)sender {
	[self.view endEditing:YES];
}

@end
