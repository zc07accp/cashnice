//
//  BankPicker.m
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

#import "BankPicker.h"
#import "UIImageView+WebCache.h"

#pragma GCC diagnostic ignored "-Wselector"
#pragma GCC diagnostic ignored "-Wgnu"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


@interface BankPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end


@implementation BankPicker

//doesn't use _ prefix to avoid name clash with superclass
@synthesize delegate;

+ (NSArray *)BankArray
{
    static NSArray *_BankArray = nil;
    if (! _BankArray) {
        _BankArray = ZAPP.myuser.bankcardPayListRespondDict[@"banks"];
    }
    return _BankArray;
}

+ (NSArray *)BankNames
{
    static NSArray *_BankNames = nil;
    if (!_BankNames)
    {
        NSMutableArray *BankNames = [[NSMutableArray alloc] init];
        for (NSDictionary *bankDict in [self BankArray]) {
            [BankNames addObject:bankDict[@"bankname"]];
        }
        _BankNames = [BankNames copy];
    }
    return _BankNames;
}

+ (NSArray *)BankCodes
{
    static NSArray *_BankCodes = nil;
    if (!_BankCodes)
    {
        NSMutableArray *BankCodes = [[NSMutableArray alloc] init];
        for (NSDictionary *bankDict in [self BankArray]) {
            [BankCodes addObject:bankDict[@"bankcode"]];
        }
        _BankCodes = [BankCodes copy];
    }
    return _BankCodes;
}

+ (NSArray *)BankImages
{
    static NSArray *_BankImages = nil;
    if (!_BankImages)
    {
        NSMutableArray *BankImages = [[NSMutableArray alloc] init];
        for (NSDictionary *bankDict in [self BankArray]) {
            [BankImages addObject:bankDict[@"bankimg"]];
        }
        _BankImages = [BankImages copy];
    }
    return _BankImages;
}

//+ (NSDictionary *)BankNamesByCode
//{
//    static NSDictionary *_BankNamesByCode = nil;
//    if (!_BankNamesByCode)
//    {
//        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
//        for (NSString *code in [NSLocale ISOCountryCodes])
//        {
//            NSString *BankName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
//
//            //workaround for simulator bug
//            if (!BankName)
//            {
//                BankName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:code];
//            }
// 
//            namesByCode[code] = BankName ?: code;
//        }
//        _BankNamesByCode = [namesByCode copy];
//    }
//    return _BankNamesByCode;
//}
//
//+ (NSDictionary *)BankCodesByName
//{
//    static NSDictionary *_BankCodesByName = nil;
//    if (!_BankCodesByName)
//    {
//        NSDictionary *BankNamesByCode = [self BankNamesByCode];
//        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
//        for (NSString *code in BankNamesByCode)
//        {
//            codesByName[BankNamesByCode[code]] = code;
//        }
//        _BankCodesByName = [codesByName copy];
//    }
//    return _BankCodesByName;
//}

- (void)setUp
{
    super.dataSource = self;
    super.delegate = self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)setDataSource:(__unused id<UIPickerViewDataSource>)dataSource
{
    //does nothing
}

- (void)setSelectedBankCode:(NSString *)BankCode animated:(BOOL)animated
{
    NSUInteger index = [[[self class] BankCodes] indexOfObject:BankCode];
    if (index != NSNotFound)
    {
        [self selectRow:(NSInteger)index inComponent:0 animated:animated];
    }else{
        [self selectRow:0 inComponent:0 animated:animated];
    }
}

- (void)setSelectedBankCode:(NSString *)BankCode
{
    [self setSelectedBankCode:BankCode animated:NO];
}

- (NSString *)selectedBankCode
{
    NSUInteger index = (NSUInteger)[self selectedRowInComponent:0];
    if ([[self class] BankCodes].count > index) {
        return [[self class] BankCodes][index];
    }
    return @"";
}

- (void)setSelectedBankName:(NSString *)BankName animated:(BOOL)animated
{
    NSUInteger index = [[[self class] BankNames] indexOfObject:BankName];
    if (index != NSNotFound)
    {
        [self selectRow:(NSInteger)index inComponent:0 animated:animated];
    }
}

- (void)setSelectedBankName:(NSString *)BankName
{
    [self setSelectedBankName:BankName animated:NO];
}

- (NSString *)selectedBankName
{
    NSUInteger index = (NSUInteger)[self selectedRowInComponent:0];
    if ([[self class] BankNames].count > index) {
        return [[self class] BankNames][index];
    }
    return @"";
}

- (void)setSelectedLocale:(NSLocale *)locale animated:(BOOL)animated
{
    [self setSelectedBankCode:[locale objectForKey:NSLocaleCountryCode] animated:animated];
}

- (void)setSelectedLocale:(NSLocale *)locale
{
    [self setSelectedLocale:locale animated:NO];
}

- (NSLocale *)selectedLocale
{
    NSString *BankCode = self.selectedBankCode;
    if (BankCode)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode: BankCode}];
        return [NSLocale localeWithLocaleIdentifier:identifier];
    }
    return nil;
}

#pragma mark -
#pragma mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView numberOfRowsInComponent:(__unused NSInteger)component
{
    return (NSInteger)[[[self class] BankCodes] count];
}

- (UIView *)pickerView:(__unused UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(__unused NSInteger)component reusingView:(UIView *)view
{
    UIView *contentView = [[UIView alloc] init];
    CGFloat viewWidth = self.frame.size.width;
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 30)];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];////CGRectMake(35, 3, 0, 24)
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        [contentView addSubview:label];
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 24, 24)];
        flagView.contentMode = UIViewContentModeScaleAspectFit;
        flagView.tag = 2;
        [contentView addSubview:flagView];
        
        [view addSubview:contentView];
    }

    UILabel *lable = ((UILabel *)[view viewWithTag:1]);
    lable.text = [[self class] BankNames][(NSUInteger)row];
    CGSize size = CGSizeMake(2000,24);
    size = [lable.text sizeWithFont:lable.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    lable.frame = CGRectMake(35, 3, size.width, 24);
    
    CGFloat width = 35 + size.width;
    contentView.frame = CGRectMake((viewWidth-width)/2, 3, width, 24);
    
    //NSString *imagePath = [NSString stringWithFormat:@"BankPicker.bundle/%@", [[self class] BankCodes][(NSUInteger) row]];
    NSString *imagePath = [[self class] BankImages][row];
    UIImageView *imageView = ((UIImageView *)[view viewWithTag:2]);
    [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];


    return view;
}

- (void)pickerView:(__unused UIPickerView *)pickerView
      didSelectRow:(__unused NSInteger)row
       inComponent:(__unused NSInteger)component
{
    __strong id<BankPickerDelegate> strongDelegate = delegate;
    [strongDelegate BankPicker:self didSelectBankWithName:self.selectedBankName code:self.selectedBankCode];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
