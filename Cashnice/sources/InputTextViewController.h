//
//  InputNameViewController.h
//  OGL
//
//  Created by ZengYuan on 15/4/23.
//  Copyright (c) 2015年 ZengYuan. All rights reserved.
//

#import "CustomViewController.h"
//#import "AWInputTextView.h"
@protocol  InputTextDelegate<NSObject>
-(void)didInputText:(NSString *)name;
@end

@interface InputTextViewController : CustomViewController

@property(assign,nonatomic) id<InputTextDelegate> delegate;
@property (nonatomic,weak) IBOutlet UITextField *textField;

@property(nonatomic,copy) NSString *originaPlaceHolderText;
@property(nonatomic,copy) NSString *originalText; //原始文本内容
@property(nonatomic,copy) NSString *navTitle;//标题


@end
