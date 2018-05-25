//
//  BankPicker.h
//
//  Version 1.2.3
//
//  Created by Nick Lockwood on 25/04/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/BankPicker
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  The source code and data files in this project are the sole creation of
//  Charcoal Design and are free for use subject to the terms below. The flag
//  icons were sourced from https://github.com/koppi/iso-Bank-flags-svg-collection
//  and are available under a Public Domain license
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import <Availability.h>
#undef weak_delegate
#if __has_feature(objc_arc_weak)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#import <UIKit/UIKit.h>


@class BankPicker;


@protocol BankPickerDelegate <UIPickerViewDelegate>

- (void)BankPicker:(BankPicker *)picker didSelectBankWithName:(NSString *)name code:(NSString *)code;

@end


@interface BankPicker : UIPickerView

+ (NSArray *)BankNames;
+ (NSArray *)BankCodes;
//+ (NSDictionary *)BankNamesByCode;
//+ (NSDictionary *)BankCodesByName;

@property (nonatomic, weak_delegate) id<BankPickerDelegate> delegate;

@property (nonatomic, copy) NSString *selectedBankName;
@property (nonatomic, copy) NSString *selectedBankCode;
@property (nonatomic, copy) NSLocale *selectedLocale;

- (void)setSelectedBankCode:(NSString *)BankCode animated:(BOOL)animated;
- (void)setSelectedBankName:(NSString *)BankName animated:(BOOL)animated;
- (void)setSelectedLocale:(NSLocale *)locale animated:(BOOL)animated;

- (void)pickerView:(__unused UIPickerView *)pickerView
      didSelectRow:(__unused NSInteger)row
       inComponent:(__unused NSInteger)component;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
