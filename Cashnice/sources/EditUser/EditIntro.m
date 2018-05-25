//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "EditIntro.h"
 
#import "FabuJiekuanTableViewCell.h"
#import "SZTextView.h"

@interface EditIntro ()

@property (weak, nonatomic) IBOutlet SZTextView *textview;
@property (strong, nonatomic) NextButtonViewController *next;

@end

@implementation EditIntro

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);

    self.textview.placeholder = @"这个家伙很懒，什么都没有写。（限200个字）";
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
    [MobClick beginLogPageView:@"个人简介"];
	[self setTitle:@"个人简介"];
	
    
    self.textview.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_SHORTDESC];
	[self.view endEditing:YES];
    [self textViewDidChange:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"个人简介"];
	[self.view endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = @"保存";
        self.next = (NextButtonViewController *)[segue destinationViewController];
	}
}

- (void)nextButtonPressed {
	[self.view endEditing:YES];
    if (self.textview.text.length > 200) {
        [Util toastStringOfLocalizedKey:@"tip.personalProfile"];
        return;
    }
    [self.delegate setIntroString:self.textview.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.next setTheEnabled:[self.textview.text notEmpty]];
}

- (IBAction)dismissKeyboard:(id)sender {
	[self.view endEditing:YES];
}

@end
