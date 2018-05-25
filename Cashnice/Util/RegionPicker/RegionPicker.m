//
//  RegionPicker.m
//
//  Version 1.2.3
//
//  Created by Nick Lockwood on 25/04/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/RegionPicker
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  The source code and data files in this project are the sole creation of
//  Charcoal Design and are free for use subject to the terms below. The flag
//  icons were sourced from https://github.com/koppi/iso-Region-flags-svg-collection
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

#import "RegionPicker.h"
#import "UIImageView+WebCache.h"

#pragma GCC diagnostic ignored "-Wselector"
#pragma GCC diagnostic ignored "-Wgnu"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


@interface RegionPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end


@implementation RegionPicker

//doesn't use _ prefix to avoid name clash with superclass
@synthesize delegate;

+ (NSArray *)RegionArray
{
    static NSArray *_RegionArray = nil;
    if (! _RegionArray) {
        _RegionArray = ZAPP.myuser.systemRegionArray;
    }
    return _RegionArray;
}

+ (NSArray *)RegionNames
{
    static NSArray *_RegionNames = nil;
    if (!_RegionNames)
    {
        NSMutableArray *RegionNames = [[NSMutableArray alloc] init];
        for (NSDictionary *RegionDict in [self RegionArray]) {
            [RegionNames addObject:RegionDict[@"name"]];
        }
        _RegionNames = [RegionNames copy];
    }
    return _RegionNames;
}

+ (NSArray *)RegionCodes
{
    static NSArray *_RegionCodes = nil;
    if (!_RegionCodes || _RegionCodes.count < 1)
    {
        NSMutableArray *RegionCodes = [[NSMutableArray alloc] init];
        for (NSDictionary *RegionDict in [self RegionArray]) {
            [RegionCodes addObject:RegionDict[@"code"]];
        }
        _RegionCodes = [RegionCodes copy];
    }
    return _RegionCodes;
}

+ (NSArray *)RegionImages
{
    static NSArray *_RegionImages = nil;
    if (!_RegionImages)
    {
        NSMutableArray *RegionImages = [[NSMutableArray alloc] init];
        for (NSDictionary *RegionDict in [self RegionArray]) {
            [RegionImages addObject:RegionDict[@"Regionimg"]];
        }
        _RegionImages = [RegionImages copy];
    }
    return _RegionImages;
}

//+ (NSDictionary *)RegionNamesByCode
//{
//    static NSDictionary *_RegionNamesByCode = nil;
//    if (!_RegionNamesByCode)
//    {
//        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
//        for (NSString *code in [NSLocale ISOCountryCodes])
//        {
//            NSString *RegionName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
//
//            //workaround for simulator bug
//            if (!RegionName)
//            {
//                RegionName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:code];
//            }
// 
//            namesByCode[code] = RegionName ?: code;
//        }
//        _RegionNamesByCode = [namesByCode copy];
//    }
//    return _RegionNamesByCode;
//}
//
//+ (NSDictionary *)RegionCodesByName
//{
//    static NSDictionary *_RegionCodesByName = nil;
//    if (!_RegionCodesByName)
//    {
//        NSDictionary *RegionNamesByCode = [self RegionNamesByCode];
//        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
//        for (NSString *code in RegionNamesByCode)
//        {
//            codesByName[RegionNamesByCode[code]] = code;
//        }
//        _RegionCodesByName = [codesByName copy];
//    }
//    return _RegionCodesByName;
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

- (void)setSelectedRegionCode:(NSInteger)RegionCode animated:(BOOL)animated
{
    NSUInteger index = [[[self class] RegionCodes] indexOfObject:@(RegionCode)];
    if (index != NSNotFound)
    {
        [self selectRow:(NSInteger)index inComponent:0 animated:animated];
        
        //[self pickerView:self didSelectRow:index inComponent:0];
    }
}

- (void)setSelectedRegionCode:(NSString *)RegionCode
{
    [self setSelectedRegionCode:[RegionCode integerValue] animated:NO];
}

- (NSString *)selectedRegionCode
{
    NSUInteger index = (NSUInteger)[self selectedRowInComponent:0];
    if ([[self class] RegionCodes].count > index) {
        return [[self class] RegionCodes][index];
    }
    return @"";
}

- (void)setSelectedRegionName:(NSString *)RegionName animated:(BOOL)animated
{
    NSUInteger index = [[[self class] RegionNames] indexOfObject:RegionName];
    if (index != NSNotFound)
    {
        [self selectRow:(NSInteger)index inComponent:0 animated:animated];
    }
}

- (void)setSelectedRegionName:(NSString *)RegionName
{
    [self setSelectedRegionName:RegionName animated:NO];
}

- (NSString *)selectedRegionName
{
    NSUInteger index = (NSUInteger)[self selectedRowInComponent:0];
    if (index < [[self class] RegionNames].count) {
        return [[self class] RegionNames][index];
    }else{
        return nil;
    }
}

- (void)setSelectedLocale:(NSLocale *)locale animated:(BOOL)animated
{
    [self setSelectedRegionCode:[locale objectForKey:NSLocaleCountryCode] animated:animated];
}

- (void)setSelectedLocale:(NSLocale *)locale
{
    [self setSelectedLocale:locale animated:NO];
}

- (NSLocale *)selectedLocale
{
    NSString *RegionCode = self.selectedRegionCode;
    if (RegionCode)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode: RegionCode}];
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
    return (NSInteger)[[[self class] RegionCodes] count];
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
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 2, 24, 26)];
        flagView.contentMode = UIViewContentModeScaleAspectFit;
        flagView.tag = 2;
        [contentView addSubview:flagView];
        
        [view addSubview:contentView];
    }

    UILabel *lable = ((UILabel *)[view viewWithTag:1]);
    lable.text = [[self class] RegionNames][(NSUInteger)row];
    CGSize size = CGSizeMake(2000,26);
    size = [lable.text sizeWithFont:lable.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    lable.frame = CGRectMake(0, 2, size.width, 26);
    
    CGFloat width = size.width;
    contentView.frame = CGRectMake((viewWidth-width)/2, 2, width, 26);
    
    /*
    //NSString *imagePath = [NSString stringWithFormat:@"RegionPicker.bundle/%@", [[self class] RegionCodes][(NSUInteger) row]];
    NSString *imagePath = [[self class] RegionImages][row];
    UIImageView *imageView = ((UIImageView *)[view viewWithTag:2]);
    [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    */
    
    return view;
}

//- (void)didMoveToSuperview {
//    [super didMoveToSuperview];
//    [self pickerView:self didSelectRow:0 inComponent:0];
//}

- (void)pickerView:(__unused UIPickerView *)pickerView
      didSelectRow:(__unused NSInteger)row
       inComponent:(__unused NSInteger)component
{
    __strong id<RegionPickerDelegate> strongDelegate = delegate;
    [strongDelegate RegionPicker:self didSelectRegionWithName:self.selectedRegionName code:self.selectedRegionCode];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
