//
//  CustomAutoCloseAlertView.m
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomTestingAlertView.h"
#import "CustomIOSAlertView.h"
#import "CustomUpdateAlertView.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat kCustomIOSAlertViewDefaultButtonHeight       = 30;
const static CGFloat kCustomIOSAlertViewDefaultButtonSpacerHeight = 10;
const static CGFloat kCustomIOSAlertViewCornerRadius              = 7;
const static CGFloat kCustomIOS7MotionEffectExtent                = 10.0;

@interface CustomTestingAlertView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWindow *overlayWindow;


@end


@implementation CustomTestingAlertView

static CGFloat buttonHeight = 0;
static CGFloat buttonSpacerHeight = 0;

@synthesize parentView, containerView, dialogView, onButtonTouchUpInside;
@synthesize delegate;
@synthesize buttonTitles;
@synthesize useMotionEffects;

static NSMutableArray *dispaliedAlertView ;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        delegate = self;
        useMotionEffects = false;
        buttonTitles = @[@"Close"];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (id)initWithMessage:(NSString *)message closeDelegate:(id<CustomIOSAlertViewDelegate>)closeDelegate buttonTitles:(NSArray *)titleArray
{
    if (self = [super init]) {
        [self createAlertViewWithMessage:message];
        [self setButtonTitles:titleArray];
        [self setDelegate:closeDelegate];
    }
    return self;
}


- (id)initWithTitle:(NSString *)aTitle andInfo:(NSString *)messageInfo {
    if (self = [super init]) {
        //self.title = aTitle;
        //self.message = messageInfo;
        [self setupUpdateContentView];
    }
    return self;
}

- (void)setupUpdateContentView{
    
}


// Create the dialog view, and animate opening the dialog
- (void)show
{
    
    
    
    //////    不可重入     //////
    if (! dispaliedAlertView) {
        dispaliedAlertView = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < dispaliedAlertView.count; i++) {
        CustomIOSAlertView *v = dispaliedAlertView[i];
        [v close];
        v = nil;
    }
    [dispaliedAlertView addObject:self];
    /////
    
    dialogView = [self createContainerView];
    
    dialogView.layer.shouldRasterize = YES;
    dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
#if (defined(__IPHONE_7_0))
    if (useMotionEffects) {
        [self applyMotionEffects];
    }
#endif
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:dialogView];
    
    // Can be attached to a view or to the top most window
    // Attached to a view:
    if (parentView != NULL) {
        [parentView addSubview:self];
        
        // Attached to the top most window
    } else {
        
        // On iOS7, calculate with orientation
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            switch (interfaceOrientation) {
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                    break;
                    
                default:
                    break;
            }
            
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            
            // On iOS8, just place the dialog in the middle
        } else {
            
            CGSize screenSize = [self countScreenSize];
            CGSize dialogSize = [self countDialogSize];
            CGSize keyboardSize = CGSizeMake(0, 0);
            
            dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
            
        }
        
        //        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        [self.overlayWindow makeKeyAndVisible];
        [self.overlayWindow addSubview:self];
    }
    
    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         //                         self.backgroundColor = [UIColor redColor];
                         
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
    
}

// Button has been touched
- (IBAction)customIOS7dialogButtonTouchUpInside:(UIButton *)sender
{
    if (delegate != NULL  && [delegate respondsToSelector:@selector(customIOS7dialogButtonTouchUpInside:clickedButtonAtIndex:)]) {
        [delegate customIOS7dialogButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
    }else{
        [self close];
    }
    
    if (onButtonTouchUpInside != NULL) {
        onButtonTouchUpInside(self, (int)[sender tag]);
    }
}

// Default button behaviour
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Clicked! %d, %d", (int)buttonIndex, (int)[alertView tag]);
    [self close];
}

- (void)closeWithAnimateDuration:(NSTimeInterval) interval{
    CATransform3D currentTransform = dialogView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[dialogView valueForKeyPath:@"layer.transform.rotation.z"] doubleValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:interval delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                         
                         // Make sure to remove the overlay window from the list of windows
                         // before trying to find the key window in that same list
                         NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                         [windows removeObject:_overlayWindow];
                         _overlayWindow = nil;
                         
                         [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                             if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                 [window makeKeyWindow];
                                 *stop = YES;
                             }
                         }];
                     }
     ];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    [self closeWithAnimateDuration:0.2f];
}

- (void)closeWithoutAnimation
{
    [self closeWithAnimateDuration:0.0f];
}

