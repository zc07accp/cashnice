//
//  CustomIOSAlertView.h
//  CustomIOSAlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013-2015 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@protocol CustomIOSAlertViewDelegate  <NSObject>
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomIOSAlertView : UIView<CustomIOSAlertViewDelegate>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)

@property (nonatomic, assign) id <CustomIOSAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, retain) UIColor *separatorLineColor;

@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *bkColor;


@property (copy) void (^onButtonTouchUpInside)(CustomIOSAlertView *alertView, int buttonIndex) ;

- (id)init;
- (CGSize)countScreenSize;
/*!
 DEPRECATED: Use the [CustomIOSAlertView init] method without passing a parent view.
 */
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));
- (id)initWithMessage:(NSString *)message closeDelegate:(id<CustomIOSAlertViewDelegate>)closeDelegate buttonTitles:(NSArray *)titleArray ;

- (void)show;
- (void)close;
- (void)closeWithoutAnimation;

// add by cc for yqs 
- (void)formatAlertButton ;
- (void)createAlertViewWithMessage : (NSString *)message;

- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(CustomIOSAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;

@end
