//
//  InputNameViewController.m
//  OGL
//
//  Created by ZengYuan on 15/4/23.
//  Copyright (c) 2015年 ZengYuan. All rights reserved.
//

#import "InputTextViewController.h"
#import "IOU.h"

@interface InputTextViewController ()

@end

@implementation InputTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    
    [self setNavButton];
    [self setNavRightBtn];
    
    self.textField.placeholder = [self.originaPlaceHolderText length]?self.originaPlaceHolderText:@"";
    self.textField.text = [self.originalText length]?self.originalText:@"";
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textField becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title=self.navTitle;
}


-(void)rightNavItemAction{
    
    if ([self.textField.text isEqualToString:@"0"]) {
        [self.view endEditing:YES];
        [Util toast:IOUWARN_MONEYZERO];
        return;
    }
    
    if ([self.textField.text length]==0) {
        [self.view endEditing:YES];
        [Util toast:[NSString stringWithFormat:@"%@不能为空",
                     self.navTitle.length ? self.navTitle:@""]];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didInputText:)]) {
        [self.delegate didInputText:self.textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setNavRightBtn{
    [super setNavRightBtn];
    [self.rightNavBtn setTitle:@"确定" forState:UIControlStateNormal];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