- (void)setSubView: (UIView *)subView
{
    containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    if (containerView == NULL) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 180)];
    }
    
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    
    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CGFloat cornerRadius = kCustomIOSAlertViewCornerRadius;
    if (! [self isKindOfClass:[CustomUpdateAlertView class]]) {
        // First, we style the dialog to match the iOS7 UIAlertView >>>
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = dialogContainer.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                           (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                           (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                           nil];
        
        
        gradient.cornerRadius = cornerRadius;
        //[dialogContainer.layer insertSublayer:gradient atIndex:0];
    }else{
        dialogContainer.backgroundColor = [UIColor whiteColor];
    }
    
    dialogContainer.backgroundColor = [UIColor whiteColor];

    dialogContainer.layer.cornerRadius = cornerRadius;
    //    dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    //    dialogContainer.layer.borderWidth = 0;
    //    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    //    dialogContainer.layer.shadowOpacity = 0.1f;
    //    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    //    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    //    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    
    
    // There is a line above the button
    //UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
    //lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    //[dialogContainer addSubview:lineView];
    // ^^^
    
  
    
    
    // Add the custom container if there is any
    [dialogContainer addSubview:containerView];
    
    
    // Add the buttons too
    [self addButtonsToView:dialogContainer];
    
    
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"请先完成风险评估";
    title.textColor = HexRGB(0x1c3681);
    title.font = [UIFont boldSystemFontOfSize:16.0f];
    title.textAlignment = NSTextAlignmentCenter;
    [dialogContainer addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(dialogContainer);
        make.top.equalTo(dialogContainer).mas_offset(14);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HexRGB(0x1c3681);
    [dialogContainer addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dialogContainer).offset(20);
        make.right.equalTo(dialogContainer).offset(-20);
        make.top.equalTo(title.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    
    
    NSString *contentStr = @"本项目适合风险承受能力为\"保守型\"及以上的用户投标。投标前，请先完成风险评估测试！";
    UILabel *content = [[UILabel alloc] init];
    //content.text = ;
    content.textColor = HexRGB(0x333333);
    content.font = CNFont(24);
    content.numberOfLines = 0;
    [dialogContainer addSubview:content];
    
    
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contentStr length])];
    [content setAttributedText:attributedString1];
    
    
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dialogContainer.mas_left).mas_offset(14);
        make.right.equalTo(dialogContainer.mas_right).mas_offset(-14);
        make.top.equalTo(line.mas_bottom).mas_offset(14);
    }];
    
    
    return dialogContainer;
}

-(void)setBkColor:(UIColor *)bkColor{
    
    if(bkColor){
        
        [dialogView.layer.sublayers[0] removeFromSuperlayer];
        dialogView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        
    }
    
}


// Helper function: add buttons to container
- (void)addButtonsToView: (UIView *)container
{
    //if (buttonTitles==NULL) { return; }
    
    CGFloat buttonWidth = container.bounds.size.width * 0.9;
    
    
    UIButton *testingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testingButton setFrame:CGRectMake((container.bounds.size.width-buttonWidth)/2, (NSInteger)(container.bounds.size.height - 2*(buttonHeight+buttonSpacerHeight)), (NSInteger)(buttonWidth), (NSInteger)(buttonHeight))];
    
    [testingButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [testingButton setTag:1];
    
    //testingButton.backgroundColor = [UIColor orangeColor];
    testingButton.backgroundColor = HexRGB(0x1C3681);
    [testingButton setTitle:@"开始评估" forState:UIControlStateNormal];
    [testingButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [testingButton.layer setCornerRadius:kCustomIOSAlertViewCornerRadius];
    
    [container addSubview:testingButton];
    

    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake((container.bounds.size.width-buttonWidth)/2, (NSInteger)(container.bounds.size.height - buttonHeight-buttonSpacerHeight), (NSInteger)(buttonWidth), (NSInteger)(buttonHeight))];
    
    [closeButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTag:2];
    
    closeButton.titleLabel.textColor=[UIColor redColor];
    [closeButton setTitle:@"暂不评估" forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [closeButton.layer setCornerRadius:kCustomIOSAlertViewCornerRadius];
    [container addSubview:closeButton];
    
    [closeButton setTitleColor:HexRGB(0x1C3681) forState:UIControlStateNormal];
    
    
}

// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = containerView.frame.size.width;
    CGFloat dialogHeight = containerView.frame.size.height + 2*buttonHeight + buttonSpacerHeight;
    
    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    if (buttonTitles!=NULL && [buttonTitles count] > 0) {
        buttonHeight       = kCustomIOSAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomIOSAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Rotation changed, on iOS7
- (void)changeOrientationForIOS7 {
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] doubleValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         dialogView.transform = rotation;
                         
                     }
                     completion:nil
     ];
    
}

// Rotation changed, on iOS8
- (void)changeOrientationForIOS8: (NSNotification *)notification {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize dialogSize = [self countDialogSize];
                         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                         dialogView.frame = CGRectMake((screenWidth - dialogSize.width) / 2, (screenHeight - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
    
    
}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    // If dialog is attached to the parent view, it probably wants to handle the orientation change itself
    if (parentView != NULL) {
        return;
    }
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationForIOS7];
    } else {
        [self changeOrientationForIOS8:notification];
    }
}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}


- (UIWindow *)overlayWindow {
    if(! _overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.tag = 10111;
        
        
        UITapGestureRecognizer *oneTaps =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTaps)];
        oneTaps.delegate = self;

        [_overlayWindow addGestureRecognizer:oneTaps];
    }
    return _overlayWindow;
}

- (void)oneTaps{
    [self close];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //if ([touch.view isKindOfClass:[UILabel class]]){
    
    if ([touch.view isEqual:containerView]) {
        return NO;
    }
    
    return YES;
}


- (UIColor *)separatorLineColor{
    return [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
}
///// add by cc for yqs
- (void)formatAlertButton {

}

- (void)createAlertViewWithMessage : (NSString *)message  {
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 140)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 120)];
    label.numberOfLines = 0;
    label.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    label.font = [UIFont systemFontOfSize:15.0f];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:message];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [message length])];
    
    [label setAttributedText:attributedString1];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    CGSize expSize = [label sizeThatFits:CGSizeMake(240, MAXFLOAT)];
    label.height = expSize.height;
    demoView.height = 20+label.height;
    [demoView addSubview:label];
    
    //    self.messageLabel = label;
    
    [self setContainerView:demoView];
}

@end
