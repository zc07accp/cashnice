//
//  EditUserInfoViewController.m
//  Cashnice
//
//  Created by a on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "PersonInfoAPIEngine.h"
#import "CNActionButton.h"

@interface EditUserInfoViewController () <UITextViewDelegate>

@property (nonatomic) NSInteger countLimit;
@property (nonatomic, strong) NSString *titleString;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet CNActionButton *saveButton;

@end

@implementation EditUserInfoViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavButton];
    self.title = self.titleString;
    
    self.textView.delegate = self;
    
    [self.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.textView.text = self.content;
    self.countLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.content.length, self.countLimit];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)setEditUserInfoType:(EditUserInfoType)editUserInfoType{
    _editUserInfoType = editUserInfoType;
    self.title = [self titleString];
}

- (void)saveAction{
    
    [self.view endEditing:YES];
    
    NSString *com = @"";
    NSString *job = @"";
    NSString *add = @"";
    
    switch (self.editUserInfoType) {
        case EditUserInfo_Workplace:
            com = self.textView.text;
            break;
        case EditUserInfo_Position:
            job = self.textView.text;
            break;
        case EditUserInfo_Address:
            add = self.textView.text;
            break;
        default:
            break;
    }
    
    progress_show
    [[PersonInfoAPIEngine sharedInstance] setUserIdentityCompany:com job:job address:add success:^{
        progress_hide
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

#pragma mark - TextViewDelegate method
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > self.countLimit) {
        textView.text = [textView.text substringToIndex:self.countLimit];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zd/%zd", textView.text.length, self.countLimit];
    
    self.saveButton.enabled = (textView.text.length > 0 && ![textView.text isEqualToString:self.content]);
}

- (NSInteger)countLimit{
    
    if (self.editUserInfoType == EditUserInfo_Address   ||
        self.editUserInfoType == EditUserInfo_Workplace   ){
        return 50;
    }else{
        return 20;
    }
}

- (NSString *)titleString{
    switch (self.editUserInfoType) {
        case EditUserInfo_Workplace:
            return @"工作在";
            break;
        case EditUserInfo_Position:
            return @"职务";
            break;
        case EditUserInfo_Address:
            return @"通信地址";
            break;
        case EditUserInfo_Email:
            return @"邮箱";
            break;
            
        default:
            return @"";
            break;
    }
}

@end
